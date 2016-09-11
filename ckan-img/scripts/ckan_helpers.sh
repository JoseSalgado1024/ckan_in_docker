
#!/bin/bash

: ${DATABASE_URL:=}
: ${SOLR_URL:=}
: ${ERROR_EMAIL:=}

set -eu

CONFIG="${CKAN_CONFIG}/${CKAN_DEV_CONFIG_FILE}"

abort() {
  echo "$@" >&2
  exit 1
}

write_config () {
  echo "Creando configuracion para: ${CKAN_CONFIG}/${CKAN_CONFIG_FILE}"
  "$CKAN_HOME"/bin/paster make-config ckan "$CONFIG"

  "$CKAN_HOME"/bin/paster --plugin=ckan config-tool "$CONFIG" -e \
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

#
ckan_init_db(){
	"$CKAN_HOME"/bin/paster --plugin=ckan db init -c "${CKAN_CONFIG}/${CKAN_DEV_CONFIG_FILE}"
	if [ "$?" -gt "0" ]; then
		abort " Fallo Inicializacion de DB"		
	fi
}

# 
ckan_add_admin(){
	ADMIN_NAME="ckan_admin"
	if [ "$#" -gt "0" ]; then
		ADMIN_NAME=$1
	fi
	# mkconfig
	"$CKAN_HOME"/bin/paster --plugin=ckan sysadmin add $ADMIN_NAME -c "${CKAN_CONFIG}/${CKAN_DEV_CONFIG_FILE}"
	if [ "$#" -gt "0" ]; then
		abort "ERR_MSG"
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

install_tools(){
	echo "friendly-ckan tools instaladas!"
	#source /etc/ckan_init.d/ckan_helpers.sh
} 

install_tools