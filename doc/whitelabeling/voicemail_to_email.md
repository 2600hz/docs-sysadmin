## Voicemail to Email



You can fetch the macros available for customization:

```shell
curl -H "X-Auth-Token: $AUTH_TOKEN" http://crossbar:8000/v2/accounts/{ACCOUNT_ID}/notifications/voicemail_to_email | python -mjson.tool
```

```json
"data": {...
        "macros": {
            "call_id": {
                "description": "Call ID of the caller",
                "friendly_name": "Call ID",
                "i18n_label": "call_id"
            },
            "callee_id.name": {
                "description": "Name of the callee",
                "friendly_name": "Callee ID Name",
                "i18n_label": "callee_id_name"
            },
            "callee_id.number": {
                "description": "Number of the callee",
                "friendly_name": "Callee ID Number",
                "i18n_label": "callee_id_number"
            },
            "caller_id.name": {
                "description": "Name of the caller",
                "friendly_name": "Caller ID Name",
                "i18n_label": "caller_id_name"
            },
            "caller_id.number": {
                "description": "Number of the caller",
                "friendly_name": "Caller ID Number",
                "i18n_label": "caller_id_number"
            },
            "date_called.local": {
                "description": "When was the voicemail left (Local time)",
                "friendly_name": "Date",
                "i18n_label": "date_called_local"
            },
            "date_called.utc": {
                "description": "When was the voicemail left (UTC)",
                "friendly_name": "Date (UTC)",
                "i18n_label": "date_called_utc"
            },
            "from.realm": {
                "description": "SIP From Realm",
                "friendly_name": "From Realm",
                "i18n_label": "from_realm"
            },
            "from.user": {
                "description": "SIP From Username",
                "friendly_name": "From User",
                "i18n_label": "from_user"
            },
            "owner.first_name": {
                "description": "First name of the owner of the voicemail box",
                "friendly_name": "First Name",
                "i18n_label": "first_name"
            },
            "owner.last_name": {
                "description": "Last name of the owner of the voicemail box",
                "friendly_name": "Last Name",
                "i18n_label": "last_name"
            },
            "to.realm": {
                "description": "SIP To Realm",
                "friendly_name": "To Realm",
                "i18n_label": "to_realm"
            },
            "to.user": {
                "description": "SIP To Username",
                "friendly_name": "To User",
                "i18n_label": "to_user"
            },
            "voicemail.box": {
                "description": "Which voicemail box was the message left in",
                "friendly_name": "Voicemail Box",
                "i18n_label": "voicemail_box"
            },
            "voicemail.length": {
                "description": "Length of the voicemail file",
                "friendly_name": "Voicemail Length",
                "i18n_label": "voicemail_length"
            },
            "voicemail.name": {
                "description": "Name of the voicemail file",
                "friendly_name": "Voicemail Name",
                "i18n_label": "voicemail_name"
            }
        }
        ,...
    }
```

You can read more [here](https://github.com/2600hz/kazoo/blob/master/applications/crossbar/doc/notifications.md).
