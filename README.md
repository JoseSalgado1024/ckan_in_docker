# CKAN Docker
_El mismo CKAN de siempre pero.. bellamente dockerizado..._

## Prerequisitos:
### DOCKER:
+ Docker para **OSX**:_TODO_

+ Docker para **Ubunut/Debian**:_TODO_
	```bash
	# Paso 1 UPDATE & UPGRADE
	sudo apt-get update && sudo apt-get -y upgrade


	# Nos aserguramos tenemos soporte para aufs disponible:
	sudo apt-get -q -y install linux-image-extra-`uname -r`

	# KEY para el repositorio de Docker.io:
	sudo apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

	# Añadimos el repositorio de Docker a APT Sources:
	echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | sudo tee /etc/apt/sources.list.d/docker.list
	echo "deb http://cz.archive.ubuntu.com/ubuntu trusty main" | sudo tee /etc/apt/sources.list
	sudo apt-get update && sudo apt-get -y upgrade

	# Update the repository with the new addition and install docker-engine:
	sudo apt-get install --upgrade cgroup-lite cgroupfs-mount aufs-tools  libsystemd-journal0 && sudo apt-get update && sudo apt-get -q -y install docker-engine
	sudo service docker start

	# Editamos la configuracion de UFW:
	sudo sed 's/DEFAULT_FORWARD_POLICY="DROP"/DEFAULT_FORWARD_POLICY="ACCEPT"/g' /etc/default/ufw > /etc/default/ufw.tmp && mv /etc/default/ufw.tmp /etc/default/ufw

	# Recargamos el servicio ufw:
	sudo ufw reload

	#Correr Docker como Daemon
	sudo docker -d &

	# Correr $ Docker sin "sudo"
	sudo groupadd docker
	sudo gpasswd -a ${USER} docker
	sudo service docker restart
```

+ Docker para **RHEL/CenOS**:_TODO_


### DOCKER IMGs:
_Vamos a requerir dos contenedores extras, ambos pertenecen al dockerHub Oficial de CKAN. Para mas informacion, visitar [esta](https://hub.docker.com/u/ckan/) pagina._
+ CKAN DB _[mas infomacion](https://hub.docker.com/r/ckan/postgresql/)_:

	docker run -d  --name db ckan/postgresql 	


+ CKAN SOLR _[mas infomacion](https://hub.docker.com/r/ckan/solr/)_:
	docker run -d  --name solr ckan/solr 	



