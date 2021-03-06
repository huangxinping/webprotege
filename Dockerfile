# References: https://blog.csdn.net/fnFenNuDManMan/article/details/113737909
FROM tomcat:8-alpine

LABEL maintainer.name="Monor Huang"
LABEL maintainer.email="monor.huang@gmail.com"
LABEL version="4.0.2"

ARG WEBPROTEGE_VERSION="4.0.2"
ARG WEBPROTEGE_DATA_DIR=/srv/webprotege
ARG WEBPROTEGE_LOG_DIR=/var/log/webprotege
ARG WEBPROTEGE_DOWNLOAD_BASE_URL=https://github.com/protegeproject/webprotege/releases/download/v${WEBPROTEGE_VERSION}

ENV webprotege.application.version=${WEBPROTEGE_VERSION}
ENV webprotege.data.directory=${WEBPROTEGE_DATA_DIR}
ENV JAVA_OPTS="$JAVA_OPTS -Dfile.encoding=UTF-8"

WORKDIR ${CATALINA_HOME}/webapps

RUN rm -rf ./*                                                                  &&\
    mkdir -p ${CATALINA_HOME}/webapps/ROOT                                      &&\
    mkdir -p ${WEBPROTEGE_DATA_DIR}                                             &&\
    mkdir -p ${WEBPROTEGE_LOG_DIR}                                             &&\
    mkdir -p /usr/local/share/java                                              &&\
    adduser -S -D -s /sbin/nologin -H -h /dev/null -g webprotege webprotege     &&\
    chown webprotege: ${WEBPROTEGE_DATA_DIR}                                    &&\
    chown webprotege: ${WEBPROTEGE_LOG_DIR}                                    &&\
    wget -q -O webprotege.war \
      ${WEBPROTEGE_DOWNLOAD_BASE_URL}/webprotege-server-${WEBPROTEGE_VERSION}.war      &&\
    wget -q -O /usr/local/share/java/webprotege-cli \
      ${WEBPROTEGE_DOWNLOAD_BASE_URL}/webprotege-cli-${WEBPROTEGE_VERSION}.jar  &&\
    unzip -q webprotege.war -d ROOT                                             &&\
    rm -f webprotege.war

COPY config/webprotege.properties /etc/webprotege/webprotege.properties
COPY config/mail.properties /etc/webprotege/mail.properties
COPY scripts/webprotege-cli /usr/local/bin/webprotege-cli

EXPOSE 8080
VOLUME ${WEBPROTEGE_DATA_DIR}
VOLUME ${WEBPROTEGE_LOG_DIR}

USER webprotege

CMD ["catalina.sh", "run"]
