# CKAN Docker
_El mismo CKAN de siempre pero.. bellamente dockerizado..._

## Prerequisitos:

### DOCKER:

+ Docker para [OSX](https://github.com/JoseSalgado1024/ckan_in_docker/blob/master/utiles/docker_osx.md).

+ Docker para [Ubuntu/Debian](https://github.com/JoseSalgado1024/ckan_in_docker/blob/master/utiles/docker_Ubuntu-Debian.md).

+ Docker para [RHEL/CentOS](https://github.com/JoseSalgado1024/ckan_in_docker/blob/master/utiles/docker_rhel-centos.md).

+ Docker para [Windows](https://github.com/JoseSalgado1024/ckan_in_docker/blob/master/utiles/docker_windows.md).


### DOCKER IMGs:

_Vamos a requerir dos contenedores extras, ambos pertenecen al dockerHub Oficial de CKAN. Para mas informacion, visitar [esta](https://hub.docker.com/u/ckan/) pagina._

+ CKAN DB _[+info](https://hub.docker.com/r/ckan/postgresql/)_:

		docker run -d  --name db ckan/postgresql 	


+ CKAN SOLR _[+info](https://hub.docker.com/r/ckan/solr/)_:

		docker run -d  --name solr ckan/solr 	


### GIT TOOLs:
	
+ Windows:
_Desacrgar e Instalar desde:_

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

