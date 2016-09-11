#!/bin/bash

eval "/bin/bash $CKAN_INIT/.make_conf.sh"
eval "/bin/bash $CKAN_INIT/.init_db.sh"
exit_code=$?
if [ "$exit_code" -eq "0" ] ; then
	sed "s/producction.ini/$CKAN_CONFIG_FILE/g" $CKAN_CONFIG/apache.wsgi 	
	service apache2 stop 
	service apache2 start
	service apache2 reload
	service nginx restart
	while true; do sleep 1000; done
else
	echo "Fallo inicio de CKAN" 
fi