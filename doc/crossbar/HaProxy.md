#

Use haproxy 1.5 to create an SSL reverse proxy

Created by Noah Mehl, last modified on Jul 09, 2013 Go to start of metadata
If you're working from an existing install, you will likely need to remove haproxy 1.4 before continuing.  Be sure to take a backup of /etc/haproxy/haproxy.cfg!
yum erase haproxy
We are going to build haproxy from a source rpm, so we need to install a few things:
yum install @development openssl-devel pcre-static pcre-devel
Then we download a source rpm to build from:
curl -O http://dagobah.ftphosting.net/yum/SRPMS/haproxy-1.5-dev14.src.rpm
Then we build the rpm:
rpmbuild --rebuild haproxy-1.5-dev14.src.rpm
Then we install the rpm we just built:
rpm -Uvh rpmbuild/RPMS/x86_64/haproxy-1.5-dev14.x86_64.rpm
Let's move the original config back in place:
mv /etc/haproxy/haproxy.cfg.rpmsave /etc/haproxy/haproxy.cfg
Let's make a directory for the cert/s:
mkdir -p /etc/haproxy/certs
Put your pem cert/key into the certs folder:
mv certificate.pem /etc/haproxy/certs
Add the following to the /etc/haproxy/haproxy.cfg config:
frontend whapps-ssl-in
    bind *:8443 ssl crt /etc/haproxy/certs/certificate.pem
    default_backend whapps
backend whapps
    balance roundrobin
    server localhost host.domain.com:8000 check
Restart haproxy and enjoy!
 
Cleanup:
Update the /var/www/html/config/config.js for the new https: and port
You may need to update the endpoint entries for existing users to point to the new https: and port, you can see how to do that here: Manually Editing Database Documents
 
Notes:
If you have an existing cert, ca-bundle and key, here's how you can make the pem:
cat certificate.crt ca-bundle.crt private.key > certificate.pem
Hopefully it's obvious that the paths, and host names need to be updated for your environment.
