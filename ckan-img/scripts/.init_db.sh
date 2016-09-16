#!/bin/sh
set -eu
"$CKAN_HOME"/bin/paster --plugin=ckan db init -c /etc/ckan/default/development.ini
exit $?