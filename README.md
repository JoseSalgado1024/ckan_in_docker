# CKAN Docker
_El mismo CKAN de siempre pero.. bellamente dockerizado..._

## Prerequisitos:

### DOCKER:

+ Docker para [OSX](https://github.com/JoseSalgado1024/ckan_in_docker/blob/master/utiles/docker_osx.md).

+ Docker para [Ubuntu/Debian](https://github.com/JoseSalgado1024/ckan_in_docker/blob/master/utiles/docker_Ubuntu-Debian.md).

+ Docker para [RHEL/CentOS](https://github.com/JoseSalgado1024/ckan_in_docker/blob/master/utiles/docker_rhel-centos.md).

+ Docker para [Windows](https://github.com/JoseSalgado1024/ckan_in_docker/blob/master/utiles/docker_rhel-centos.md).


### DOCKER IMGs:

_Vamos a requerir dos contenedores extras, ambos pertenecen al dockerHub Oficial de CKAN. Para mas informacion, visitar [esta](https://hub.docker.com/u/ckan/) pagina._

+ CKAN DB _[+info](https://hub.docker.com/r/ckan/postgresql/)_:

	docker run -d  --name db ckan/postgresql 	


+ CKAN SOLR _[+info](https://hub.docker.com/r/ckan/solr/)_:

	docker run -d  --name solr ckan/solr 	



