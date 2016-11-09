 

   
######**ACCOUNT LIMITS**

   
`twoway_trunks` : 0 //two way flat rate trunks, can only be used if `system_config.jonny5. flat_rate_whitelist` regex matches AND `system_config.jonny5.flat_rate_blacklist` does not. This can also be specified as a `pvt_twoway_trunks`, the lower will be used.
   
`inbound_trunks` : 0 //exactly the same as two-way trunks but only used for inbound calls. If there are more inbound calls then trunks two-way trunks will be checked next.
   
`resource_consuming_calls` : -1 // hard limit on the number of calls that can consume one or more resources (IE: inbound to outbound forwarded number is one resource consuming call), can also be specified as `pvt_resource_consuming_calls`, the smallest of the two is used
   
`calls` : -1 // total number of calls (resource consuming OR NOT) that an account can have, can also be specified as `pvt_calls`, the smallest of the two is used
   
`allow_prepay` : true, // allows the customer to disable `per_minute` authorizations relying solely on trunks and/or allotments, this will be overridden by `pvt_allow` prepay
   
`pvt_type` : limits
   
`pvt_vsn` : 
   
`pvt_account_id` : d75312345678901234567890

   
`pvt_account_db` : account%2Fd7%2F53%12345678901234567890

`did_us` : // then classification of a number as per `system_config.number_manager.classifiers`

`amount` : 120 // the allotment in seconds
   
`pvt_created` : 63518278682
   
`pvt_modified` : 63518278682
   
`pvt_soft_limit_outbound` : false // allows otherwise unauthorized outbound calls to continue
   
`pvt_soft_limit_inbound` : true //allows otherwise unauthorized inbound calls to conitnue
   
`pvt_allow_prepay` : true
   
`pvt_allow_postpay` : true // whether or not to allow the account to go negative
   
`pvt_max_postpay_amount` : 100 // the maximum negative amount that is acceptable
   
`pvt_allotments`:
      
`cycle` : hourly // the allotment reset period: yearly, monthly, weekly, daily, hourly, minutely
     
`pvt_discounts`:
      
`did_us` : // then classification of a number as per `system_config.number_manager.classifiers`
      
`percentage` : 10 // a percentage discount off the rate of EVERY per_minute call
 
   
`pvt_enabeld` : true // should limits be enforced for this account, IF FALSE THE ACCOUNT IS UNRESTRICTED




