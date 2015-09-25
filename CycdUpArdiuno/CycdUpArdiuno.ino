
int analogVals[4];

void setup() {
  Serial.begin(57600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
  }
}

void loop() {
  
  analogVals[0] = analogRead(A0);
  analogVals[1] = analogRead(A1);
  analogVals[2] = analogRead(A2);
  analogVals[3] = analogRead(A3);
  
  for (int i=0; i<4; i++) {
    
    Serial.write(0xff);
    Serial.write(0xff);
    Serial.write(i);
    Serial.write(lowByte(analogVals[i]));
    Serial.write(highByte(analogVals[i]));
    
  }
  delay(10);
}
