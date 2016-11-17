## Cluster Health



These instructions assume you are running as `root`. All services MUST be working as indicated in order to have a properly running **Kazoo** platform.


## FreeSWITCH

Is **FreeSWITCH** running?
 
  `service freeswitch status
 
  freeswitch(pid:xxxx): up`

If not then:

  `service freeswitch start`
 
Is **FreeSWITCH** Connected?

**FreeSWITCH** must be connected to the rest of the platform. You can check this from within **FreeSWITCH** itself. Enter the 

**FreeSWITCH** CLI and check for erlang listener(s). You should have at least one:
```
  cli -x 

  erlang listeners
```
You should see at least one of your other servers listed. If you don't, or there are no listeners, then **FreeSWITCH** is running by `ecallmgr` is not connected to it.
 
 
## ECallMgr

Is **ECallMgr** Running?

**ECallMgr** connects the Kazoo platform with all **FreeSWITCH** servers. It is the primary link between **FreeSWITCH** and the rest of the platform.
 
  `service ecallmgr status

  [freeswitch@fs001.yourserver.com,

  freeswitch@fs002.yourserver.com]`

This command should return a list of **FreeSWITCH** nodes which **ECallMgr** is connected to, in JSON format.
 
If it does not, try restarting `ECallMgr`:

  `service ecallmgr restart`

Check **RabbitMQ** status

**RabbitMQ** provides the glue between **FreeSWITCH** and the **Kazoo** Applications:
`
 service rabbitmq-server status`

That command should return something like:
 ```
  Status of node rabbit@mydomain.com...
    
  [{pid,2049
   },
 
  { running_applications,[{rabbit,

  RabbitMQ, 2.7.0 },
                        
  {os_mon, CPO  CXC 138 46, 2.2.6},
                        
  {sasl, SASL  CXC 138 11, 2.1.9.4},
                        
  {mnesia, MNESIA  CXC 138 12, 4.4.19},
                        
  {stdlib,ERTS  CXC 138 10, 1.17.4},
                        
  {kernel,ERTS  CXC 138 10,2.14.4}]},
 
  {os,{unix,linux}},
 
   {erlang_version,
Erlang R14B03 (erts-5.8.4) [source] [64-bit] [smp:4:4] [rq:4] [async-threads:30] [kernel-poll:true]\n},
 
{memory,[{total, 26165880},
          
{processes, 10842712},
          
{processes_used, 10828488},
          
{system, 15323168},
          
{atom, 1122017},
          
{atom_used, 1116886},
          
{binary, 115952},
          
{code, 11271185},
          
{ets, 865008}]},
 
{vm_memory_high_watermark,0.3999999997516473},
 
{vm_memory_limit, 322122547}]`

...done.
 
If not then:
 
`# service rabbitmq-server restart`
 ```
 
## Kazoo Applications
 
`# service whapps status`
 
Should give you something like:
 
Searching for running **WhApps** on 'whistle_apps@mydomain.com

`[cdr,sysconf,conference,registrar,hangups,media_mgr,crossbar,callflow,
 
stepswitch]`
 
If it does not, try restarting it. 

`service whapps restart`
 
Some of these are optional and some are mandatory. I believe **Crossbar** is necessary for **Winkstart** to work. If **Crossbar** is not there you can try running 

`whapps_maintenance:refresh().`

from the 'Some Useful Commands' section of this wiki.


## HAProxy
 
`# service haproxy status`

haproxy (pid  xxxx) is running...
 
and if not
 
`# service haproxy restart`
 

## Check BigCouch

Assuming localhost
 
  `# curl localhost: 5984

  { couchdb: Welcome, version: 1.1.1, bigcouch: 0.4.0}`
 
if not then check and double check your haproxy config and status and try:
 
`# service bigcouch restart`
 
 
