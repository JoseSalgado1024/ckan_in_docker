#!/bin/bash
# Instalo Harvest y DataJSON x fuera del docker file, dado que da problemas la lib PyYaml con PasteScript

print_config_file (){
	echo "${CKAN_CONFIG}/${CKAN_CONFIG_FILE}"
}

# Inicializa bases para la CKANext, Harvest
init_harvest_db (){
	$CKAN_HOME/bin/paster --plugin=ckanext-harvest harvester initdb --config=$(print_config_file)
}

$CKAN_HOME/bin/pip install -r $CKAN_INIT/ext_requirements.txt
$CKAN_HOME/bin/pip install -e "git+https://github.com/ckan/ckanext-harvest.git#egg=ckanext-harvest"
$CKAN_HOME/bin/pip install -e "git+https://github.com/GSA/ckanext-datajson.git#egg=ckanext-datajson"

# inicializo la Base de Harvest
init_harvest_db
hidb=$?
