# Minimum Requirements


## Minimal Computational Resources

**Kazoo** is designed to be as flexible as possible on what platforms it runs on. Realistically, you would not want to rely on an embedded device with 256MB of RAM to handle 1,000,000 calls per second. That said, with modest hardware **Kazoo** will run just fine for small to medium sized businesses, and scaling to larger capacity servers is relatively seamless and painless.

## Virtualized or not?

Setting up a **Rackspace**, **Amazon**, **Synapse Global**, or other hosted provider is more than acceptable, especially when starting out. As demands increase, moving the **FreeSWITCH** components onto dedicated hardware (or adding more virtualized nodes) is generally enough to increase performance and capacity. Whether you use a virtualized service, dedicated hardware in a datacenter, or a server on your intranet, **Kazoo** will install and work. You can also setup hybrid clusters where some clients are hosted in your "cloud" while others are hosted on site (replicating and failing over to the "cloud" if the premise server goes down). Since joining a **Kazoo** cluster is easy, the configurations possible are flexible and powerful.
 
## Operating System Recommendations

It is strongly recommended that **Kazoo** be deployed on the **Linux** distribution **CentOS**, version 6.4 or 6.5.  Since **FreeSWITCH** is a large influence on **Kazoo**, and they recommend using **CentOS**; we have a similar recommendation. Also note that this is the OS of choice for 2600hz's production deployments. As time goes on, we will be testing other platforms with **Kazoo** and updating this page with recommendations. However, any operating system that **Erlang** or **FreeSWITCH** run on should suffice. 

## Preparing Computational and Operating System Resources

A fully qualified domain name is REQUIRED

**Kazoo** relies heavily on your server hostnames being fully qualified domain names (or FQDN).  Servers are usually given a short-name, such as "bob", by admins to make it easier to refer to and manage.  Fully qualified domain names are comprised of the servers name as well as the domain to which it belongs, such as "bob.example.com". Your system may not be configured to use the FQDN if you did not expressly do so.  To find out if your system is properly configured try running the following command:
 ```
[root@bob ~]$ hostname -f
bob.example.com
```
If running running the command above results in both the servers name and the domain it belongs to (basically "bob.something") skip to the next section.
 
To configure your system with a FQDN Hostname you can follow these steps:

We will modify the systems "hosts" file such that it will be able to understand a FQDN (such as "bob.example.com") belongs to an IP address.  The hosts file can be found at "/etc/hosts".
 
If you have a DNS server for the domain, say "example.com" rather than modify the hosts file you could add an A record "bob.example.com" with the servers IP. This will make it easier to manage the cluster if the IP addresses of the equipment is expect to change.  
However, if you use a DNS service (rather than the hosts file) to resolve the FQDN of the servers in your cluster you need to ensure it is 100% available! DNS failure in this configuration will disrupt voice service.
 
