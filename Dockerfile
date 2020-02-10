FROM ubuntu:18.04

USER root
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install openjdk-8-jdk

# Create glassfish user/group
RUN groupadd glassfish
RUN useradd -ms /bin/bash -g glassfish glassfish

# Install temporary utilities
RUN apt-get -y install wget
RUN apt-get -y install unzip

# Specify working directory
WORKDIR /opt/glassfish
RUN chown glassfish:glassfish /opt/glassfish

# Change to glassfish user
USER glassfish

RUN wget -O glassfish-5.1.0.zip http://eclipse.mirror.rafal.ca/glassfish/glassfish-5.1.0.zip
COPY glassfish-5.1.0.zip.sha512 .
RUN ls -l
RUN sha512sum -c glassfish-5.1.0.zip.sha512
RUN unzip glassfish-5.1.0.zip
RUN rm glassfish-5.1.0.zip

# Change to root user
USER root

# Remove temporary utilities
RUN apt-get purge -y wget
RUN apt-get purge -y unzip
RUN apt autoremove -y
RUN apt-get clean

RUN rm glassfish-5.1.0.zip.sha512
COPY configure-glassfish.sh .
COPY glassfish-runner.sh .
COPY new_passwordfile.txt .
COPY old_passwordfile.txt .
RUN chown glassfish:glassfish configure-glassfish.sh
RUN chown glassfish:glassfish glassfish-runner.sh
RUN chown glassfish:glassfish new_passwordfile.txt
RUN chown glassfish:glassfish old_passwordfile.txt

USER glassfish

# Configure glassfish
ENV PATH /opt/glassfish/glassfish5/bin:$PATH
RUN /opt/glassfish/configure-glassfish.sh
RUN rm /opt/glassfish/configure-glassfish.sh
RUN rm /opt/glassfish/old_passwordfile.txt
RUN rm /opt/glassfish/new_passwordfile.txt

CMD [ "/opt/glassfish/glassfish-runner.sh" ]
