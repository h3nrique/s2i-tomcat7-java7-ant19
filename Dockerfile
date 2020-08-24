FROM centos/s2i-base-centos7:1

EXPOSE 8080

ENV TOMCAT_VERSION=7.0.105 \
    ANT_VERSION=1.9.15 \
    TOMCAT_DISPLAY_VERSION=7 \
    CATALINA_HOME=/opt/tomcat \
    JAVA_VERSION="7" \
    JAVA_UPDATE="80" \
    JAVA_HOME="/usr/lib/jvm/default-jvm"

LABEL io.k8s.description="Platform for building with Ant and running Java 7 applications on Tomcat 7." \
      sun.java.version="7u80" \
      apache.ant.version="1.9.15" \
      apache.tomcat.version="7.0.104" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="s2i,builder,tomcat,tomcat6,java,java6,ant" \
      io.openshift.s2i.destination="/opt/s2i/destination"

# Copy the JDK to /tmp dir
COPY ./java-installer/ /tmp/

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

# Install Java, Ant, Tomcat
RUN INSTALL_PKGS="tar unzip bc which lsof" && \
    cd /tmp && \
    sha256sum -c jdk-7u80-linux-x64.tar.gz.sha256 && \
    yum repolist && \
    yum install $INSTALL_PKGS -y && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y && \
    tar zxvf /tmp/jdk-7u80-linux-x64.tar.gz && \
    mkdir -p "/usr/lib/jvm" && \
    mv "/tmp/jdk1.${JAVA_VERSION}.0_${JAVA_UPDATE}" "/usr/lib/jvm/java-${JAVA_VERSION}-oracle" && \
    ln -s "/usr/lib/jvm/java-${JAVA_VERSION}-oracle" "$JAVA_HOME" && \
    ln -s "$JAVA_HOME/bin/"* "/usr/bin/" && \
    rm -rfv /tmp/jdk-7u80-linux-x64.* \
           "$JAVA_HOME/"*src.zip \
           "$JAVA_HOME/lib/missioncontrol" \
           "$JAVA_HOME/lib/visualvm" \
           "$JAVA_HOME/lib/"*javafx* \
           "$JAVA_HOME/jre/lib/plugin.jar" \
           "$JAVA_HOME/jre/lib/ext/jfxrt.jar" \
           "$JAVA_HOME/jre/bin/javaws" \
           "$JAVA_HOME/jre/lib/javaws.jar" \
           "$JAVA_HOME/jre/lib/desktop" \
           "$JAVA_HOME/jre/plugin" \
           "$JAVA_HOME/jre/lib/"deploy* \
           "$JAVA_HOME/jre/lib/"*javafx* \
           "$JAVA_HOME/jre/lib/"*jfx* \
           "$JAVA_HOME/jre/lib/amd64/libdecora_sse.so" \
           "$JAVA_HOME/jre/lib/amd64/"libprism_*.so \
           "$JAVA_HOME/jre/lib/amd64/libfxplugins.so" \
           "$JAVA_HOME/jre/lib/amd64/libglass.so" \
           "$JAVA_HOME/jre/lib/amd64/libgstreamer-lite.so" \
           "$JAVA_HOME/jre/lib/amd64/"libjavafx*.so \
           "$JAVA_HOME/jre/lib/amd64/"libjfx*.so \
           "$JAVA_HOME/jre/bin/keytool" \
           "$JAVA_HOME/jre/bin/orbd" \
           "$JAVA_HOME/jre/bin/pack200" \
           "$JAVA_HOME/jre/bin/policytool" \
           "$JAVA_HOME/jre/bin/rmid" \
           "$JAVA_HOME/jre/bin/rmiregistry" \
           "$JAVA_HOME/jre/bin/servertool" \
           "$JAVA_HOME/jre/bin/tnameserv" \
           "$JAVA_HOME/jre/bin/unpack200" \
           "$JAVA_HOME/jre/lib/jfr.jar" \
           "$JAVA_HOME/jre/lib/jfr" \
           "$JAVA_HOME/jre/lib/oblique-fonts" && \
    curl -o /tmp/apache-ant.zip "https://downloads.apache.org//ant/binaries/apache-ant-${ANT_VERSION}-bin.zip" && \
    unzip /tmp/apache-ant.zip -d /usr/local && \
    ln -sf /usr/local/apache-ant-${ANT_VERSION}/bin/ant /usr/local/bin/ant && \
    rm -rfv /tmp/apache-ant.zip && \
    mkdir -p ${CATALINA_HOME} && \
    curl -v https://downloads.apache.org/tomcat/tomcat-${TOMCAT_DISPLAY_VERSION}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz | tar -zx --strip-components=1 -C ${CATALINA_HOME} && \
    mkdir -p /opt/s2i/destination && \
    chown -R 1001:0 ${CATALINA_HOME} && \
    chown -R 1001:0 ${HOME} && \
    chmod -R ug+rwx ${CATALINA_HOME} && \
    chmod -R g+rw /opt/s2i/destination

USER 1001

CMD $STI_SCRIPTS_PATH/usage
