#!/bin/sh
set -eu
CONFIG="/etc/ckan/default/development.ini"
"$CKAN_HOME"/bin/paster --plugin=ckan db init -c "${CONFIG}"
exit $?