## Install via ISO 



**Overview**

*DISCLAIMER: The Kazoo Single Server ISO is still under development and is not guaranteed to work.*

If you need a small development or testing **Kazoo** environment, a single server installation may work for you. Keep in mind that only using a single server to host the various **Kazoo** platform software results in limited performance and no redundancy or backups. The **Kazoo** platform was designed to be a scalable, failure resistant platform. 
 
 
## Installing the ISO

Prepare your virtual machine or server for installation via ISO. Note that this ISO will overwrite any data on the selected partition/hard drive, so using a virtual machine is preferred. Alternatively, please setup your partitions accordingly. Download the **Kazoo** Single Server ISO here: http://repo.2600hz.com/ISOs/. Make sure to download the latest version. Install the ISO as you would any other **Linux** distribution. The **Kazoo** Single Server ISO is built on **CentOS 6.5**. Remember the root password you set! Once completed, reboot the server and login as the root user.

When you log in, you will be presented with information regarding your **Kazoo** installation, including the URL for your **Kazoo** web interface and login credentials. By default, this installation method will use a DHCP provided IP. If you are using a static IP, see "Changing IP Settings" below. If you want to change the hostname, you should also do that now. Login to the web interface with the information provided. Please make sure to reset your password! In case you missed it on the previous step, the web interface's URL should look like: (http://<server-ip>/kazoo-ui). You can now start testing your **Kazoo** installation! If you encounter any problems, you can utilize the **Kazoo** **Google Groups: 2600hz-users** and **2600hz-dev**, or visit our public **IRC** channel: **#2600hz** on **Freenode*.
 
 
## Using Kazoo

Were you able to login to the web interface? If so, you have properly installed the Kazoo platform! 
 
**Changing IP Settings**
By default, this installation method will use a DHCP provided IP. If you as OK with this, then you are set! But if you want to use a static IP, do the following:

1. Change your network settings to set your static IP. Run the script `/root/kazoo_ip_set.sh`

2. Select STATIC, then select the network interface where your static IP is set. The script will automatically change your Kazoo settings to match your statically set IP. Do you want to use DHCP, but want Kazoo bound on a different network interface? Run the script `/root/kazoo_ip_set.sh`

3. Select DHCP, then select the network interface you want Kazoo bound to. The script will automatically change your **Kazoo** settings to bind to the network interface you chose.
 
 
## Changing Hostname

Want to change your hostname? Note that **BigCouch** uses the hostname as a location pointer to where it stores data. For this reason, you will have to wipe out all data in the **Bigcouch** database when you change hostnames. You should probably change hostnames as soon as possible! (It is possible to change hostnames while saving data, but this is out of scope of this simple ISO guide.) Run the script `/root/kazoo_hostname_set.sh`. Follow the script's instructions. Make sure your hostname is fully qualified, this is a requirement for the **Kazoo** platform. The script will change your hostname and update **Kazoo** settings to match.
 
 
## Advanced

By default, this **Kazoo** installation will only be able to utilize local extensions and calling between them. If you want to be able to use real phone numbers and making/receiving calls to/from the outside world, you will need to add your carrier(s) information to the database. 

Note: To access the **BigCouch** database user interface, visit (http://<SERVER IP ADDRESS>:5984/_utils). For security purposes, this port is blocked by default, so you will either need to forward that port, or temporarily disable iptables.

