#!/bin/bash

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
  	echo "docker run -d --link db:db --link solr:solr -p 80:80 jsalgadowk/ckan:latest"

}


deploy_postgresql (){
	echo "++----------------------------------------------+";
  	echo "|             INSTALANDO POSTGRESQL             |";
  	echo "+-----------------------------------------------+";
  	echo "cd ckan_in_docker/postgresql-img/"
	echo "docker build -t jsalgadowk/postgresql:latest ."
	echo "docker run -d  --name db jsalgadowk/postgresql:latest"
}

deploy_solr (){
	echo "-------------------------------------------------";
  	echo "|               INSTALANDO SOLR                 |";
  	echo "-------------------------------------------------";
  	echo "cd ckan_in_docker/sorl-img/"
	echo "docker build -t jsalgadowk/sorl:latest ."
	echo "docker run -d  --name sorl jsalgadowk/sorl:latest"
}

deploy_ckan (){
	echo ""
	echo "++----------------------------------------------+";
	echo "|               INSTALANDO CKAN                 |";
	echo "+-----------------------------------------------+";
	echo "cd ckan_in_docker/ckan-img/"
	echo "docker build -t jsalgadowk/ckan:latest ."
}

deploy_portal (){
	echo ""
	echo "++----------------------------------------------+";
	echo "|                                               |";
	echo "|               INSTALANDO PORTAL               |";
	echo "|                                               |";
	echo "+-----------------------------------------------+";  
	deploy_postgresql
	sleep 1
	deploy_solr
	sleep 1
	deploy_ckan
	sleep 1
	start_ckan-docker
	echo "Enjoy! :D"

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