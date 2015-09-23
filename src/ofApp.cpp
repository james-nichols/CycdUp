#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    
    counter = 0;
    
    bDraw = false; bRun = false;
    in_bytes[0] = 0; in_bytes[1] = 0; read_count = 0;

    num_bufs = NUM_RIDERS;
    buf_size = DISPLAY_TIME_LENGTH * DATA_RATE;

    for (int j=0;j<num_bufs;j++) {
        
        vector<double> buf_col;

        for (int i=0; i<buf_size; i++) {
            buf_col.push_back(0.0);
        }
        
        buf.push_back(buf_col);
        ofLog() << &buf_col << " " << &buf[j];
        ofLog() << buf[j][0];
        
        int hue = fmod(float(j*255)/float(num_bufs),float(255.0)); // ofRandom(0,255);
        buf_colour.push_back(ofColor::fromHsb(hue, 240, 240));
    }

    // Set up the OSC osc_sender
    osc_sender.setup(HOST, PORT);    
   
    ofSetWindowTitle("Cyc'd Up!");
    ofDisableAntiAliasing();
    ofSetFrameRate(FRAME_RATE);

    // Set up the arduino for CV output (via PWM)
	//ard.connect("/dev/tty.usbserial-A9007W2m", 57600);
    //ofAddListener(ard.EInitialized, this, &ofApp::setupArduino);
    //bSetupArduino = false;	// flag so we setup arduino when its ready, you don't need to touch this :)
    
    int baud = 57600;

	serial.listDevices();
	vector <ofSerialDeviceInfo> deviceList = serial.getDeviceList();

	//serial.setup("/dev/tty.usbserial-A9007W2m", baud); // mac osx example
    serial.setup(0, baud); // Takes the first one from the device list
    //bSetupArduino = true;
    read_mode = READY;
    destination_buf = 0;
}

//--------------------------------------------------------------
void ofApp::update(){
    
    // Read all avaiable serial data and send to appropriate buffers
    
    while (serial.available() && bRun) {
         
        in_bytes[0] = serial.readByte();

        if ( in_bytes[0] == OF_SERIAL_NO_DATA ) 
            ofLog() << "Serial no data received...";
        else if ( in_bytes[0] == OF_SERIAL_ERROR )
            ofLog() << "Serial read error occurred...";
        else
            switch(read_mode) { 
                case READY:
                    if (in_bytes[0] == SERIAL_MSG_START && in_bytes[1] == SERIAL_MSG_START) { 
                        read_mode = READ_DESTINATION;
                    }
                    break;
                case READ_DESTINATION: 
                    destination_buf = in_bytes[0];
                    read_mode = READ_DATA;
                    break;
                case READ_DATA:
                    // Need to read just one more byte to get the full 10-bit int from the board
                    read_mode = PROCESS_DATA;
                    break;
                case PROCESS_DATA:
                    if (destination_buf >= num_bufs)
                        ofLog() << "Insufficient buffers initialised for rider #" << destination_buf;
                    double data_point = float(in_bytes[0] * uint8_t(0x10) + in_bytes[1]) / 1024.0;
                    buf[destination_buf].push_back(data_point);
                    buf[destination_buf].erase(buf[destination_buf].begin());
                    read_mode = READY;
                    break;
            }
        in_bytes[1] = in_bytes[0];
    }

}

//--------------------------------------------------------------
void ofApp::draw(){
	ofBackgroundGradient(ofColor(50), ofColor(0));

    if (bDraw) {
        for (int i=0; i<num_bufs; i++) {
            ofMesh graph;
            ofMesh graph_double;
            graph.setMode(OF_PRIMITIVE_LINE_STRIP);
            graph_double.setMode(OF_PRIMITIVE_LINE_STRIP);
            
            float z = 8 * i;
            for (int j=0; j<buf_size; j++) {
                graph.addColor(buf_colour[i]);
                graph_double.addColor(buf_colour[i]);
                
                float x = float((ofGetWidth()-2*W_MARGIN) * j) / float(buf_size) + float(W_MARGIN);
                float y = ofGetHeight() - ((ofGetHeight()-2*H_MARGIN) * buf[i][j] + float(H_MARGIN));
            
                //graph.addVertex(ofVec2f(x,y)); 
                //graph_double.addVertex(ofVec2f(x,y+1)); 
                graph.addVertex(ofVec(x,y,z)); 
                graph_double.addVertex(ofVec(x,y+1,z)); 
            
            }
            graph.draw();
            graph_double.draw();
            
            // Draw little circles that follow the data
            float x = float((ofGetWidth()-2*W_MARGIN) * float(buf_size-1)) / float(buf_size-1) + float(W_MARGIN);
            float y = ofGetHeight() - ((ofGetHeight()-2*H_MARGIN) * buf[i].back() + float(H_MARGIN));

            ofSetColor(buf_colour[i]);
            ofNoFill();
            ofCircle(x, y, z, 5);
            ofSetColor(ofColor(255,255,255,80));
            ofFill();
            ofCircle(x, y, z, 4);

            // Write numerical value in top left-hand corner
            ofSetColor(buf_colour[i]);
            ofDrawBitmapString("Rider " + ofToString(i + 1) + " power output: "
                               + ofToString(buf[i].back()), TW_MARGIN, TH_MARGIN + i*12);

            // Send OSC messages...
            ofxOscMessage m;
            m.setAddress("/data" + ofToString(i));
            m.addFloatArg(buf[i].back());
            
            osc_sender.sendMessage(m);
        }

    //ofSetColor(ofColor(255));
    //ofDrawBitmapString("Data output rate: " + ofToString(round(ofGetFrameRate())) 
    //                   + " Hz", TW_MARGIN, TH_MARGIN + (num_bufs+1)*12);
    }

}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){
    if (key=='r')
        bRun = !bRun;
    if (key=='d')
        bDraw = !bDraw; 
}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}
