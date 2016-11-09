It is possible to utilize Kazoo to enable CNAM lookups on inbound calls. This allows you to overlay Caller ID in the US with CNAM dips from a third-party service. Both bandwidth.com's Dash services and OpenCNAM have been tested with this service, but any CNAM lookup that returns an unformatted text response will work.
To enable CNAM lookups, first, enable CNAM for the entire system by creating a document in system_config/stepswitch.cnam, as follows:
{
   
_id
: 
stepswitch.cnam
,
   
default
: {
       
http_url
: 
https://cnam.dashcs.com/?companyId=XXXXX
password=XXXXX
number={{phone_number}}
,
       
http_body
: 
,
       
http_method
: 
get
,
       
http_accept_header
: 
text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
,
       
http_user_agent_header
: 
Kazoo Stepswitch CNAM
,
       
http_content_type_header
: 
application/json
,
       
http_basic_auth_username
: 
,
       
http_basic_auth_password
: 
,
       
cnam_expires
: 900
   }
}
 
Then, on each individual phone number you wish to overlay CNAM lookups, enable the cnam feature.  See 
number document
.
 
