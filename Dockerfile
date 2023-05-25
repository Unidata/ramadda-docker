FROM unidata/tomcat-docker:8.5-jdk11

USER root

COPY files/setenv.sh ${CATALINA_HOME}/bin/setenv.sh
COPY files/javaopts.sh ${CATALINA_HOME}/bin/javaopts.sh
COPY startram.sh ${CATALINA_HOME}/bin/
COPY entrypoint.sh /

ENV DATA_DIR /data/repository

RUN apt-get update && \
    apt-get install -y --no-install-recommends  vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p ${DATA_DIR} && \
    curl -SL \
    https://geodesystems.com/repository/entry/get/repository.war?entryid=synth%3A498644e1-20e4-426a-838b-65cffe8bd66f%3AL3JlcG9zaXRvcnkud2Fy \
    -o ${CATALINA_HOME}/webapps/repository.war && chmod +x ${CATALINA_HOME}/bin/*.sh && \
    chmod +x /entrypoint.sh

WORKDIR ${DATA_DIR}

ENTRYPOINT ["/entrypoint.sh"]

###
# Start container
###

CMD ["startram.sh"]
