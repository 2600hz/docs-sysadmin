## Service Plans



Service Plans define costs associated with various services in the system. Services figure out how many devices, trunks, users and similar 
features are in use for an account. Those totals are applied to one or more service plans on the account and then passed to a bookkeeper to handle the actual billing functionality.
 
## Use Case

New guy just installed his cluster, wants to bill his clients
 

## Configuring a Service Plan

A service plan document defines services, such as DIDs or SIP devices, which have a cost. It also defines the name of the corresponding element that will be used in your given bookkeeper (i.e. you may call DIDs in Quickbooks Phone Numbers, and therefore you need to map our name to your name). Together, these two concepts make up a service plan. The service plan document(s) is located within a reseller's account. The master account on every system is automatically considered the default reseller.


## Master / Default Service Plans

Standard accounts are accounts which live underneath a reseller. By default, the master account is the first reseller in the system. For the purposes of this example, we'll assume you're creating your first account beneath your master/reseller account.


**Find Your Master Account**

1. You'll need the account-ID if you don't already know it.

2. Go into the master account's database via **BigCouch**'s Futon interface

3. Create a new document

4. Add the field `pvt_type` with the value `service_plan`

5. Add a plan 

    object {phone_numbers: {     
    did_us: { name: US DID,rate: 1,    
    discounts: {
    cumulative: {                   
    maximum: 2,                  
    rate: 0.5
      }
    },
           
    cascade: false },
       
    tollfree_us: { name: US Tollfree
    ,rate: 5
    ,cascade: true           
    ,minimum: 10
       }
     },
     
    number_services: {       
    cnam: { name: CNAM Update
    ,activation_charge: 2
    },
       
    port: {           
    name: Port Request
    ,activation_charge: 5
    },
       
    e911: {
     name: E911 Service
    ,rate: 5     
    ,discounts: {single: {rate: 5 }
       }
       }
    }
   
   limits: { twoway_trunks: { name: Two-Way Trunk, rate: 29.99 }
     ,inbound_trunks: { name: Inbound Trunk,rate: 19.99 }
   
    },
    
   devices: { _all: {
    name: SIP Device
    ,as: sip_devices
    ,cascade: true,
           
   rates: {5: 0         
    ,20: 24.95        
    ,50: 49.95           
    ,100: 149.95
      }
     }
    }
   }
   
   >>The following is how to not bill a client for their first 50 phones, but bill for those after 50
       
   "devices": {
   "_all": {
   "name": "SIP Device",
   "as": "sip_devices",
   "cascade": true,
   "rates": {
   "50": 0,
   "51": 24.95
   }
   }
   },
   
   >>   The following will take the first rate that is less than the current quantity and charge that flat rate.  If the currently quantity exceeds all flat rates then the normal process (rate x quantity) is applied.
   >> The example below reads, if this was for devices: The first 5 devices, inclusive, will charge you $0 a month (IE: free). The 6th device to the 20th, inclusive, will charge you $24.95.  The 21st to 50th, inclusive, will charge you $49.95.  The 51st device and up will be $1.00 a device a month.
   
   "rate": 1.00,
   "rates": {
   50: 49.95,
   20: 24.95,
   5: 0
   }

 
 
 
**Reseller Service Plans**
 
**Service Plan Minimums**
  
**Assigning Service Plans**

**Assigning Plans to Customers**
 
**Promoting Accounts to Reseller Status**
 
**Setting the default / global service plan**

**Checking if someone is properly setup as a reseller?**

**APIs for any of the above (now or future)**

**What does default_service_plan do?**

**How to check that a bookkeeper is loaded/running?**

**What happens if a bookkeeper is not working/loaded/running?**

 
## Advanced Features

It may be useful to have a reseller account with subaccounts, who in turn have their own subaccounts, all billing back to the reseller account. An account's reseller is determined by looking at each parent until the first account with a reseller flag is found. If no such account is found, the master account is used.

 
## IMMEDIATE ACTION AFTER CHANGE:

 USER ADDS DEVICE ---
  DEVICES ARE RE-COUNTED  ---
  SERVICES DATABASE IS UPDATED WITH LATEST COUNT --
  ACCOUNT IS MARKED AS DIRTY
 
 
## PERIODIC MAINTENANCE:

 SCAN FOR DIRTY ACCOUNTS --
 APPLY SERVICE PLAN TO ACCOUNT SERVICES  --
 PASS THE LIST OF BILLABLE ITEMS TO THE 
 BOOKKEEPER
 IF CUSTOMER IS PART OF A RESELLER, DIRTY THE RESELLER'S ACCOUNT
 
 
## BOOKKEEPER:
 TAKE NORMALIZED LIST OF ITEMS --
 PASS TO BOOKKEEPER SPECIFIC LOGIC (Could be WHMCS, Braintree, Stripe, etc.)  --
 RETURNS ACCOUNT STATUS (GOOD STANDING or ERROR)
 
 
 
