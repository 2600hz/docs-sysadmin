# Kazoo Enable CNAM

It is possible to utilize **Kazoo** to enable **CNAM** lookups on inbound calls. This allows you to overlay Caller ID in the US with **CNAM** dips from a third-party service.

## Supported CNAM Providers

* Carriers
   * Vitelity
   * Telnyx
* Providers
   * OpenCNAM
   * Others possible

If you provision a number using one of the carriers above, you can enable CNAM features using the [phone numbers](https://docs.2600hz.com/dev/applications/crossbar/doc/phone_numbers/) API.

## Setup OpenCNAM (or other providers)

Kazoo provides a generic HTTP configuration for making CNAM dips. OpenCNAM is known to work and other providers may too, provided they return the Caller ID Name as the HTTP response body in plain text. This is handy when you provision numbers outside of Kazoo and import them.

To setup the Inbound CNAM dip, use the [system config](https://docs.2600hz.com/dev/applications/crossbar/doc/system_configs/) API to create/edit the [`stepswitch.cnam`](https://github.com/2600hz/kazoo/blob/master/applications/crossbar/priv/couchdb/schemas/system_config.stepswitch.cnam.json):

```bash
curl -v -X POST \
    -H "X-Auth-Token: {AUTH_TOKEN}" \
    'http://{SERVER}:8000/v2/system_configs/stepswitch.cnam' \
    -d '{"data":{"default":{...}}}'
```

Check the [JSON schema]((https://github.com/2600hz/kazoo/blob/master/applications/crossbar/priv/couchdb/schemas/system_config.stepswitch.cnam.json)) for the necessary fields to set in the `{...}` portion.
