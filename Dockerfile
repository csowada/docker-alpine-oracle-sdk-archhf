FROM armhfbuild/alpine:latest

MAINTAINER Christian Sowada <docker@cs-dev.de>

LABEL Description="This image is used as base image for my explorations of running JAVA/Node applications on a Raspberry Pi 2 cluster." Version="0.1"

# Set environment
ENV JAVA_VERSION=8 \
    JAVA_UPDATE=73 \
    JAVA_BUILD=02 \
    JAVA_HOME="/opt/jdk" \ 
    PATH=$PATH:${PATH}:/opt/jdk/bin

# Download and install glibc
RUN apk update && \
  apk upgrade && \
  apk add bash wget ca-certificates && \
  wget https://github.com/leannenorthrop/alpine-pkg-glibc/releases/download/glibc-2.22-r1-armhf-beta/glibc-2.22-r1.apk && \
  wget https://github.com/leannenorthrop/alpine-pkg-glibc/releases/download/glibc-2.22-r1-armhf-beta/glibc-bin-2.22-r1.apk && \
  wget https://github.com/leannenorthrop/alpine-pkg-glibc/releases/download/glibc-2.22-r1-armhf-beta/libgcc_s.so && \
  wget https://github.com/leannenorthrop/alpine-pkg-glibc/releases/download/glibc-2.22-r1-armhf-beta/libgcc_s.so.1 && \
  apk add --allow-untrusted glibc-2.22-r1.apk && \
  apk add --allow-untrusted glibc-bin-2.22-r1.apk && \
  mv libgcc* /lib && \
  chmod a+x /lib/libgcc_s.so* && \
  cp /usr/glibc-compat/lib/ld-linux-armhf.so.3 /lib && \
  wget --header "Cookie: oraclelicense=accept-securebackup-cookie;" "http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION}u${JAVA_UPDATE}-b${JAVA_BUILD}/jdk-${JAVA_VERSION}u${JAVA_UPDATE}-linux-arm32-vfp-hflt.tar.gz" && \
  tar -xzf jdk-${JAVA_VERSION}u${JAVA_UPDATE}-linux-arm32-vfp-hflt.tar.gz && \
  echo "" > /etc/nsswitch.conf && \ 
  mkdir /opt && \
  mv jdk1.${JAVA_VERSION}.0_${JAVA_UPDATE} /opt/jdk-${JAVA_VERSION}u${JAVA_UPDATE}-b${JAVA_BUILD} && \
  ln -s /opt/jdk-${JAVA_VERSION}u${JAVA_UPDATE}-b${JAVA_BUILD} /opt/jdk && \
  ln -s /opt/jdk/jre/bin/java /usr/bin/java && \
  /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib /opt/jdk/lib /opt/jdk/jre/lib /opt/jdk/jre/lib/arm /opt/jdk/jre/lib/arm/jli && \
  echo "hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4" >> /etc/nsswitch.conf && \
  rm -f glibc-*.apk jdk*.tar.gz /opt/jdk/src.zip && \
    rm -rf $JAVA_HOME/*src.zip \
       $JAVA_HOME/lib/missioncontrol \
       $JAVA_HOME/lib/visualvm \
       $JAVA_HOME/lib/*javafx* \
       $JAVA_HOME/jre/lib/plugin.jar \
       $JAVA_HOME/jre/lib/ext/jfxrt.jar \
       $JAVA_HOME/jre/bin/javaws \
       $JAVA_HOME/jre/lib/javaws.jar \
       $JAVA_HOME/jre/lib/desktop \
       $JAVA_HOME/jre/plugin \
       $JAVA_HOME/jre/lib/deploy* \
       $JAVA_HOME/jre/lib/*javafx* \
       $JAVA_HOME/jre/lib/*jfx* \
       $JAVA_HOME/jre/lib/amd64/libdecora_sse.so \
       $JAVA_HOME/jre/lib/amd64/libprism_*.so \
       $JAVA_HOME/jre/lib/amd64/libfxplugins.so \
       $JAVA_HOME/jre/lib/amd64/libglass.so \
       $JAVA_HOME/jre/lib/amd64/libgstreamer-lite.so \
       $JAVA_HOME/jre/lib/amd64/libjavafx*.so \
       $JAVA_HOME/jre/lib/amd64/libjfx*.so

# Set environment
ENV JAVA_HOME /opt/jdk
ENV PATH ${PATH}:${JAVA_HOME}/bin
