FROM       centos:centos7
MAINTAINER Jodem <jocelyn.demoy@gmail.com>

ENV SONATYPE_WORK /sonatype-work
ENV NEXUS_VERSION 3.0.0-b2016011501

RUN yum install -y \
  curl tar createrepo \
  && yum clean all

RUN cd /var/tmp \
  && curl --fail --silent --location --retry 3 -O \
  --header "Cookie: oraclelicense=accept-securebackup-cookie; " \
  http://download.oracle.com/otn-pub/java/jdk/8u71-b15/jdk-8u71-linux-x64.rpm \
  && rpm -Ui jdk-8u71-linux-x64.rpm \
  && rm -rf jdk-8u71-linux-x64.rpm



RUN mkdir -p /opt/sonatype/nexus \
  && curl --fail --silent --location --retry 3 \
  http://download.sonatype.com/nexus/3/nexus-3.0.0-m7-unix.tar.gz \
  | gunzip \
  | tar x -C /tmp nexus-${NEXUS_VERSION} \
  && mv /tmp/nexus-${NEXUS_VERSION}/*  /tmp/nexus-${NEXUS_VERSION}/.install4j* /opt/sonatype/nexus/ \
  && rm -rf /tmp/nexus-${NEXUS_VERSION}

RUN useradd -r -u 200 -m -c "nexus role account" -d ${SONATYPE_WORK} -s /bin/false nexus

VOLUME ${SONATYPE_WORK}

EXPOSE 8081
WORKDIR /opt/sonatype/nexus
USER nexus
ENV CONTEXT_PATH /
#ENV MAX_HEAP 768m
#ENV MIN_HEAP 256m
ENV JAVA_OPTS -server -Djava.net.preferIPv4Stack=true
#ENV LAUNCHER_CONF ./conf/jetty.xml ./conf/jetty-requestlog.xml
USER root
CMD bin/nexus run
