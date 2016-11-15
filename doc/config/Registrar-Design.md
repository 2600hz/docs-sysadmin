## Register Startup


1. On startup of Registrar, prime the cache by looking up the registrations currently stored in the DB Registration Attempt.
2. Phone sends registration to SBC, which load-balances the request to the next switch in its list.
3. Switch sends an auth challenge back
4. Phone sends registration with digest data
5. Switch forwards request to Whistle
6. **Whistle** creates an `authn_req`AMQP message
7. Registrar receives `authn_req` AMQP message
8. If credentials are found, Registrar sends an `authn_resp` AMQP message
9. **Whistle** receives the response and sends the switch the appropriately formatted response.
10. Phone is notified of success or failure
11. Using the `Auth-User` and `Auth-Realm`, lookup the sip credentials for this combination
12. Check the in-memory cache for the sip credential object.
13. If found, return the object else, lookup in the DB for the user/realm combination and cache the response
14. If the user/realm isn't found, this process stop processing immediately
15. Create the `authn_resp` AMQP message
16. Send it directly to the requesting **Whistle** process
17. The phone is now registered (or not). Behind the scenes, there is more to be done though. **Whistle**, upon learning of a successful registration, will create a `reg_success` AMQP message for which Registrar is also listening. Upon receipt:
18. Cleanup the contact string
19. Create the cache ID from the contact string (md5'ed)

## Lookup in the cache:

1. If the cache ID exists: update the cache with the latest registration JSON object.
2. If it doesn't exist: remove the old registrations for the username/realm from the database.
3. Store the registration in the cache and a mapping of username/realm to the cache ID.
4. Store the registration in the database.


## Querying the Registrar

1. Sending a `reg_query` on AMQP is picked up by Registrar
2. Using the username/realm, lookup the registration cache ID.
3. If the cache ID exists, lookup the registration JSON object.
4. If the cache ID doesn't exist, the process exits.
5. Based on what Fields are requested in the query, a response is created from the cached registration JSON.
 
 
## MISC

The Registration/Authentication **WhApp**, responsible for receiving auth/reg events off AMQP from `ecallmgr`, querying a SIP credentials DB, and returning a response to AMQP on successful lookup. A registration doc will also be created/updated on success (may need to figure out how nonce/cnonce work for verifying the password).

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


## Querying the Registration WhApp

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
