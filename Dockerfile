FROM ubuntu:latest

MAINTAINER Wang Kai <wangkai@qiandy.net>

RUN apt-get update && apt-get install -y python-software-properties software-properties-common && \
	apt-add-repository -y -u ppa:mosquitto-dev/mosquitto-ppa && \    
    apt-get install -y mosquitto mosquitto-clients && \
    adduser --system --disabled-password --disabled-login mosquitto

RUN mkdir -p /mqtt/config /mqtt/data /mqtt/log
COPY config /mqtt/config
RUN chown -R mosquitto:mosquitto /mqtt
VOLUME ["/mqtt/config", "/mqtt/data", "/mqtt/log"]


EXPOSE 1883 9001

COPY docker-entrypoint.sh /usr/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/sbin/mosquitto", "-c", "/mqtt/config/mosquitto.conf"]
