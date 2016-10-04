#!/bin/bash

# ----------------------------------------------------- # 
#  Finalizado el Build del contenedor en "run-mode"
#  debemos hacer algunas cosas para que todo funcione
#  correctamente. 
# ----------------------------------------------------- #

APACHE2_WSGI=$CKAN_CONFIG/apache.wsgi

# Creamos contexto para CKAN
/bin/bash $CKAN_INIT/.make_conf.sh
mconf=$?

# Inicializamos la Base de datos e incluso, Solr.
/bin/bash $CKAN_INIT/.init_db.sh

idb=$?
exit_code=$(($mconf + $idb))

# Ambos commandos anteriores, fueron exitosos?
if [ "$exit_code" -eq "0" ] ; then

	# Forzamos la seleccion de nuestra configuracion actual dentro de WSGI 
	sed "s/production.ini/$CKAN_CONFIG_FILE/g" $CKAN_CONFIG/apache.wsgi > temp.f && mv temp.f $CKAN_CONFIG/apache.wsgi  	
	
	# Si esta corriendo, detenemos Apache & NginX
	service apache2 stop && service nginx stop;
	service apache2 start && service apache2 reload && service nginx restart;
	
	# Agrego herramientas para simplificar el uso de CKAN
	source $CKAN_INIT/ckan_helpers.sh 
	
	# Sentencia tonta que evita la finalizacion del script y a su vez, que docker termine el contenedor.
	while true; do sleep 1000; done

else
	# Ok.. el mundo ya no es un lugar amigable!
	echo "-------------------------------------------"
	echo "  Ooops! hubo un problema.. :( " 
	echo "-------------------------------------------"
fi