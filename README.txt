INPUT to --> WEKIHELPER =               MouseDraggedObject_Input_1 (X_Position)
OUTPUT from WEKIHELPER --> WEKINATOR =  Velocity along X_Axis

The Input helper uses input_1 of the MouseDragged2Inputs feature extractor.
Input_1 is the X position. I chose the output to be "First order difference" -- VELOCITY (of the dragging speed along the X axis).
The output from the Helper is then the INPUT to WEKINATOR.

This can be used for game audio, where you modulate the frequency of enemy sounds depending on how fast they move.
It can also be a parameter for physics simulations, where the velocity of you dragging a car on the screen against a wall, can be used to teach about collisions.

Example:
Let's send the WEKINATOR output (trained on the WEKIHELPER INPUT) to CHUCK to control the frequency of a sine wave through velocity (input with draggedmouse):

To do this you have to make sure that:

WEKIHELPER LISTENS @ Port 6448
		SENDS @ Port 6449
WEKINATOR LISTENS @ 6448
	SENDS @ 12000
CHUCK LISTENS @ 12000 (like in the code below);

CHUCK CODE:
--------

SinOsc sine => dac;
// create our OSC receiver
OscRecv recv;
// use port 12000
12000 => recv.port;
// start listening (launch thread)
recv.listen();

440 => sine.freq;
0 => int useTriggerFinger;

// Listen for this OSC message, containing one float (1 Output Value)
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
            c*440 => sine.freq;

        }
    }

}

//fun void multiplyFreq (osc, freq, multiplier) {
//   freq * multiplier => osc.freq;
//}

---------
