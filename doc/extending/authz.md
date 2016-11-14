## Hook Auth Externally

**Kazoo** allows you to hook to authentication and authorization requests externally. This makes it simple to attach a billing or single sign-on system externally. The concept is easy to understand. Each time a username/password needs verification, we'll make a call to your external system to check if it's valid. Each time a phone number is dialed, we'll make a call to your external system to make sure it's OK for the identified customer to make that call.
