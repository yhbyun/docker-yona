FROM debian:jessie
MAINTAINER pokev25 <pokev25@gmail.com>

LABEL Description="This image is used to start the yona-1.3.2" Vendor="pokev25" Version="1.3.2"

## install Oracle Java 8 and clean up installation files
RUN \
  echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list && \
  echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 && \
  apt-get update && \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
  apt-get install -y oracle-java8-installer oracle-java8-set-default unzip && \
  rm -rf /var/cache/oracle-jdk8-installer && apt-get clean && rm -rf /var/lib/apt/lists/*

## Timezone
RUN echo "Asia/Seoul" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

## add yona user
RUN useradd -m -d /yona -s /bin/bash -U yona && \
    mkdir /yona/downloads

## install yona
RUN cd /yona/downloads && \
    wget https://github.com/yona-projects/yona/releases/download/v1.3.2/yona-v1.3.2-bin.zip && \
    unzip -d /yona/release yona-v1.3.2-bin.zip && \
    mv /yona/release/yona-1.3.2 /yona/release/yona && \
    rm -f yona-v1.3.2-bin.zip

## set environment variables
ENV YONA_DATA "/yona/data"
ENV JAVA_OPTS "-Xmx2048m -Xms2048m"

## add entrypoints
ADD ./entrypoints /yona/entrypoints
RUN chmod +x /yona/entrypoints/*.sh

## yona home directory mount point from host to docker container
VOLUME ["/yona/source", "/yona/data"]
WORKDIR /yona

## yona service port expose from docker container to host
EXPOSE 9000

## run yona command
ENTRYPOINT ["/yona/entrypoints/bootstrap.sh"]
