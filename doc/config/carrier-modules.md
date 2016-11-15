## Configuration Document



## Base Parameters


`carrier_modules`: This is a list of modules that the number manager uses to interact with carriers. There are two special modules:

`wnm_local`: numbers that utilize this module are assumed to be managed manually by account admins and are treated as untrusted numbers

`wnm_other`: numbers that utilize this module are assumed to be managed by the **Kazoo** cluster admins and are treated as trusted numbers

Other modules exist some of which currently search, provision and maintain numbers via certain carriers APIs. This list is growing.

`carrier_modules : ["wnm_other", "wnm_local"]`

"providers": This is a list of modules that provide supplemental services to numbers. These service range from sending port request emails to provisioning US E911 in realtime. Providers can be applied to any trusted number (in other words numbers managed by the **Kazoo** cluster admins). Enabled providers look for specific properties on numbers and take action when they are added, removed, or changed. For example, the port_notifier module will send a email to the **Kazoo** cluster admins if a number is added with a port property, notifying them a port needs to take place.

`providers : ["port_notifier", "cnam_notifier"]`

`reconcile_regex`: This regular expression is used to identify numbers that are globally routable, for example a US number like +14158867900. If a number does not match this expression then it will only be dial-able within an account. For example, extension 100 could exist in multiple accounts and should not be matched by the `reconcile_regex`. However, a US number such as the one above, will come from a carrier and must match to work. It is important that this number be able to match any format inbound calls (from your carriers) are likely to send; otherwise **Kazoo** will not attempt to route them.

`reconcile_regex: ^\\+?1?\\d{10}$`

`e164_converters`: This a set of normalization regular expresions used on every number that **Kazoo** processes. The job of these expressions is to format numbers the same way irregardless of where they originated. For example, most US carriers send numbers in E164 format (+14158867900) yet users do not dial +1. One use case is to ensure any US number begins with +1. 

`classifiers`: This is a set of regexes to group numbers by type and are not used for routing. Classifiers are used to create groups of numbers that can be restricted, pretty print numbers in emails (like voicemail to email) and provide user friendly names in the UI. 

`released_state`: When an account deletes a trusted number it will follow the number lifecycle. By default these numbers go through an aging period and after a certain amount of time become available for purchase once again. However, some operators would like to disconnect these numbers while others prefer they become immediately available to their clients. This is accomplished by setting this property to the desired state a trusted number should be moved to if an account deletes it.

`released_state : "available"`

`porting_module_name`: If a number is added to the system in the `port_in` state this carrier module will be invoked to provision the number automatically. Any carrier module is valid for this property but only certain modules will preform realtime provisiong. If a carrier module is specified that does not have this capability the **Kazoo** cluster admins should enable the `port_notifier` provider so they will receive an email (and can manually port the number).
```
 porting_module_name" : "wnm_bandwidth"

{
   "_id":"number_manager",
   "default":{
      "carrier_modules":[
         "wnm_local",
         "wnm_other"
      ],
      "reconcile_regex":"^\\+?1?\\d{10}$|^\\+[2-9]\\d{7,}$|^011\\d*$|^00\\d*$",
      "providers":[
         "port_notifier",
         "cnam_notifier"
      ],
      "porting_module_name":"wnm_bandwidth",
      "released_state":"available",
      "e164_converters":{
         "^\\+?1?([2-9][0-9]{2}[2-9][0-9]{6})$":{
            "prefix":"+1"
         },
         "^011(\\d*)$|^00(\\d*)$":{
            "prefix":"+"
         }
      },
      "classifiers":{
         "tollfree_us":{
            "regex":"^\\+1(800|888|877|866|855)\\d{7}$",
            "friendly_name":"US TollFree"
         },
         "toll_us":{
            "regex":"^\\+1900\\d{7}$",
            "friendly_name":"US Toll"
         },
         "emergency":{
            "regex":"^911$",
            "friendly_name":"Emergency Dispatcher"
         },
         "caribbean":{
            "regex":"^\\+?1(684|264|268|242|246|441|284|345|767|809|829|849|473|671|876|664|670|787|939|869|758|784|721|868|649|340)\\d{7}$",
            "friendly_name":"Caribbean"
         },
         "did_us":{
            "regex":"^\\+?1?[2-9][0-9]{2}[2-9][0-9]{6}$",
            "friendly_name":"US DID",
            "pretty_print":"SS(###) ### - ####"
         },
         "international":{
            "regex":"^011\\d*$|^00\\d*$",
            "friendly_name":"International",
            "pretty_print":"SSS011*"
         },
         "unknown":{
            "regex":"^.*$",
            "friendly_name":"Unknown"
         }
      }
   }
}
```

