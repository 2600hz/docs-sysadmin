######**CALL RATING**




**Kazoo** provides a basic facility to load a rate-deck into the system for the purpose of rating each call. The rate is only utilized if 

the system determines the caller does not have any flat-rate services available for the number being dialed.

How to load the rate deck

How to test the rate deck (if possible)

How to check our costs vs. retail costs

How to make sure the rating module is loaded / running / being utilized

Info dump to later be cleaned up

**Call Rating** is handled by the **'hotornot'** application. When it starts up for the first time, it will create a database called 

**'ratedeck'** and load an initial rate document for US-domestic calls. That document looks like:

{ _id : US-1, direction: [ inbound, outbound ],
   
pvt_internal_rate_cost : 0.01,
   
iso_country_code: US, options: [ ],
   
prefix: 1,
   
rate_cost: 0.02,
   
rate_increment: 60,
   
rate_minimum: 60,
   
rate_name: US-1,
   
rate_surcharge: 0.00,
   
routes: [^0111(\\d{10})$, ^\\+1(\\d{10})$],
   
pvt_type: rate

}

######**Create your own rate document**

`_id` is arbitrary, but we recommend using `iso_country_code` + prefix direction determines whether to apply the rate to an inbound or 

outbound call (or both).

`pvt_internal_rate_cost` // is what you are charged by your upstream carrier (optional)

`iso_country_code` // what country this rate is applicable.

`options` // what features does this rate apply to. You might put `[Fax]` for a rate, and if a fax machine is configured and has the same 

flag in its settings, this rate will be used.

`rate_cost` // how much the call will cost, per rate_increment

`rate_increment` // how many seconds the `rate_cost` applies to. So $0.02 for `rate_cost` and 60 for `rate_increment` means 2 cents per 

minute.

`rate_minimum` // how many seconds to bill for at a minimum. If a call lasts 30 seconds and `rate_minimum` is 60, bill it as a 60-second 

call.

`rate_name` // friendly name, eventually will be exposed in the GUI

`rate_surcharge` // flat rate to charge for connecting the call.

`routes` // list of regex to apply to the dialed DID to determine if this rate is eligible to be applied to the call.

`pvt_type` //
 
`rate` //


######**Other info**

The rate chosen is based on the prefix length. So if I have two rates with routes that match the dialed DID, one with prefix 

'1' and one with prefix '123', the rate for prefix '123'will be applied. The rate information is placed in the channel variables and will 

appear in the call's CDR data under the `Custom-Channel-Vars`field.
