#!/bin/bash
echo "Instalar herramientas requeridas..."
apt-get -q -y update 
DEBIAN_FRONTEND=noninteractive apt-get -y install python-minimal python-dev python-virtualenv libevent-dev libpq-dev nginx-light apache2 libapache2-mod-wsgi postfix build-essential git-core