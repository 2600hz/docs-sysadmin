#
Secure Your REST APIs with SSL


Encrypt your Crossbar traffic
HTTP traffic, by default, is sent in the clear, meaning anyone with the ability to sniff network traffic could potentially see sensitive information flowing to/from Crossbar and the REST endpoint accessing the APIs. To combat this, SSL support has been added to Crossbar. Here are the steps taken to add SSL support from the beginning.
All shell commands that follow are run in applications/crossbar/priv/ssl/ which you may need to create:
KAZOO_ROOT$ mkdir -p applications/crossbar/priv/ssl 
KAZOO_ROOT$ cd applications/crossbar/priv/ssl
KAZOO_ROOT/applications/crossbar/priv/ssl$ 

Create the root key (skip if you have a root key already that you want to use):

$ openssl genrsa -out 2600hzCA.key 2048
Generating RSA private key, 2048 bit long modulus
.............+++
......................................................+++
e is 65537 (0x10001)

Sign the root key (fill out a questionaire):
$ openssl req -x509 -new -nodes -key 2600hzCA.key -days 1024 -out 2600hzCA.pem
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:US
State or Province Name (full name) [Some-State]:California
Locality Name (eg, city) []:San Francisco
Organization Name (eg, company) [Internet Widgits Pty Ltd]:2600Hz
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:api.2600hz.com
Email Address []:

Create a certificate (cert):
$ openssl genrsa -out crossbar.key 2048
Generating RSA private key, 2048 bit long modulus
.......+++
......+++
e is 65537 (0x10001)

Remove the need for a passphrase:
$ openssl rsa -in crossbar.key -out crossbar.pem
writing RSA key

Generate the certificate signing request (CSR). Be sure, when answering the "Common Name" question to put either your FQDN or IP address that will show in the browser:
$ openssl req -new -key crossbar.key -out crossbar.csr
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:US
State or Province Name (full name) [Some-State]:California
Locality Name (eg, city) []:San Francisco
Organization Name (eg, company) [Internet Widgits Pty Ltd]:2600Hz
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:api.2600hz.com
Email Address []:
Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:

Sign the CSR
$ openssl x509 -req -in crossbar.csr -CA 2600hzCA.pem -CAkey 2600hzCA.key -CAcreateserial -out crossbar.crt -days 500
Signature ok
subject=/C=US/ST=California/L=San Francisco/O=2600Hz/CN=thinky64.2600hz.com
Getting CA Private Key

Generate the self-signed certificate:
$ openssl x509 -req -days 60 -in crossbar.csr -signkey crossbar.key -out crossbar.crt
Signature ok
subject=/C=US/ST=California/L=San Francisco/O=2600Hz/CN=thinky64.2600hz.com
Getting Private key

Modify the "crossbar" doc in the "system_config" database with the following values:
"default":{
  "ssl_port":"8443"
  ,"ssl_cert":"applications/crossbar/priv/ssl/crossbar.crt"
  ,"ssl_key":"applications/crossbar/priv/ssl/crossbar.key"
  ,"use_ssl":true
  ,"ssl_ca_cert":"applications/crossbar/priv/ssl/2600HzCA.pem" // May be omitted if you do not want to verify the peer.
  ...
}

Start Crossbar. You can now test your new SSL-enabled APIs via:
$ curl -v -k https://api.2600hz.com:8443/v1/accounts
* About to connect() to api.2600hz.com port 8443 (#0)
*   Trying 127.0.0.1... connected
* successfully set certificate verify locations:
*   CAfile: crossbar.crt
  CApath: /etc/ssl/certs
* SSLv3, TLS handshake, Client hello (1):
* SSLv3, TLS handshake, Server hello (2):
* SSLv3, TLS handshake, CERT (11):
* SSLv3, TLS handshake, Server key exchange (12):
* SSLv3, TLS handshake, Server finished (14):
* SSLv3, TLS handshake, Client key exchange (16):
* SSLv3, TLS change cipher, Client hello (1):
* SSLv3, TLS handshake, Finished (20):
* SSLv3, TLS change cipher, Client hello (1):
* SSLv3, TLS handshake, Finished (20):
* SSL connection using DHE-RSA-AES256-SHA
* Server certificate:
*        subject: C=US; ST=California; L=San Francisco; O=2600Hz; CN=api.2600hz.com
*        start date: 2012-06-01 21:59:03 GMT
*        expire date: 2012-07-31 21:59:03 GMT
*        common name: api.2600hz.com (matched)
*        issuer: C=US; ST=California; L=San Francisco; O=2600Hz; CN=api.2600hz.com
*        SSL certificate verify ok.
> GET /v1/accounts HTTP/1.1
> User-Agent: curl/7.22.0 (x86_64-pc-linux-gnu) libcurl/7.22.0 OpenSSL/1.0.1 zlib/1.2.3.4 libidn/1.23 librtmp/2.3
> Host: api.2600hz.com:8443
> Accept: */*
> 
< HTTP/1.1 401 Unauthorized
< Www-Authenticate: 
< Access-Control-Max-Age: 86400
< Access-Control-Expose-Headers: Content-Type, X-Auth-Token, X-Request-ID, Location, Etag, ETag
< Access-Control-Allow-Headers: Content-Type, Depth, User-Agent, X-File-Size, X-Requested-With, If-Modified-Since, X-File-Name, Cache-Control, X-Auth-Token, If-Match
< Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS, HEAD
< Access-Control-Allow-Origin: *
< X-Request-ID: 5ad53536debfff23f55641caecb3849d
< Content-Length: 0
< Date: Fri, 01 Jun 2012 22:19:11 GMT
< Server: Cowboy
< Connection: keep-alive
< 
* Connection #0 to host api.2600hz.com left intact
* Closing connection #0
* SSLv3, TLS alert, Client hello (1):
You should now be able to interact with your APIs via port 8443, and have the communication protected from endpoint to server and vice versa.
You can optionally disable the plaintext API server if you only want your APIs accessible via SSL. Edit the crossbar doc in the system_config database, toggling "use_plaintext" from true to false. The next time Crossbar is started, only the SSL API server should start.

Securing KazooUI
Now that you've configured Crossbar to serve requests via SSL, it is important to have your GUI access the APIs over the secured connections. Here we go!
Edit the kazoo_ui/config/config.js
Replace port 8000 with 8443
Replace "http://" with "https://"

If you have created a self-signed certificate, there is a very good chance that your browser will block the AJAX requests. You will need to add the self-signed cert to your browser's exception list to have the API requests sent. Alternatively, you can purchase a certificate that will be accepted by the default browser lists (this is the preferred method for production use, as it should require no extra effort by users).
