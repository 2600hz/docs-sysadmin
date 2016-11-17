## Store and Forward (T.37)

 

##Ways to transmit a Fax over IP:


## PCMU
 
Plain old audio, uncompressed (64k) regular phone line. PCMU is OK if you can guarantee the audio signal is consistent around 200-300ms latency. T.38 - At least two sides must understand T.38 to use it:

Negotiation was be successful between the two sides. Who negotiates first?
 
v0, v1, v2, v3, ECM, v17 - Max Speed (14400/9600)
 
Redundancy Feature - FAX - ATA - CLOUD - v1, v2, v3
 

## STEPS FOR T.38 TO WORK:

Two devices must be able to hear each other initially via voice (to detect the tones) 
Best way to test: CALL THE FAX MACHINE. Also, have them call you from the fax machine if possible. CLUE: No t38 message in the logs AND hang up within 15-30 seconds. CATCH: Many fax machines don't answer for 5 rings, and your calling timeout might be too long. You'll see NO_ANSWER in the FreeSWITCH log. Two devices must be able to negotiate T38 either with each other or with the upstream phone company (You won't know who's on the other side, and that's OK). You will see a log entry in the FS log that a negotiation of T38 was attempted. You will then see a reply from the other side of either Not Acceptable Here / Incompatible Destination OR OK. In addition, the OK will come back with the confirmed parameters


## For Testing:

1. Need One (1) Physical Fax that can Send/Receive
2. Need One Virtual or Physical Fax that can Send /Receive
3. PATIENCE!
4. Test PCMU. Should work over fast connection but may not always - The most optimized services should work, so for example RingCentral 
   Our Fax to Email (server) Service. Probably won't work to a real fax machine
5. Test Two-way Audio
6. Test Long/Complex Faxes
7. Test Short/Simple Faxes
8. Test Two Model ATAs :-) and no more then two models.
9. Test Two Fax Machines. 
10. Test error conditions and how OUR software handles them.
11. Inspect quality for lost rows/lines.
12. Someday test store forward.
13. Test Failback abilities on our side.
 
