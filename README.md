# CKAN Docker
_El mismo CKAN de siempre pero.. bellamente dockerizado..._

## Que es CKAN?

Comprehensive Knowledge Archive Network (CKAN) es una aplicación web de código abierto para el almacenamiento y la distribución de los datos, tales como hojas de cálculo y los contenidos de las bases de datos. Está inspirado en las capacidades de gestión de paquetes comunes para abrir sistemas operativos, como Linux, y está destinado a ser el "apt-get de Debian para los datos"

_fuente: [wikipedia](https://es.wikipedia.org/wiki/CKAN)_

## Que es DOCKER?

es un proyecto de código abierto que automatiza el despliegue de aplicaciones dentro de contenedores de software, proporcionando una capa adicional de abstracción y automatización de Virtualización a nivel de sistema operativo en Linux.
_fuente: [wikipedia](https://es.wikipedia.org/wiki/Docker_(software))_

## Con que cuenta esta version de CKAN?

Features:

+ CKAN 2.6.
+ Datastore.
+ Datapusher.
+ WSGI.
+ Extensiones:
	+ CKAN-Hierarchy. Mas informacion [aqui](https://github.com/datagovuk/ckanext-hierarchy)
	+ CKAN-GobArTheme. Ver [Demo](http://http://datos.gob.ar/). Mas Informacion [aqui](https://github.com/gobabiertoAR/datos.gob.ar/blob/master/docs/03_instalacion_tema_visual.md)
+ Ckan-tools


## Prerequisitos:

### DOCKER:

+ Docker para [OSX](https://docs.docker.com/docker-for-mac).

+ Docker para [Ubuntu/Debian](https://github.com/JoseSalgado1024/ckan_in_docker/blob/master/aux-docs/docker_Ubuntu-Debian.md).

+ Docker para [RHEL/CentOS](https://github.com/JoseSalgado1024/ckan_in_docker/blob/master/aux-docs/docker_rhel-centos.md).

+ Docker para [Windows](https://docs.docker.com/engine/installation/windows).


### GIT TOOLs(_...All you need is Git..._):
	
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
_Para instalar y ejecutar CKAN-Docker, debemos seguir los siguientes pasos:_

+ Paso 1: Clonar Repositorio. _Es recomendable clonar el repo dentro de /tmp (o C:\temp en **Windows X**), dado que al finalizar la instalacion, no usaremos mas el repositorio_.
		
		$ cd /tmp # en Linux, en Windows, usar cd C:\temp
		$ git clone https://github.com/JoseSalgado1024/ckan_in_docker.git

+ Paso 2: _construir y lanzar el contenedor de **PostgreSQL** usando el Dockerfile hubicado en **postgresql-img/**._ 

		$ cd ckan_in_docker/postgresql-img/
		$ docker build -t jsalgadowk/postgresql:latest .
		$ docker run -d  --name db jsalgadowk/postgresql:latest


+ Paso 3: _construir y lanzar el contenedor de **Solr** usando el Dockerfile hubicado en **solr-img/**._

		# Salimos una carpeta hacia atras mediante cd ..
		$ cd ckan_in_docker/solr-img/ 
		$ docker build -t jsalgadowk/solr:latest .
		$ docker run -d  --name solr jsalgadowk/solr:latest

+ Paso 4: _construir el contenedor de **ckan** usando el Dockerfile hubicado en ckan-img/._

		# Salimos una carpeta hacia atras mediante cd ..
		$ cd ckan_in_docker/
		$ docker build -t jsalgadowk/ckan:latest .

+ Paso 3: _Correr contenedor  de **CKAN**_
		
		$ docker run -d --link db:db --link solr:solr -p 80:80 jsalgadowk/ckan:latest

--- 

#### Si..., todo bien.. pero sigo pensando que es muy dificil...

_La idea detras de esta implementacion de CKAN, es que **SOLO** te encargagues de tus datos, nada mas, por tanto, dependiendo de que OS usas, podes seleccionar un script de auto-deploy!_

+ Ubuntu|Debian:

		sudo su -c "cd /tmp && git clone https://github.com/JoseSalgado1024/ckan_in_docker.git && cd /tmp/ckan_in_docker/ubunut-debian_auto-deploy.sh"

+ RHEL|CentOS:

		sudo su -c "cd /tmp && git clone https://github.com/JoseSalgado1024/ckan_in_docker.git && cd /tmp/ckan_in_docker/rhel-centos_auto-deploy.sh"
