FROM ubuntu:14.04
MAINTAINER Jose A. Salagdo<jose.salgado.wrk@gmail.com>

# Actualizamos las bases de apt-get!
RUN apt-get -q -y update 

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common
RUN add-apt-repository universe
RUN DEBIAN_FRONTEND=noninteractive apt-get update

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
            libapache2-mod-wsgi \
            wget \
            nano \
            ca-certificates \
            git-core

# Crearemos algunas variables de entorno, que nos seran utiles mas tarde
ENV CKAN_APACHE2_PORT 80
ENV CKAN_DATAPUSHER_PORT 8800
ENV CKAN_CONFIG_FILE development.ini
ENV HOME /root
ENV CKAN_VERSION 2.5.1  
ENV CKAN_HOME /usr/lib/ckan/default
ENV CKAN_CONFIG /etc/ckan/default
ENV CKAN_DATA /var/lib/ckan
ENV CKAN_INIT /etc/ckan_init.d

# Instalamos psql
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
RUN DEBIAN_FRONTEND=noninteractive apt-get -y update
RUN DEBIAN_FRONTEND=noninteractive apt-get -qq -y install pgadmin3


# Bajamos el .deb de ckan
RUN mkdir -p $CKAN_HOME $CKAN_CONFIG $CKAN_DATA
RUN virtualenv $CKAN_HOME
RUN wget http://packaging.ckan.org/python-ckan_2.5-trusty_amd64.deb -P /tmp
RUN ln -s $CKAN_HOME/src/ckan/ckan/config/who.ini $CKAN_CONFIG/who.ini
RUN mkdir -p $CKAN_HOME $CKAN_CONFIG $CKAN_DATA
RUN chown www-data:www-data $CKAN_DATA
RUN chmod u+rwx $CKAN_DATA
RUN touch /tmp/ckan_service.log
RUN chmod u+rw /tmp/ckan_service.log
# Instalamos CKAN
RUN dpkg -i /tmp/python-ckan_2.5-trusty_amd64.deb

# Actualizamos pip
RUN $CKAN_HOME/bin/pip install --upgrade pip

# Instalamos las extensiones de CKAN: GobAR-Theme & Hierarchy 
RUN $CKAN_HOME/bin/pip install -e "git+https://github.com/datosgobar/datos.gob.ar.git#egg=ckanext-gobar_theme"
RUN $CKAN_HOME/bin/pip install -e "git+https://github.com/datagovuk/ckanext-hierarchy.git#egg=ckanext-hierarchy"

ADD ./requirements/ckan_default.conf /etc/apache2/sites-enabled/ckan_default.conf 
ADD ./scripts $CKAN_INIT
ADD ./requirements/apache.wsgi $CKAN_CONFIG/apache.wsgi
ADD ./requirements/datapusher.wsgi /etc/ckan/datapusher.wsgi
ADD ./requirements/rc.local /etc/rc.local
RUN chmod +x -R $CKAN_INIT/
RUN chmod 777 -R $CKAN_CONFIG

# Script de inicializacion para ckan.
CMD ["/etc/ckan_init.d/start_ckan.sh"]

# Creo un volumen para las configs.
VOLUME $CKAN_CONFIG

# Abro el puerto de 80(ad) para Apache
EXPOSE $CKAN_APACHE2_PORT

# Abro el puerto de 8800(dp) apache.datapusher.wsgi
EXPOSE $CKAN_DATAPUSHER_PORT

# OK, Limpiamos y nos vamos
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*