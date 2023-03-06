

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
      < create-dish.sql
    
      clickhouse client --host ${aiven_clickhouse.clickhouse.service_host} \
                  --secure \
                  --port ${aiven_clickhouse.clickhouse.service_port} \
                  --user ${aiven_clickhouse.clickhouse.service_username} \
                  --password ${aiven_clickhouse.clickhouse.service_password} \
      < create-menu.sql
      
      clickhouse client --host ${aiven_clickhouse.clickhouse.service_host} \
                  --secure \
                  --port ${aiven_clickhouse.clickhouse.service_port} \
                  --user ${aiven_clickhouse.clickhouse.service_username} \
                  --password ${aiven_clickhouse.clickhouse.service_password} \
      < create-menupage.sql
      
      clickhouse client --host ${aiven_clickhouse.clickhouse.service_host} \
                  --secure \
                  --port ${aiven_clickhouse.clickhouse.service_port} \
                  --user ${aiven_clickhouse.clickhouse.service_username} \
                  --password ${aiven_clickhouse.clickhouse.service_password} \
      < create-menuitem.sql
      
    echo "Created the clickhouse tables"

    clickhouse client --host ${aiven_clickhouse.clickhouse.service_host} \
                  --secure \
                  --port ${aiven_clickhouse.clickhouse.service_port} \
                  --user ${aiven_clickhouse.clickhouse.service_username} \
                  --password ${aiven_clickhouse.clickhouse.service_password} \
                  --format_csv_allow_single_quotes 0  \
                  --input_format_null_as_default 0 \
                  --query "INSERT INTO dish FORMAT CSVWithNames" < Dish.csv

      echo "Loaded the dishes"

      clickhouse client --host ${aiven_clickhouse.clickhouse.service_host} \
                  --secure \
                  --port ${aiven_clickhouse.clickhouse.service_port} \
                  --user ${aiven_clickhouse.clickhouse.service_username} \
                  --password ${aiven_clickhouse.clickhouse.service_password} \
                  --format_csv_allow_single_quotes 0 \
                  --input_format_null_as_default 0 \
                  --query "INSERT INTO menu FORMAT CSVWithNames" < Menu.csv

      echo "loaded the menus"

      clickhouse client --host ${aiven_clickhouse.clickhouse.service_host} \
                  --secure \
                  --port ${aiven_clickhouse.clickhouse.service_port} \
                  --user ${aiven_clickhouse.clickhouse.service_username} \
                  --password ${aiven_clickhouse.clickhouse.service_password} \
                --format_csv_allow_single_quotes 0 \
                --input_format_null_as_default 0 \
                --query "INSERT INTO menu_page FORMAT CSVWithNames" < MenuPage.csv
      
      echo "loaded the menu pages"

      clickhouse client --host ${aiven_clickhouse.clickhouse.service_host} \
                  --secure \
                  --port ${aiven_clickhouse.clickhouse.service_port} \
                  --user ${aiven_clickhouse.clickhouse.service_username} \
                  --password ${aiven_clickhouse.clickhouse.service_password} \
                  --format_csv_allow_single_quotes 0 \
                  --input_format_null_as_default 0 \
                  --date_time_input_format best_effort \
                  --query "INSERT INTO menu_item FORMAT CSVWithNames" < MenuItem.csv

    echo "finished loading datasets"

    EOF
  filename = "../data/create.sh"
  file_permission = 0711
}

