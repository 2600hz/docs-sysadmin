Overview
Lineman is a utility for validation and load testing the entire Whistle platform.  Once complete this tool will be able to simulate FreeSWITCH nodes as well as BigCouch allowing full integration testing with mixed component fixtures.  Lineman is a modular architecture with three main components:
Workorder - This are a XML representation of a simulation or load test.
Toolbag - This is a collection of tools (or test components) that are available for use in a workorder.
Sequences - This is a set of directives utilizing lineman tools to preform a test or simulation.
Workorder
A workorder is an XML file that describes the configuration of the lineman tool, data fixtures, and test procedures.  Each workorder defines these three sections as follows:
?xml version=
1.0
 encoding=
ISO-8859-1
?
workorder
parameters
 ... 
/parameters
toolbag
 ... 
/toolbag
sequences
 ... 
/sequences
/workorder
Each section will be detailed bellow.
Parameters
Parameters element is used to configure lineman for execution of a workorder, this includes how many simultaneous sequences to run at what rate.  The available parameters are: 
Element
Attributes
Default
Description
name
-
Unknown
This is used for display and logging purposes as a descriptive name of for the workorder.
max-running-sequences
-
100
The maximum simultaneous running sequences that should be allowed
max-sequence-executions
-
100
The maximum number of sequences to execute. The test will stop when this is reached.
It is not an absolute value as additional sequences can execute depending on the rate/period parameters.
sequence-order
-
sequential
If a workorder contains multiple sequences this determines the order that they are executed. Currently the only valid options are 
sequential
 or 
random
.
sequence-period
-
1000
A period in milliseconds to execute another set of sequences. Every sequence-period starts sequence-rate sequences.
sequence-rate
-
1
The number of sequences to start every sequence-period.
display-period
-
2000
A period in milliseconds to display the current 
lineman
 status. The lineman status will always be show at the completion of a workorder.
 
Toolbag
The toolbag element is were each tool is configure prior to starting execution of the sequences.  This section will be processed when the workorder is first loaded, once.  See the individual tool pages for details about the XML elements of this section.
Sequences
The sequences element should contain one or more sequence elements.  At the end of the sequence-period a sequence element will be selected based on the sequence-order and execution started, for sequence-rate elements each period.  If the sequence-order is 
sequential
 then each sequence element will be started after the previous, in parallel.  However, if the sequence-order is 
random
 then one of the sequence elements will be chosen at random for execution during the start phase.  
Tools
freeswitch
expect
variables
os
sleep
more soon
XML Value Cleaning
By default all XML element values will be 
cleaned
.  This is a process by which leading whitespace is stripped from all lines as well as the first and last newline of only whitespace.  This allows the element value to be tabified and on the lines between the open/close XML tags.  However, if the value is sensitive to this process any element can define set a 
clean
 attribute to 
false
 and this process will be skipped.
Example Workorders
Load Testing Registrar
Registrar Validation
more soon
