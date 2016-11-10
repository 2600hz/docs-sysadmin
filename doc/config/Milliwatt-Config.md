**Configuration Document**
 
Create a document (with milliwatt for id) in the `system_config` database.

**Base Parameters**

`echo
duration`

This sets the duration of the echo action. The value is in milliseconds. 
 
*View Sample Code

`duration: 5000
caller_id`

This sets the caller ids of the echo action. It means that any call made 
from theses numbers (or users) will be redirected to Milliwatt echo action.
 
*View Sample Code

`caller_id: [4155555555, username]
number`

This sets the number of the echo action. It means that any call made 
to these numbers will be redirected to Milliwatt echo action.
 
*View Sample Code

`number: [123456789,1011121314]`

*View Sample Code

`echo: {duration : 5000
   ,caller_id: [ 
	4155555555,username
	],
	
number: [123456789]}

tone

frequencies`

This sets the frequencies used for the tone action.
 
*View Sample Code

`frequencies: [2600, 2300]
duration`

This sets the duration of the tone action. The value is in milliseconds.
 
*View Sample Code

`duration
 : 
5000
caller_id`

This sets the caller ids of the tone action. It means that any call made 
from theses numbers (or users) will be redirected to Milliwatt tone action.
 
*View Sample Code

`caller_id
 : [
4155555555
, 
username
]
number`

This sets the number of the tone action. It means that any call made 
to these numbers will be redirected to Milliwatt tine action.
 
 
*View Sample Code

`number: [
123456789,1011121314
]`

*View Sample Code

`tone: {
frequencies: [2600]	
,duration: 5000
,caller_id: [4155555555
,username
]
	
,number: [123456789]
}
 ` 
*Example:
 `
{_id: milliwatt,default: {echo: {duration
: 5000
,caller_id: [username_echo ],
           
number: [5555555551]
  }
  ,tone: {frequencies:[2600]
  ,duration: 2000
  ,caller_id: [username_tone]
  ,number: [5555555552]
     }
   }
}
`
