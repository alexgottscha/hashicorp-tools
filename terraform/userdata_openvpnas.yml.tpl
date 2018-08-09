#cloud-config

hostname: openvpnas

apt:
        sources:
                certbot-ubuntu-certbot-xenial.list:
                        source: "deb http://ppa.launchpad.net/certbot/certbot/ubuntu xenial main"
                        keyid: 75BCA694

package_update: true

runcmd:
        - certbot certonly -d "openvpnas.${var.dns_domain}" -n
