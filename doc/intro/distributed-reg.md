## Traditional Registration



When a business or hobby first starts out, a single switch is the typical starting point. Clients point their devices to the IP of the switch, registration credentials are stored on the switch, and life is good. Then the switch begins to fill up with clients, to the point where a second server is needed handle the capacity demands. No problem; new clients on the new switch. But what happens when a client on the first switch grows? Migrate them to the new switch? Setup another switch just for them? But now you have to change the configurations on their devices, update carriers that routed DIDs to the first switch, perhaps you customized some features for that client that now have to be migrated as well...in short, it gets unwieldy fast.

This speaks nothing of the fact that if that server crashes (for a host of reasons, some controllable, some not), all clients on said switch are without service. Even when you have a hot spare or master-master setup, its no guarantee the system will survive a crash. If both servers are at 70% load, when one goes down, that 70% is headed to the other switch. How fast can the ops team spin up a new server?


## A Better Way

At a general level, the softswitch was not built to handle the distributed case. They route calls, handle codec transcoding (if necessary), but they assume they are the authority on what devices can connect and how to find devices for calls.
**Whistle** has relieved them of that concern (and others). When a registration request is received by the switch, it asks **Whistle** to give it the necessary credentials to verify the device. If successful, the switch lets **Whistle** know; **Whistle** then sends the successful registration information out the any listening WhApps (in our case, `registrar`, which stores them in **BigCouch** for later retrieval).

Now, when the switch receives a call that needs to be routed to a known device, it just asks **Whistle** for the contact information and sends the SIP traffic on its merry way. The handling switch, however, need not have ever interacted with the device before that point.


## Why Do I Care?

Because the switch is agnostic to devices, and instead trusts **Whistle** to guide it in routing calls, your clients can register their devices to any of the switches in your cluster, and carriers can send calls destined for your clients to any of the switches as well. Better still, you can put a load balancer in front of your switches, giving your clients two IPs (assume two load balancers for redundancy) to register their devices against. These load balancers keep no history of what device hit which switch last time but distribute the load evenly across your cluster.

Capacity issues? Add a switch into the cluster behind the load balancers, update the load balancers' configs, and voila, increased capacity without the client or carrier changing a single setting.


## Tangential Benefits

Because the switch is no longer storing state between calls, performance gains are noticeable as disk activity and memory usage decreases, which increases capacity as more concurrent calls can be loaded on a single switch. Plus, impacts from a switch going down are limited to the current calls (and some switches, namely **FreeSWITCH**, are building functionality to be able to rebuild an in-progress call on a new server). When those calls restart, they are evenly distributed across your remaining cluster, not overwhelming the hapless hot spare or co-master.

Capacity planning becomes much easier when you can spread load from a single failed switch across 3, 5, 10, or even 100 other switches. As the number of switches increases, your ability to load them with higher and higher sustained call rates without fear of cascading failures grows as well.
