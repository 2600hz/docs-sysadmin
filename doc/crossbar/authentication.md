## Enabling / Disabling Authentication

Only turn authentication on and/or authorization off on a non-public server. Servers with no authentication can be easily compromised.
 
**Kazoo** comes with two modules that allow you to bypass the authentication and authorization mechanisms, but has them turned off by default. Enabling them is relatively easy. These instructions assume the **Crossbar** application is running in the **WhApps** container and is listening on port 8000, the default.

## Steps to Turn Off Auth
```
sup crossbar_module_sup start_mod cb_noauthn
sup crossbar_module_sup start_mod cb_noauthz
```

## What did we just do?

We just loaded two dummy modules, one for authentication and one for authorization. These modules listen for authentication and authorization requests and blindly reply to them in the affirmative. You must still provide credentials when performing checks on the system, but the credentials (such as a username and password, or an X-Auth-Token) can be bogus.
 
## Turning Auth Back On
```
sup crossbar_module_sup stop_mod cb_noauthn
sup crossbar_module_sup stop_mod cb_noauthz
```

## What did we just do?

We just stopped and unloaded the two dummy modules that blindly reply to authentication and authorization requests. You will now be enforcing username/password and auth token requirements as normal.
 
To verify the enabling/disabling

XXXX

