SinOsc sine => dac;
// create our OSC receiver
OscRecv recv;
// use port 12000
12000 => recv.port;
// start listening (launch thread)
recv.listen();

440 => sine.freq;
0 => int useTriggerFinger;

// Listen for this OSC message, containing one float
// Event oe will be triggered whenever this message arrives.
recv.event( "/wek/outputs, f" ) @=> OscEvent oe;

<<< "Listening for 1 classifier output (4 classes) on port 12000, message name /wek/outputs">>>;

waitForEvent();

20::second => now;


fun void waitForEvent() {
    // infinite event loop
    while ( true )
    {
        // wait for our OSC message to arrive
        oe => now;
        
        // grab the next message from the queue. 
        while ( oe.nextMsg() != 0 )
        { 
            // getFloat fetches the expected float (as indicated by "f")
            //We can cast it to an int:
            oe.getFloat()$int => int c;
            <<< c >>>;
            c*440 => sine.freq;
            
        }
    }   
    
}
