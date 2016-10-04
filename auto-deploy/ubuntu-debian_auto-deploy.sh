#!/bin/bash
source docker_friendly_functions

clear 
printf "\n$W╔═════════════════════════════════════════════════════════╗\n"
printf "$W║                                                       $B▓███▓▒░\n"
printf "$W║     ${W}BIENVENIDO A LA INSTALACION AUTOMATICA DE ${BOLD}CKAN${NORMAL}    $W▓███▓▒░\n"
printf "$W║                ${W}EN DOCKER ${BOLD}UBUNTU|DEBIAN${NORMAL}.               $B▓███▓▒░\n"
printf "$W╚═════════════════════════════════════════════════════════╝\n"
# Esta docker insalado?	
if [ $(dpkg-query -W -f='${Status}' docker-engine 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
	# No? no importa, lo instalamos! :D
	install_docker_debian
fi
# Instalemos CKAN! :D
deploy_portal
if [[ $? -eq 0 ]]; then
	# OK! veamos como quedo tu portal! :D
	echo "Todo listo! el portal esta funcionando! :D"
else
	echo "Oops... Algo se rompio..."
fi
