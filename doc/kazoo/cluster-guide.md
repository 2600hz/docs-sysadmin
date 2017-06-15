## Key Dedicated

Name: **Kazoo Dedicated Cluster Guide**

Description: *A guide for installing, configuring and managing your own dedicated Kazoo cluster.*

Let's assume the following 7 server clusters in 2 zones.  Each zone is in a different datacenter with full access the other zone.  All FQDNs are DNS resolvable by all servers.

bc = Bigcouch  
fs = Freeswitch    
mq = RabbitMQ
kz = Kazoo
ka = Kamailio  

10.100 = zone 100  
10.200 = zone 200  
10.x00.10.x = Bigcouch  
10.x00.20.x = Freeswitch  
10.x00.30.x = RabbitMQ  
10.x00.40.x = Kazoo  
10.x00.50.x = Kamailio  

| ZONE 1 | ZONE 2 |
| ---------- | ---------- |
|bc1.z100.somedomain.com  10.100.10.1  | bc1.z200.somedomain.com  10.200.10.1 |
bc2.z100.somedomain.com  10.100.10.2   | bc2.z200.somedomain.com  10.200.10.2 |
bc3.z100.somedomain.com  10.100.10.3   | bc3.z200.somedomain.com  10.200.10.3 |
fs1.z100.somedomain.com  10.100.20.1   | fs1.z200.somedomain.com  10.200.20.1 | 
mq1.z100.somedomain.com  10.100.30.1   | mq1.z200.somedomain.com  10.200.30.1 |
kz1.z100.somedomain.com  10.100.40.1   | kz1.z200.somedomain.com  10.200.40.1 |
ka1.z100.somedomain.com  10.100.50.1   | ka1.z200.somedomain.com  10.200.40.1 |

### Cluster Bigcouch
If not using zones leave out the `zone=` config
