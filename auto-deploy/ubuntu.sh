#!/bin/bash
DHUB_USER="jsalgadowk"
CKAN_DI="ckan"
PG_DI="pg-ckan"
SOLR_DI="solr"
HOST_TO_BIND=""

CKAN_APACHE2_PORT="80"
CKAN_DATAPUSHER_PORT="8800"
CKAN_CONFIG_FILE="development.ini"
CKAN_HOME="/usr/lib/ckan/default"
CKAN_CONFIG="/etc/ckan/default"
CKAN_DATA="/var/lib/ckan"



# FONT COLORS & STYLE :D
R="\x1B[31m"
G="\x1B[29m"
GG="\x1B[32m"
B="\x1B[34m"
Y="\x1B[33m"
W="\x1B[37m"
BL="\x1B[30m"
V="\x1B[35m"
C="\x1B[36m"
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

get_ip(){
	echo $(ifconfig $(route | grep '^default' | grep -o '[^ ]*$') | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
}

clear 
printf "\n
╔═════════════════════════════════════════════════════════╗\n
║                                                         ║\n
║     BIENVENIDO A LA INSTALACION AUTOMATICA DE CKAN      ║\n
║                EN DOCKER UBUNTU|DEBIAN.                 ║\n
║                                                         ║\n
╚═════════════════════════════════════════════════════════╝\n"
# Esta docker insalado?	
if [ $(dpkg-query -W -f='${Status}' docker-engine 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
	# No? no importa, lo instalamos! :D
	echo "Instalando Docker Engine ..."
	curl -sSL https://get.docker.com/ | sh
fi
# Instalemos CKAN! :D
echo "$CKAN_DI $PG_DI $SOLR_DI" | xargs -n 1 | while read img; do docker rm -f $img; done
echo "$CKAN_DI $PG_DI $SOLR_DI" | xargs -n 1 | while read img; do docker pull $DHUB_USER/$img:latest; done
mkdir -p $HOME/ckan/volumenes/data $HOME/ckan/volumenes/config $HOME/ckan/volumenes/pgdata
echo "$PG_DI $SOLR_DI" | xargs -n 1 | while read img; do docker run -d  --name $img $DHUB_USER/$img; done
docker run -dit -v $HOME/ckan/volumenes/data:/var/lib/ckan --link $PG_DI:db --link $SOLR_DI:solr -p 80:80 -p 8800:8800 --name $CKAN_DI $DHUB_USER/$CKAN_DI:latest

