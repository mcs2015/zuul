FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive


RUN apt-get update && \
apt-get dist-upgrade -y

## Remove any existing JDKs
RUN apt-get --purge remove openjdk*

## Install Oracle's JDK
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" > /etc/apt/sources.list.d/webupd8team-java-trusty.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
RUN apt-get update && \
apt-get install -y --no-install-recommends oracle-java8-installer && \
apt-get clean all

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV SERVER_PORT 8765

## Setup work directory
RUN mkdir /server
WORKDIR /server

## Copy application
ADD target/zuul-1.0.0.BUILD-SNAPSHOT.jar /server/zuul-1.0.0.BUILD-SNAPSHOT.jar

EXPOSE ${SERVER_PORT}

# Define default command.
CMD ["java","-jar", "zuul-1.0.0.BUILD-SNAPSHOT.jar"]
#CMD ["bash"]
