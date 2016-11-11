How to optimize **Kazoo UI**?


The optimizer will reduce the size, obfuscate and reformat all the CSS and JS file in the project 


**Prerequisites**

In order to use the optimizer, you will need... the `requirejs` optimizer (https://github.com/jrburke/r.js).
You will need to install `node` and `npm`.


**The build file**

The optimizer is based on a build file that will specify what options you will want to use to optimize the project.
Here is the one that I used to do it:
 

    {
    
    baseUrl: monsterToOptimized/
       ,mainConfigFile: monsterToOptimized/js/main.js
       ,dir: optimized
       ,findNestedDependencies: true,
       ,preserveLicenseComments: false
       ,removeCombined: true
       ,modules: [{ name: js/main
              ,exclude: [config]},
	     

    {    
    
     name: apps/common/app
       ,exclude: [bootstrap-switch
         ,toastr
         ,jquery
         ,monster
         ,timepicker
         ,underscore
         ,ddslick
	 ]},
        
	
    {
    
    name: apps/voip/app
      ,exclude: [ jstz
      ,monster-timezone
      ,toastr               
      ,jquery				
      ,mask                
      ,monster                 
      ,timepicker     
      ,underscore				
      ,chosen                
      ,chart
      ]},
	
	
    { 
    
    name: apps/callflows/app
    ,exclude: [                
    ,jquery         
    ,monster            
    ,underscore				
    ,chosen                
    ,mask                
    ,monster-timezone                
    ,slider

            ]}
	    
         ]}

If you want to get more information about what option is used for what I recommend taking a look at the example here: 
    
    https://github.com/jrburke/r.js/blob/master/build/example.build.js


**Execution**
Let's say that you have put the optimizer file `r.js` and your build file `build.js` in a folder at the same level than the **Kazoo UI** folder. The command that you will need to execute is the following one:

    node r.js -o build.js

When the execution is done, you should have a folder called 'optimized' in the same folder as `r.js` (Note: On Windows, you might have to type `r.js.cmd` instead of `r.js`)
