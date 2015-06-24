FROM debian:jessie
MAINTAINER SungKwang Song <saltfactory@gmail.com>

LABEL Description="This image is used to start the yobi-0.8.1" Vendor="saltfactory.net" Version="0.8.1"

## replace debian mirror with ftp.daum.net in Korea
RUN cd /etc/apt && \
     sed -i 's/httpredir.debian.org/ftp.daum.net/g' sources.list

## install Oracle Java 8 and clean up installation files
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
RUN apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java8-installer oracle-java8-set-default

## install extra package
RUN apt-get install -y unzip

## remove cache
RUN rm -rf /var/cache/oracle-jdk8-installer && apt-get clean && rm -rf /var/lib/apt/lists/*


## add yobi user
RUN useradd -m -d /yobi -s /bin/bash -U yobi

## install yobi
RUN cd /yobi/downloads; \
    wget https://github.com/naver/yobi/releases/download/v0.8.1/yobi-0.8.1.zip && \
    unzip -d /yobi/release yobi-0.8.1.zip

## set environment variables
ENV YOBI_HOME "/yobi/home"
ENV JAVA_OPTS "-Xmx2048m -Xms2048m"

## yobi home directory mount point from host to docker container
VOLUME ["/yobi/home"]
WORKDIR ["/yobi/home"]

## yobi service port expose from docker container to host
EXPOSE 9000

## run yobi command
CMD ["/yobi/release/yobi-0.8.1/bin/yobi"]