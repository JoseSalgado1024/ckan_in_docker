#!/bin/bash
source docker_friendy_functions.sh

echo "++----------------------------------------------+";
echo "|                                               |";
echo "|     BIENVENIDO A LA INSTALACION AUTOMATICA    |";
echo "|               DE CKAN EN DOCKER               |";
echo "|                                               |";
echo "+-----------------------------------------------+";
# Esta docker insalado?	
if [ $(dpkg-query -W -f='${Status}' docker-engine 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
	# No? no importa, lo instalamos! :D
	install_docker_rhel
fi
deploy_portal