#
Media Streaming

Created by Darren Schreiber on May 13, 2012 Go to start of metadata
Media Anywhere
Running a PBX, call center, and other telephony-related applications requires custom media files to be accessible to the softswitch processing the call(s). Music-on-hold (MOH), voicemails, auto-attendant menus, etc, are generally created by either the service provider or customers, and any underlying switch in the Whistle platform needs access to those files. Copying all media files to all possible servers is not a viable solution.
What Do You Do?
Here's What We Did
We store media binary data in CouchDB documents as attachments, with the meta-data of the file the properties of the document itself. When Whistle receives a request from a WhApp to play custom media, Whistle makes a request to any listening WhApps for a URL to stream the media from, and the responding WhApp (if any, and usually MediaMgr) responds with one of two types of URLs, shout:// and http://.
shout://
A URL prepended by shout:// indicates MP3 media which FreeSWITCH plays via mod_shout. MediaMgr, when it sees that the requested media is MP3 data, creates a tiny SHOUTCast server to stream the MP3 data and a unique URL that is sent back to Whistle. Whistle feeds this URL to FreeSWITCH which then connects to the stream and plays the audio.
http://
A URL prepended by http:// indicates WAV media. Recently, FreeSWITCH has added a new module, mod_shell_stream, to stream audio from an arbitrary shell command. Combined with a simple sox command, any http URL becomes streamable to FreeSWITCH. MediaMgr returns an http URL from which it proxies the WAV media from CouchDB to FreeSWITCH.
Types of Streams
Currently we have two streams, new and extant. When Whistle requests media data, it indicates whether this is a one-off request (like playing a voicemail) or if it should be joining an already-running stream (like MOH). For one-off requests, "new" is used; for running streams, "extant" is used. If this is the first time the media is requested on an extant stream, the stream is initialized and streaming begun.
Location Awareness
Sometimes Whistle receives a request to play custom media early enough in the Dialplan that Whistle can pre-fetch the appropriate URL stream. When this is the case, Whistle can wait on several responses from different MediaMgr WhApps and figure out which is the most appropriate to stream the media from (all media streams in MediaMgr have timeouts, so unused streams will be reclaimed fairly quickly). When rushed, Whistle assumes the first responding WhApp corresponds to which WhApp can also stream the media most efficiently.
