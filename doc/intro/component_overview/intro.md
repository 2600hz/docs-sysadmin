
######**OpenSIPS**

**OpenSIPS** acts as a load balancer for the SIP requests (much the way nginx or HAProxy are used to load balance web requests). We minimize the number of public network interfaces needed to inform clients and carriers of by pointing them to the load balancers (usually two for redundancy). Adding capacity becomes as easy as informing openSIPS of the new switch.

to the Switch... 


######**FreeSWITCH**

We primarily use **FreeSWITCH** in this layer because of the tight integration we get between **Kazoo** and **FreeSWITCH** via the 
`mod_erlang_event` module. As **FreeSWITCH** is already a carrier-grade switch on its own, bringing the clustering features of **Kazoo** on top, you get a truly high-quality cluster of switches on which to build your business.

to the Control Layer...


######**Control Layer - Kazoo**

**Kazoo** provides an abstraction layer (among other things) to the underlying switching layer. Application developers can program their applications against the **Kazoo** APIs and know that Kazoo will take care of the details. Application developers also benefit from Kazoo's ability to distribute processing amongst the servers in the switching layer. To the application developer, Kazoo is one logical switch.

to the Message Bus... 


######**RabbitMQ**

We primarily start and conduct conversations between servers using a standard protocol named AMQP, which is implemented via a program named **RabbitMQ**. While we've had discussions about 
faster systems like **ZeroMQ** (theoretically anyway), **RabbitMQ** allows us to keep everything in native Erlang data types, pass things around our software quickly, and cluster **Kazoo** and **WhApp** servers easily. It also implements all the brokers we need out-of-the-box.

to the Logic...


######**WhApps**

**WhApps** can control what happens at all stages of a call (even initiate calls of their own). Authentication, routing, in-call applications (like IVRs and voicemail), and more, are all exposed via the **Kazoo** APIs. We provide a set of APIs via a REST interface, implemented as a **WhApp** named **Crossbar**. With **Crossbar**, configuration of PBX functionality and more is exposed. Other **WhApps** included are Registrar (authentication and distributed registration server), **Callflow** (real-time dialplan execution), **MediaMgr** (real-time streaming of MP3 and WAV media files to the switching layer), and **Trunkstore** (trunking platform).

to the Storage.... 


######**BigCouch**

Its a known secret that **BigCouch** is the magic fairy dust that makes **Kazoo** so reliable. With the ability to replicate data, dynamically adjust the read and write quorums, and a simple-to-use HTTP interface, developing our platform using **BigCouch** as the long term datastore has been a huge win. As important, from an operational perspective, once you understand the knobs and levers to turn to tweak the performance characteristics, **BigCouch** is a breeze to operate and maintain.
