You can issue commands directly in the Erlang VM by running:
For Whapps:
/opt/kazoo/whistle_apps/conn-to-apps.sh
For ecallmgr:
/opt/kazoo/ecallmgr/conn-to-ecallmgr.sh
Cookie
Check what cookie is used:
erlang:get_cookie().
Set the cookie:
erlang:set_cookie(node(), 
cookiemonster
).
