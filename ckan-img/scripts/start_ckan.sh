#!/bin/bash
# ec2-52-203-114-238.compute-1.amazonaws.com

eval "/bin/bash $CKAN_INIT/.make_conf.sh"
eval "/bin/bash $CKAN_INIT/.init_db.sh"
exit_code=$?

if [ "$exit_code" -eq "0" ] ; then
	service apache2 stop
	service apache2 start
	service apache2 reload
	service nginx restart
	$CKAN_HOME/bin/paster serve "${CKAN_CONFIG}/${CKAN_CONFIG_FILE}" &
	# $CKAN_HOME/bin/
else
	echo "Fallo inicio de CKAN" 
fi