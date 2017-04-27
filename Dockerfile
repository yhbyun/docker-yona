FROM debian:jessie

LABEL Description="This image is used to start the yona" maintainer="pokev25"

ARG YONA_VERSION=1.5.0
ARG YONA_DOWNLOAD_URL=https://github.com/yona-projects/yona/releases/download/v${YONA_VERSION}/yona-v${YONA_VERSION}-bin.zip

## install Oracle Java 8 and clean up installation files
RUN \
  echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list && \
  echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list && \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 && \
  apt-get update && \
  apt-get install -y --no-install-recommends oracle-java8-installer oracle-java8-set-default unzip && \
  apt-get clean && rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/oracle-jdk8-installer

## Timezone
RUN echo "Asia/Seoul" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

## add yona user
RUN useradd -m -d /yona -s /bin/bash -U yona && \
    mkdir /yona/downloads

## install yona
RUN cd /yona/downloads && \
    wget --no-check-certificate $YONA_DOWNLOAD_URL && \
    unzip -d /yona/release yona-v$YONA_VERSION-bin.zip && \
    mv /yona/release/yona-$YONA_VERSION /yona/release/yona && \
    rm -f yona-v$YONA_VERSION-bin.zip

## set environment variables
ENV YONA_DATA "/yona/data"
ENV JAVA_OPTS "-Xmx2048m -Xms1024m"

## add entrypoints
ADD ./entrypoints /yona/entrypoints
RUN chmod +x /yona/entrypoints/*.sh

## yona home directory mount point from host to docker container
VOLUME yona/data
WORKDIR /yona

## yona service port expose from docker container to host
EXPOSE 9000

## run yona command
ENTRYPOINT ["/yona/entrypoints/bootstrap.sh"]
