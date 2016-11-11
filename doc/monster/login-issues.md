**Login Issues**


User can't login: *Check that the apiUrl set up in the js/config.js is correct.*

User can login but land on a white page: *Check that the apiUrl of the apps are setup correctly in the database. Apps are defined in the admin account database, in the `app_store` view. If you need to update these documents, refresh the views (sup whapps_maintenance blocking_refresh)

**Phone Numbers Issues**


User can't search/buy/list numbers: *make sure that the correct `phonebook_url` (ask Francis?) are defined properly in the `system_configs`, `crossbar.phone_numbers` and `number_manager.other`.*
