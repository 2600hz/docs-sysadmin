If you login to your **Kazoo** UI but no applications appear at the top of the page, your user or your config.js have mismatched API URLs. For security and validation, when you login the system checks to make sure the API you are logging into matches the API you are requesting apps from. If they don't, things won't work right (without special CORS headers - that's an advanced topic).

To fix this issue, follow these steps:


**Step 1: Identify the Authentication URL**
In your Kazoo UI's HTML folders there is a folder named config and a file named config.js. Inside that file is a configuration section which includes a default auth app which specifies the API you are authenticating against.
    
    winkstart.apps = {
        auth: { api_url: http://YOUR.SERVER.NAME.COM:8000/v1 }
        };


Note the `api_url` that is set.
 
**Step 2: Identify the User's Apps**

For each user that logs in they have a configured list of apps. These apps also utilize an API URL. If you are running **Kazoo UI** on your own server you'll want users to be utilizing the same API they authenticated with.
To find the user's app list, take the following steps:

Login to Futon (your **CouchDB**'s graphical user interface) on port 5984 on your server.   

    http://YOUR.SERVER.NAME.COM:5984/_utills/

Click on the correct account ID to enter your account database. Accounts are formatted `account/22/33/4567890456789045678904567890`
Once inside the account database, on the top right corner of the screen is a drop-down with all the available views. Click on the drop-down and select `users/ crossbar`

Verify that the API URL for your App matches the API URL you logged in with (in Step 1) 
 
If you make a change, make sure you logout and log back in as the list of Apps is cached on your browser.
 
You can add the complete list of apps manually, like this:
 
    {
    voip: {    
       label: Hosted PBX,     
       icon: phone,    
       api_url: http://YOUR.SERVER.NAME.COM:8000/v1,
       
       ui_flags: {          
       provision_admin: true,           
       super_duper_admin: true
     },
       
     default: false
       },
   
    pbxs: {      
       label: PBX Connector,       
       icon: pbx,      
       api_url: http://YOUR.SERVER.NAME.COM:8000/v1,    
       default: false
     },
   
    numbers: {      
       label: Number Manager,       
       icon: menu1,       
       api_url: http://YOUR.SERVER.NAME.COM:8000/v1,      
       default: false   
     },
   
    accounts: {      
       label: Accounts,      
       icon: account,      
       api_url: http://YOUR.SERVER.NAME.COM:8000/v1,      
       default: true
        },
   
    developer: {
       id: developer,
       label: Developer,       
       icon: connectivity,       
       desc: API Developer Tool,   
       api_url: http://YOUR.SERVER.NAME.COM:8000/v1,     
       default: false
       }
    }
