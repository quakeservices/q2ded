FROM debian:stable-slim

ARG yquake_version
ENV yquake_version ${yquake_version:-7_41}

RUN apt-get update -y && \
    apt-get upgrade -y

RUN apt-get install -y wget build-essential libgl1-mesa-dev libsdl2-dev libopenal-dev

RUN groupadd -r quake && \
    useradd -r -g quake -s /sbin/nologin -M quake

RUN wget https://github.com/yquake2/yquake2/archive/QUAKE2_$yquake_version.tar.gz -O /tmp/QUAKE2_$yquake_version.tar.gz

RUN tar -xf /tmp/QUAKE2_$yquake_version.tar.gz -C /opt/ && \
    mv /opt/yquake2-QUAKE2_$yquake_version /opt/quake2

COPY ./baseq2 /opt/quake2/
COPY ./ctf    /opt/quake2/
COPY ./rogue  /opt/quake2/
COPY ./xatrix /opt/quake2/

COPY ./maps       /opt/quake2/baseq2/
COPY ./server.cfg /opt/quake2/baseq2/

RUN chown -R quake:quake /opt/quake2
