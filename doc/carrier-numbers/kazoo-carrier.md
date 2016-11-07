# 
Building a Carrier Module

Created by James Aimonetti, last modified by Peter Defebvre on Jan 16, 2014 Go to start of metadata
Hooking a Carrier's API into Kazoo
More and more carriers are starting to offer API access to their number search, number provisioning, and other services. Kazoo has a generic method it uses to access these features, allowing the enterprising developer to add a module to Kazoo that does the integration between the carrier and Kazoo. This page will serve as a developer's guide to creating that module.
Overview
Carrier modules exist as part of the core's whistle_number_manager application. You can view existing modules in src/carriers/ to help guide your development efforts. A carrier module must export the following functions (this is the Kazoo interface):
find_numbers/3
acquire_number/1
disconnect_number/1
find_number/3
This is what Crossbar and other modules within Kazoo would use to search for numbers from a given carrier. The function accepts three arguments and should return a JSON object OK 2-tuple or an error 2-tuple.
The first argument is the prefix or number to search for; this will depend on what types of searches the carrier's API supports. It could be the NPA or NPA-NXX in the US, or some other search criteria.
The second argument is the quantity of numbers requested by Kazoo.
The third argument is a proplist, usable for passing carrier-specific options to the underlying module.
The JSON object returned should have, as top-level keys, the DIDs found, and the value should be a JSON object containing any additional information (like rate center, features on the number, etc). A sample return could be:
{"+12223334444":{"sms":"enabled"}
 ,"+12223334445":{"sms":"disabled", "ratecenter":"OR"}
}
 
acquire_number/1
This function is responsible for actually provisioning a number from the carrier and having the carrier route the DID to the Kazoo installation. It takes as input the #number{} record and expects the modified record back. Typically all that is modified is the module_data portion, which is generally appended with any order information the carrier may return. If an error occurs when provisioning the number, use the wnm_number:error_* functions to throw an appropriate exception.
Some carriers will allow you to dynamically add the IP(s) to use when routing the DID to the Kazoo cluster. These are typically stored in the system_config database in a document for the carrier settings (something like number_manager.carrier_name).
Each acquire_number function should also have a dry run capability:
acquire_number(#number{dry_run='true'}=Number) -> Number;
This allow to bypass the work and not actually buy the number but the rest of the work in Kazoo is done. This will return you an updated service plan with the charges that would happen if you bought the number (this work will appear in phone_numbers V2 apis).
 
disconnect_number/1
This function is responsible to releasing the DID from the carrier. Similar to acquire_number/1, this function will only return the #number{} record on success; otherwise use the wnm_number error functions to throw exceptions when this function should fail.
