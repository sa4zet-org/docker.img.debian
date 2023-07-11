ARG debian_version
FROM debian:${debian_version}-slim

ARG teamcity="##teamcity[blockOpened name='set debian settings']"
ARG debian_version
RUN echo "APT::Install-Recommends \"0\";" > /etc/apt/apt.conf.d/99local \
  && echo "APT::Install-Suggests \"0\";" >> /etc/apt/apt.conf.d/99local \
  && echo "Acquire::http::Pipeline-Depth \"0\";" >> /etc/apt/apt.conf.d/99local \
  && echo "deb http://http.debian.net/debian/ ${debian_version} main contrib non-free non-free-firmware" >/etc/apt/sources.list \
  && echo "user:x:1000:1000:,,,:/home/user:/bin/bash" >>/etc/passwd \
  && echo "user:x:1000:" >>/etc/group \
  && mkdir -p /home/user \
  && chown user:users /home/user \
  && usermod --append --groups users user
COPY etc/ /etc/
ARG teamcity="##teamcity[blockClosed name='set debian settings']"

ARG teamcity="##teamcity[blockOpened name='upgrade installed debian packages']"
RUN apt-get update \
  && apt-get dist-upgrade -y
ARG teamcity="##teamcity[blockClosed name='upgrade installed debian packages']"

ARG teamcity="##teamcity[blockOpened name='install common debian packages']"
RUN apt-get -y install \
    bash-completion \
    ca-certificates \
    curl \
    iproute2 \
    iw \
    net-tools \
    procps
ARG teamcity="##teamcity[blockClosed name='install common debian packages']"

ARG teamcity="##teamcity[blockOpened name='clean']"
RUN apt-get --purge -y autoremove \
    && apt-get clean \
    && rm -rf /tmp/* /var/lib/apt/lists/*
ARG teamcity="##teamcity[blockClosed name='clean']"

ARG docker_repository
ENV \
  LANG=C.UTF-8 \
  LC_ALL=C.UTF-8 \
  TERM=xterm-256color \
  SHELL=/bin/bash \
  DEBIAN_FRONTEND=noninteractive \
  DOCKER_TAG=$docker_repository

SHELL ["/bin/bash", "-c"]
