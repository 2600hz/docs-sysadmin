## Build Your Own WhApp



## WhApps

**WhApps** are built to be self-contained units of functionality, varying in scope from a registrar that listens and responds to authentication requests and lookups from **Kazoo**, to a full-blown call center system handling agents, queues, etc. While they do not depend on each other for functionality, some are quite fundamental to the operation of normal telephony services, and therefore we enable them by default. Of course, you are free to write other **WhApps** to replace the functionality provided.


## The WhApp Container

All code is referenced from: ` $KAZOO/whistle_apps/ directory`
 
Starting the container is as simple as `running ./start.sh` from the applications directory. With no additional arguments, the start script will start an **Erlang** Virtual Machine named `whistle_apps`. You can start multiple VMs by passing unique values as an argument to the script (running more than one VM on a single physical server could help increase throughput, depending on the scenario and circumstances).

Once started, a control script is available to interact with the container in a rudimentary way. `whistle_apps_ctl` has a couple options for managing what **WhApps** are running on the VM: `start_app`, `stop_app`, and `running_apps`.

`start_app`: takes one parameter, the name of the **WhApp** to start, if its not already started.

`stop_app`: takes one parameter, the name of the **WhApp** to stop, if it has been started.

`running_apps`: takes no parameters, returns a list of known running **WhApps**.


## CouchDB

We use an abstraction layer on top of CouchDB that can be configured to connect to a CouchDB instance (or BigCouch or an http proxy for either). This configuration file can be found at:` $KAZOO/lib/whistle_couch-X.Y.Z/priv/startup.config`. The default config file should look like:

`{default_couch_host,"localhost",5984,"username","password"}.`

You may also have an entry similar to the above, but with `{couch_host...}` starting the config line. This is the line added by our **CouchDB** layer when successfully connecting to a **CouchDB** server. If you do not use authentication (Admin party!), leave username and password as empty strings (""). Alternatively, you can set the properties (except port) via the `whistle_apps_ctl` script mentioned above:

`set_couch_host`: takes one parameter, the hostname to connect to.

You will be prompted for the username and password. If you haven't set one, press <enter> for both questions. Your **WhApps** container should now be reading and writing to the new host.


## RabbitMQ

Similar to **CouchDB**, we have an abstraction layer for **RabbitMQ** and a simple configuration file for it as well, located at:          

`$ KAZOO/lib/whistle_amqp-X.Y.Z/priv/startup.config` 

It defaults to: `{default_host, "localhost"}`.

Alternatively, you can set the host via the `whistle_apps_ctl` script:

`set_amqp_host`: takes one parameter, the host of a **RabbitMQ** broker.
