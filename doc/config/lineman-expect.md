######**Lineman Expect**

The lineman expect tool is a way of defining an expected response from any of the other tools.  This is done by binding to events and specifying the expected value.

**Toolbag**
This tool has no configuration parameters.

**Sequence Elements**
All sequence elements are in a expect element and described by the type attribute, which defaults to line if not present. This section will be broken down by the available types (more will be added).  For the available bindings see the other tool pages. 

`expect[@type='line']`

Compares the expected content with the binding content line by line.  This comparison is implemented by searching for the existence of each line of the expected content in the entire binding content.  Failure to find any line or receive content in the defined timeout will fail the current sequence.

Attribute

Description

Type

The value can be line or not present binding. The binding that should carry the expected content timeout. The time in milliseconds to wait for a binding content, defaults to 1000.

`clean` if this is set to `false` then the XML value will not be cleaned up. See **Lineman Test Tool** for details.
 
Example:

?xml version=1.0

encoding=ISO-8859-1?

workorder

sequences

sequence

expect binding= freeswitch.fetch_reply.36889abf-8e1b-498e-9f68-d9ad6af3df48

timeout=2000

![CDATA[
          
section name= directory

domain name=test.2600hz.com

user id=device_1


params


param name=password

value= 123456//params

variables


variable name=

ecallmgr_Authorizing-ID

value= e00816343ee126968a5f18a0aa2442e4

variable name= ecallmgr_Inception

value= on-net 

variable name=ecallmgr_Authorizing-Type

value=device

variable name=ecallmgr_Account-ID

value=c0705d7474ea0160c10a351b2544006b 

variable name=ecallmgr_Realm

value=test.2600hz.com 

variable name=ecallmgr_Username

value=device_1 

    /variables

   /user

  /domain

/section

    ]]
        
        
        
/expect
/sequence
/sequences
/workorder
