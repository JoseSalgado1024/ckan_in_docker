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
	install_docker
fi
# Instalemos CKAN! :D
deploy_portal
printf "CKAN esta iniciando... "
sleep 1
if [[ $? -eq 0 ]]; then
	# OK! veamos como quedo tu portal! :D
	printf "[OK]\nTodo listo! el portal esta funcionando! :D\n "
	#sleep 5
	#bind_portal
	#print_ckan_status
	printf \
"
Bien! hasta ahora tenes todo instalado y funcional, solo hacen falta dos \"pasitos\" mas y estaria listo tu ckan.
1) Bindear tu ckan con internet, esto se refiere a que configures tu url dentro de CKAN, puede ser un ip o una direccion humana, es facil, se hace asi:

	Si tu url es un ip, ej: 123.456.654.321:

    docker exec ckan /usr/lib/ckan/default/bin/paster --plugin=ckan config-tool /etc/ckan/default/development.ini -e \
    \"ckan.datapusher.url = http://123.456.654.321:8800\" \
    \"ckan.site_url = http://123.456.654.321\"

    Si usas una url del tipo: \"mi_ckan.com\", deberias configurarla de la siguiente manera:

    docker exec ckan /usr/lib/ckan/default/bin/paster --plugin=ckan config-tool /etc/ckan/default/development.ini -e \
    \"ckan.datapusher.url = http://mi_ckan.com:8800\" \
    \"ckan.site_url = http://mi_ckan.com\"

2) Crear usuario \"ckan_admin\" para que puedas crear tus objetos dentro de ckan, lo haces asi:
	docker exec ckan /usr/lib/ckan/default/bin/paster --plugin=ckan sysadmin add ckan_admin -c /etc/ckan/default/development.ini

...Y listo! ya podes contarle a todo el mundo que tenes un CKAN muy bonito para compartir tus recursos! 
"
else
	printf "[FALLO]\nOops... Algo se rompio...\n"
fi