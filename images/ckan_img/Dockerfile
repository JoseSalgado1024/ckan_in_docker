
FROM ubuntu:16.04
MAINTAINER Jose A. Salagdo<jose.salgado.wrk@gmail.com>

# Crearemos algunas variables de entorno, que nos seran utiles mas tarde
ENV OUTGOIN_PORT 80
ENV HOME /root
ENV CKAN_HOME /usr/lib/ckan/default
ENV CKAN_CONFIG /etc/ckan/default
ENV CKAN_DATA /var/lib/ckan

# Actualizamos las bases de apt-get!
RUN apt-get -q -y update 

# Instalamos la Herramientas que vamos a requerir
RUN DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
    	    python-minimal \
        	python-dev \
        	python-virtualenv \
        	libevent-dev \
        	libpq-dev \
        	nginx-light \
        	apache2 \
        	libapache2-mod-rpaf \
        	libapache2-mod-wsgi \
        	postfix \
        	build-essential \
        	git-core

# venv para CKAN &  permisos
RUN virtualenv $CKAN_HOME
RUN mkdir -p $CKAN_HOME $CKAN_CONFIG $CKAN_DATA
RUN chown www-data:www-data $CKAN_DATA

ADD ./requirements/python-requirements.txt $CKAN_HOME/src/ckan/requirements.txt
RUN $CKAN_HOME/bin/pip install -r $CKAN_HOME/src/ckan/requirements.txt
ADD . $CKAN_HOME/src/ckan/
RUN $CKAN_HOME/bin/pip install -e $CKAN_HOME/src/ckan/
RUN ln -s $CKAN_HOME/src/ckan/ckan/config/who.ini $CKAN_CONFIG/who.ini
ADD ./requirements/apache.wsgi $CKAN_CONFIG/apache.wsgi

# Configutacion para APACHE
ADD ./requirements/apache.conf /etc/apache2/sites-available/ckan_default.conf
RUN echo "Listen 8080" > /etc/apache2/ports.conf
RUN a2ensite ckan_default
RUN a2dissite 000-default

# Configuramos NGINX
ADD ./requirements/nginx.conf /etc/nginx/nginx.conf
RUN mkdir /var/cache/nginx

# Configuramos un server de MAIL
ADD ./requirements/main.cf /etc/postfix/main.cf

# Configurar la ejecucion
ADD ./requirements/ckan_init.d /etc/ckan_init.d
ADD ./requirements/svc /etc/service
CMD ["/sbin/ckan_init"]

# Publicamos el puerto declarado en: OUTGOIN_PORT hacia afuera del contenedor! 
EXPOSE $OUTGOIN_PORT

# OK, Limpiamos y nos vamos
# RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*