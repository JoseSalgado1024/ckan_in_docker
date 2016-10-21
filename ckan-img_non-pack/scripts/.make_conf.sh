#!/bin/sh
#######################################################
#                                                     #
#     Basado en el trabajo realizado de CKAN          #
#                                                     #
#######################################################

: ${DATABASE_URL:=}
: ${SOLR_URL:=}
: ${ERROR_EMAIL:=}
: ${DATASTORE_URL_RO:=}
: ${DATASTORE_URL_RW:=}
: ${CKAN_URL:=}
: ${DATAPUSHE_URL:=}

set -eu

CONFIG="${CKAN_CONFIG}/${CKAN_CONFIG_FILE}"

abort () {
  echo "$@" >&2
  exit 1
}

write_config () {
  "$CKAN_HOME"/bin/paster --plugin=ckan config-tool "$CONFIG" -e \
      "sqlalchemy.url = ${DATABASE_URL}" \
      "solr_url = ${SOLR_URL}" \
      "ckan.storage_path = ${CKAN_DATA}" \
      "ckan.plugins = stats text_view image_view recline_view hierarchy_display hierarchy_form gobar_theme datastore datapusher"  \
      "ckan.auth.create_user_via_api = false" \
      "ckan.auth.create_user_via_web = false" \
      "ckan.locale_default = es" \
      "email_to = disabled@example.com" \
      "ckan.datapusher.url = http://${CKAN_IP}:8800" \
      "ckan.datapusher.formats = csv xls xlsx tsv application/csv application/vnd.ms-excel application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" \
      "ckan.datastore.write_url = $(link_rw_datastore)" \
      "ckan.datastore.read_url = $(link_ro_datastore)" \
      "ckan.max_resource_size = 300" \
      "error_email_from = ckan@$(hostname -f)" \
      "ckan.site_url = ${CKAN_IP}"

  if [ -n "$ERROR_EMAIL" ]; then
    sed -i -e "s&^#email_to.*&email_to = ${ERROR_EMAIL}&" "$CONFIG"
  fi
}


link_rw_datastore (){
  local user=$DB_ENV_POSTGRES_USER
  local pass=$DB_ENV_POSTGRES_PASS
  local db=$DB_ENV_POSTGRES_DB
  local host=$DB_PORT_5432_TCP_ADDR
  local port=$DB_PORT_5432_TCP_PORT
  echo "postgresql://${user}:${pass}@${host}:${port}/datastore_default"
}


link_ro_datastore (){
  local user=$DB_ENV_POSTGRES_USER
  local pass=$DB_ENV_POSTGRES_PASS
  local db=$DB_ENV_POSTGRES_DB
  local host=$DB_PORT_5432_TCP_ADDR
  local port=$DB_PORT_5432_TCP_PORT
  echo "postgresql://datastore_default:pass@${host}:${port}/datastore_default"
}

link_postgres_url () {
  local user=$DB_ENV_POSTGRES_USER
  local pass=$DB_ENV_POSTGRES_PASS
  local db=$DB_ENV_POSTGRES_DB
  local host=$DB_PORT_5432_TCP_ADDR
  local port=$DB_PORT_5432_TCP_PORT
  echo "postgresql://${user}:${pass}@${host}:${port}/${db}"
}

link_solr_url () {
  local host=$SOLR_PORT_8983_TCP_ADDR
  local port=$SOLR_PORT_8983_TCP_PORT
  echo "http://${host}:${port}/solr/ckan"
}

get_url () {
  my_host=$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
  sufix=""
  if [[ $# -gt 0 ]];
    then
    SUFIX=":$1"
  fi
  echo "http://${my_host}${sufix}"
}

# Creamos link para DB
if [ ! -e "$CONFIG" ]; then
  if [ -z "$DATABASE_URL" ]; then
    if ! DATABASE_URL=$(link_postgres_url); then
      abort "Imposible conectar DATABASE_URL ..."
    fi
  fi
  # Creamos link para Solr
  if [ -z "$SOLR_URL" ]; then
    if ! SOLR_URL=$(link_solr_url); then
      abort "Imposible conectar SOLR_URL ..."
    fi
  fi
  # Creamos link para DataStore RO
  if [ -z "$DATASTORE_URL_RO" ]; then
    if ! DATASTORE_URL_RO=$(link_ro_datastore); then
      abort "Imposible crear DATASTORE RO link ..."
    fi
  fi
  # Creamos link para DataStore RW
  if [ -z "$DATASTORE_URL_RW" ]; then
    if ! DATASTORE_URL_RW=$(link_rw_datastore); then
      abort "Imposible crear DATASTORE RW link ..."
    fi
  fi
  # Creamos link para CKAN
  if [ -z "$CKAN_URL" ]; then
    if ! CKAN_URL=$(get_url); then
      abort "Imposible crear CKAN_URL link ..."
    fi
  fi
  # Creamos link para DataPusher
  if [ -z "$DATAPUSHE_URL" ]; then
    if ! DATAPUSHE_URL=$(get_url 8800); then
      abort "Imposible crear DATAPUSHE_URL link ..."
    fi
  fi
  write_config
fi