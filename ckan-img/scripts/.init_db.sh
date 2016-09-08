#!/bin/sh
set -eu

eval "$CKAN_HOME"/bin/paster --plugin=ckan db init -c "${CKAN_CONFIG}/${CKAN_CONFIG_FILE}"
exit $?