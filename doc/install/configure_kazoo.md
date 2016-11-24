- [Configuring Kazoo](#org728b8e7)
  - [API Basics](#orge01008e)
  - [Create a device](#org34cfaaa)
    - [Via API](#orgf05a11c)
    - [Via MonsterUI](#org685c0b6)
  - [Create a callflow for the device](#orgcd0f6f9)
    - [Via API](#orgee602db)
  - [Create an outbound carrier](#org93a7a98)
  - [Route numbers to your setup](#org6d191a6)
  - [Create a PBX](#org5c74911)



<a id="org728b8e7"></a>

# Configuring Kazoo

This guide assumes you've installed Kazoo via one of the supported methods and are now ready to create devices, users, carriers, etc.


<a id="orge01008e"></a>

## API Basics

Kazoo requires an auth-token for most API usage. You can create a token via a number of ways but we'll just use the username/password we created in the installation guide.

```bash
# User/Pass credentials hash
echo -n "{USERNAME}:{PASSWORD}" | md5sum
{MD5_HASH}  -

# Copy the {MD5_HASH} and create an Auth Token
curl -v -X PUT -H "content-type:application/json" \
     -d '{"data":{"credentials":"{MD5_HASH}","account_name":"{ACCOUNT_NAME}"}}' \
     http://ip.add.re.ss:8000/v2/user_auth | python -mjson.tool

# Export the "auth_token" and "account_id" for easy use in later API requests
export AUTH_TOKEN="{AUTH_TOKEN}"
export ACCOUNT_ID="{ACCOUNT_ID}"
```

Now your shell will have an auth token and account id to use (please export the real values and not the {&#x2026;} placeholders.


<a id="org34cfaaa"></a>

## Create a device


<a id="orgf05a11c"></a>

### Via API

```bash
# Create a base device
curl -X PUT -H "X-Auth-Token: $AUTH_TOKEN" \
     -d '{"data":{"name":"Device1"}}' \
     http://ip.add.re.ss:8000/v2/accounts/$ACCOUNT_ID/devices | python -mjson.tool

# capture the "id" of the device
export DEVICE_ID="{DEVICE_ID}"

# Add a terrible username and password
curl -X PATCH -H "X-Auth-Token: $AUTH_TOKEN" \
     -d '{"data":{"sip":{"username":"device_1","password":"password_1"}}}' \
     http://ip.add.re.ss:8000/v2/accounts/$ACCOUNT_ID/devices/$DEVICE_ID | python -mjson.tool
```

Using the realm of the account, you should now be able to register a phone using the credentials created.


<a id="org685c0b6"></a>

### Via MonsterUI

Use SmartPBX - Screenshots welcomed


<a id="orgcd0f6f9"></a>

## Create a callflow for the device


<a id="orgee602db"></a>

### Via API

```bash
# create a callflow for extension 1001 to ring the device
# note: we need to escape the quotes to use $DEVICE_ID in the JSON data
curl -X PUT -H "X-Auth-Token: $AUTH_TOKEN" \
     -d "{\"data\":{\"name\":\"Device1 Callflow\", \"numbers\":[\"1001\"], \"flow\":{\"module\":\"device\",\"data\":{\"id\":\"$DEVICE_ID\"}}}}" \
     http://ip.add.re.ss:8000/v2/accounts/$ACCOUNT_ID/callflows | python -mjson.tool
```

You should now be able to create a second device and call 1001 to ring the first device


<a id="org93a7a98"></a>

## Create an outbound carrier

This assumes you have an upstream carrier that uses username/password to authenticate your calls.

```bash
# Create a "resource" representing the carrier
# "rules" is a list of regexes to match numbers for this carrier
# "gateways" is a list of JSON objects representing the gateway(s) to use
curl -X PUT -H "X-Auth-Token: $AUTH_TOKEN" \
     -d '{"data":{"rules":[".{5,}"],"name":"Carrier Foo","gateways":[{"realm":"sip.carrier.com","server":"sip.carrier.com","username":"your_username","password":"your_password","enabled":true}]}}' \
     http://ip.add.re.ss:8000/v2/accounts/$ACCOUNT_ID/resources | python -mjson.tool

# capture the id of the resource
export RESOURCE_ID="{RESOURCE_ID}"

# Now create a callflow to use this account resource
# This uses the "no_match" special number
curl -X PUT -H "X-Auth-Token: $AUTH_TOKEN" \
     -d '{"data":{"name":"Offnet Callflow","numbers":["no_match"],"flow":{"module":"resources","data":{"use_local_resources":true}}}}' \
     http://ip.add.re.ss:8000/v2/accounts/$ACCOUNT_ID/callflows | python -mjson.tool
```

If you use the regex above, any number 5 digits or more will route to your carrier.


<a id="org6d191a6"></a>

## Route numbers to your setup

Getting numbers to route in Kazoo requires a few steps. This guide will use the defaults in the system (read: mostly US-based numbers) to make this fast. Alternative documentation should be created for handling other areas of the world.

1.  Add the carrier to the ACLs

    ```bash
    sup ecallmgr_maintenance allow_carrier CarrierFoo 1.2.3.4/32
    ```

    You can set the IP as a raw IPv4 IP address or in [CIDR notation](https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing#CIDR_notation).
2.  Add a number that you expect your carrier to route to you

    ```bash
    curl -X PUT -H "X-Auth-Token: $AUTH_TOKEN" \
         -d '{"data":{}}' \
         "http://ip.add.re.ss:8000/v2/accounts/$ACCOUNT_ID/phone_numbers/+15551234567" | python -mjson.tool

    # Activate the number
    curl -v -X PUT -H "X-Auth-Token: $AUTH_TOKEN" \
         -d '{"data":{}}' \
         "http://ip.add.re.ss:8000/v2/accounts/$ACCOUNT_ID/phone_numbers/+15551234567/activate" | python -mjson.tool
    ```
3.  Create a callflow for that DID. You could also amend the callflow created for the first device, adding the number to its "numbers" array.

    ```bash
    curl -X PUT -H "X-Auth-Token: $AUTH_TOKEN" \
         -d "{\"data\":{\"name\":\"Main Callflow\",\"numbers\":[\"+15551234567\"],\"flow\":{\"module\":\"device\",\"data\":{\"id\":\"$DEVICE_ID\"}}}}" \
         http://ip.add.re.ss:8000/v2/accounts/$ACCOUNT_ID/callflows | python -mjson.tool
    ```


<a id="org5c74911"></a>

## Create a PBX

If you have existing PBXes and want to provide them with SIP trunks, create a "connectivity" doc. Be sure any DIDs you add here have been added in the above method (or similar).

```bash
curl -X PUT -H "X-Auth-Token: $AUTH_TOKEN" \
     -d '{"data":{"account":{"auth_realm":"{ACCOUNT_SIP_REALM}"},"servers":[{"DIDs":{"+12125554321":{}},"options":{"inbound_format":"e164"},"auth":{"auth_method":"password","auth_user":"{USERNAME}","auth_password":"{PASSWORD}"}}]}}'
http://ip.add.re.ss:8000/v2/accounts/$ACCOUNT_ID/connectivity
```