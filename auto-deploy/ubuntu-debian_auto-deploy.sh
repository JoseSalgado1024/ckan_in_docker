#!/bin/bash
DHUB_USER="jsalgadowk"
CKAN_DI="ckan"
PG_DI="pg-ckan"
SOLR_DI="solr"

# Pull all containers [pg-ckan, ckan, solr]
docker_pull_all_containers(){
	echo ""
	echo "++----------------------------------------------+";
	echo "|            DESCARGAR CONTENEDORES             |";
	echo "+-----------------------------------------------+";
	echo $CKAN_DI $PG_DI $SOLR_DI | xargs -n 1 | while read img; do docker pull $DHUB_USER/$img:latest; done
}

# Delete all containers! (cause i think is fun..)
docker_containers_delete_all (){
	echo ""
	echo "++----------------------------------------------+";
	echo "|              BYE BYE CONTAINERS               |";
	echo "+-----------------------------------------------+";
	docker rm -f $(docker ps -a -q)
}

# Stop all your running docker containers
docker_stop_all (){
	echo ""
	echo "++----------------------------------------------+";
	echo "|          STOP ALL DOCKER CONTAINERS           |";
	echo "+-----------------------------------------------+";
	docker stop -f $(docker ps -a -q)
}

# Bye Bye Docker images!
docker_imgs_delete_all (){
	echo ""
	echo "++----------------------------------------------+";
	echo "|           BYE BYE DOCKER IMAGES               |";
	echo "+-----------------------------------------------+";
	docker rmi -f $(docker images -q)
}

# EASY WAY TO INSTALL DCOKER (...cause i'm a rockstar \o/)
install_docker_debian (){
	echo ""
	echo "++----------------------------------------------+";
	echo "|                INSTALANDO DOCKER              |";
	echo "+-----------------------------------------------+";
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

install_docker_rhel(){
	sudo su -c "yum update"
	# Paso 2: Añadir el Repositorio de Docker.
	sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
	[dockerrepo]
	name=Docker Repository
	baseurl=https://yum.dockerproject.org/repo/main/centos/7/
	enabled=1
	gpgcheck=1
	gpgkey=https://yum.dockerproject.org/gpg
	EOF
	# Paso 3: Instalar paquetes de Docker:
	sudo su -c "yum install -y docker-engine"
	# Paso 4: Instalar e iniciar el Daemon de Docker.
	sudo su -c "chkconfig docker on"
	sudo su -c "service docker start"
	# Paso 6: Crear grupo "docker"
	sudo su -c "groupadd docker"
	# Paso 7: añadir tu usuario al grupo antes creado.
	sudo usermod -aG docker $(id -u -n)
}

start_ckan-docker (){
	echo ""
	echo "++----------------------------------------------+";
  	echo "|         INICIANDO PORTAL CKAN-DOCKER          |";
  	echo "+-----------------------------------------------+";
  	echo $PG_DI, $SOLR_DI | xargs -n 1 | while read img; do echo "docker run -d  --name $img $DHUB_USER/$img"; done
  	docker run -d --link $PG_DI:db --link $SOLR_DI:solr -p 80:80 $DHUB_USER/$CKAN_DI:latest

}


deploy_portal (){
	# Paso 1: Descargo todos lo contenedores necesarios.
	docker_pull_all_containers
	# Paso 2: Run CKAN!
	start_ckan-docker 
}
source docker_friendy_functions

printf "\n\x1B[32m++----------------------------------------------+\n";
printf "\x1B[32m|                                               \x1B[32m|\n";
printf "\x1B[32m|     \x1B[37mBIENVENIDO A LA INSTALACION AUTOMATICA    \x1B[32m|\n";
printf "\x1B[32m|        \x1B[37mDE CKAN EN DOCKER UBUNTU|DEBIAN        \x1B[32m|\n";
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
if [[ $? -eq 0 ]]; then
	# OK! veamos como quedo tu portal! :D
	firefox 'http://localhost' &
else
	echo "Oops... Algo se rompio..."
fi
