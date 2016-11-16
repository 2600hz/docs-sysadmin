## Basic SIPp Overview



From http://sipp.sourceforge.net/: **SIPp** is a free Open Source test tool / traffic generator for the SIP protocol. It includes a few basic **SipStone** user agent scenarios (UAC and UAS) and establishes and releases multiple calls with the `INVITE` and `BYE` methods. It can also reads custom XML scenario files describing from very simple to complex call flows. It features the dynamic display of statistics about running tests (call rate, round trip delay, and message statistics), periodic CSV statistics dumps, TCP and UDP over multiple sockets or multiplexed with retransmission management and dynamically adjustable call rates. The **2600hz** team has created a repo with some very simple **SIPp** configurations for use as examples.


## Quick Setup

Install **SIPp** using your package manager: `yum install -y sipp`
 
Clone the **2600hz SIPp** example repo onto a server, such as a **Kazoo** app server: `$ git clone git://github.com/2600hz/sipp.git`

Create a **Kazoo** account with the Realm : sipp.2600hz.com

On the website hover over 'Voip Services' then click 'Accounts', click 'New Account' and name the account anything you wish.

Enter into the Realm **sipp.2600hz.com** and save.

Click 'Use Account'

Create a **Kazoo** device: 
```
username: user_101
password: pwd_101
```

Hover over 'Voip Services' then click 'Devices',

Click 'Add Device' then click 'SIP Device' and give the device any name you wish.

Click 'Advanced Settings'then go to the SIP Setting and change: 

```
username: user_101 
password: pwd_101
```

Click 'Save' 

Create a **Kazoo** device:
```
username: user_102
password: pwd_102
```

Click 'Add Device'

Click 'SIP Device' and give the device any name you wish.

Click 'Advanced Settings' then go to the 'SIP Setting' 

From there change:

```
username: user_102 
password: pwd_102
```

Click 'Save'.

Create a **Kazoo** device with: 

```
username: user_103
password: pwd_103
```

Click 'Add Device'

Click 'SIP Device' and give the device any name you wish.

Click 'Advanced Settings' then go to 'SIP Setting' 

Change:

```
username: user_103
password: pwd_103 
```

Click 'Save'.

Enable the 'Check Voicemail' feature code on the account. Hover over 'Voip Services' then click 'Feature Codes'and expand the 'Miscellaneous'section. 

Click the 'Enabled'box by the 'Check Voicemail' feature code and click 'Save'. The **SIPp** test account does not need phone numbers, callflows, or voicemials unless you plan to test them.


## Calls to Voicemail with Authentication

```
call_with_auth.sh
cd dirname $0
sipp -inf users.csv -sf uac_auth.xml -r 1 -d 1000 -s *97 -i 192.168.5.42 192.168.5.151`
-r 1
```

This is the number of calls to start every second, it can be changed while the test it running

`-d 1000`

This is how long each call should remain up, in milliseconds

`-s *97`

This is is the number to call, in this case the default check voicemail feature code.

`-i 192.168.5.42`

This is the IP address to bind to, you will need to set this to the IP of the server running **SIPp**.

`192.168.5.151 `

This is the IP address of the **FreeSWITCH** server to test. Change the two IP address to be the address of the test server and the address of a **FreeSWITCH** server (in that order). When you run this test it will round robin between the SIP credentials in `users.csv` running the test `uac_auth.xml`. 

To start the test type:

`$ ./call_with_auth.sh`
 
 
## Register

Edit: 
```
register.sh
cd dirname $0
sipp -inf users.csv -sf register.xml -d 1000 -s 5000 -i 192.168.5.42 192.168.5.151`
-d 1000 
```
This is ignored by this test

`-s 5000 `

This is ignored by this test

`-i 192.168.5.42`

This is the IP address to bind to, you will need to set this to the IP of the server running **SIPp**

`192.168.5.151 `

This is the IP address of the **FreeSWITCH** server to test.

Change the two IP address to be the address of the test server and the address of a **FreeSWITCH** server (in that order). When you run this test it will round robin between the SIP credentials in `users.csv` running the test `register.xml.`

To start the test type:

`$ ./register.sh`


## Leave Voicemails

Create a 'Voicemail Box' under the **SIPp** test account and create a callflow that goes to that 'Voicemail Box' with the number 5000:

#Edit 
```
leave_vm.sh
cd dirname $0
sipp -inf users.csv -sf uac_auth_audio.xml -r 1 -d 5000 -s 5000 -i 192.168.5.42 192.168.5.151
-r 1
```

This is the number of calls to start every second, it can be changed while the test it running.

`-d 1000`

This is how long each call should remain up, in milliseconds.

`-s 5000`

This is is the number to call, in this case the default check voicemail feature code.

`-i 192.168.5.42`

This is the IP address to bind to, you will need to set this to the IP of the server running **SIPp**.

`192.168.5.151` 

This is the IP address of the **FreeSWITCH** server to test.

Change the two IP address to be the address of the test server and the address of a **FreeSWITCH** server (in that order).
When you run this test it will round robin between the SIP credentials in `users.csv` running the test `uac_auth_audio.xml`. 

To start the test type:

`$ ./leave_vm.sh`
