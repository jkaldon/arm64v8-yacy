FROM debian:buster-slim AS build

# Image metadata
# git commit
LABEL org.opencontainers.image.revision="-"
LABEL org.opencontainers.image.source="https://github.com/jkaldon/arm64v8-yacy/tree/master"

ARG YACY_URL=https://github.com/yacy/yacy_search_server.git
ARG YACY_TAG=Release_1.92

RUN set -e && \
  apt-get update && \
  apt-get install -y \
          curl \
          wget \
          openssl \
          bash \
          vim \
          coreutils \
          git \
          gnupg && \
  useradd -d /home/yacy -m -s /usr/sbin/nologin yacy && \
  mkdir /data && \
  chown -R yacy.yacy /data

RUN set -e && \
  cd /tmp && \
  wget --no-verbose https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public -O /tmp/openjdk.key && \
  gpg --no-default-keyring --keyring ./adoptopenjdk-keyring.gpg --import /tmp/openjdk.key && \
  gpg --no-default-keyring --keyring ./adoptopenjdk-keyring.gpg --export --output adoptopenjdk-archive-keyring.gpg && \
  rm ./adoptopenjdk-keyring.gpg && \
  mv adoptopenjdk-archive-keyring.gpg /usr/share/keyrings && \
  chown root:root /usr/share/keyrings/adoptopenjdk-archive-keyring.gpg && \
  echo "deb [signed-by=/usr/share/keyrings/adoptopenjdk-archive-keyring.gpg] https://adoptopenjdk.jfrog.io/adoptopenjdk/deb buster main" | tee /etc/apt/sources.list.d/adoptopenjdk.list && \
  apt-get update && \
  apt-get install -y \
          ant \
          adoptopenjdk-8-openj9 && \
  git clone --branch "${YACY_TAG}" "${YACY_URL}" yacy && \
  cd yacy && \
  ant clean all dist && \
  cd /home/yacy && \
  tar -xzf /tmp/yacy/RELEASE/*.tar.gz && \
  mv yacy dist && \ 
  chown -R yacy.yacy dist && \
  rm -rf /tmp/yacy /tmp/openjdk.key '/tmp/adoptopenjdk-keyring.gpg~'

USER yacy
WORKDIR /home/yacy

COPY resources/* /home/yacy/

RUN set -e && \
  ln -s /data/yacy /home/yacy/.yacy 

ENTRYPOINT [ "/bin/bash", "-c" ]
#CMD [ "/home/yacy/dist/startYACY.sh", "-d", "-s", ".yacy" ]
CMD [ "/home/yacy/dist/startYACY.sh -d -s .yacy" ]

