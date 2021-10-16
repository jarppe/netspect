FROM debian:bullseye-slim

# Detect and save architecture for later reference:

RUN \
  ARCH=                                                                            && \
  dpkgArch="$(dpkg --print-architecture)"                                          && \
  case "${dpkgArch##*-}" in                                                        \
    amd64)                                                                         \
      ARCH='amd64';                                                                \
      ;;                                                                           \
    arm64)                                                                         \
      ARCH='arm64';                                                                \
      ;;                                                                           \
    *)                                                                             \
      echo "unsupported architecture";                                             \
      exit 1                                                                       \
      ;;                                                                           \
  esac                                                                             && \
  echo "$ARCH" > /etc/.arch


# Upggrade base, install generic tools, these are required for Docker, AWS CLI, GCP CLI, etc:

RUN apt -q update                                                                  && \
    apt -q upgrade -y                                                              && \
    apt -q install -y                                                              \
        gpg                                                                        \
        wget                                                                       \
        curl                                                                       \
        ca-certificates                                                            \
        software-properties-common                                                 \
        apt-transport-https                                                        \
        python3                                                                    \
        python3-pip


# Docker:

RUN \
  ARCH=$(cat /etc/.arch)                                                           && \
  curl -fsSL https://download.docker.com/linux/debian/gpg                          \
    | apt-key add -                                                                && \
  add-apt-repository "deb [arch=${ARCH}] https://download.docker.com/linux/debian $(lsb_release -cs) stable"  && \
  apt -q update                                                                    && \
  apt -q install -y docker-ce-cli



# kubectl, kubectx, kubens, and kim

ARG KUBECTX_VER=0.9.4
ARG KIM_VER=0.1.0-beta.6

RUN \
  ARCH=$(cat /etc/.arch)                                                           && \
  KUBE_URL=https://storage.googleapis.com/kubernetes-release/release               && \
  KUBE_VER=$(curl -s ${KUBE_URL}/stable.txt)                                       && \
  curl -L "${KUBE_URL}/${KUBE_VER}/bin/linux/${ARCH}/kubectl"                      \
       -o /usr/local/bin/kubectl                                                   && \
  chmod +x /usr/local/bin/kubectl                                                  && \
  CPU="${ARCH}"                                                                    && \
  case "${CPU}" in amd64) CPU=x86_64;; esac                                        && \
  curl -Ls "https://github.com/ahmetb/kubectx/releases/download/v${KUBECTX_VER}/kubectx_v${KUBECTX_VER}_linux_${CPU}.tar.gz"  \
    | tar xzf - -C /usr/local/bin kubectx                                          && \
  curl -Ls "https://github.com/ahmetb/kubectx/releases/download/v${KUBECTX_VER}/kubens_v${KUBECTX_VER}_linux_${CPU}.tar.gz"   \
    | tar xzf - -C /usr/local/bin kubens                                           && \
  curl -Ls "https://github.com/rancher/kim/releases/download/v${KIM_VER}/kim-linux-${ARCH}"  \
       -o /usr/local/bin/kim                                                       && \
  chmod +x /usr/local/bin/kim

# Install AWS CLI, set default region:

ARG AWS_REGION=eu-west-1

RUN \
  python3 -m pip install setuptools awscli                                         && \
  aws configure set default.region ${AWS_REGION}


# GCP CLI:

RUN \
  curl -L https://packages.cloud.google.com/apt/doc/apt-key.gpg                    \
    | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -                 && \
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main"    \
    | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list                         && \
  apt -q update -y                                                                 && \
  apt -q install -y google-cloud-sdk


# Misc tools, install after heavy ones above:

RUN \
  apt -q update                                                                    && \
  apt -q install -y                                                                \
         net-tools                                                                 \
         inetutils-ping                                                            \
         inetutils-telnet                                                          \
         tcptraceroute                                                             \
         bc                                                                        \
         httpie                                                                    \
         socat                                                                     \
         mtr                                                                       \
         gnupg                                                                     \
         gnupg-agent                                                               \
         postgresql-client                                                         \
         jq                                                                        \
         git                                                                       \
         zsh                                                                       \
         exa                                                                       \
         direnv                                                                    \
         procps


# tcping

RUN \
  curl -Ls http://www.vdberg.org/~richard/tcpping                                  \
       -o /usr/local/bin/tcpping                                                   && \
  chmod +x /usr/local/bin/tcpping


# User:

RUN groupadd -g 1001 user                                                          && \
    useradd -u 1000 -g user -m user

ENV HOME=/home/user
WORKDIR /home/user
USER user:user

# My image, my preferences

COPY ./zshenv  /home/user/.zshenv
COPY ./zshrc   /home/user/.zshrc
CMD ["zsh"]


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
