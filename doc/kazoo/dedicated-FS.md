**Lineman FreeSWITCH Simulator**

The **FreeSWITCH** tool of `lineman` is designed to allow full emulation of a (currently single) **FreeSWITCH** server.  This allows a workorder greater control to:

Without requiring a running **FreeSWITCH** server and SIP endpoint/simulators

Complete control of all messages, including the creation of non-compliant or expected data

The dynamic generation of **FreeSWITCH** events with respect to data fixtures.

Using the **FreeSWITCH** test tool requires a certain understanding of **FreeSWITCH** events as this is what the tool is mostly responsible for generating. 

`toolbag`

Within the toolbag element a (currently single) **Freeswitch** element can be define the following elements:

`default-event-headers`
 
The value of this element is a collection of `event-header` elements that are prepended to every **Freeswitch** request made in a sequence.  See the `event-header` description below for more details.

Example:

?xml version= 1.0
 encoding= ISO-8859-1?

workorder

toolbag

freeswitch

default-event-headers

event-header name= Core-UUID 05cfa64d-fd57-478b-a34d-2877d1aaaeec

/event-header

event-header name= FreeSWITCH-Hostname vagrant.2600hz.com

/event-header

event-header name= FreeSWITCH-Switchname vagrant.2600hz.com

/event-header

event-header name= FreeSWITCH-IPv4 192.168.1.45

/event-header

event-header name= FreeSWITCH-IPv6

::1

/event-header

event-header name= Event-Date-Local

2012-04-06 13:17:53

/event-header

event-header name= Event-Date-GMT

Fri, 06 Apr 2012 20:17:53 GMT

/event-header

event-header name= Event-Date-Timestamp

1333743473494547

/event-header

event-header name=Event-Calling-File

sofia_reg.c

/event-header

event-header name= Event-Calling-Function

sofia_reg_parse_auth

/event-header

event-header name= Event-Calling-Line-Number

2379

/event-header

/default-event-headers

/freeswitch

/toolbag

/workorder
 
`bind`
Binds the static value of the element to a freeswitch event. When the binding is invoked, with the optional argument defined in the 
args attribute, the static value is delivered to the requester.

Attribute

Description

binding

A **Freeswitch** event binding `args`The argument requested when the binding is invoked `error`
If this is set to `true`then the XML value is present to `ecallmgr` as an `error` response.

`clean` If this is set to `false` then the XML value will not be cleaned up. See Lineman Test Tool for details.

A list of available binds is below.
 
Example:

?xml version=1.0

encoding=ISO-8859-1?

workorder

toolbag

freeswitch

bind binding=freeswitch.api.status
 
 args=![CDATA[
          
          UP 0 years, 18 days, 13 hours, 41 minutes, 1 second, 777 milliseconds, 964 microseconds
          
          FreeSWITCH is ready
          
          147 session(s) since startup
          
          0 session(s) 0/200
          
          5000 session(s) max
          
          min idle cpu 0.00/43.00
          
        ]]
      /bind

bind binding=freeswitch.api.load

args=mod_sofia ![CDATA[
          
          +OK Reloading XML
          
          -ERR [Module already loaded]
          
        ]]

/bind

/freeswitch

/toolbag

/workorder
 
`connect` When this element is invoked the tool will connect to an ecallmgr node, and configure it for testing.
 This will remove the ability of that `ecallmgr` to connect to an actual **FreeSWITCH** server for the duration of the test.

Attribute

Description

`node` The name of the `ecallmgr` node, typically `ecallmgr`

`host` The FQDN of the server running `ecallmgr`, if not present the local hostname is used.

`cookie`The erlang cookie of the ecallmgr virtual machine.

?xml version=

1.0 encoding= ISO-8859-1?

workorder

toolbag

freeswitch

connect node= ecallmgr

/

/freeswitch

/toolbag

/workorder
 
 
**Sequence Elements**

All sequence elements are in a **Freeswitch** element and described by the action attribute.  This section will be broken down by the 
available actions.


`freeswitch[@action='fetch']` Used to preform a **FreeSWITCH** request for a binding such as a directory lookup. See **FreeSWITCH** bindings for more information.

Attribute

Description


`action` The value must be fetch fetch-module, the binding config file, for example:  

`directory`

`fetch-key`


The **FreeSWITCH** XML section to request

`fetch-property` The  fetch property  name `fetch-value`

The fetch property value `fetch-id` the ID of the fetch request
 
**Example:**

?xml version=1.0

encoding=ISO-8859-1?

workorder

sequences

sequence

freeswitch action=fetch

fetch-module=directory

fetch-key=domain

fetch-property=name

fetch-value=test.2600hz.com

fetch-id= 36889abf-8e1b-498e-9f68-d9ad6af3df48

