#!/bin/bash
source docker_friendly_functions

clear  
printf "\n$W ╔═════════════════════════════════════════════════════════╗\n"
printf "$W ║                                                       $B▓███▓▒░\n"
printf "$W ║     ${W}BIENVENIDO A LA INSTALACION AUTOMATICA DE ${BOLD}CKAN${NORMAL}    $W▓███▓▒░\n"
printf "$W ║                 ${W}EN DOCKER ${BOLD}RHEL|CentOS${NORMAL}${W}.                $B▓███▓▒░\n"
printf "$W ╚═════════════════════════════════════════════════════════╝\n\n"

# Esta docker insalado?	
if [ $(dpkg-query -W -f='${Status}' docker-engine 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
	# No? no importa, lo instalamos! :D
	install_docker_rhel
fi
deploy_portal