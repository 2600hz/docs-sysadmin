#
Number Document 
Created by Karl Anderson, last modified on Apr 12, 2013 Go to start of metadata
Number Document
The number document is the only document used to route inbound calls that originate from a source not associated with an account such as a carrier.  Any number that matches the reconcile_regex, in the configuration, will generate a number document in the associated database when saved.  If the database is not present it will be created the when required.  
The UI uses a numbers document that is stored in the account database to display the numbers which is kept in synchronization with changes by the number manager.  If you make manual changes you will need to also update this document.
Database
Number documents are stored in a database based on the prefix of the number after E.164 converters have been applied.  All number databases start with "numbers/" followed by the first five digits of the number.  For example, 4158867900 would be stored in a database called "numbers/+1415" (url encoded as "numbers%2F%2B415").
Base Parameters
PROVIDER_PROPERTIES
These are provider specific properties that are added to enable some feature (via a provider module).  See below for sub-parameters
pvt_module_name
This property sets carrier module that is responsible for the number. For example if this is set to "wnm_some_carrier" then the API module for "Some Carrier" would be used to provision the number or disconnect it.
 View Sample Code
pvt_module_data
This property is opaque metadata needed by the carrier module to maintain the number. This property should never be manipulated or used by anything other than the carrier module.
pvt_number_state
This property tracks the state in accordance with the Number Lifecycle.
 View Sample Code
pvt_authorizing_account
This property is the account id that was used to create the number, it is set only during creation and never changes.
 View Sample Code
pvt_assigned_to
This is the most important property of a number. It is the account id that the number should route to and will only be set on a number that is in_service or reserved.
 View Sample Code
pvt_previously_assigned_to
When an account deletes a number maintained by a carrier module other than wnm_local it will transition to the released_state (as set in the configuration). When this happens the pvt_assigned_to will be cleared and this property will be populated with the account id that it was assigned to.
 View Sample Code
pvt_features
This property is used to track what features (as supported by provider modules) are active on the number. When a provider is triggered by adding the appropriate properties it will automatically add or remove the associated feature to this list. The primary use of this is for the billing/services module. This parameter is maintained by the number manager and should not be changed directly.
 View Sample Code
pvt_reserve_history
When an account reserves a number it is added to this ordered list of account ids. As accounts delete the number this list will be used to reserve the number in the next account that previously reserved it. For example, a parent account might reserve a number for use on a sub-account, which adds itself to the reserve history. The subaccount may then acquire the number and use it for a period of time, eventually deleting it. When this happens the number will revert to being reserved on the parent account, instead of moving to a released state. It is only when a number is removed from an account with no reserve history that it actually moves to the released state.
 View Sample Code
pvt_ported_in
This property is used to track numbers that where created as a port in request.
 View Sample Code
pvt_created
This is the timestamp that the number was created on, in gregorian seconds.
 View Sample Code
pvt_modified
This is the timestamp that the number was lasted modified on, in gregorian seconds.
 View Sample Code
pvt_db_name
This is the url encoded database name that the number document is stored in.
 View Sample Code
 View Sample Code
Sub-Parameters
 cnam
 port
 dash_e911
