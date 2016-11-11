**Lineman OS**

This tool executes a operating system command.  It can optionally publish the result on a binding so the except tool can compare the result.


**Toolbag**

This tool has no configuration parameters.


**Sequence Elements**

The only sequence element this tool provides is:

OS

Attribute

Description

Event

An option event, if specified will be used as the routing key to publish the returned content of the command. Dont forget that sequences run in parallel, use the variables tool to give the event attribute a unique name or your consumers might not be getting the content from this sequence's execution!
 
**Example:**

    ?xml version=
    1.0
     encoding=
    ISO-8859-1
    ?
    workorder
    øsequences
    sequence
    os event=
    os_command.registrar.local_summary
    ![CDATA[
          /opt/whistle/2600hz-platform/utils/command_bridge/command_bridge registrar_maintenance local_summary test.2600hz.com device_1
        ]]
    /os
    /sequence
    /sequences
    /workorder
