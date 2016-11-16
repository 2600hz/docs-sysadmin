## Creating Accounts Manually



## Command-Line Creation (Method #1)

The easiest way to create an account in the system manually is to use the command line. To create a new account, run the following commands after **Kazoo** is installed:

`/opt/kazoo/utils/sup/sup crossbar_maintenance create_account accountname realm username password`

Replace `accountName`, `realm`, `username` and `password` with an account you'd like to create. You can then login using this account and you're ready to go! *Please note that the account name, realm, username and password must be all lower case, no spaces.* If there are no accounts in the db then it will be automatically promoted to `superduper` (master / full permissions) admin.

Issues creating the master account:

If you're having an error while creating the first master account after an install, make sure you have the correct permissions set on the **Bigcouch** nodes:

`chown -R bigcouch: daemon /srv/db`

And make sure all the views are up to date:

`/opt/kazoo/utils/sup/sup whapps_maintenance blocking_refresh`
 
 
## Database Creation (Method #2)

For more advanced users who really want to understand what's happening under the hood you can follow the steps below. This isn't necessary if you've run the command line options above – you're already done!


## Access Your Database

If aren't already aware, you can access your database server's web management tool by navigating to the database's IP address on port 5984. For example, type http://my.webserver.com:5984/_utils/ into your web browser. You should see a graphical user interface where you can create and manage data and databases. You will want to login to your database so that you can modify information. To get your database's username and password, check the file `/opt/kazoo/whistle_apps/lib/whistle_couch-1.0.0/priv/startup.config`. 

You will see a setting like this in the file: 

`{couch_host,"127.0.0.1",15984,"USERNAME","PASSWORD",15986].`
      
You must login to the web interface by clicking login at the bottom right of the screen and entering the username and password displayed from that file.

## Generating an Account Database and Document

1. Decide on Account Names
2. Before you get started, you need to have 3 items ready that you will need to replace in the examples below anywhere you see them:
   An account ID of your choosing. It can be anything, though normally we choose a random Unique Identifier with a slash after the 2nd and    4th character
   Example: "01/90/c8578486089413d3f9058af4d000" or "my_new_account" are both acceptable
3. A friendly name for the account
   Example: "My Company" or "Master"
4. A DNS name that will be used when registering devices to this account (not an IP address)
   Example: "customer1.2600hz.com" or "91201.s.com"


## Create the Account

To create your account, follow these steps:

1. Click the Create Database icon on the top left of the screen
2. Enter the database name as account/name, such as `account/01/90/c8578486089413d3f9058af4d000` or `account/my_new_account` depending on    what you decided above. Click create.
3. You will be taken into the new database.
4. Click "New Document"
5. Click the Source tab (on the right)
6. Paste the following data into the account, replacing `_id`, `pvt_XX` and `name` with the appropriate fields you selected Initial Account Document
```
{
   // Account's ID number, used in API calls and everywhere else
   _id: ACCOUNT_ID_GOES_HERE,
  
  
   // A copy of the account ID (private). This should match the _id field above
   pvt_account_id: ACCOUNT_ID_GOES_HERE,
  
   // The database-formatted version of the Account ID, note the %2F which is a slash
   // **NOTE: You must replace any slashes in the account ID with %2F!!!**
   pvt_account_db: account%2FACCOUNT_ID_GOES_HERE,
  
   // DNS name for all devices within this account
   realm: DOMAIN.NAME.GOES.HERE,
  
   // A friendly name for the account, used when logging in
   name: FRIENDLY NAME GOES HERE,
  
   // You can leave these items as they are:
   
   pvt_api_key: "",
   pvt_tree: [],
   pvt_enabled : true,
   pvt_type: account,
   pvt_vsn: 1
}
```
**!! Double-Check Your Database Name**

Make sure the `pvt_account_db` field matches the database string at the of the page exactly. It should have `%2F` instead of slashes. Save the document. You've now created your first account!
 
 
## Generating a User Document

An account isn't very useful if a user can't login, so let's follow the same procedure above, while still in the account database, to create our first user document.


## Generate a Credential

Our platform attempts to never store usernames and passwords in plain-text. In that regard, usernames and passwords are always converted into an md5 hash before storage or transmission, when possible. Therefore, you must select a username and password and then generate an md5 hash of it. We also sometimes use a sha1 encryption algorithm. For speed, we calculate the sha1 prior to storage. So you will need to generate that as well.

Generating the md5 is easy. You can:

Use a website like http://www.miraclesalad.com/webtools/md5.php and enter a username:password there.

Use a linux command. Type `echo -n username:password | md5sum`.

Use a Mac command. Type `echo -n username:password | md5`.

Record the output as your md5 credential.
 

Now, generate your sha1sum. You can:

Use a website like http://hash.online-convert.com/sha1-generator

Use a linux command. Type `echo -n username:password | sha1sum`

Use a Mac command. Type `echo -n username:password | shasum`

Record the output as your sha1 credential.


## Create the User Document

To create your user, follow these steps:

Make sure you are in the correct account database (see above)

Click "New Document"

Click the Source tab (on the right)

Change all the fields below that are in all caps to intelligent values. Use the md5 and sha1 values you generated above as well to 
populate those fields.


## User Document

```
{
   "_id": "000000000000000000000000000000001",
   "username": "YOUR_USER_NAME",
   "first_name": "YOUR_FIRST_NAME",
   "last_name": "YOUR_LAST_NAME",
   "email": "YOUR_EMAIL_ADDRESS",
   "apps": {
       "voip": {
           "label": "Your PBX",
           "icon": "phone",
           "api_url": "http://YOUR.SERVERS.DNS.NAME:8000/v1"
       }
   },
   "pvt_type": "user",
   "pvt_md5_auth": "MD5-YOU-GENERATED-GOES-HERE",
   "pvt_sha1_auth": "SHA1-YOU-GENEREATED-GOES-HERE",
   "pvt_vsn": "1",
   "pvt_account_id": "YOUR_ACCOUNT_ID_FROM_THE_FIRST_STEP",
   "pvt_account_db": "YOUR_DATABASE_ACCOUNT_ID_FROM_THE_FIRST_STEP"
}
 ```

## Updating the Global Accounts Database

To update the global accounts database, so that it gets a copy of the new account you just created, and to create the default views on the new account, simply run these commands:
```
/opt/kazoo/whistle_apps/conn-to-apps.sh
whapps_maintenance:refresh('ACCOUNT_ID_GOES_HERE').
```
If you've done this correctly, you can login to the database's Futon web interface and see a copy of your new account in the accounts database.
 
**If you see "removed"...**

If you see the word "removed" after running the command above, the system was unable to process your account document for that account and thinks it's been removed. Check these items:

1. Is the `_id` field the same as the `ACCOUNT_ID_GOES_HERE` you entered?
2. Did you create your database named as `account/ACCOUNT_ID_GOES_HERE`?
3. Is the `pvt_enabled` field anything other then "true"?

