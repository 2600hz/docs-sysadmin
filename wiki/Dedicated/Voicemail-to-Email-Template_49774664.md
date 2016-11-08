Voicemail to Email Template
Here are the fields available when designing your custom (or the default) voicemail-to-email templates:
account
all fields in an account doc
service
url - the service's url
name - the service's name
provider - the service's provider
support_number
support_email
send_from
host
voicemail
caller_id_number
caller_id_name
date_called_utc
date_called - local time of the user/voicemail box/account
from_user
from_realm
to_user
to_realm
box - voicemail box id
media - voicemail message id
length - length of the message, in seconds
transcription - text version of the recording, if available
call_id
magic_hash - create your own URL for users to access the message
if the hash is 
xyzpdq
, your template could have 
http://foo.bar.com/xyzpdq
 as the 
download
 link
as long as foo.bar.com directs you to Crossbar, it should work.
 
 
Tip: Dive in the system_config database, choose which notification doc u want to change and copy the html from that template to an html editor.
