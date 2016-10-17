#!/bin/bash
clear

.mostrar_ayuda (){
clear
printf \
"AYUDA:
======

USUARIOS:
Crear, listar o borrar usuarios de CKAN: --usuario=accion parametro o -u=accion parametro 

    Agregar usuario admin: --usuario=add nombre_de_usuario o -u=add nombre_de_usuario     
    Listar usuarios de CKAN: --usuario=listar o -u=listar     
    Borrar usuario: --usuario=del nombre_de_usuario o -u=del nombre_de_usuario    

CKAN:
Iniciar, detener, reiniciar o desinstalar CKAN: --ckan=accion o -ckan=accion 

    Iniciar CKAN: --ckan=start     
    Detener CKAN: --ckan=stop
    Reiniciar CKAN: --ckan=restart    
    Desinstalar CKAN: --ckan=remove

BASES DE DATOS:
Tareas de mantenimiento para las bases de datos de CKAN: --bases-de-datos=accion o -db=accion 

    Inicializar bases de datos de CKAN: --bases-de-datos=init o -db=init     
    Hacer dump de bases de CKAN: --bases-de-datos=dump /carpeta/dump.sql o -db=dump /carpeta/dump.sql 
    Limpiar Bases de Datos de CKAN: --bases-de-datos=clear o -db=clear

ACTUALIZACION:
Programar momento de actualizacion para contenedores de CKAN: --actualizacion=accion o -a=accion 

    Activar actualizacion: --actualizacion=start     
    Desactivar actualizacion: --actualizacion=stop

BACKUP:
Activar, desactivar backups automaticos para el contenido de CKAN: --backup=accion parametro o -bu=accion parametro 

    Activar backup: --backup=start /carpeta/de/destino o -bu=start /carpeta/de/destino      
    Desactivar backup: --backup=stop o -bu=stop
\n" 
}

.user_afunctions(){
    # ADD | DEL | LIST    
    printf "\nFunciones de adminstracion de usuarios\n"
    p_actions="add del list"
    [[ $p_actions =~ $1 ]] && echo "Accion: $1" || echo "Opcion no reconocida..."
    echo ""
}

.app_afunctions(){
    # START | STOP | RESTART | REMOVE
    printf "\nFunciones de adminstracion de Aplicacion CKAN\n"
    p_actions="start stop restart remove"
    [[ $p_actions =~ $1 ]] && echo "Accion: $1" || echo "Opcion no reconocida..."
    echo ""
}

.update_afunctions(){
    # START | STOP    
    printf "\nFunciones de Actualizacion\n"
    p_actions="start stop"
    [[ $p_actions =~ $1 ]] && echo "Accion: $1" || echo "Opcion no reconocida..."
    echo ""
}

.backup_afunctions(){
    # START | STOP
    printf "\nFunciones de adminstracion de backups\n"
    p_actions="start stop"
    [[ $p_actions =~ $1 ]] && echo "Accion: $1" || echo "Opcion no reconocida..."
    echo ""
}

.database_afunctions(){
    # INIT | DUMP | CLEAR    
    printf "\nFunciones de adminstracion de bases de datos\n"
    p_actions="init dump clear"
    [[ $p_actions =~ $1 ]] && echo "Accion: $1" || echo "Opcion no reconocida..."
    echo ""
}


DEFAULT=NOT
ACTION="NONE"
VALUE="NONE"

case $1 in
    -u=*|--usuario=*)
    ACTION="Usuarios"
    VALUE="${1#*=}"
    .user_afunctions $VALUE
    ;;

    -a=*|--actualizar=*)
    ACTION="Actualizacion"
    VALUE="${1#*=}"
    .update_afunctions $VALUE
    ;;

    -db=*|--bases-de-datos=*)
    ACTION="Base de Datos"
    VALUE="${1#*=}"
    .database_afunctions $VALUE
    ;;

    -ckan=*|--ckan=*)
    ACTION="CKAN"
    VALUE="${1#*=}"
    .app_afunctions $VALUE
    ;;

    -b=*|--backup=*)
    ACTION="Backup"
    VALUE="${1#*=}"
    .backup_afunctions $VALUE
    ;;

    -h | --help)
    ACTION="Ayuda"
    VALUE="Mostrar ayuda"
    .mostrar_ayuda
    ;;  
esac

if echo "$ACTION" | grep "NONE"; then 
    echo "Opcion ingresada no valida..."
fi 