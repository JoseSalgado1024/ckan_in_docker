#!/bin/bash

# Colores de Fuentes
FBLACK="\033[30;"
FRED="\033[31;"
FGREEN="\033[32;"
FYELLOW="\033[33;"
FBLUE="\033[34;"
FPURPLE="\033[35;"
D_FGREEN="\033[6;"
FWHITE="\033[7;"
FCYAN="\x1b[36m"

DHUB_USER="jsalgadowk"
CKAN_DI="ckan"
PG_DI="pg-ckan"
SOLR_DI="solr"


# Fiendy Docker functions! :D
# Pull all containers [pg-ckan, ckan, solr]
docker_pull_all_containers(){
	print ""
	echo $CKAN_DI, $PG_DI, $SOLR_DI | xargs -n 1 | while read img; do echo "docker pull $DHUB_USER/$img:latest"; done
}

docker_containers_delete_all (){
	print ""
	docker rm $(docker ps -a -q)
}

docker_stop_all (){
	print ""
	docker stop $(docker ps -a -q)
}

docker_imgs_delete_all (){
	print ""
	docker rmi $(docker images -q)
}

install_docker (){
	### Paso 1 UPDATE & UPGRADE
	sudo su -c "apt-get -qqy update && apt-get -qqy upgrade"

	### Nos aserguramos tenemos soporte para aufs disponible:
	sudo su -c "apt-get -q -y install linux-image-extra-`uname -r`"

	### KEY para el repositorio de Docker.io:
	sudo apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

	### Añadimos el repositorio de Docker a APT Sources:
	echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | sudo tee /etc/apt/sources.list.d/docker.list
	echo "deb http://cz.archive.ubuntu.com/ubuntu trusty main" | sudo tee /etc/apt/sources.list
	sudo apt-get update && sudo apt-get -y upgrade

	### Update apt-get e install docker-engine:
	sudo apt-get install --upgrade cgroup-lite cgroupfs-mount aufs-tools  libsystemd-journal0 && sudo apt-get update && sudo apt-get -q -y install docker-engine
	sudo service docker start

	### Editamos la configuracion de UFW:
	sudo su -c "sed 's/DEFAULT_FORWARD_POLICY=\"DROP\"/DEFAULT_FORWARD_POLICY=\"ACCEPT\"/g' /etc/default/ufw > /etc/default/ufw.tmp && mv /etc/default/ufw.tmp /etc/default/ufw"

	### Recargamos el servicio ufw:
	sudo su -c "ufw reload"

	### Correr $ Docker sin "sudo"
	sudo su -c "groupadd docker"
	sudo su -c "gpasswd -a ${USER} docker"
	sudo su -c "service docker restart"
}

start_ckan-docker (){
	echo "++----------------------------------------------+";
  	echo "|         INICIANDO PORTAL CKAN-DOCKER          |";
  	echo "+-----------------------------------------------+";
  	echo "docker run -d --link db:db --link solr:solr -p 80:80 $DHUB_USER/$CKAN_DI:latest"

}

deploy_portal (){
	# Paso 1: Descargo todos lo contenedores necesarios.
	docker_pull_all_containers
	
	# Paso 2: 
}

# Esta docker insalado?	
if [ $(dpkg-query -W -f='${Status}' docker-engine 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  echo "++----------------------------------------------+";
  echo "|                                               |";
  echo "|                INSTALANDO DOCKER              |";
  echo "|                                               |";
  echo "+-----------------------------------------------+";
  echo "install_docker"
fi
deploy_portal