#!/bin/sh
set -eu
CONFIG="${CKAN_CONFIG}/${CKAN_CONFIG_FILE}"
# printf "\nInicalizando DB, Segun configuracion: ${CONFIG}\n"
#$CKAN_HOME"/bin/paster --plugin=ckan db init -c "${CONFIG}"
"$CKAN_HOME"/bin/paster --plugin=ckan db init -c "${CONFIG}"
exit $?