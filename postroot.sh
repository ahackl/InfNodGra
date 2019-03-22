#!/bin/bash

# Shell script which is executed by bash *AFTER* complete installation is done
# (*AFTER* postinstall and *AFTER* postupdate). Use with caution and remember,
# that all systems may be different!
#
# Exit code must be 0 if executed successfull. 
# Exit code 1 gives a warning but continues installation.
# Exit code 2 cancels installation.
#
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Will be executed as user "root".
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
# You can use all vars from /etc/environment in this script.
#
# We add 5 additional arguments when executing this script:
# command <TEMPFOLDER> <NAME> <FOLDER> <VERSION> <BASEFOLDER>
#
# For logging, print to STDOUT. You can use the following tags for showing
# different colorized information during plugin installation:
#
# <OK> This was ok!"
# <INFO> This is just for your information."
# <WARNING> This is a warning!"
# <ERROR> This is an error!"
# <FAIL> This is a fail!"

# To use important variables from command line use the following code:
COMMAND=$0    # Zero argument is shell command
PTEMPDIR=$1   # First argument is temp folder during install
PSHNAME=$2    # Second argument is Plugin-Name for scipts etc.
PDIR=$3       # Third argument is Plugin installation folder
PVERSION=$4   # Forth argument is Plugin version
#LBHOMEDIR=$5 # Comes from /etc/environment now. Fifth argument is
              # Base folder of LoxBerry
PTEMPPATH=$6  # Sixth argument is full temp path during install (see also $1)

# Combine them with /etc/environment
PCGI=$LBPCGI/$PDIR
PHTML=$LBPHTML/$PDIR
PTEMPL=$LBPTEMPL/$PDIR
PDATA=$LBPDATA/$PDIR
PLOG=$LBPLOG/$PDIR # Note! This is stored on a Ramdisk now!
PCONFIG=$LBPCONFIG/$PDIR
PSBIN=$LBPSBIN/$PDIR
PBIN=$LBPBIN/$PDIR

echo -n "<INFO> Current working folder is: "
pwd
echo "<INFO> Command is: $COMMAND"
echo "<INFO> Temporary folder is: $PTEMPDIR"
echo "<INFO> (Short) Name is: $PSHNAME"
echo "<INFO> Installation folder is: $PDIR"
echo "<INFO> Plugin version is: $PVERSION"
echo "<INFO> Plugin CGI folder is: $PCGI"
echo "<INFO> Plugin HTML folder is: $PHTML"
echo "<INFO> Plugin Template folder is: $PTEMPL"
echo "<INFO> Plugin Data folder is: $PDATA"
echo "<INFO> Plugin Log folder (on RAMDISK!) is: $PLOG"
echo "<INFO> Plugin CONFIG folder is: $PCONFIG"

# check if docker is already installed, otherwise install
if  [ ! -f "/usr/bin/docker" ]
then
	# error: docker not installed
	echo "<FAIL> Docker not installed"
	exit 2
fi


# if influxdb container does not exists
container=$(docker ps --filter name=influxdb -q)
if [ "$container" == "" ]
then
	# check if stopped influx container exists
	container=$(docker ps -a --filter name=influxdb -q)
	if ! [ "$container" == "" ]
	then
		# remove stopped influxdb container
		docker rm influxdb
	fi
	# pull influxdb docker image
	docker pull influxdb
	# start influxdb container
	docker run --name=influxdb --restart always \
		-d -p 8086:8086 \
		-v influxdb_data:/var/lib/influxdb \
		-e INFLUXDB_HTTP_AUTH_ENABLED=true \
		-e INFLUXDB_ADMIN_ENABLED=true \
		-e INFLUXDB_ADMIN_USER=dbadmin \
		-e INFLUXDB_ADMIN_PASSWORD=dbadmin \
		influxdb
        # create a database
	curl -i -XPOST "http://localhost:8086/query?u=dbadmin&p=dbadmin" --data-urlencode "q=CREATE DATABASE loxdb"
fi


# if nodered container does not exists
container=$(docker ps --filter name=nodered -q)
if [ "$container" == "" ]
then
	# check if stopped nodered container exists
	container=$(docker ps -a --filter name=nodered -q)
	if ! [ "$container" == "" ]
	then
		# remove stopped nodered container
		docker rm nodered
	fi
	# pull nodered docker image
	docker pull nodered/node-red-docker:rpi
	# start nodered container
	docker run --name=nodered --restart always \
		-d -p 1880:1880 \
		-v nodered_data:/data \
		nodered/node-red-docker:rpi

	# install modules
	modules=(node-red-contrib-influxdb node-red-dashboard node-red-node-openweathermap)
	for i in "${modules[@]}"
	do
		docker exec -ti nodered sh -c "cd /data && npm install $i && exit"
	done
	docker stop nodered
	docker start nodered
fi

# if grafana container does not exists
container=$(docker ps --filter name=grafana -q)
if [ "$container" == "" ]
then
	# check if stopped grafana container exists
	container=$(docker ps -a --filter name=grafana -q)
	if ! [ "$container" == "" ]
	then
		# remove stopped grafana container
		docker rm grafana
	fi
	# pull grafana docker image
	docker pull grafana/grafana
	# start grafana container
	docker run --name=grafana --restart always \
		-d -p 3000:3000 \
	    -e GF_SECURITY_ADMIN_PASSWORD=admin \
		-v grafana_data:/var/lib/grafana \
		grafana/grafana

fi




# Exit with Status 0
exit 0
