#!/bin/bash
echo "Iniciando CKAN:"
echo "Creando contexto..."
INITC="/bin/bash $CKAN_INIT/.make_conf.sh /bin/bash CKAN_INIT/.init_db.sh"
if $INITC ; then
	echo "Lanzando CKAN"
	$CKAN_HOME/bin/paster serve "${CKAN_CONFIG}/${CKAN_DEV_CONFIG_FILE}"
else
	echo "Fallo inicio de CKAN" 
fi