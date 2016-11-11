**Register Startup**


On startup of Registrar, prime the cache by looking up the registrations currently stored in the DB Registration Attempt

Phone sends registration to SBC, which load-balances the request to the next switch in its list.

Switch sends an auth challenge back

Phone sends registration with digest data

Switch forwards request to Whistle

**Whistle** creates an `authn_req`AMQP message

Registrar receives `authn_req` AMQP message

If credentials are found, Registrar sends an `authn_resp` AMQP message

**Whistle** receives the response and sends the switch the appropriately formatted response.

Phone is notified of success or failure

Using the `Auth-User` and `Auth-Realm`, lookup the sip credentials for this combination

Check the in-memory cache for the sip credential object.

if found, return the object else, lookup in the DB for the user/realm combination and cache the response

If the user/realm isn't found, this process stop processing immediately

Create the `authn_resp` AMQP message

Send it directly to the requesting **Whistle** process

The phone is now registered (or not). Behind the scenes, there is more to be done though. **Whistle**, upon learning of a successful registration, will create a `reg_success` AMQP message for which Registrar is also listening. Upon receipt:

Cleanup the contact string

Create the cache ID from the contact string (md5'ed)


**Lookup in the cache:**

If the cache ID exists: update the cache with the latest registration JSON object.

If it doesn't exist: remove the old registrations for the username/realm from the database.

Store the registration in the cache and a mapping of username/realm to the cache ID.

Store the registration in the database.


**Querying the Registrar**

Sending a `reg_query` on AMQP is picked up by Registrar

Using the username/realm, lookup the registration cache ID.

If the cache ID exists, lookup the registration JSON object.

If the cache ID doesn't exist, the process exits.

Based on what Fields are requested in the query, a response is created from the cached registration JSON.
 
 
# edit this mockup

The Registration/Authentication whapp, responsible for receiving auth/reg events off AMQP from `ecallmgr`, querying a SIP credentials DB, 
and returning a response to AMQP on successful lookup. A registration doc will also be created/updated on success (may need to figure out how nonce/cnonce work for verifying the password).

**Registration Success Message**

**Event-Category** `directory` required

**Event-Name** `reg_success` required

**Event-Timestamp** `timestamp` required

**From-User** `username` required

**From-Host** `host.com` required

**Contact** `contact@host.com:1234;other=params` required

**RPid** unknown, maybe others required

**Status** some status optional

**Expires** time,in seconds required

**To-User** `username` required

**To-Host** 1.2.3.4 required

**Network-IP** 1.2.3.4 required

**Network-Port** 12345 required

**Username** `username` required

**Realm** 1.2.3.4 required

**User-Agent** Whistle-1.0 optional


**Querying the Registration WhApp**

Given user credentials, you can retrieve the fields listed above in the 'Registration Success' message for any registrations that have not expired.


**Event-Category** directory required

**Event-Name** `reg_query` required

**Username** string required

**Realm** string required

**Fields** `[whistle:Field]` required


Your application will receive the following message as response:

**Event-Category** directory required

**Event-Name** `reg_query_resp` required

**Fields** `[whistle:{Field, Value}]` required
