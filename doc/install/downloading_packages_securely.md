# Downloading Packages Securely

By default, `curl` verifies the certificate used on https://packages.2600hz.com. Unfortunately, most installs don't have the particular certificate chain used here. This requires you to download the packages insecurely. 

If you would like to download the packages without having to pass `-k` or `--insecure` to `curl`, follow these steps:

Download the "Go Daddy Secure Certificate Authority - G2" chain
```
$ curl --output /etc/pki/tls/certs/gdig2.crt https://certificates.godaddy.com/repository/gdig2.crt
```

Add the certificate to nssdb
```
# certutil -d sql:/etc/pki/nssdb -A -t "C,C,C" \ 
  -n "Go Daddy Secure Certificate Authority - G2" \ 
  -i /etc/pki/tls/certs/gdig2.crt
```

This information was obtained from [this post](https://blog.hqcodeshop.fi/archives/304-Fixing-curl-with-Go-Daddy-Secure-Certificate-Authority-G2-CA-root.html).
