# centos-xl2tpd
Run this image.
```shell
docker run -d \ 
    --name xl2tpd  --privileged \
    -p 500:500/udp -p 4500:4500/udp -p 1701:1701/udp \
    -v /data/apps/xl2tpd/chap-secrets:/etc/ppp/chap-secrets \
    --restart always \
    docker.sqbj.info/xl2tpd-psk:latest
```

-e DOCKER_NET_SUB=... (defaults to 172.18)

-e PSK_passwd=... (defaults to 123)

/data/apps/xl2tpd/chap-secrets
```shell
# Secrets for authentication using CHAP
# client	server	secret			IP addresses
test  * test *
```
