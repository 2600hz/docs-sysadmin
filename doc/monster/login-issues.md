## Login Issues



1. User can't login: Check that the API URL set up in the JS / `config.js` is correct.

2. User can login but lands on a white page: Check that the API URL of the apps are setup correctly in the database. Apps are defined in the admin account database, in the `app_store` view. If you need to update these documents, refresh the views: 

  `sup kapps_maintenance blocking_refresh`


## Phone Numbers Issues

1. User can't search/buy/list numbers: Make sure that the correct `phonebook_url` are defined properly in the `system_configs`, `crossbar.phone_numbers` and `number_manager.other`.
