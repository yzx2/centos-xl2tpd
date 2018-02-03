FROM centos:latest

RUN yum install -y  epel-release && yum install -y  strongswan xl2tpd && yum install  -y iptables-services net-tools

WORKDIR /app

ADD start.sh /app/start.sh

CMD ["/app/start.sh"]
