# DNS lookup (needed for pesky random DNS failures)
sudo aptitude -y install bind9 bind9utils

sudo cat >/etc/resolv.conf << EOF
nameserver 127.0.0.1
domain cern.ch
search cern.ch
EOF

sudo cat >/etc/bind/named.conf.options << EOF
options {
        directory "/var/cache/bind";

        forwarders {
                10.0.2.2;
        };

        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
};
EOF

sudo service bind9 restart
