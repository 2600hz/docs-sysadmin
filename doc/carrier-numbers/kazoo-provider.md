# Kazoo Provider Module



## Hooking a Provider's API into Kazoo

Service providers offer various add-ons to telephony; things like CNAM, E911, and other services can be added to numbers in **Kazoo**. Creating a provider module links **Kazoo** up with the provider's APIs.


## Overview

Provider modules exist as part of the core's `whistle_number_manager` application. You can view existing modules in src/providers/ to help guide your development efforts. The exported interface varies based on the type of service being provided. 

Services include:
```
E911
CNAM
Porting
E911
# An E911 provider module will export the following interface:
save/1
delete/1
```
Each function takes the `#number{}` record and must return a `#number{}` record back to the caller on success. If a failure occurs, an exception is thrown using the `wnm_number` error functions.
