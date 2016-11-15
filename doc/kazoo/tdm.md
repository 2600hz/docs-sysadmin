## Kazoo and TDM



**Kazoo** allows you to connect your **FreeSWITCH** servers to TDM-based networks via PRIs or other digital circuits. Using cards 
supporting the **FreeSWITCH FreeTDM** system you can program **Kazoo** to utilize hardware inside **FreeSWITCH** servers to call via those 
circuits. The current **Kazoo FreeTDM** support is fairly limited. You must have a TDM card installed, with similar capacity, in each system where calls are to be placed. To configure the user of TDM circuits, add a document such as the sample below to your offnet or carriers record:

```{_id: 23c1c9ae35fc7b7318d6128af00009bb,
pvt_type: resource,
name: FreeTDM Pretend Card,
enabled: true,  
flags: [ ],   
weight_cost: 60,   
rules: [^\\+1(\d{10})$],  
gateways: [{server: fs-tdm.2600hz.com,          
prefix: 1, suffix: ,        
codecs:[PCMU], progress_timeout: 8,         
enabled: false, span: 1, invite_format: e164,         
endpoint_type: freetdm, channel_selection: ascending} ]

}```


