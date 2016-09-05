# CKAN Docker
_El mismo CKAN de siempre pero.. bellamente dockerizado..._

## Que es CKAN?

Comprehensive Knowledge Archive Network (CKAN) es una aplicación web de código abierto para el almacenamiento y la distribución de los datos, tales como hojas de cálculo y los contenidos de las bases de datos. Está inspirado en las capacidades de gestión de paquetes comunes para abrir sistemas operativos, como Linux, y está destinado a ser el "apt-get de Debian para los datos"

_fuente: [wikipedia](https://es.wikipedia.org/wiki/CKAN)_

## Que es DOCKER?

es un proyecto de código abierto que automatiza el despliegue de aplicaciones dentro de contenedores de software, proporcionando una capa adicional de abstracción y automatización de Virtualización a nivel de sistema operativo en Linux.
_fuente: [wikipedia](https://es.wikipedia.org/wiki/Docker_(software))_


## Prerequisitos:

### DOCKER:

+ Docker para [OSX](https://docs.docker.com/docker-for-mac).

+ Docker para [Ubuntu/Debian](https://github.com/JoseSalgado1024/ckan_in_docker/blob/master/utiles/docker_Ubuntu-Debian.md).

+ Docker para [RHEL/CentOS](https://github.com/JoseSalgado1024/ckan_in_docker/blob/master/utiles/docker_rhel-centos.md).

+ Docker para [Windows](https://docs.docker.com/engine/installation/windows).


### DOCKER IMGs:

_Vamos a requerir dos contenedores extras, ambos pertenecen al dockerHub Oficial de CKAN. Para mas informacion, visitar [esta](https://hub.docker.com/u/ckan/) pagina._

+ CKAN DB _[+info](https://hub.docker.com/r/ckan/postgresql/)_:

		docker run -d  --name db ckan/postgresql 	


+ CKAN SOLR _[+info](https://hub.docker.com/r/ckan/solr/)_:

		docker run -d  --name solr ckan/solr 	


### GIT TOOLs:
	
+ Windows:
_Descargar e Instalar desde:_

		https://github.com/git-for-windows/git/releases/tag/v2.10.0.windows.1

+ Ubuntu/Debian:

		$ sudo su -c "apt-get update && apt-get install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel"
		$ sudo su -c "apt-get -y install git-core"

+ RHEL/CentOS:

		$ yum update && yum install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel
		$ yum install -y git-core

+ OSX:

		sudo port install git-core +svn +doc +bash_completion +gitweb


## Instalacion y Ejecucion de CKAN

	sudo su -c "cd /tmp && git clone https://github.com/JoseSalgado1024/ckan_in_docker.git && cd /tmp/ckan_in_docker && docker build -t jsalgadowk/ckan:latest ."
	sudo su -c "docker run -d --link db:db --link solr:solr -p 5000:5000 jsalgadowk/ckan:latest"


Al finalizar, y para corrovorar que todo esta funcionando perfectamente, chequear [ckan_local](http://localhost:5000).