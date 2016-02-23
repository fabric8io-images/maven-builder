FROM centos:7

RUN yum update -y && \
  yum install -y docker && \
  yum install -y unzip && \
  yum install -y git && \
  yum install -y wget && \
  yum clean all

RUN curl --retry 999 --retry-max-time 0  -sSL https://bintray.com/artifact/download/fabric8io/helm-ci/helm-v0.1.0%2B825f5ef-linux-amd64.zip > helm.zip && \
  unzip helm.zip && \
  mv helm /usr/bin/

# Maven
RUN wget -q http://mirrors.ukfast.co.uk/sites/ftp.apache.org/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz && \
  tar -C /opt -zxvf apache-maven-3.2.5-bin.tar.gz && \
  rm -rf apache-maven-3.2.5-bin.tar.gz

# Java JDK
RUN wget -q --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u5-b13/jdk-8u5-linux-x64.rpm" -O jdk-8-linux-x64.rpm && \
  yum -y install jdk-8-linux-x64.rpm && \
  rm -rf jdk-8-linux-x64.rpm

RUN alternatives --install /usr/bin/java jar /usr/java/latest/bin/java 200000 && \
  alternatives --install /usr/bin/javaws javaws /usr/java/latest/bin/javaws 200000 && \
  alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 200000

ENV M2_HOME /opt/apache-maven-3.2.5
ENV M2 $M2_HOME/bin
ENV PATH $M2:$PATH
ENV JAVA_HOME /usr/java/latest

# hub
RUN wget -q https://github.com/github/hub/releases/download/v2.2.3/hub-linux-amd64-2.2.3.tgz && \
  tar -zxvf hub-linux-amd64-2.2.3.tgz && \
  mv hub-linux-amd64-2.2.3/bin/hub /usr/bin/ && \
  rm -rf hub-linux-amd64-2.2.3.tgz && \
  rm -rf hub-linux-amd64-2.2.3

CMD cat
