
#!/bin/bash

: ${DATABASE_URL:=}
: ${SOLR_URL:=}
: ${ERROR_EMAIL:=}

set -eu

CKAN_PASTER=$CKAN_HOME/bin/paster
CKAN_PIP=$CKAN_HOME/bin/pip 

# fonts color
FBLACK="\033[30;"
FRED="\033[31;"
FGREEN="\033[32;"
FYELLOW="\033[33;"
FBLUE="\033[34;"
FPURPLE="\033[35;"
D_FGREEN="\033[6;"
FWHITE="\033[7;"
FCYAN="\x1b[36m"

# background color
BBLACK="40m"
BRED="41m"
BGREEN="42m"
BYELLOW="43m"
BBLUE="44m"
BPURPLE="45m"
D_BGREEN="46m"
BWHITE="47m"

# Configuracion actual [/etc/ckan/default/nombre.ini]
CONFIG="${CKAN_CONFIG}/${CKAN_CONFIG_FILE}"

abort() {
  echo "$@" >&2
  exit 1
}

write_config () {
  echo "Creando configuracion para: ${CKAN_CONFIG}/${CKAN_CONFIG_FILE}"
  "$CKAN_HOME"/bin/paster make-config ckan "$CONFIG"

  "$CKAN_PASTER" --plugin=ckan config-tool "$CONFIG" -e \
      "sqlalchemy.url = ${DATABASE_URL}" \
      "solr_url = ${SOLR_URL}" \
      "ckan.storage_path = /var/lib/ckan" \
      "ckan.plugins = stats text_view image_view recline_view hierarchy_display hierarchy_form gobar_theme"  \
      "ckan.auth.create_user_via_api = false" \
      "ckan.auth.create_user_via_web = false" \
      "ckan.locale_default = es" \
      "email_to = disabled@example.com" \
      "error_email_from = ckan@$(hostname -f)" \
      "ckan.site_url = http://172.17.0.4"
      

  if [ -n "$ERROR_EMAIL" ]; then
    sed -i -e "s&^#email_to.*&email_to = ${ERROR_EMAIL}&" "$CONFIG"
  fi
}

link_postgres_url() {
  local user=$DB_ENV_POSTGRES_USER
  local pass=$DB_ENV_POSTGRES_PASS
  local db=$DB_ENV_POSTGRES_DB
  local host=$DB_PORT_5432_TCP_ADDR
  local port=$DB_PORT_5432_TCP_PORT
  echo "postgresql://${user}:${pass}@${host}:${port}/${db}"
}

link_solr_url() {
  local host=$SOLR_PORT_8983_TCP_ADDR
  local port=$SOLR_PORT_8983_TCP_PORT
  echo "http://${host}:${port}/solr/ckan"
}



#####################################
#                                   #
#        ADMIN CKAN FUNCTIONS!      #
#                                   #
#####################################

# Listar usuarios todos de CKAN
ckan_list_users (){
	"$CKAN_PASTER" --plugin=ckan user list -c "$CONFIG"

}


# Crear usuario admin de CKAN!
ckan_add_admin(){
	ADMIN_NAME="ckan_admin"
	if [ "$#" -gt "0" ]; then
		ADMIN_NAME=$1
	fi
	# mkconfig
	"$CKAN_PASTER" --plugin=ckan sysadmin add $ADMIN_NAME -c "$CONFIG"
	if [ "$#" -gt "0" ]; then
		abort "ERR_MSG"
	fi 
}

# Inicializar la base de datos "Default"
ckan_init_db(){
	"$CKAN_PASTER" --plugin=ckan db init -c "$CONFIG"
	if [ "$?" -gt "0" ]; then
		abort "Fallo Inicializacion de DB :("		
	fi
}

#
ckan_start(){
	echo "Foo Text!"
}

ckan_build_context(){
	if [ ! -e "$CONFIG" ]; then
	  if [ -z "$DATABASE_URL" ]; then
	    if ! DATABASE_URL=$(link_postgres_url); then
	      abort "DATABASE_URL no encontrado..."
	    fi
	  fi
	  if [ -z "$SOLR_URL" ]; then
	    if ! SOLR_URL=$(link_solr_url); then
	      abort "SOLR_URL No encontrado..."
	    fi
	  fi
	  write_config
	fi
}

fooTest(){
	echo "friendly-ckan tools instaladas!"
	#source /etc/ckan_init.d/ckan_helpers.sh
} 

fooTest