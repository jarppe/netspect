# Simple image with network and devops tools

Contains:

* wget
* curl
* ping
* telnet
* httpie
* tcptraceroute
* mtr
* ca-certificates
* Python3.7 and pip
* Docker client
* kubectl and kubectx
* AWS CLI
* GCP CLI
* PostgreSQL client
* zsh

...and more.

## Usage:

```bash
$ docker run --rm -it jarppe/netspect
[netspect]/> http ip.jsontest.com
HTTP/1.1 200 OK
Access-Control-Allow-Origin: *
Content-Length: 24
Content-Type: application/json
Date: Sat, 05 Dec 2020 12:07:27 GMT
Server: Google Frontend
X-Cloud-Trace-Context: 6413facfbe4cb34d159cd030c181f91c

{
    "ip": "172.16.216.64"
}
```

or simply

```bash
$ docker run --rm -it jarppe/netspect docker image ls --filter label=name=jarppe/netspect
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
jarppe/netspect     latest              1cc62de9069a        3 minutes ago       1.45GB
```

## License

Copyright © 2020 Jarppe Länsiö.

Available under the terms of the Eclipse Public License 2.0, see [LICENSE](./LICENSE)
