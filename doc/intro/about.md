#####**Intro**

When most people talk about a phone line, they are actually (unknowingly) referring to a package of services provided by their local phone company. This package is actually put together from independent services. Each service is often provided from a different server, service or in some cases a completely external service provider, but to make things easy for customers all the services are packaged and sold together. This makes marketing and sales simpler.

As some companies have begun re-inventing telephony via VoIP, VoIP service providers are able to pick and choose what they wish to provide and how. To remain competitive each VoIP provider must look at the cost of providing services and decide which services to offer, how to offer them and what to price them at. Some providers use statistics to average their costs across all clients for various services. Other providers (often ones providing bargain basement prices) package almost nothing and require you to pay a-la-carte for add-ons.

At it's core, a phone line can (and usually does) consist of services that impact inbound calling and services that impact outbound calling. We break down each service below:


#####**Inbound Calls**
1.  Inbound calls (commonly referred to as "origination") occur over what are called circuits, or ports, at most providers. In this manner, a provider might have 500 phone lines which cost $20 each a month to maintain. When you make a call outbound the provider recoups the cost of these circuits, plus the cost of long-distance charges, by charging you a per-minute fee. For inbound calls, however, most people don't expect to pay anything but in reality providers pay a fee to have the phone circuits available for phone calls, so they are losing money. Many wholesale and VoIP companies assume that a circuit will be used mostly for outbound so they give you inbound calling for free, and some VoIP companies charge tariffs (sort of like taxes) to other companies when they receive inbound calls, which pay for the call. But ultimately, inbound calls do cost money and must be charged somewhere. These ports can be marketed for flat-rates for as little as $6 or as much as $30, but they always cost something. If you're getting an inbound port for free, your carrier is making up the costs in some other way (either by charging you for DIDs, or charging other companies tariffs, or assuming you'll spend money on outbound).
2.  Inbound Caller ID Name
When you receive a call from a remote number, the phone number is delivered with the call and can be shown on your Caller ID display for free. In countries outside the US, the caller's name also comes with the call and can be displayed for free. However, in the US, Caller ID Name is not free. For each call that comes into your phone where you see the Caller ID Name, YOUR receiving phone company must pay for access to lookup the name of the person who is calling. This fee is usually between $0.001 and $0.0001 per call/lookup, depending on volume discounts. Most companies either give this feature away for free (factoring the cost of the feature into the monthly cost of a phone number) or charge a small flat-fee for having Caller ID Name. Almost no company charges per-lookup as that's way too confusing and nit-picky for most customers to understand.
3.  Calls from Payphones
Inbound calls sometimes come from payphones, though rarely these days. As payphones now cost much more money to maintain then they usually get in revenue, providers of payphones began charging surcharges for calls from payphones, especially to 800 numbers. These charges are usually just passed onto the end customer.
4.  Collect and Third-Party Calls
Collect calls are uncommon in the US these days but allow you to charge the receiving party for a call, plus a fee (and usually a big mark-up). They are still used (and popular) from prisons and for overseas individuals calling US phone numbers in emergencies. These charges are usually heavily marked up and passed to the end customer, as the use of this feature is usually only done when one is in distress or in a situation where no other option is available.

**Toll-free numbers**
Toll-free numbers consist of two types of charges - the cost of reserving the toll-free number itself and the cost, per-minute, of receiving calls on a toll-free number. Like long-distance calls, there is no such thing as a flat-rate charge for toll-free calls - the calls are always billed based on the From and To number of the caller and the negotiated tariffs of the sending and receiving phone companies, which are usually based on distance and population. That said, to make life easy for consumers, the numbers are usually averaged into rates like 2 cents per minute, that people can easily understand.

**SMS**
SMS is free on inbound in most cases when you go direct to the carrier. However, it is assumed most people sending SMS messages also receive them. In that case, many companies charge a lower outbound fee than it actually costs them (to beat their competition's pricing) but also charge for inbound text messages. Their assumption is that the total number of outbound and inbound messages will result in them retaining a margin. This is usually a fair bet since most outbound messages 
(Hi honey, what's for dinner?) result in a response message (Mac and Cheese!).

**Video Calling**
1.  Video calling is simply a different codec and additional RTP channel used for transmitting video in addition to audio. It is supported by the SIP protocol itself and many providers are introducing formal support for these protocols. However, video doesn't work over the old PSTN and video also increases bandwidth utilization significantly. Some companies are charging various rates for this (which are still evolving) to compensate for increased data usage.
2.  Video calling also often requires a Media Processing device to transcode signals when they are not the same (such as an H261 phone to an H263 phone). Most companies offering video have invested in one of these units, which usually allow a certain number of conversations at a time. For sample purposes, let's say the media processing server can handle 100 channels at a time and cost $100,000 to implement. That's $1,000 a channel. Assuming most people use the video processing only a few times a month, you could spread that cost out across your customers at $5 per customer per month (over, say, 200 customers) to recoup those fees, assuming out of 200 customers only 100 channels are in use at any time. This is the basis for these fees - not the bandwidth or telecommunications fees.

**Codecs (G729, T38)**
1.  G729 is a pay codec that was engineered to allow low-bandwidth audio phone calls to sound like regular phone calls. The codec took a lot of money to develop and is patented. To deal with being able to offer G729, most companies buy G729 licenses which, like video calling above, cost a certain amount for each active call that will be in use on the system. If 100 people are on G729 calls then 100 licenses are needed. In this scenario, the cost of the license is fixed but to recoup the cost, most service providers spread the cost out over their client base by increasing the per-minute cost of calls or otherwise.
2.  T38 is a fax codec that uses various tricks to make fax machines more tolerant of delays in the line when a fax needs to be processed. It often requires special equipment to be handled properly, which also costs money. This cost is, again, usually spread across the per-minute costs of a service.
 
 
######**Outbound Calling (Termination)**

**Long Distance Calling**
Long distance calling in the US and in most other places still is charged per-minute. Many people have run statistics and advertise 
flat-rate costs, but there is no such thing. Abuses of flat-rate services have actually lead to many different flavors of fine print limiting the amount of minutes you can talk on a flat-rate plan. Flat-rate has become more of a term used to put consumers at ease that they don't need to worry about their usage and should behave normally, as the flat-rate charges cover normal usage. The fine print seeks to clarify what normal usage is. But the companies offering these plans are actually 
always paying per-minute rates, they are just averaging their costs across all their clients to try to make their marketing and product simpler and more competitive.


**N11+**
N11 services are short-codes (211, 311, 511, etc) available on many phone lines for government, state, local and emergency services as well as some pay-per-use services. 511 in San Francisco or New York City, for example, give access to local government services and live operators who can assist with basic questions about city parking laws, snow plowing, leaks and fire hydrant issues and so-on. These numbers are specially routed numbers that actually go to call centers or custom circuits provided by the local phone company. While these numbers often were only accessible by using the local telco for some time, the rise of VoIP services in popularity and the complexity within the phone companies own networks has usually resulted in public access numbers being published for these services. For example, the 
Bay Area 511 allows phone companies to route 511 to their public access number of 888-500-INFO, which (to the caller) will behave identically to dialing 511 on a landline. 


**911**
911 is a regulated service provided by phone companies to connect callers to their local Public Safety Answering Point (PSAP). All phone companies interconnect with various PSAPs in their area to allow access to 911. In addition, VoIP providers pay third-party companies to be able to route calls to the 911 network via SIP carriers who maintain databases of PSAP centers around the country and circuits allowing 911 calls to those PSAPs. This industry is highly regulated.
Typically, 911 costs money for each phone number it is applied to, even if the phone numbers are all in the same location. Most VoIP providers save money by provisioning only one number (the main number) with a 911 address and charge extra for provisioning additional numbers for 911 services. 


**Outbound CNAM**
CNAM is a database used for storing and retrieving the names of callers associated with a phone number (for Caller ID purposes). Outbound CNAM is usually a service provided by phone companies to update the Caller ID Name seen by others when you make an outbound call. This service is generally done for you by your local phone company, often by providing a generic CNAM (such as WIRELESS CALLER) or a specific CNAM usually based on your billing name (such as MARTHA STEWART) which is inputted into the database. The name will stay in the database until the next time the name is updated, even if the number changes owners or moves to a different carrier, because the database has nothing to do with the carrier (other then the carrier being able to submit updates).This service generally confuses people as sometimes they will inherit an old number from another company and the Caller ID Name will be wrong. In addition, most companies charge a fee for being able to access the database and input data into it, and for the labor associated with processing such a request since the system is not very robust and easily accessed/automated.


**900 Numbers**
900 numbers are an outbound calling pay service where the caller is billed for the cost of the call. As 900 service is hugely unpopular due to abuse and complexities in billing, it is not supported by most VoIP companies.


**700 and 500 Numbers**
700 and 500 numbers belong to an interexchange carrier and are locally routed by that carrier only. Thus, 700-555-4141 on ATT and 700-555-4141 on Sprint are actually two completely different numbers and can be routed to completely different services. The intent of these numbers was to allow phone companies to control and roll out services on an exchange that would be available only to their own customers and would allow for faster roll-outs to their customers. These numbers were largely unsuccessful and are rarely supported by VoIP providers.


**International Calling**
International calling is an outbound service where a phone company leases time on circuits (usually on inter-continental fiber optics, underwater cables running across oceans or seas or satellite) between countries. These costs are passed on to the customer at marked up rates by the local phone company.


**Pay-Per-Call** 
Some prefixes in large metropolitan areas were used for local pay services. For example, in NYC there is a 950 and 976 prefix which were used for toll-free and pay services respectively, but were only available to local providers in those areas. These numbers have been slowly phased out over time.


**Toll-free numbers**
Toll free numbers, like inbound circuits, still require a physical connection to the telephone network, which costs money. As toll-free numbers are still largely popular and still cost money to utilize, there is often a fee in VoIP for making calls to a toll-free number. For advertising and simplicity purposes this fee is usually absorbed by the calling party's carrier. There are also various arbitrage schemes to encourage calling toll-free numbers through service providers who get paid tariffs for delivering calls to 800 numbers. These tariffs often offset the cost of the calls.


**SMS**
SMS outbound always costs money, usually from $0.01 to $0.02 per text message, with some wholesales going as low as $0.005 for volume. These fees are charged to cover the costs of maintaining databases of phone numbers with SMS capabilities and their responsible carriers and for providing the infrastructure to transmit and receive messages reliably across the SMS network. There are also tariffs and access charges from various telcos for interoperating with SMS messages.
 
