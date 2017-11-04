FROM taitd/docker-oracle-java
MAINTAINER Dennis Tait <dennis.tait@nanitesoftware.co.uk>

ENV ARTIFACTORY_HOME /opt/artifactory \
    ARTIFACTORY_OSS_VERSION 5.5.2

# Http port
EXPOSE 8081

RUN yum install unzip wget -y
RUN cd /opt \
i#&& curl -L "https://bintray.com/jfrog/artifactory/download_file\?file_path\=jfrog-artifactory-oss-5.5.2.zip" > artifactory.zip \
&& wget -O artifactory.zip https://bintray.com/jfrog/artifactory/download_file\?file_path\=jfrog-artifactory-oss-5.5.2.zip \
&& pwd \
&& ls -la \
&& unzip artifactory.zip \
&& mv artifactory-oss-5.5.2 artifactory \
&& ls -la \
&& rm artifactory.zip \
&& yum remove unzip wget -y \
&& yum clean all -y

WORKDIR $ARTIFACTORY_HOME
ENTRYPOINT ["./bin/artifactory.sh"]
