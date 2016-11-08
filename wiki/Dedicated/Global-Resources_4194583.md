Creating carriers to route outbound calls has never been easier! A single doc for each carrier inside the offnet/ database will make a carrier available to all customers. (Individual customers can optionally set their own carriers in the APIs or via a GUI)
The base doc
Pretty simple at this level. Just create a new doc
 
{
  
_id
: 
random_doc_id
  
,
name
: 
my carrier
}
 
A carrier
Defining a carrier for the system is relatively simple. The keys required are 
enabled
, 
flags
, 
weight_cost
, 
routes
, and 
gateways
.
enabled
, toggles whether the carrier is to be included when deciding how to route an outbound call.
flags
, a list of features a carrier supports (like CName). This list is matched against a 
Client DID's
 options; if all of the features in a DID's options list exist in the carrier's flags, the carrier is kept in the available routes; otherwise it is removed from contention.
weight_cost
, when multiple carriers are available to route a call, weight_cost allows you to assign which is preferred (by giving it a lower weight). So if you have a primary carrier, assign it 1 (it will be used first).
routes
, a list of regular expressions for matching E.164-formatted (+12223334444) DIDs. A sample regex to match all E.164 numbers:
^\\+1(\\d{10})$
You can obviously add regexes for specific area codes, toll-free, E911, and international numbers. The first capture group is what is used to pass in the bridge URI (in the example, the 10-digit number will be passed to the gateways).
gateways
, a list of gateways provided by the carrier that will handle the routes matched by the regex(s).
callerid_type
, an optional field that can toggle how CallerID is passed to the carrier. Potential values are 
rpid
, 
pid
, and 
from
 (corresponding to Remote Party ID, P-*-Identity headers, and From).
formatters
, an optional object of formatting instructions for inbound requests from the carrier
 
{
   
_id
: 
5bbc699c76df9da56363233dcc1214bd
,
   
pvt_type
: 
resource
,
   
name
: 
Some Carrier
,
   
enabled
: true,
   
flags
: [
   ],
   
weight_cost
: 30,
   
rules
: [
       
^\\+1(\\d{10})$

   ],
   
gateways
: [
        ... see below ...
   ],
   
grace_period
: 5,
formatters
: {
request
: [ {
regex
: 
^\\+?1?\\d{6}(\\d{4})$
,
prefix
: 
,
suffix
: 
 }]
}
}
 
Gateways
Each gateway has a simple configuration that offers enough flexibility for most carriers.
The only two required fields are 
server
 and 
enabled
, but a host of other parameters are available to tweak the setup.
server
, hostname or IP of the gateway
enabled
, is this gateway available to route over.
username
, if the gateway requires a username
password
, if the gateway requires a password
prefix
, if the gateway requires a prefix on the capture group from the succeeding regex
suffix
, if the gateway requires a suffix on the capture group
codecs
, a list of codecs to constrain the carrier to during negotiation
progress_timeout
, the number of seconds to wait for the gateway to connect the call before failing to the next gateway
To clarify the prefix/suffix/capture group, the route sent to the switch will be built as follows:
DID +12223334444 is being called, and the above regex is matched. The capture group becomes 
2223334444
. If prefix or suffix are not set, they default to 
, the empty string. The resulting INVITE will look like PREFIXcapture_groupSUFFIX@SERVER where the text in caps correspond to the fields above.
 
gateways
: [
  
{
    
server
: 
sip001.server.voip_carrier.com
    
, 
username
: 
myacctid
    
, 
password
: 
12345
    
, 
prefix
: 
1717
    
, 
suffix
: 
    
, 
codecs
: [ 
G729
, 
PCMU
, ... ]
    
, 
progress_timeout
: 
8
// 8 seconds
    
, 
enabled
: true
  
}
]
 
Bringing it together
Here's the stitched-together carriers document:
 
{
_id
: 
5bbc699c76df9da56363233dcc1214bd
,
   
pvt_type
: 
resource
,
   
name
: 
Some Carrier
,
   
enabled
: true,
   
flags
: [
   ],
   
weight_cost
: 30,
   
rules
: [
       
^\\+1(\\d{10})$

   ],
   
gateways
: [
       {
           
server
: 
sip.carrier.com
,
           
realm
: 
sip.carrier.com
,
           
username
: 
username
,
           
password
: 
password
,
           
prefix
: 
+
,
           
suffix
: 
,
           
codecs
: [
           ],
           
enabled
: true
       }
   ],
   
grace_period
: 5,
formatters
: {
request
: [ {
regex
: 
^\\+?1?\\d{6}(\\d{4})$
,
prefix
: 
,
suffix
: 
 }]
}
}
 
A carrier is defined. The first has a route that matches E.164 numbers (so US numbers only). The second carrier will match any number starting with 011 or any number that starts with +
2-9
 (not +1XXXX..., so no US numbers).
 
 
