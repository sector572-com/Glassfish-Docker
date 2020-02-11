FROM ubuntu:18.04

USER root
RUN apt-get update && apt-get -y upgrade && apt-get -y install openjdk-8-jdk wget curl unzip

# Create glassfish user/group
RUN groupadd glassfish && useradd -ms /bin/bash -g glassfish glassfish

# Specify working directory
WORKDIR /opt/glassfish
RUN mkdir /var/lib/glassfish && chown glassfish:glassfish /opt/glassfish /var/lib/glassfish

# Change to glassfish user
USER glassfish

RUN wget -O glassfish-5.1.0.zip http://eclipse.mirror.rafal.ca/glassfish/glassfish-5.1.0.zip && curl -o glassfish-5.1.0.zip.sha512 'https://www.eclipse.org/downloads/sums.php?file=%2Fglassfish%2Fglassfish-5.1.0.zip&type=sha512' && sha512sum -c glassfish-5.1.0.zip.sha512 && unzip glassfish-5.1.0.zip && rm glassfish-5.1.0.zip glassfish-5.1.0.zip.sha512

# Change to root user
USER root

# Remove temporary utilities
RUN apt-get purge -y wget curl unzip && apt autoremove -y && apt-get clean

COPY configure-glassfish.sh ./
RUN chown glassfish:glassfish configure-glassfish.sh

USER glassfish

# Configure glassfish
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64
ENV GLASSFISH_HOME /opt/glassfish/glassfish5
ENV PATH $JAVA_HOME/bin:$GLASSFISH_HOME/bin:$PATH
RUN /opt/glassfish/configure-glassfish.sh && rm /opt/glassfish/configure-glassfish.sh /opt/glassfish/old_passwordfile.txt /opt/glassfish/new_passwordfile.txt

EXPOSE 8080 4848

CMD [ "asadmin", "start-domain", "--verbose", "domain1" ]
