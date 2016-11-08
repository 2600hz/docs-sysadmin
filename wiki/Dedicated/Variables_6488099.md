Lineman Variables
This tool provides variable substitution in attributes and values.  It can also generate certain types of values dynamically.
Toolbag
This tool has no configuration parameters.
Sequence Elements
This tool provides the 
variables
 element which is used to define 
variable
 elements. See bellow.
Example:
?xml version=
1.0
 encoding=
ISO-8859-1
?
workorder
sequences
sequence
variables
variable name=
fetch_uuid
 generate=
uuid
/
variable name=
ip
 generate=
ip_v4
/
variable name=
username
 generate=
username
/
variable name=
password
 generate=
password
/
variable name=
realm
test.sip.2600hz.com
/variable
/variables
/sequence
/sequences
/workorder
 
Variable
Attribute
Description
name
The variable name, if this is encountered inside two braces it will be replaced with the value
generate
Generate a dynamic value of the provided type, see bellow for a list of types
clean
If this is set to 
false
 then the XML value will not be 
cleaned up
. See 
Lineman Test Tool
 for details.
Generate Types
uuid
username
password
ip_v4
word
domain
chars
Example Usage
?xml version=
1.0
 encoding=
ISO-8859-1
?
workorder
sequences
sequence
variables
variable name=
uuid
 generate=
uuid
/
variable name=
username
 generate=
username
/
variable name=
password
 generate=
password
/
variable name=
ip
 generate=
ip_v4
/
variable name=
realm
test.sip.2600hz.com
/variable
/variables
freeswitch action=
publish
 call-id=
{{uuid}}@{{ip}}
event-header name=
Event-Name
CUSTOM
/event-header
event-header name=
Event-Subclass
sofia::register
/event-header
event-header name=
contact
![CDATA[
user
sip:{{username}}@{{ip}}:5348;fs_path=
sip:192.168.1.50;lr;received=sip:{{ip}}:5348
]]
/event-header
event-header name=
username
{{username}}
/event-header
event-header name=
realm
{{realm}}
/event-header
/freeswitch
os event=
os_command.registrar.local_summary.{{uuid}}
![CDATA[
          /opt/whistle/2600hz-platform/utils/command_bridge/command_bridge registrar_maintenance local_summary {{realm}} {{username}}
        ]]
/os
expect binding=
os_command.registrar.local_summary.{{uuid}}
![CDATA[
          Realm: {{realm}}
          Username: {{username}}
          Contact: 
user
 sip:{{username}}@{{ip}}:5348;fs_path=sip:192.168.1.50;lr;received=sip:{{ip}}:5348
        ]]
/expect
/sequence
/sequences
/workorder
