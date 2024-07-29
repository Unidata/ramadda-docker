#!/bin/bash
set -e

if [ "$1" = 'startram.sh' ]; then

    USER_ID=${TOMCAT_USER_ID:-1000}
    GROUP_ID=${TOMCAT_GROUP_ID:-1000}

    ###
    # Tomcat user
    ###
    # create group for GROUP_ID if one doesn't already exist
    if ! getent group $GROUP_ID &> /dev/null; then
      groupadd -r tomcat -g $GROUP_ID
    fi
    # create user for USER_ID if one doesn't already exist
    if ! getent passwd $USER_ID &> /dev/null; then
      useradd -u $USER_ID -g $GROUP_ID tomcat
    fi
    # alter USER_ID with nologin shell and CATALINA_HOME home directory
    usermod -d "${CATALINA_HOME}" -s /sbin/nologin $(id -u -n $USER_ID)
    
    ###
    # Change CATALINA_HOME ownership to tomcat user and tomcat group
    # Restrict permissions on conf
    # Ensure RAMADDA data directory is owned by tomcat
    ###
    chown -R $USER_ID:$GROUP_ID ${CATALINA_HOME} ${DATA_DIR} && find ${CATALINA_HOME}/conf \
        -type d -exec chmod 755 {} \; -o -type f -exec chmod 400 {} \;

    sync
    exec gosu $USER_ID "$@"
fi

exec "$@"
