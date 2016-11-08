Configuration Document
Base Parameters
outbound_user_field
This sets the field used to find resources when attempting outbound calls. The only valid values are 
To
 and 
Request
, missing or invalid values will assume the latter.
View Sample Code
outbound_user_field
 : 
Request
inbound_user_field
This sets the field for the inbound calls when searching for the account. The only valid values are 
To
 and 
Request
, missing or invalid values will assume the latter.
View Sample Code
inbound_user_field
 : 
Request
format_from_uri
When this property is set to true all outbound calls will have the SIP from header set to 
sip:CALLER_ID@DOMAIN/REALM
. However if the outbound request does not have either the caller id or realm set then the From header will not be changed.
 
View Sample Code
format_from_uri
 : true
default_weight
If a resource does not define a weight property this value will be used.
View Sample Code
default_weight
 : 5
default_prefix
If a 
resource 
gateway does not define a prefix property this value will be used.
View Sample Code
default_prefix
 : 
+1
default_suffix
If a 
resource 
gateway does not define a suffix property this value will be used.
View Sample Code
default_suffix
 : 
default_codecs
If a resource gateway does not define a codecs property this value will be used.
View Sample Code
default_codecs
 : [
PCMU
, 
PCMA
]
default_bypass_media
If a resource gateway does not define a bypass_media property this value will be used.
View Sample Code
default_bypass_media
 : false
default_caller_id_type
If a resource gateway does not define a caller_id_type property this value will be used.
View Sample Code
default_caller_id_type
 : 
external
default_progress_timeout
If a resource gateway does not define a progress_timeout property this value will be used.
View Sample Code
default_progress_timeout
 : 8
max_shortdial_correction
If an outbound request has no resources available and is shorter than the caller id it will be prefixed by the difference as taken from the caller id. This property sets the maximum number of digits that should be considered for correcting a shortdial before giving up. For example, lets say a user dials 8867998 with a caller id of +14158867900 and no resources exist which match the number as originally dialed. The caller id differs by 5 digits, and since that is equal to or less than the max_shortdial_correction the first five digits of the caller id will be added to the dialed number making it +14158867998 before trying again. However had the original number been something like 7998 the difference with the caller id would have exceeded the max_shortdial_correction and no second attempt would be made.
View Sample Code
max_shortdial_correction
 : 5
bridge_timeout
This is the maximum time to wait, in milliseconds, for a outbound request to be answered before considering it unanswered.
View Sample Code
bridge_timeout
 : 30000
View Sample Code
{
   
_id
:
stepswitch
,
   
default
:{
      
outbound_user_field
:
Request
,
      
inbound_user_field
:
Request
,
      
format_from_uri
:false,
      
default_weight
:3,
      
default_prefix
:
,
      
default_suffix
:
,
      
default_codecs
:[

      ],
      
default_bypass_media
:false,
      
default_caller_id_type
:
external
,
      
default_progress_timeout
:8,
      
max_shortdial_correction
:5,
      
bridge_timeout
:30000
   }
}
Sub-Parameters
 
