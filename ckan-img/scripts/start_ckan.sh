#!/bin/bash

# ----------------------------------------------------- # 
#  Finalizado el Build del contenedor en "run-mode"
#  debemos hacer algunas cosas para que todo funcione
#  correctamente. 
# ----------------------------------------------------- #


# Creamos contexto para CKAN
eval "/bin/bash $CKAN_INIT/.make_conf.sh"
mconf=$?
# Inicializamos la Base de datos e incluso, Solr.
eval "/bin/bash $CKAN_INIT/.init_db.sh"
idb=$?
exit_code=$(mconf+idb)
# Ambos commandos anteriores, fueron exitosos?
if [ "$exit_code" -eq "0" ] ; then
	# Forzamos la seleccion de nuestra configuracion actual dentro de WSGI 
	sed "s/producction.ini/$CKAN_CONFIG_FILE/g" $CKAN_CONFIG/apache.wsgi 	
	# Si esta corriendo, detenemos Apache & NginX
	service apache2 stop && service nginx stop;
	service apache2 start && service apache2 reload && service nginx restart;
	# Sentencia tonta que evita la finalizacion del script y a su vez, que docker termine el contenedor.
	while true; do sleep 1000; done
else
	echo "-------------------------------------------"
	echo ""
	echo "  Ooops! hubo un problema.. :( " 
	echo ""
	echo "-------------------------------------------"
fi