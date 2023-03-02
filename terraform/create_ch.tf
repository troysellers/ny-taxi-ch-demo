

data "aiven_project" "demo-project" {
  project = var.aiven_project_name
}


#Clickhouse service
resource "aiven_clickhouse" "clickhouse" {
  project                 = var.aiven_project_name
  cloud_name              = var.aiven_cloud
  plan                    = var.aiven_plan
  service_name            = "${var.service_prefix}ch"
  maintenance_window_dow  = "monday"
  maintenance_window_time = "10:00:00"
}

resource "local_file" "create_sh" {
  content  = <<EOF

    clickhouse client --host ${aiven_clickhouse.clickhouse.service_host} \
                  --secure \
                  --port ${aiven_clickhouse.clickhouse.service_port} \
                  --user ${aiven_clickhouse.clickhouse.service_username} \
                  --password ${aiven_clickhouse.clickhouse.service_password} \
      < create-table.sql
    
    echo "Created the clickhouse table"

    counter=0
    while [ $counter -le 19 ]
    do 
      echo "insert trips_$counter.tsv into clickhouse"

      clickhouse client --host ${aiven_clickhouse.clickhouse.service_host} \
                  --secure \
                  --port ${aiven_clickhouse.clickhouse.service_port} \
                  --user ${aiven_clickhouse.clickhouse.service_username} \
                  --password ${aiven_clickhouse.clickhouse.service_password} \
                  --query "
        INSERT INTO trips
          SELECT
            trip_id,
            pickup_datetime,
            dropoff_datetime,
            pickup_longitude,
            pickup_latitude,
            dropoff_longitude,
            dropoff_latitude,
            passenger_count,
            trip_distance,
            fare_amount,
            extra,
            tip_amount,
            tolls_amount,
            total_amount,
            payment_type,
            pickup_ntaname,
            dropoff_ntaname
          FROM input('trip_id UInt32, pickup_datetime DateTime, dropoff_datetime DateTime, pickup_longitude Nullable(Float64), pickup_latitude Nullable(Float64), dropoff_longitude Nullable(Float64),dropoff_latitude Nullable(Float64),passenger_count UInt8,trip_distance Float32,fare_amount  Float32, extra Float32, tip_amount Float32, tolls_amount Float32, total_amount Float32, payment_type Enum8(\'CSH\' = 1, \'CRE\' = 2, \'NOC\' = 3, \'DIS\' = 4, \'UNK\' = 5), pickup_ntaname LowCardinality(String), dropoff_ntaname LowCardinality(String)')
          FORMAT TabSeparatedWithNames
        " < trips_$counter.tsv
        
        ((counter++))
        echo "finished dataset"
    done

    echo "finished loading all $counter datasets"

    EOF
  filename = "../data/create.sh"
  file_permission = 0711
}

