#!/bin/bash

counter=0

while [ $counter -le 19 ]
do
   curl -O https://datasets-documentation.s3.eu-west-3.amazonaws.com/nyc-taxi/trips_$counter.gz 
   gzip -d trips_$counter.gz
   mv trips_$counter trips_$counter.tsv
   ((counter++))
done

echo "finished"
