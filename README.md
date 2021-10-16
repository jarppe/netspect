# Simple image with network and devops tools

This image is based on [debian:bullseye-slim](https://hub.docker.com/_/debian). It includes commonly used tools and utilities for quick shell work, and
some basic network related work.

Some tools included are:

* wget
* curl
* ping
* httpie
* telnet
* tcptraceroute
* mtr
* Python 3.7
* Docker client
* kubectl, kubectx, kubens, and kim
* AWS CLI
* GCP CLI
* PostgreSQL client
* zsh
* git client

...and more.

The user in image is `user:user` with uid 1000 and gid 1001. The default command is `zah`.

## Usage:

Basic usage:

```bash
$ docker run --rm -it jarppe/netspect
[netspect]/> 
```

The image is fairly large one.

```bash
$ docker image ls --filter label=name=jarppe/netspect
REPOSITORY        TAG       IMAGE ID       CREATED         SIZE
jarppe/netspect   latest    68b8a8b5882a   2 minutes ago   1.63GB
```

## TODO

[x] kim (https://github.com/rancher/kim)
[ ] Multi-architecture image (https://github.com/docker/buildx#building-multi-platform-images)
[ ] Help on AWS, GCP and Kube usage.


## License

Copyright © 2021 Jarppe Länsiö.

Available under the terms of the Eclipse Public License 2.0, see [LICENSE](./LICENSE)
