#!/bin/sh

# URL for the primary database, in the format expected by sqlalchemy (required
# unless linked to a container called 'db')
: ${DATABASE_URL:=}
# URL for solr (required unless linked to a container called 'solr')
: ${SOLR_URL:=}
# Email to which errors should be sent (optional, default: none)
: ${ERROR_EMAIL:=}

set -eu

CONFIG="${CKAN_CONFIG}/${CKAN_CONFIG_FILE}"

abort () {
  echo "$@" >&2
  exit 1
}

write_config () {
  #echo "Creando configuracion [$CKAN_CONFIG_FILE]"
  "$CKAN_HOME"/bin/paster make-config ckan "$CONFIG";
  CKAN_URL=$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
  "$CKAN_HOME"/bin/paster --plugin=ckan config-tool /etc/ckan/default/production.ini -e \
    "sqlalchemy.url = ${DATABASE_URL}" \
    "solr_url = ${SOLR_URL}" \
    "ckan.site_url=http://$CKAN_URL"\
    "ckan.site_id = default"
    "ckan.storage_path = /var/lib/ckan" \
    "ckan.plugins = stats text_view image_view recline_view hierarchy_display hierarchy_form gobar_theme"  \
    "ckan.auth.create_user_via_api=false" \
    "ckan.auth.create_user_via_web=false" \
    "ckan.locale_default=es" \
    "email_to=disabled@example.com" \
    "error_email_from=ckan@$(hostname -f)"
      

  if [ -n "$ERROR_EMAIL" ]; then
    sed -i -e "s&^#email_to.*&email_to = ${ERROR_EMAIL}&" "$CONFIG"
  fi
}

link_postgres_url () {
    #echo "Linking Park... digo Postgres ;)"
    local user=$DB_ENV_POSTGRES_USER
    local pass=$DB_ENV_POSTGRES_PASS
    local db=$DB_ENV_POSTGRES_DB
    local host=$DB_PORT_5432_TCP_ADDR
    local port=$DB_PORT_5432_TCP_PORT
    echo "postgresql://${user}:${pass}@${host}:${port}/${db}"
}

link_solr_url () {
  #echo "Linking Solr..."
  local host=$SOLR_PORT_8983_TCP_ADDR
  local port=$SOLR_PORT_8983_TCP_PORT
  echo "http://${host}:${port}/solr/ckan"
}


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