## Sub-Parameters


E164 converters are designed to allow users and carriers to send or enter numbers in different format into **Kazoo**. **Kazoo** will convert the numbers, using regular expressions you specify, into a standardized format used within your system. While we strongly recommend converting numbers into proper E.164 format, it is not required that these properties adhear to E164. The only requirement is that your conversion takes the acceptable numbers users or carriers will use and converts them to the same universal format used throughout your system. When multiple converters are present they are tried from the top of the list down. The first regular expression to match is used to convert the number.

`REGULAR_EXPRESSION`

prefix: Any value of this property will be added to the front of the regular expression capture group. If there is no capture then it will be added to the font of the entire number.

suffix: Any value of this property will be added to the end of the regular expression capture group. If there is no capture then it will be added to the end of the entire number. 
```
   "e164_converters":{
      "^\\+?1?([2-9][0-9]{2}[2-9][0-9]{6})$":{
         "prefix":"+1"
      },
      "^011(\\d*)$|^00(\\d*)$":{
         "prefix":"+"
      },
      "^[2-9]\\d{7,}$":{
         "prefix":"+"
      }
   }
 ```
 
Notice how the first regular expression matches any variant of a US number (+14158867900, 14158867900, 4158867900). Only the portion of the number inside the parentheses is used, removing the any + or 1 if present at the start of the number. By then adding +1 via the prefix to the front of the number it ensures all US numbers will be in the same format irregardless of how they were dialed.

Change these carefully if you have an active system, when numbers are added to the datastore they are first normalized. If you change the these settings such that a number that used to be normalized in one way now results in a different format it will fail to route until it is resaved (causing it to be duplicated in the datastore in the new format).

Classifiers are attempted from the top of the list to the bottom. Like `e164_converters` the first regular expression to match is used as the number classification. Unlike `e164_converters` these do not impact routing and can be safely changed at any time. The primary use of classifiers is to restrict users from being able to dial certain "classifications" of numbers. For example, if you add a classifier called `my_classifier` the UI will present admins with the option to restrict users or devices from being able to dial numbers which match that classifiers regular expression (`regex`).

`UNIQUE_NAME`

`regex`: If a number matches this regular expression then it is considered to be classified as the properties name (UNIQUE_NAME). Capture groups can be used to make your expression cleaner but will have no impact on the number.

`friendly_name`: This is the name presented to users of the Kazoo UI when viewed in the number manager or on the permission tab. If a friendly name is not provided the `UNIQUE_NAME` of the classifier is used.

`pretty_print`: This is a way to change the format of numbers matching the classifier in emails sent by **Kazoo**, such as voicemail notifications. Prior to pretty printing a number it will be normalized via the e164_converters to ensure it is in a known format.
The following characters can be used in a pretty print string to manipulate the number:

"#" - Pound signs will be replaced by the number at the same position

S - A capital 'S' will skip a number at the same position

"*" - An asterisk will add any remaining numbers from that position to the end of the number

If you wish to add pound sign, the capital letter S, or an asterisk to the pretty print of the number precede it with a backslash (for example "\#")


## SS(###) ### - *

This sample will convert numbers in the format of +14158867900 to (415) 886 - 7900. Remember all numbers will be normalized prior to pretty print so, in our example, we are assured they will begin with +1 followed by 10 digits.
```
   "classifiers":{
      "tollfree_us":{
         "regex":"^\\+1(800|888|877|866|855)\\d{7}$",
         "friendly_name":"US TollFree"
      },
      "toll_us":{
         "regex":"^\\+1900\\d{7}$",
         "friendly_name":"US Toll"
      },
      "emergency":{
         "regex":"^911$",
         "friendly_name":"Emergency Dispatcher"
      },
      "caribbean":{
         "regex":"^\\+?1(684|264|268|242|246|441|284|345|767|809|829|849|473|671|876|664|670|787|939|869|758|784|721|868|649|340)\\d{7}$",
         "friendly_name":"Caribbean"
      },
      "did_us":{
         "regex":"^\\+?1?[2-9][0-9]{2}[2-9][0-9]{6}$",
         "friendly_name":"US DID",
         "pretty_print":"SS(###) ### - ####"
      },
      "international":{
         "regex":"^011\\d*$|^00\\d*$",
         "friendly_name":"International",
         "pretty_print":"SSS011*"
      },
      "unknown":{
         "regex":"^.*$",
         "friendly_name":"Unknown"
      }
   }
```



