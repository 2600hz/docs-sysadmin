#

Numbers Document


The numbers document is only used by the APIs to list numbers and has no impact on routing.  It exists to reduce the overhead of the phone_number API so every number database does not need to be scanned to determine which numbers are active on an account.
The number document is the only document used for routing, however if you are making changes to this document you should ensure they reflect the number document or the user may be confused by conflicting information in the UI.
Database
Numbers document are stored in account databases with the id "phone_numbers".
Base Parameters
NUMBER_PROPERTIES
For each number associated with an account there will be a number property.  
See below for sub-parameters

pvt_type
This is the type of document and will always have the value of "phone_numbers"
 "pvt_type" : "phone_numbers"

pvt_vsn
This is the version of the document and indicates which format you will find the data in. Currently these documents are at the first version.
 "pvt_vsn" : "1"

pvt_created
This is the timestamp that the number was created on, in gregorian seconds.
 "pvt_created" : 63494331491

pvt_modified
This is the timestamp that the number was lasted modified on, in gregorian seconds.
 "pvt_modified" : 63494331491

pvt_account_db
This is the url encoded database of the account.
 "pvt_account_db" : "account%2F43%2F57%2F9fc0a3aa11e29e960800200c9a66"

pvt_account_id
This is the id of the account.
 "pvt_account_db" : "43579fc0a3aa11e29e960800200c9a66"


{
   "_id": "phone_numbers",
   "pvt_account_db": "account%2F43%2F57%2F9fc0a3aa11e29e960800200c9a66",
   "pvt_account_id": "43579fc0a3aa11e29e960800200c9a66",
   "pvt_vsn": "1",
   "pvt_type": "phone_numbers",
   "pvt_modified": 63529420348,
   "pvt_created": 63520338360,
   "+14158867900": {
       "state": "in_service",
       "features": [
           "dash_e911",
           "outbound_cnam",
           "inbound_cnam"
       ],
       "on_subaccount": false,
       "assigned_to": "43579fc0a3aa11e29e960800200c9a66"
   },
   "+14158867998": {
       "state": "in_service",
       "features": [
       ],
       "on_subaccount": false,
       "assigned_to": "43579fc0a3aa11e29e960800200c9a66"
   }
}
Sub-Parameters

NUMBER
state
This is the current number state in accordance with the Number Lifecycle.
features
This property is used to display what features (as supported by provider modules) are active on the number. Changing this directly will have no effect on the actual feature.
on_subaccount
This property is used to determine if a number is used by a sub account. For example, if a parent reserves a number then assigns it to a sub account this value will be true.
assigned_to
This property is used to determine which sub account a number might be assigned to. For example, if a parent reserves a number then assigns it to a sub account this value will be the account id of the sub account.
 
 
 
 
 "+14158867900": {
       "state": "in_service",
       "features": [
           "dash_e911",
           "outbound_cnam",
           "inbound_cnam"
       ],
       "on_subaccount": false,
       "assigned_to": "43579fc0a3aa11e29e960800200c9a66"
   }
   
    
