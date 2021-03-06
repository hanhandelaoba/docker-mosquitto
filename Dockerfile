FROM ubuntu:16.04
LABEL maintainer="wangkai@qiandy.net"
LABEL Description="docker image for newest mosquitto version on ppa:mosquitto-dev/mosquitto-ppa. websockets opening. building on ubuntu latest docker image."

RUN apt-get update && apt-get install -y python-software-properties software-properties-common && \
    apt-add-repository -y -u ppa:mosquitto-dev/mosquitto-ppa && \    
    apt-get update && apt-get install -y mosquitto mosquitto-clients     

RUN mkdir -p /mqtt/config /mqtt/data /mqtt/log
COPY config /mqtt/config
RUN adduser --system --disabled-password --disabled-login mosquitto && \
    chown -R mosquitto:mosquitto /mqtt
USER mosquitto
VOLUME ["/mqtt/config", "/mqtt/data", "/mqtt/log"]

EXPOSE 1883 8883 9001

COPY docker-entrypoint.sh /usr/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/sbin/mosquitto", "-c", "/mqtt/config/mosquitto.conf"]
