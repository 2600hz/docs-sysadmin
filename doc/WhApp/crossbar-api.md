
#
API Design

Created by Darren Schreiber on Feb 05, 2013 Go to start of metadata
Everyone thinks the APIs are so mysterious so here's a little secret. The APIs are actually a very simple pass-thru mechanism with some logic in the middle.
 
Request From Browser --> HTTP Server --> Authentication Check --> Data Validation --> (Some Routing Magic) --> Save to Database (without changing the format of the original request)
In other words, in almost every API request:
1) We read a document from CouchDB, in JSON format
2) We strip any fields with pvt_ and _ at the beginning of the field names out
3) We send it to you via the API
So what's in the DB is what you get back via API calls. And what you send to the API works in reverse but the same - if you send it, we store it.
That means if you want to introduce new features, custom fields, etc. well, you can! Just add them to your API requests and change the validation to allow those new fields.
The validation criteria is also kept in the database (makes it easy to change) - check out the system_schemas/ database. Add or remove at will.

The only things layered "in-between" your request and the database are:
Validation, which is done off configurable documents - check out the system_schemas/ database
Note: The schemas also allow you to auto-add default values if they are missing, when a document is created or updated
Authentication. You must have access to the account, based on your auth_token
Eventing. You can listen for events when someone stores or retrieves something
Some internationalization and upload/binary file handling, in some cases
A message bus to transport the requests to/from the apps
