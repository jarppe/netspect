FROM debian:10-slim
WORKDIR /app


RUN apt update &&       \
    apt install -y      \
       net-tools        \
       inetutils-ping   \
       inetutils-telnet \
       tcptraceroute    \
       bc               \
       httpie           \
       socat


ADD http://www.vdberg.org/~richard/tcpping /bin/tcpping
RUN chmod +x /bin/tcpping


CMD ["bash"]
