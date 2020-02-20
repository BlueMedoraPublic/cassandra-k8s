FROM gcr.io/google-samples/cassandra:v13

# in production, you should not be hardcoding jmx credentials
# into your image, rather use volume mounts to pass credentials
# in at runtime. this can be tricky to do with k8s. For example:
# you can mount these files as config maps but they will be read
# only, and the cassandra startup script will attempt to 'chown'
# these files, causing a startup failure. The solution would be
# to use an init container that mounts these files to /tmp, and 
# copies them to a shared emptyDir volume mount. You then update
# the cassandra JVM arguments to use your custom path to these
# jxm password / access files. this can be difficult, and requires
# good planning to execute well.
RUN echo 'monitor  password' > /etc/cassandra/jmxremote.password
RUN echo 'monitor  readonly' > /etc/cassandra/jmxremote.access
RUN chown cassandra:cassandra /etc/cassandra/jmxremote.*

# local jmx will allow us to connect to jmx over an ip (service address for example)
ENV LOCAL_JMX=yes
