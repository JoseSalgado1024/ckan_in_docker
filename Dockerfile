FROM ubuntu:14.04
MAINTAINER Jose A. Salagdo<jose.salgado.wrk@gmail.com>

# Actualizamos las bases de apt-get!
RUN apt-get -qq -y update 

RUN apt-get install -y software-properties-common
RUN add-apt-repository universe
RUN apt-get update

# Instalamos la Herramientas que vamos a requerir
RUN DEBIAN_FRONTEND=noninteractive apt-get -qq -y install \
            libevent-dev \
            libpq-dev \
            nginx \
            apache2 \
            libapache2-mod-rpaf \
            postfix \
            build-essential \
            python-dev \
            python-minimal \
            python-virtualenv \
            python-pip \
            wget \
            nano \
            libapache2-mod-python \
            libapache2-mod-wsgi \
            git-core

# Crearemos algunas variables de entorno, que nos seran utiles mas tarde
ENV CKAN_DEFAULT_PORT 5000
ENV CKAN_APACHE2_PORT 5000
ENV CKAN_DEV_CONFIG_FILE development.ini
ENV HOME /root
ENV CKAN_VERSION 2.5.1  
ENV CKAN_HOME /usr/lib/ckan/default
ENV CKAN_CONFIG /etc/ckan/default
ENV CKAN_DATA /var/lib/ckan
ENV CKAN_INIT /etc/ckan_init.d

# Bajamos el .deb de ckan
RUN mkdir -p $CKAN_HOME $CKAN_CONFIG $CKAN_DATA
RUN virtualenv $CKAN_HOME
RUN wget http://packaging.ckan.org/python-ckan_2.5-trusty_amd64.deb -P /tmp
RUN ln -s $CKAN_HOME/src/ckan/ckan/config/who.ini $CKAN_CONFIG/who.ini
RUN mkdir -p $CKAN_HOME $CKAN_CONFIG $CKAN_DATA
RUN chown www-data:www-data $CKAN_DATA

# Instalamos CKAN
RUN dpkg -i /tmp/python-ckan_2.5-trusty_amd64.deb

# Instalamos las extensiones de CKAN: GobAR-Theme & Hierarchy 
RUN $CKAN_HOME/bin/pip install -e "git+https://github.com/gobabiertoAR/datos.gob.ar.git#egg=ckanext-gobar_theme"
RUN $CKAN_HOME/bin/pip install -e "git+https://github.com/datagovuk/ckanext-hierarchy.git#egg=ckanext-hierarchy"

ADD ./ckan-img/scripts $CKAN_INIT
RUN chmod +x $CKAN_INIT/*.sh
RUN chmod +x $CKAN_INIT/.*.sh
RUN chmod 777 -R $CKAN_CONFIG

CMD ["/etc/ckan_init.d/start_ckan.sh"]

EXPOSE $CKAN_APACHE2_PORT
EXPOSE $CKAN_DEFAULT_PORT

# OK, Limpiamos y nos vamos
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*