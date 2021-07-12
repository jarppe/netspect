FROM debian:bullseye-slim

# Upggrade base:

RUN apt -qq update                                                                 && \
    apt -qq upgrade -y


# tini:

RUN apt -qq install -y gpg

ENV TINI_VERSION v0.19.0
ENV TINI_URL https://github.com/krallin/tini/releases/download
ADD ${TINI_URL}/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]


# Base tools, these are required for Docker, AWS CLI, GCP CLI, etc:

RUN apt -qq update                                                                 && \
    apt -qq upgrade -y                                                             && \
    apt -qq install -y                                                             \
        wget                                                                       \
        curl                                                                       \
        ca-certificates                                                            \
        software-properties-common                                                 \
        apt-transport-https                                                        \
        python3                                                                    \
        python3-pip


# Docker:

RUN curl -fsSL https://download.docker.com/linux/debian/gpg                        \
      | apt-key add -                                                              && \
    add-apt-repository                                                             \
      "deb [arch=amd64] https://download.docker.com/linux/debian                   \
      $(lsb_release -cs)                                                           \
      stable"                                                                      && \
    apt -qq update                                                                 && \
    apt -qq install -y docker-ce-cli


# kubectl and kubectx

RUN KR=https://storage.googleapis.com/kubernetes-release/release                   && \
    KRV=$(curl -s ${KR}/stable.txt)                                                && \
    curl -o /usr/local/bin/kubectl -L "${KR}/${KRV}/bin/linux/amd64/kubectl"       && \
    chmod +x /usr/local/bin/kubectl

# TODO: kubectx is not in bullseye repo
# RUN apt install -y kubectx


# Install AWS CLI:

RUN python3 -m pip install setuptools                                              \
                           awscli                                                  && \
    aws configure set default.region eu-west-1


# GCP CLI:

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main"    \
      | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list                       && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg                     \
      | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add -              && \
    apt -qq update -y                                                              && \
    apt -qq install -y google-cloud-sdk


# Install python libs for httpie:

RUN python3 -m pip install urllib3                                                 \
                           chardet                                                 \
                           requests


# Misc tools, install after heavy ones above:

RUN apt update -qq &&                 \
    apt -qq install -y                \
        net-tools                     \
        inetutils-ping                \
        inetutils-telnet              \
        tcptraceroute                 \
        bc                            \
        httpie                        \
        socat                         \
        mtr                           \
        gnupg                         \
        gnupg-agent                   \
        postgresql-client             \
        jq                            \
        git                           \
        zsh                           \
        exa                           \
        direnv                        \
        procps


# tcping

ADD http://www.vdberg.org/~richard/tcpping /bin/tcpping
RUN chmod +x /bin/tcpping

# mongosh

RUN wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc                 \
      | apt-key add -                                                            && \
    echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.4 main"    \
      > /etc/apt/sources.list.d/mongodb-org-4.4.list                             && \
    apt -qq update                                                               && \
    apt -qq install -y mongodb-org-shell


# Image labels:

ARG BUILD_DATE

LABEL name="jarppe/netspect"
LABEL author="jarppe@gmail.com"
LABEL doc="https://github.com/jarppe/netspect"
LABEL source="https://github.com/jarppe/netspect/blob/master/Dockerfile"

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="jarppe/netspect"
LABEL org.label-schema.description="Simple image with network and DevOps tools"
LABEL org.label-schema.vendor="Jarppe"
LABEL org.label-schema.url="https://github.com/jarppe/netspect"
LABEL org.label-schema.build-date="${BUILD_DATE}"


# My image, my preferences

COPY ./zshenv  /root/.zshenv
COPY ./zshrc   /root/.zshrc
CMD ["zsh"]
