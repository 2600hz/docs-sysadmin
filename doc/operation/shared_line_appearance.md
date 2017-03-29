# Shared Line Appearance (SLA)

Legacy PBXes often had a feature called **Shared Line Appearance** for incoming calls. The functionality basically allowed multiple phones to have a line key tied to an extension or DID and offered several features:

- Incoming calls would ring all configured phones simultaneously
- When a phone answered the call, the status light would turn green; on the other phones, the status light would turn red
- If the caller is placed on hold, all phones' (answering or not) status lights will blink red
- Any phone with SLA can pickup the on-hold call
- When the call completes, all status lights turn off.

## Simulating SLA

Simulating most of SLA on a Kazoo system is possible. Let's take a look at how this might be achieved.

### Incoming calls ring all devices

This is pretty straight-forward. In Kazoo, one of the callflow actions is a [ring group](https://docs.2600hz.com/dev/applications/callflow/doc/ring_group/). Put any endpoints ([`devices`](https://docs.2600hz.com/dev/applications/crossbar/doc/devices/), [`users`](https://docs.2600hz.com/dev/applications/crossbar/doc/users/), or [`groups`](https://docs.2600hz.com/dev/applications/crossbar/doc/groups/)) into the ring group and all calls to the callflow will ring the endpoints according to the strategy provided.

### Status lights

Kazoo allow updating a pre-defined `presence_id` to with BLF updates. You can set this `presence_id` on the `device` or `user` documents, or you can use the `manual_presence` callflow action to toggle this. Configure the phones' BLF light to subscribe for this `presence_id` value to have it update during calls.

#### Placing on hold for others

The closest way to put a call on hold so others could pick it up is using [`call parking`](https://docs.2600hz.com/dev/applications/callflow/doc/park/). Rather than using the hold button on the phone, the answering device can transfer the caller to a parking slot. Once parked, any device that knows the slot number can pick up the call.

## Example SLA simulation

Consider the typical executive with an administrative assistant. The assistant's phone has a line key that will ring when the executive is called. The easiest way to do this is create two devices in Kazoo and assign them to the executive's Kazoo user.

### Create the assistant

1. Create the assitant's device
   ```shell
   curl -X PUT \
       -H "X-Auth-Token: $AUTH_TOKEN" \
       -d '{"data":{"name":"Assistant Device", "sip":{"username":"assistant", "password":"to_the_stars"}}}' \
       http://{SERVER}:8000/v2/accounts/$ACCOUNT_ID/devices
   ```
   ```json
   {
       "data":{
           "id":"{ASSISTANT_DEVICE_ID}"
           ,...
       }
       ,...
   }
   ```

### Create the executive

1. [Create a user](https://docs.2600hz.com/dev/applications/crossbar/doc/users/) for the executive. Be sure to include `presence_id="EXT"` in the user object - this is what BLF lights will be tied to when setting up presence.
   ```shell
   curl -X PUT \
       -H "X-Auth-Token: {AUTH_TOKEN}" \
       -d '{"data":{"first_name":"Exec", "last_name":"Utive", "presence_id":"1000"}}'
   http://{SERVER}:8000/v2/accounts/{ACCOUNT_ID}/users
   ```
   ```json
   {
       "data":{
           "id":"{EXECUTIVE_USER_ID}"
           ,...
       }
       ,...
   }
   ```
2. [Create a device](https://docs.2600hz.com/dev/applications/crossbar/doc/devices/) for the executive.
   ```shell
   curl -X PUT \
       -H "X-Auth-Token: $AUTH_TOKEN" \
       -d '{"data":{"name":"Executive Device", "owner_id":"{EXECUTIVE_USER_ID}", "sip":{"username":"executive", "password":"high_roller"}}}' \
       http://{SERVER}:8000/v2/accounts/$ACCOUNT_ID/devices
   ```
   ```json
   {
       "data":{
           "id":"{EXECUTIVE_DEVICE_ID}"
           ,...
       }
       ,...
   }
   ```
3. [Create the callflow](https://docs.2600hz.com/dev/applications/crossbar/doc/callflows/) using the [ring group](https://docs.2600hz.com/dev/applications/callflow/doc/ring_group/) action to ring both the executive's and assistant's phones. This will also cause a BLF update to `presence_id`@`account.realm` to update the assistant's BLF key.
   ```shell
   curl -X PUT \
       -H "X-Auth-Token: $AUTH_TOKEN" \
       -d '{"data":{"numbers":["1000"], "flow":{"module":"ring_group","data":{"endpoints":[{"id":"{EXECUTIVE_USER_ID}", "endpoint_type":"user"}, {"id":"{ASSISTANT_DEVICE_ID}", "endpoint_type":"device"}]}}}}' \
        http://{SERVER}:8000/v2/accounts/$ACCOUNT_ID/callflows
   ```
   ```json
   {
       "data":{
           "id":"{EXECUTIVE_CALLFLOW_ID}"
           ,...
       }
   }
   ```

Now calls to extension 1000 should ring both the executive and the assistant devices.

### Create the call park/pickup callflow

Create a callflow, `*4{presence_id}`, that will have the [`park`](https://docs.2600hz.com/dev/applications/callflow/doc/park/) callflow action. This will be used by the BLF key to simulate the hold/pickup of SLA. You should set the `action` to `auto` and the `slot` to `presence_id`.
    ```shell
   curl -X PUT \
       -H "X-Auth-Token: $AUTH_TOKEN" \
       -d '{"data":{"patterns":["*4(\\d+)"], "flow":{"module":"park","data":{"action":"auto"}}}}' \
        http://{SERVER}:8000/v2/accounts/$ACCOUNT_ID/callflows
   ```
   ```json
   {
       "data":{
           "id":"{PARK_CALLFLOW_ID}"
           ,...
       }
   }
   ```

`auto` will retrieve a call if one is parked or park the call if the slot is empty.

### Create the BLF key

Create a BLF key configuration on the assistant's phone to:

a. The "value" (or equivalent) will be `presence_id`
b. The "extension" (or equivalent) will be `*4{presence_id}`

This will light up with the corresponding call.

When the assistant puts the call on hold, the BLF can be used to pickup the call.
