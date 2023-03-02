# Clickhouse Demo - NY Taxi Data

This demo is built following the instructions in the [Clickhouse](https://clickhouse.com/docs/en/getting-started/example-datasets/nyc-taxi) documentation. 

*The terraform script included in this project will create a file that has the credentials for this database in the data directory!! It is a demo, think carefully friends*

## Pre-requisites
This was built and tested on an Apple Silicon mac, it hasn't really be valiated on anything else. 

* [Clickhouse binary](https://clickhouse.com/docs/en/install)
* [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
* [Aiven CLI](https://docs.aiven.io/docs/tools/cli)
* Aiven account and an [authentication token](https://docs.aiven.io/docs/platform/howto/create_authentication_token)

## Setup
Once you have downloaded this repository `git clone git@github.com:troysellers/ny-taxi-ch-demo.git`

get the data to work with

```
$> cd ny-taxi-ch-demo/data
$> ./get-data.sh
```

This might take a few minutes, we are going to get all 20 sets of the data.
You will end up with a collection of .tsv files that we are going to then load into Clickhouse. 

## Build the Clickhouse service
Now move into the terraform directory.

```
$> cd ../terraform
$> terraform init
```
This is going to setup the terraform things.. then, run the script. 

If you normally don't YOLO, perhaps `terraform plan` first? 

```
$> terraform apply --auto-approve
```

## Import your data
Move into the data directory 
```
$> cd ../data
```

Run the script that the terraform script would have output for you
```
$> ./create_sh
```


## Query your clickhouse. 
Open the Aiven [console](https://console.aiven.io) to get your credentials for Clickhouse
(If you open the `create_sh` script you will also find this command in that script.) 

![Clickhouse connection](img/ch-creds.png)

Now connect and query away! 

```
$> clickhouse client \
    --host <host> \
    --secure \
    --port <port> \
    --password <password> \
    --user <user> 
```

Want to see the most popular pickup locations in NY? 
```
$> select pickup_ntaname, count() as count from trips group by pickup_ntaname order by count desc limit 10


Query id: 1ab0a0cf-fc01-495e-88ec-1060bc9d3653

┌─pickup_ntaname─────────────────────────────┬───count─┐
│ Midtown-Midtown South                      │ 3460770 │
│ Hudson Yards-Chelsea-Flatiron-Union Square │ 1893412 │
│ West Village                               │ 1380513 │
│ Turtle Bay-East Midtown                    │ 1291080 │
│ Upper East Side-Carnegie Hill              │ 1214850 │
│ Airport                                    │  993906 │
│ SoHo-TriBeCa-Civic Center-Little Italy     │  951070 │
│ Murray Hill-Kips Bay                       │  909452 │
│ Upper West Side                            │  893506 │
│ Clinton                                    │  855681 │
└────────────────────────────────────────────┴─────────┘

10 rows in set. Elapsed: 0.108 sec. Processed 19.71 million rows, 21.84 MB (182.08 million rows/s., 201.83 MB/s.)
```

Not bad, processing 19.7 million rows in 100ms. 


