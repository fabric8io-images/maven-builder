FROM centos:7

RUN yum update -y && \
  yum install -y docker git java-1.8.0-openjdk-devel java-1.8.0-openjdk-devel.i686 unzip which && \
  yum clean all

# Maven
RUN curl -L http://mirrors.ukfast.co.uk/sites/ftp.apache.org/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz | tar -C /opt -xzv

ENV M2_HOME /opt/apache-maven-3.3.9
ENV maven.home $M2_HOME
ENV M2 $M2_HOME/bin
ENV PATH $M2:$PATH

# Set JDK to be 32bit
COPY set_java $M2
RUN $M2/set_java && rm $M2/set_java
RUN java -version

RUN mkdir /root/workspaces
WORKDIR /root/workspaces
CMD sleep infinity
