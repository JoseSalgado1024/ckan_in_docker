#!/bin/bash
source docker_friendy_functions.sh

printf "\n\x1B[32m++----------------------------------------------+\n";
printf "\x1B[32m|                                               \x1B[32m|\n";
printf "\x1B[32m|     \x1B[37mBIENVENIDO A LA INSTALACION AUTOMATICA    \x1B[32m|\n";
printf "\x1B[32m|               \x1B[37mDE CKAN EN DOCKER               \x1B[32m|\n";
printf "\x1B[32m|                                        \x1B[34mXX\x1B[37mXX\x1B[34mXX \x1B[32m|\n";
printf "\x1B[32m+-----------------------------------------------+\n\n";
# Esta docker insalado?	
if [ $(dpkg-query -W -f='${Status}' docker-engine 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
	# No? no importa, lo instalamos! :D
	install_docker_debian
fi
# Instalemos CKAN! :D
deploy_portal
# OK! veamos como quedo tu portal! :D
firefox 'http://localhost' &
