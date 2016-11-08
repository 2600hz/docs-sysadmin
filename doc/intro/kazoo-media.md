#
Kazoo Media

Created by Karl Anderson, last modified on Apr 12, 2013 Go to start of metadata
Streaming Audio (mp3 and wav) to FreeSWITCH from Erlang
One of the biggest challenges to overcome with distributing FreeSWITCH servers inside your cluster is getting them access to the same media files, both system and user-generated (like voicemails and custom prompts). Replicating (via rsync or similar) files amongst the FreeSWITCH servers works at a small scale, but increase over a few servers and the operational requirements accelerate.
Challenges
How to ensure each server has the same set of media files?
How to ensure each server has the same version of media files?
How to ensure each server received a copy of a media file?
How to ensure a newly added server gets all the updated media?
How to ensure a newly added server gets any new media?
Will each server realistically be able to store all media across the system?
To The Clou^H^H^H^H Stateless Switch
If a switch or subset of switches are responsible for storing a client's voicemail files, we have a point of failure with respect to that client. With the single switch setup, it is an obvious point of failure. As you increase the number of switches storing media, the operational costs begin to increase (while the likelyhood of losing those files decreases). However, the client is still limited in which switch they are able to hit and retrieve their media.
A guiding decision we've made in Whistle is that the underlying switching servers should be as "dumb" as possible with respect to the decision making process. Included in this decision is the storage of client media. As seen above, the job of synchronizing media across the cluster is difficult in the switching layer. Whistle instead pushes the responsibility of handling media up to the WhApp layer. As long as a switch is managed by Whistle, and Whistle is connected via messaging bus to a WhApp that handles media distribution, all switches have access to the same media.
The biggest enablers of this strategy, from the switch's perspective, are two FreeSWITCH modules: mod_shout and mod_shell_stream. mod_shout provides us with an entry point for both streaming mp3 media into a call, as well as streaming recordings from FreeSWITCH to Whistle (more on this later). mod_shell_stream, as the wiki states, allows you to "stream audio from an arbitrary shell command". Combining this with a simple cURL+sox script, we now have the building blocks to stream all audio to/from Whistle/WhApps.
Media Manager
Included with Whistle is a media management WhApp named media_mgr.
Sending Audio to FreeSWITCH
When Whistle encounters a dialplan action requiring media, it makes a request to the message bus asking for an accessible URL from which to stream the media. media_mgr receives the request and does a lookup in the data-store for the requested media. If found, a stream process is created and give the data necessary to stream the chosen media contents. The media type (WAV or MP3) determines the type of stream (HTTP or SHOUT, respectively). The stream process crafts a URL with the port it will be listening on and sends the response back to the Whistle process handling the call.
Whistle checks the protocol of the URL received to determine how to send the stream to FreeSWITCH. If the protocol is http:// (WAV), Whistle knows that mod_shell_stream should be invoked and creates the play command to do so. If the URL is shout://, Whistle passes it along to FreeSWITCH; FreeSWITCH then passes control to mod_shout to pull the actual contents down.
mod_shell_stream script
To invoke mod_shell_stream, Whistle passes a command to FreeSWITCH similar to:
 
shell_stream:///path/to/fetch_remote_audio.sh http://mediamgr.url.com/stream.wav
 
The fetch_remove_audio.sh script makes an HTTP request to the stream URL, and pipes the body (the WAV contents) to sox, which in turn sends the data into FreeSWITCH.
Recording audio
mod_shout also allows us to stream a recording to a SHOUT server rather than to the local disk, critical when a voicemail is being left.
Our voicemail is actually a callflow module and sends a MediaName to Whistle to identify the recording for later use in the call. Whistle, when executing the record instruction, creates a SHOUT server process and sends the URL along with the record command, something along the lines of:
 
shout://foo:bar@whistle.server.com:39266/fs_02688d5d2b37267a2e9496d156cb52dd.mp3 120 500 5
 
Yes, the foo:bar is actually used. mod_shout uses basic HTTP auth to connect to the Whistle SHOUT server, expects an appropriate response, and then streams the recording to Whistle. Whistle stores this recording to its local disk. If the user on the call wants to review the recording, Whistle actually sets up a SHOUT streaming server, much like media_mgr did, and streams the recording back into FreeSWITCH. When the WhApp controlling the call issues a store command, in this case passing the CouchDB URL with attachment to stream into, Whistle reads the file off its local disk and streams away as normal. Once the phone call ends, the recorded media will be streamed via media_mgr (say when a user checks their voicemail).
