FROM debian:sid-slim AS build-stage

RUN echo "APT::Install-Recommends \"0\";" > /etc/apt/apt.conf.d/99local \
  && echo "APT::Install-Suggests \"0\";" >> /etc/apt/apt.conf.d/99local \
  && echo "Acquire::http::Pipeline-Depth \"0\";" >> /etc/apt/apt.conf.d/99local \
  && rm /etc/apt/sources.list.d/* \
  && echo "user:x:1000:1000:,,,:/home/user:/bin/bash" >>/etc/passwd \
  && echo "user:x:1000:" >>/etc/group \
  && mkdir -p /home/user \
  && chown user:users /home/user \
  && usermod --append --groups users user
COPY etc/ /etc/

RUN apt-get update \
  && apt-get dist-upgrade -y

RUN apt-get -y install \
    bash-completion \
    ca-certificates \
    curl \
    iproute2 \
    net-tools \
    procps

RUN apt-get --purge -y autoremove \
    && apt-get clean \
    && rm -rf /tmp/* /var/lib/apt/lists/*

FROM scratch AS final-stage
COPY --from=build-stage / /

ENV \
  LANG=C.UTF-8 \
  LC_ALL=C.UTF-8 \
  TERM=xterm-256color \
  SHELL=/bin/bash \
  DEBIAN_FRONTEND=noninteractive \
  DOCKER_TAG=ghcr.io/sa4zet-org/docker.img.debian

SHELL ["/bin/bash", "-c"]
