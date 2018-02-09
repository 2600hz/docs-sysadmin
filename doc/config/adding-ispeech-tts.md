## Adding iSpeech TTS to Kazoo



## iSpeech

Adding **iSpeech** TTS to **Kazoo** provides a nice TTS engine for turning your dynamic text into a sound file for playing to your callers. Once **Kazoo** is configured properly, **iSpeech** will be used to generate the TTS wav files instead of the `default mod_flite` **FreeSWITCH** module. Generally speaking, the **iSpeech** versions are of a higher quality. As **iSpeech** is a third-party service, you will need to setup and maintain your **iSpeech** account/credits outside of **Kazoo** itself.
 
 
## Configure Kazoo to use iSpeech

1. Access your **BigCouch**/**CouchDB Futon GUI** (usually located at http://your.host.com:5984/_utils)

2. Open up the `system_config` database

3. Edit the speech document:
```
{
"_id" : "speech",
     default: {
       "tts_url": "http://api.ispeech.org/api/json",
       "tts_api_key": "YOUR_ISPEECH_KEY",
       "tts_frequency": "16000",
       "tts_bitrate": "16",
       "tts_speed": 0,
       "tts_start_padding": 1,
       "tts_end_padding": 0,
       "tts_provider": "ispeech",
       "tts_voice": "female",
       "tts_language": "en-US",
       "tts_default_voice": "female/en-US",
       "tts_url_ispeech": "http://api.ispeech.org/api/json"
       }
}
```

These configs should take effect the next time something (such as directory or **Pivot's** Say) utilizes the TTS commands in **Kazoo**.  **Kazoo** will proxy/cache the generated .wav file for a time, and normal **FreeSWITCH** media caching will also take place, so an oft-used TTS string should not require accessing **iSpeech** (resulting in audio delays).
