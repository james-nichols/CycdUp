#pragma once

#include "ofMain.h"
#include "ofMath.h"
#include "ofSerial.h"
#include "ofEvents.h"

// 3rd party addons
#include "ofxOsc.h"
#include "ofxMidi.h"

#define HOST "localhost"
//#define HOST "192.168.0.255"
//#define HOST "10.1.1.255"
#define PORT 57120

#define H_MARGIN 100
#define W_MARGIN 100
#define TH_MARGIN 20
#define TW_MARGIN 20

#define FRAME_RATE 25 
#define DATA_RATE 50
#define DISPLAY_TIME_LENGTH 30 // Display last 30 seconds of rider effort

#define SERIAL_MSG_START 0xff

#define READY 0
#define READ_DESTINATION 1
#define READ_DATA 2
#define PROCESS_DATA 3 

#define NUM_RIDERS 4

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
        
        // Arduino/CV mechanism
    	//ofArduino ard;
    	//bool bSetupArduino;
        //void setupArduino(const int & version);
       
        ofSerial serial;        
        uint8_t in_bytes[2];
        int read_count;
        int read_mode;
        int destination_buf;

        bool bDraw;
	    bool bRun;	
};
