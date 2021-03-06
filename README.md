# docker-mosquitto

docker image for newest mosquitto version on ppa:mosquitto-dev/mosquitto-ppa with websockets opening. building on ubuntu latest docker image.
reference from toke/docker-mosquitto.

## Running with persistence

### Local directories / External Configuration

Alternatively you can use volumes to make the changes persistent and change the configuration.

    mkdir -p /opt/mqtt/config/
    mkdir -p /opt/mqtt/data/
    mkdir -p /var/log/mqtt/
    # place your mosquitto.conf in /opt/mqtt/config/
    # NOTE: You have to change the permissions of the directories
    # to allow the user to read/write to data and log and read from
    # config directory
    # For TESTING purposes you can use chmod -R 777 /opt/mqtt/data and chmod -R 777 /var/log/mqtt to change the permissions.
    # Better use "-u" with a valid user id on your docker host

    # Copy the files from the config directory of this project
    # into /opt/mqtt/config. Change them as needed for your
    # particular needs.

    docker run -it -p 1883:1883 -p 8883:8883 -p 9001:9001 \
    --mount type=bind,source=/opt/mqtt/config,target=/mqtt/config,readonly \
    --mount type=bind,source=/var/log/mqtt,target=/mqtt/log \
    --mount type=bind,source=/opt/mqtt/data,target=/mqtt/data \
    --name mqtt mosquitto:v1.4.15

Volumes: /mqtt/config, /mqtt/data and /mqtt/log

### Docker Volumes for data persistence

Using Docker Volumes for data persistence.

Create a named volume:

    docker volume create --name mqtt_data
    docker volume create --name mqtt_log

Now it can be attached to docker by using `--mount source=mqtt_data,target=/mqtt/data --mount source=mqtt_log,target=/mqtt/log` in the Example above. Be aware that the permissions within the volumes are most likely too restrictive.

## Start with systemd

As an example this how you run the container with systemd. The example uses  docker volumes named mqtt_data and mqtt_log (see above).

    [Unit]
    Description=Mosquitto MQTT docker container
    Requires=docker.service
    Wants=docker.service
    After=docker.service

    [Service]
    Restart=always
    ExecStart=/usr/bin/docker run \
    --mount type=bind,source=/opt/mqtt/config,target=/mqtt/config,readonly \
    --mount source=mqtt_log,target=/mqtt/log \
    --mount source=mqtt_data,target=/mqtt/data \
    -p 1883:1883 -p 8883:8883 -p 9001:9001 \
    --name mqtt mosquitto:v1.4.15
    ExecStop=/usr/bin/docker stop -t 2 mqtt
    ExecStopPost=/usr/bin/docker rm -f mqtt

    [Install]
    WantedBy=multi.target

## Build

    git clone https://github.com/hanhandelaoba/docker-mosquitto.git
    cd docker-mosquitto
    docker build -t mosquitto:v1.4.15 .

## Contact

Wang Kai

wangkai@qiandy.net