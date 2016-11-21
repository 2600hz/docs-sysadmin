- [Quick SSL Setup Guide](#org4bdaaae)
  - [Let's Encrypt Cert Setup](#org02c5c19)
    - [Setup Let'sEncrypt and Apache](#orgeb6046d)
    - [Auto-renew](#org5109f70)
  - [Setup Apache as a reverse proxy](#org18e6150)
    - [MonsterUI](#org26cc7b3)
    - [API Reverse Proxy](#orgc503092)
    - [Reconfigure MonsterUI and the Apps](#orga3c7a5d)



<a id="org4bdaaae"></a>

# Quick SSL Setup Guide

This guide assumes you have configured your DNS properly to point to the server you wish to secure. It will assume you are using Apache to serve MonsterUI and as a reverse proxy for Crossbar (the API server) for SSL termination.


<a id="org02c5c19"></a>

## Let's Encrypt Cert Setup

We'll use [Let's Encrypt](https://letsencrypt.org/) to generate a free SSL certificate for us. See [these instructions](https://www.digitalocean.com/community/tutorials/how-to-secure-apache-with-let-s-encrypt-on-ubuntu-14-04) for a more detailed guide.

```bash
# First, get the script from EFF
sudo wget -O /usr/local/sbin https://dl.eff.org/certbot-auto

# Make it executable
sudo chmod a+x /usr/local/sbin/certbot-auto
```


<a id="orgeb6046d"></a>

### Setup Let'sEncrypt and Apache

To start an interactive session to setup the certificate for your domain (in this case, kazoo.mycompany.com):

```bash
certbot-auto --apache -d kazoo.mycompany.com
```

Certificates will be installed to \`/etc/letsencrypt/live\`


<a id="org5109f70"></a>

### Auto-renew

Let's Encrypt certificates are valid for 90 days. Triggering the renewal process is straight-forward:

```bash
certbot-auto renew
```

Setup auto-renewal in the form of a cronjob:

```bash
sudo crontab -e
```

```crontab
30 2 * * 1 /usr/local/sbin/certbot-auto renew >> /var/log/le-renew.log
```


<a id="org18e6150"></a>

## Setup Apache as a reverse proxy

Having Apache (or any HTTP server) proxy the requests for the API server makes sense. You can manage your certificates in fewer places and API servers can come and go since each request is independent of any others (no state shared between requests on a given API server).

We create two VirtualHost entries, one for serving MonsterUI assets and one for proxying to Crossbar.


<a id="org26cc7b3"></a>

### MonsterUI

```apache
<VirtualHost *:443>
    ServerName kazoo.mycompany.com:443

    DocumentRoot /var/www/html/monster-ui

    SSLEngine on
    SSLCertificateKeyFile "/etc/letsencrypt/live/kazoo.mycompany.com/privkey.pem"
    SSLCertificateFile "/etc/letsencrypt/live/kazoo.mycompany.com/cert.pem"

    <Directory />
        #Options FollowSymLinks
        Options Indexes FollowSymLinks Includes ExecCGI
        AllowOverride All
        Order deny,allow
        Allow from all
    </Directory>
</VirtualHost>
```


<a id="orgc503092"></a>

### API Reverse Proxy

Be sure to replace the IPs with the IP Crossbar is using.

```apache
<VirtualHost *:8443>
    ServerName kazoo.mycompany.com:8443
    ProxyPreserveHost On

    SSLEngine on
    SSLCertificateKeyFile "/etc/letsencrypt/live/pdx.2600hz.com/privkey.pem"
    SSLCertificateFile "/etc/letsencrypt/live/pdx.2600hz.com/fullchain.pem"

    ProxyPass / http://10.1.10.29:8000/
    ProxyPassReverse / http://10.1.10.29:8000/
</VirtualHost>
```


<a id="orga3c7a5d"></a>

### Reconfigure MonsterUI and the Apps

Once you've reloaded Apache, you'll want to update MonsterUI's config.js:

```bash
vim /var/www/html/monster-ui/js/config.js
# Update api_url to 'https://kazoo.mycompany.com:8443/v2'
```

And re-init the apps:

```bash
# Re-initialize Monster Apps
sup crossbar_maintenance init_apps \
/var/www/html/monster-ui/apps \
https://kazoo.mycompany.com:8443/v2
```