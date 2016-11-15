## DNS Concepts



## What is DNS and why do you need to know:


## What

Short for Domain Name System (or Service or Server), an Internet service that translates domain names into IP addresses. Because domain names are alphabetic, they're easier to remember. The Internet however, is really based on IP addresses. Every time you use a domain name, therefore, a DNS service must translate the name into the corresponding IP address. For example, the domain name www.example.com might translate to `198.105.232.4`. The DNS system is, in fact, its own network. If one DNS server doesn't know how to translate a particular domain name, it asks another one, and so on, until the correct IP address is returned.
 
 
## Why

To be able to connect to our platform u would need to remember ip addreses, To see the GUI go to `88.25.25.1`, register your phone at `89.25.36.2` and so on. You remember kazoo.io and DNS translates that to the proper IP.
 
 
## Thats all?

Nope.. DNS is awesome as it can do some tricks that really help. Here are a few, add more if you like:

CNAME records >> They enable you to use your own domainname, but still use a hosted GUI thats not at your own IP or server (a bit like masquerading)

SRV records >> one of the magic tools that **Kazoo** utilizes. It enables you to specify multiple ip adresses for a single service that maybe delivered by one or more servers. Lets say u have a VoiP service,  It runs on a single server and you use my-awesome-domain.com. You grow, get smart and need to add an extra server to your system to share load.

You have no desire to say to 50% of your clients that they need to register to an other server such as im-growing.my-awesome-domain.com.
SRV solves that for you by giving you the ability to use my-awesome-domain.com but have two ip addreses beneath that.
 
 


