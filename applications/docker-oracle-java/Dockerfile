FROM docker.io/centos:7

MAINTAINER Dennis Tait <dennis.tait@nanitesoftware.co.uk>

#RUN yum update -y

#RUN curl -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.rpm > jdk-8u45-linux-x64.rpm \
#&& yum install -y jdk-8u45-linux-x64.rpm \
#&& rm jdk-8u45-linux-x64.rpm \
#&& yum clean all

#RUN yum -y upgrade && \
#    yum -y update && \
#    yum -y install wget unzip findutils && \
#    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u102-b14/jdk-8u102-linux-x64.rpm && \
#    echo "1ffe998845b594c66db2703dd5f60d88  jdk-8u102-linux-x64.rpm" >> MD5SUM8 && \
#    md5sum -c MD5SUM8 && \
#    rpm -Uvh jdk-8u102-linux-x64.rpm && \
#    yum -y clean all && \
#    rm -f jdk-8u102-linux-x64.rpm MD5SUM8

# java
#

# VERSION       Java 8
#ENV JAVA_VERSION 8u31
#ENV BUILD_VERSION b13
ENV JAVA_VERSION 8u141
ENV BUILD_VERSION b15

# Upgrading system
RUN yum -y upgrade
RUN yum -y install wget

# Downloading Java
#RUN wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/$JAVA_VERSION-$BUILD_VERSION/jdk-$JAVA_VERSION-linux-x64.rpm" -O /tmp/jdk-8-linux-x64.rpm
RUN wget -c "jdk-8u141-linux-x64.tar.gz" --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u141-b15/336fa29ff2bb4ef291e347e091f7f4a7/jdk-$JAVA_VERSION-linux-x64.rpm"

RUN ls -la
RUN yum -y install "jdk-$JAVA_VERSION-linux-x64.rpm"
RUN alternatives --install /usr/bin/java jar /usr/java/latest/bin/java 200000
RUN alternatives --install /usr/bin/javaws javaws /usr/java/latest/bin/javaws 200000
RUN alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 200000
RUN yum -y clean all
RUN rm -f "jdk-$JAVA_VERSION-linux-x64.rpm"

ENV JAVA_HOME /usr/java/latest

