FROM ubuntu:18.04

USER root
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install openjdk-8-jdk

# Create glassfish user/group
RUN groupadd glassfish
RUN useradd -ms /bin/bash -g glassfish glassfish

# Install temporary utilities
RUN apt-get -y install wget curl unzip

# Specify working directory
WORKDIR /opt/glassfish
RUN chown glassfish:glassfish /opt/glassfish

# Change to glassfish user
USER glassfish

RUN wget -O glassfish-5.1.0.zip http://eclipse.mirror.rafal.ca/glassfish/glassfish-5.1.0.zip
RUN curl -o glassfish-5.1.0.zip.sha512 'https://www.eclipse.org/downloads/sums.php?file=%2Fglassfish%2Fglassfish-5.1.0.zip&type=sha512'
RUN sha512sum -c glassfish-5.1.0.zip.sha512
RUN unzip glassfish-5.1.0.zip
RUN rm glassfish-5.1.0.zip glassfish-5.1.0.zip.sha512

# Change to root user
USER root

# Remove temporary utilities
RUN apt-get purge -y wget curl unzip
RUN apt autoremove -y
RUN apt-get clean

COPY configure-glassfish.sh .
COPY new_passwordfile.txt .
COPY old_passwordfile.txt .
RUN chown glassfish:glassfish configure-glassfish.sh new_passwordfile.txt old_passwordfile.txt

USER glassfish

# Configure glassfish
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64
ENV GLASSFISH_HOME /opt/glassfish/glassfish5
ENV PATH $JAVA_HOME/bin:$GLASSFISH_HOME/bin:$PATH
RUN /opt/glassfish/configure-glassfish.sh
RUN rm /opt/glassfish/configure-glassfish.sh /opt/glassfish/old_passwordfile.txt /opt/glassfish/new_passwordfile.txt

EXPOSE 8080 4848

CMD [ "asadmin", "start-domain", "--verbose", "domain1" ]
