FROM debian:10-slim

# Base tools, these are required for Docker, AWS cli, etc:

RUN apt update &&                     \
    apt install -y                    \
        wget                          \
        curl                          \
        ca-certificates               \
        software-properties-common    \
        python3                       \
        python3-pip

# Docker:

RUN curl -fsSL https://download.docker.com/linux/debian/gpg                        \
      | apt-key add -                                                              && \
    add-apt-repository                                                             \
      "deb [arch=amd64] https://download.docker.com/linux/debian                   \
      $(lsb_release -cs)                                                           \
      stable"                                                                      && \
    apt update                                                                     && \
    apt install -y docker-ce-cli

# kubectl

RUN KR=https://storage.googleapis.com/kubernetes-release/release                     && \
    KRV=$(curl -s ${KR}/stable.txt)                                                  && \
    curl -o /usr/local/bin/kubectl -L "${KR}/${KRV}/bin/linux/amd64/kubectl"         && \
    chmod +x /usr/local/bin/kubectl

# Install AWS CLI:

RUN python3 -m pip install setuptools                                              \
                           awscli                                                  && \
    aws configure set default.region eu-west-1

# Misc tools, install after heavy ones above:

RUN apt update &&                     \
    apt install -y                    \
        net-tools                     \
        inetutils-ping                \
        inetutils-telnet              \
        tcptraceroute                 \
        bc                            \
        httpie                        \
        socat                         \
        mtr                           \
        gnupg-agent                   \
        postgresql-client             \
        jq                            \
        git                           \
        zsh                           \
        exa                           \
        direnv

# tcping

ADD http://www.vdberg.org/~richard/tcpping /bin/tcpping
RUN chmod +x /bin/tcpping

# My image, my preferences

COPY ./zshenv  ./.zshenv
COPY ./zshrc   ./.zshrc
CMD ["zsh"]
