#pragma once

#include "ofMain.h"
#include "ofMath.h"
#include "ofSerial.h"
#include "ofEvents.h"

// 3rd party addons
#include "ofxOsc.h"
#include "ofxMidi.h"

// These define the destination for OSC messages, to send data to 
// Supercollider for sound synthesis
#define HOST "localhost"
// Can do network transmission and broadcasting
//#define HOST "192.168.0.255"
#define PORT 57120

#define H_MARGIN 100
#define W_MARGIN 100
#define TH_MARGIN 20
#define TW_MARGIN 20

#define FRAME_RATE 60
// Next two variables just determine length of display buffer.
// Make sure DATA_RATE is roughly similar to the rate the Arduino transmits.
#define DATA_RATE 50 
#define DISPLAY_TIME_LENGTH 30 // Display last x seconds of rider power

#define BAUD 57600
#define SERIAL_MSG_START 0xff

#define READY 0x00
#define READ_DESTINATION 0x01
#define READ_DATA 0x02
#define PROCESS_DATA 0x03 

#define NUM_RIDERS 0x04

//using namespace wng;

class ofApp : public ofBaseApp{

	public:
		void setup();
		void update();
		void draw();

		void keyPressed(int key);
		void keyReleased(int key);
		void mouseMoved(int x, int y );
		void mouseDragged(int x, int y, int button);
		void mousePressed(int x, int y, int button);
		void mouseReleased(int x, int y, int button);
		void windowResized(int w, int h);
		void dragEvent(ofDragInfo dragInfo);
		void gotMessage(ofMessage msg);
		
        int counter;

        // All the data is processed here
        vector<vector<double> > buf;
        int buf_size;
        int num_bufs;

        vector<ofColor> buf_colour;
        
        // OSC mechanism
		ofxOscSender osc_sender;     
        
        // MIDI mechanism
        //ofxMidiOut midi_out;
        //int midi_channel;
        //int midi_note, midi_arp_note, midi_velocity;
        
        ofSerial serial;        
        uint8_t in_bytes[2];
        int read_count;
        int read_mode;
        int destination_buf;

        bool bDraw;
	    bool bRun;	
};
