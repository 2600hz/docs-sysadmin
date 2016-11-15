- [Configuring Kazoo](#org16d66e4)
  - [API Basics](#org9be87b6)
  - [Create a device](#org1073db1)
    - [Via API](#orgbe13569)
    - [Via MonsterUI](#org09361ef)
  - [Create a callflow for the device](#org9b23dba)
    - [Via API](#org41ec4d6)
  - [Create an outbound carrier](#orgc7aee6a)



<a id="org16d66e4"></a>

# Configuring Kazoo

This guide assumes you've installed Kazoo via one of the supported methods and are now ready to create devices, users, carriers, etc.


<a id="org9be87b6"></a>

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


<a id="org1073db1"></a>

## Create a device


<a id="orgbe13569"></a>

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


<a id="org09361ef"></a>

### Via MonsterUI

Use SmartPBX - Screenshots welcomed


<a id="org9b23dba"></a>

## Create a callflow for the device


<a id="org41ec4d6"></a>

### Via API

```bash
# create a callflow for extension 1001 to ring the device
# note: we need to escape the quotes to use $DEVICE_ID in the JSON data
curl -X PUT -H "X-Auth-Token: $AUTH_TOKEN" \
     -d "{\"data\":{\"name\":\"Device1 Callflow\", \"numbers\":[\"1001\"], \"flow\":{\"module\":\"device\",\"data\":{\"id\":\"$DEVICE_ID\"}}}}" \
     http://ip.add.re.ss:8000/v2/accounts/$ACCOUNT_ID/callflows | python -mjson.tool
```

You should now be able to create a second device and call 1001 to ring the first device


<a id="orgc7aee6a"></a>

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