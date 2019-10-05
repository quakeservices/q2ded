FROM debian:stable-slim

ARG yquake_version
ENV yquake_version ${yquake_version:-7_41}

RUN mkdir -p /opt/quake2

COPY ./data/nonfree/baseq2 /opt/quake2/baseq2
COPY ./data/nonfree/ctf    /opt/quake2/ctf
COPY ./data/nonfree/rogue  /opt/quake2/rogue
COPY ./data/nonfree/xatrix /opt/quake2/xatrix

RUN apt-get update -y && \
    apt-get upgrade -y

RUN apt-get install -y wget build-essential libgl1-mesa-dev libsdl2-dev libopenal-dev libcurl4-gnutls-dev

RUN groupadd -r quake && \
    useradd -r -g quake -s /sbin/nologin -M quake

RUN wget https://github.com/yquake2/yquake2/archive/QUAKE2_$yquake_version.tar.gz -O /tmp/QUAKE2_$yquake_version.tar.gz && \
    tar -xf /tmp/QUAKE2_$yquake_version.tar.gz -C /opt/

RUN cd /opt/yquake2-QUAKE2_$yquake_version && \
    make -j $(nproc)

RUN cp /opt/yquake2-QUAKE2_$yquake_version/release/q2ded          /opt/quake2/q2ded
RUN cp /opt/yquake2-QUAKE2_$yquake_version/release/quake2         /opt/quake2/quake2
RUN cp /opt/yquake2-QUAKE2_$yquake_version/release/ref_gl1.so     /opt/quake2/ref_gl1.so
RUN cp /opt/yquake2-QUAKE2_$yquake_version/release/ref_gl3.so     /opt/quake2/ref_gl3.so
RUN cp /opt/yquake2-QUAKE2_$yquake_version/release/ref_soft.so    /opt/quake2/ref_soft.so
RUN cp /opt/yquake2-QUAKE2_$yquake_version/release/baseq2/game.so /opt/quake2/baseq2/game.so

COPY ./data/free/maps       /opt/quake2/baseq2/maps
COPY ./data/free/config.cfg /opt/quake2/baseq2/config.cfg
COPY ./data/free/maps.lst   /opt/quake2/baseq2/maps.lst

RUN chown -R quake:quake /opt/quake2

USER quake

CMD ["/opt/quake2/q2ded"]
