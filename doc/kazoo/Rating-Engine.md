**Build Your Own Rating Engine**


Here are the steps to easily add your own rating engine to **Kazoo** (and bypass the HotOrNot WhApp).

How calls are rated in **Kazoo**

When a new call is received in the `ecallmgr` application, a rating request is published onto the AMQP bus. Any application bound for those rate request events will receive the JSON payload and can optionally respond with a rate response. The first valid response received will be the rate applied to the call.


**Rate Request JSON**

**Kazoo** generates a rate request payload published onto the callmgr exchange with a routing key of rate.req. The JSON payload will look something along the lines of:

Rate Request JSON

    {To-DID:+14158867900
    ,Call-ID:abc123def456ghi789
    ,Event-Category:rate
    ,Event-Name:req
    ,Msg-ID:msg_id_9876
    ,Server-ID:amqp_queue_name
    ,App-Name:sending_app
    ,App-Version:sending_app_ver
    ,Node:ecallmgr@host.com
    ,Account-ID:qwerty1234567890
    ,From-DID:+14158867915
    ,Options:[] 
    ,Direction:inbound

    }


**Description of the Rate Request JSON payload:**

Field

Description

Value

Required

To-DID

The dialed number

The dialed number off the INVITE

Yes

Call-ID

The unique identifier for this channel

String

Yes

Event-Category

The class of event

rate

Yes

Event-Name

The name of the event

req

Yes

Msg-ID

The ID of this rate request message

String

Yes

Server-ID

The name of the AMQP queue of the sender, empty if no response is needed

String

Yes

App-Name

The name of the application that published the request

String

Yes

App-Version

The version of the application that published the request

String

Yes

Node

The Erlang VM node name of the sender

String

Yes

Options

Arbitrary list of strings set by sender, usually used by receiving to filter list of applicable rates

List of strings

No

Direction

The direction of the call, relative to Kazoo; 

outbound

meaning from Kazoo to the endpoint and 

inbound

meaning from the endpoint to Kazoo

inbound

or 

outbound

No

Account-ID

The Kazoo account ID associated with this cal (if any)

String

No

From-DID

The Caller ID number, if available

String

No

Route Response JSON


Any application which receives rate requests and wishes to respond will need to publish the response to the targeted exchange using the Server-ID from the rate request payload as the routing key. Assuming the request above, a potential response would be constructed thusly:

Rate Response JSON:

    {Rate:0.05
    ,Call-ID:abc123def456ghi78
    ,Rate-Increment:60
    ,Rate-Minimum:60
    ,Discount-Percentage:0
    ,Surcharge:1.00
    ,Rate-Name:expensive_rate
    ,Base-Cost:1.05
    ,Msg-ID:msg_id_9876
    ,Update-Callee-ID:true
    ,Event-Category:rate
    ,Event-Name:resp
    ,App-Name:hotornot
    ,App-Version:1.0.0
    ,Server-ID:
    ,Node:whistle_apps@host.com

    }



**Description of the Rate Response JSON payload:**


**Field**

Description

Value

Required


**Rate**

The cost of the rate

Float

Yes


**Call-ID**

Identifier of the channel

String

Yes


**Event-Category**

Class of message

rate

Yes


**Event-Name**

Name of the message type

resp

Yes


**App-Name**

Name of the responding application

String

Yes


**App-Version**

Version of the responding application

String

Yes


**Msg-ID**

The ID from the request payload that identifies the request message

String

Yes


**Node**

The responder's node (useful mostly for debugging)

String

Yes


**Server-ID**

Empty, since no response to this message will be sent

Yes


**Rate-Increment**

How many seconds before Rate is applied

Integer, defaults to 60

No


**Rate-Minimum**

Minimum number of seconds to bill the call for, regardless of call duration

Integer, defaults to 60

No


**Discount-Percentage**

Apply a discount to the cost of the call

Integer

No


**Surcharge**

Flat amount to bill the call (in addition to per-minute charges)

Float

No


**Rate-Name**

Arbitrary name for the rate

String

No


**Base-Cost**


`(Rate * (Rate-Minimum div 60)) + Rate-Surcharge`

Float

No


**Update-Callee-ID**

If true, will prepend the Callee ID name with the rate of the call

Boolean, defaults to false

No


The **Rate** fields (Rate, Rate-Increment, etc) will be set on the channel and available in the 
Custom-Channel-Vars of the resulting CDR. A simple formula is used to calculate the cost of the call: 
 
 
R = Rate

RI = Rate-Increment

RM = Rate-Minimum

Sur = Surcharge

Secs = Billing Seconds
 

*When RM * `60 = Sur + ((RM / 60) * R)`

*When* `RM = 60 = Sur + ((RM / 60) * R) + ceiling((Secs - RM) / RI) * ((RI / 60) * R)))`
 
 
 