event-header name=Event-Name

REQUEST_PARAMS

/event-header

event-header name= action

sip_auth

/event-header

event-header name= sip_profile

sipinterface_1

/event-header

event-header name= sip_user_agent

PolycomSoundPointIP-SPIP_330-UA/3.3.2.0413

/event-header

event-header name= sip_auth_username

device_1

/event-header

event-header name= sip_auth_realm

test.2600hz.com

/event-header

event-header name=sip_auth_nonce

6acd9049-149e-4790-bb4c-1a6931b633ae

/event-header

event-header name= sip_auth_uri

sip:test.2600hz.com:5060

/event-header

event-header name= sip_contact_user

device_1

/event-header

event-header name= sip_contact_host

192.168.1.181

/event-header

event-header name= sip_to_user

device_1

/event-header

event-header name= sip_to_host

test.2600hz.com

/event-header

event-header name= sip_from_user

device_1

/event-header

event-header name= sip_from_host

test.2600hz.com

/event-header

event-header name= sip_request_host

192.168.1.45

/event-header

event-header name= sip_request_port

5060

/event-header

event-header name= X-AUTH-IP 192.168.1.181

/event-header

event-header name= sip_auth_qop auth

/event-header

event-header name= sip_auth_cnonce n6XPbFowczF2OxQ

/event-header

event-header name= sip_auth_nc 00000009

/event-header

event-header name= sip_auth_response 3ad345827751258c993109c0ef4c297e

/event-header

event-header name= sip_auth_method REGISTER

/event-header

event-header name= key id

/event-header

event-header name= user device_1

/event-header

event-header name= domain test.2600hz.com

/event-header

event-header name= ip 192.168.1.41

/event-header

/freeswitch

/sequence

/sequences

/workorder



freeswitch[@action='publish']

Used to publish a **FreeSWITCH** event.

Attribute

Description

`action` The value must be `publish`

`call-id` The `call-id` to report this event belongs to: 

Example:

?xml version= 1.0

encoding=ISO-8859-1 ?

workorder

sequences

sequence

freeswitch action= publish

call-id= 66d05b09-74b57bae-d67cf1f7@192.168.1.181

event-header name= Event-Name CUSTOM

/event-header

event-header name= Event-Subclass sofia::register

/event-header

event-header name= profile-name sipinterface_1

/event-header

event-header name= from-user device_1

/event-header

event-header name= from-host test.2600hz.com

/event-header

event-header name= presence-hosts test.2600hz.com

/event-header

event-header name= contact ![CDATA[

user

sip:device_1@192.168.1.181:5348;fs_path=

sip:192.168.1.50;lr;received=sip:192.168.1.181:5348

]]

/event-header

event-header name= call-id

66d05b09-74b57bae-d67cf1f7@192.168.1.181

/event-header

event-header name= rpid unknown

/event-header

event-header name= status Registered(UDP)

/event-header

event-header name= expires 60

/event-header

event-header name= to-user device_1

/event-header

event-header name= to-host test.2600hz.com

/event-header

event-header name= network-ip 192.168.1.41

/event-header

event-header name= network-port 5060

/event-header

event-header name= username device_1

/event-header

event-header name= realm test.2600hz.com

/event-header

event-header name= user-agent PolycomSoundPointIP-SPIP_330-UA/3.3.2.0413

/event-header

/freeswitch

/sequence

/sequences

/workorder



Event Headers

Event headers is an XML element used to represent a line of a FreeSWITCH event.  All events published to ecallmgr are a combination of all 

event-headers defined in the value of the element prepend with any defined in the toolbag section under the 

default-event-headers

element.

Attribute

Description

name

The name (or key) of this even header, this is required on each and should be unique (duplicates will be delivered to ecallmgr)

clean

If this is set to 

false

then the XML value will not be 

cleaned up

. See 

Lineman Test Tool

for details.

Provided Bindings

This is a list of binding that are generated when ecallmgr makes requests to the FreeSWITCH tool.  The parts defined in braces vary 

depending on the request, for example 

freeswitch.fetch_reply.123546789

would be the response for a fetch request with the attribute 

fetch-id=123456789
.
freeswitch.bind.{type}

freeswitch.register_event_handler

freeswitch.send

freeswitch.fetch_reply.{fetch-id}

freeswitch.api.{command}

freeswitch.bgapi.{command}

freeswitch.event

freeswitch.session_event

freeswitch.nixevent

freeswitch.session_nixevent

freeswitch.noevents

freeswitch.session_noevents

freeswitch.close.exit

freeswitch.sendevent.{event-name}

sendevent.custom.{sub-class-name}

freeswitch.sendmsg.{UUID}

freeswitch.getpid

freeswitch.handlecall.{UUID}

freeswitch.start_handler.{type}




