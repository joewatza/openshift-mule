FROM java:openjdk-8-jdk

MAINTAINER joewatza@gmail.com

# Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Platform for building Mule Applications" \
      io.k8s.display-name="Mule POC Stand alone Edition" \
      io.openshift.expose-services="8888:http" \
      io.openshift.tags="builder,mule,3.x,java"

RUN cd ~ && wget https://repository-master.mulesoft.org/nexus/content/repositories/releases/org/mule/distributions/mule-standalone/3.9.0/mule-standalone-3.9.0.tar.gz

RUN cd /opt && tar xvzf ~/mule-standalone-3.9.0.tar.gz && rm ~/mule-standalone-3.9.0.tar.gz && ln -s /opt/mule-standalone-3.9.0 /opt/mule

#add wrapper for standalone community ed
# mac version RUN https://download.tanukisoftware.com/wrapper/3.5.35/wrapper-macosx-universal-64-3.5.35.tar.gz

RUN cd ~ && wget https://download.tanukisoftware.com/wrapper/3.5.35/wrapper-linux-x86-64-3.5.35.tar.gz
RUN cd ~ && tar -zxvf wrapper-linux-x86-64-3.5.35.tar.gz wrapper-linux-x86-64-3.5.35/conf/wrapper.conf
RUN cd ~ && cp wrapper-linux-x86-64-3.5.35/conf/wrapper.conf /opt/mule/conf/
RUN cd ~ && rm -r wrapper-linux-x86-64-3.5.35

# Define environment variables.
ENV MULE_HOME /opt/mule

# Define mount points.
VOLUME ["/opt/mule/logs", "/opt/mule/conf", "/opt/mule/apps", "/opt/mule/domains"]

# Define working directory.
WORKDIR /opt/mule

# Copy application files
COPY ./apps/*.zip $MULE_HOME/apps/

CMD [ "/opt/mule/bin/mule" ]

# Default http port
EXPOSE 8888
