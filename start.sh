#!/bin/bash
docker_net_sub=$DOCKER_NET_SUB
left_ip=`ifconfig |grep ${docker_net_sub:-172.18}|awk  '{print $2}'`


cat > /etc/strongswan/ipsec.conf << EOF
config setup
conn %default
        ikelifetime=60m
        keylife=20m
        rekeymargin=3m
        keyingtries=1
conn L2TP-PSK
        type=transport
        authby=psk
        keyexchange=ikev1
        keyingtries=3
        rekey=no
        left=${left_ip}
        right=%any
        auto=add
EOF



cat > /etc/strongswan/strongswan.conf << EOF
charon {
        load_modular = yes
        plugins {
                include strongswan.d/charon/*.conf
        }
        filelog {
          /var/log/strongswan.log {
            time_format = %b %e %T
            append = no
            default = 1
            flush_line = yes
            ike = 2
          }
        }
}

include strongswan.d/*.conf
EOF

cat > /etc/strongswan/ipsec.secrets << EOF
: PSK "${PSK_passwd:-123}"
EOF


cat > /etc/xl2tpd/xl2tpd.conf  << EOF
[global]
ipsec saref = yes
[lns default]
ip range = 10.0.200.10-10.0.200.100
local ip = 10.0.200.1
refuse chap = yes
refuse pap = yes
require authentication = yes
ppp debug = yes
pppoptfile = /etc/ppp/options.xl2tpd
length bit = yes
EOF



iptables --table nat --append POSTROUTING --jump MASQUERADE

/usr/sbin/xl2tpd -c /etc/xl2tpd/xl2tpd.conf -D &
/usr/sbin/strongswan start --nofork &

sleep 5

tail -f /var/log/strongswan.log

