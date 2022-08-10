# syntax=docker/dockerfile:1
FROM debian:stable-slim AS base

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && \
    apt-get upgrade -y

FROM base AS builder

ARG yquake_version
ENV yquake_version ${yquake_version:-8_10}

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get install -y wget build-essential libgl1-mesa-dev libsdl2-dev libopenal-dev libcurl4-gnutls-dev


RUN wget https://github.com/yquake2/yquake2/archive/QUAKE2_$yquake_version.tar.gz -O /tmp/QUAKE2_$yquake_version.tar.gz && \
    tar -xf /tmp/QUAKE2_$yquake_version.tar.gz -C /opt/ && \
    cd /opt/yquake2-QUAKE2_$yquake_version && \
    make -j $(nproc)

FROM base as q2ded

ARG yquake_version
ENV yquake_version ${yquake_version:-8_10}

RUN groupadd --system quake && \
    useradd --system \
            --home-dir /opt/quake2\
            --gid quake \
            --shell /sbin/nologin \
            quake


COPY --chown=quake:quake --from=builder \
    /opt/yquake2-QUAKE2_$yquake_version/release/ /opt/quake2

COPY --chown=quake:quake \
    data/nonfree/baseq2 /opt/quake2/baseq2

COPY --chown=quake:quake \
    data/free/ /opt/quake2/baseq2/

# COPY ./data/nonfree/ctf    /opt/quake2/ctf
# COPY ./data/nonfree/rogue  /opt/quake2/rogue
# COPY ./data/nonfree/xatrix /opt/quake2/xatrix

USER quake

CMD ["/opt/quake2/q2ded"]
