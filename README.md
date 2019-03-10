## InfNodGraf

Install the [influxDB] database, the [Node-RED] flow-based programming language and analytic tool [Grafana]
on a Raspberry Pi with [LoxBerry] 1.4 via a docker environment.

This is experimental and not for productive usage.
No warranty 


# Install Docker Composer

curl -L https://github.com/mjuu/rpi-docker-compose/blob/master/v1.12.0/docker-compose-v1.12.0?raw=true -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose


# Copy InfNodGraf.yml to the Raspberry Pi and start the docker containers

docker-compose -f InfNodGraf.yml up -d


## To install the influxDB plugin in the Node-RED container:

# Connect to the container
docker exec -it mynodered /bin/bash

# In the container install the plugin
cd /data
npm install node-red-contrib-influxdb
exit

# Restart the container
docker stop mynodered
docker start mynodered


## To create a database:

# Connect to the container
docker exec -it myinfluxdb /bin/bash
# Connect to the database server
influx
# Create a database and exit 
CREATE DATABASE TEST_NAME
exit
# Exit the container
exit



[influxDB]: https://www.influxdata.com
[Node-RED]: https://nodered.org
[Grafana]: https://grafana.com
[LoxBerry]: https://www.loxwiki.eu/display/LOXBERRY/LoxBerry

