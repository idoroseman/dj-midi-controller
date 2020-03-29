
#include "MIDIUSB.h"

#define NUM_ANALOG 1
#define NUM_DIGITAL 5

int prevAnalog[NUM_ANALOG];
int prevDigital[NUM_DIGITAL];

bool needFlush = false;

void noteOn(byte channel, byte pitch, byte velocity) {
  midiEventPacket_t noteOn = {0x09, 0x90 | channel, pitch, velocity};
  MidiUSB.sendMIDI(noteOn);
}

void noteOff(byte channel, byte pitch, byte velocity) {
  midiEventPacket_t noteOff = {0x08, 0x80 | channel, pitch, velocity};
  MidiUSB.sendMIDI(noteOff);
}

void controlChange(byte channel, byte control, byte value) {
  midiEventPacket_t event = {0x0B, 0xB0 | channel, control, value};
  MidiUSB.sendMIDI(event);
}

void setup(){
  Serial.begin(9600);
}
  
void loop()
{
  needFlush = false;
  for (int d=0; d<NUM_ANALOG; d++)
  {
    int val = analogRead(A0+d);  // Read the voltage
    val = map(val, 0, 1024, 0, 127);
    if (prevAnalog[d] != val)
    {
      noteOn(3, 16+d, val );
      prevAnalog[d] = val;
      needFlush = true;
    }
  }
  
  for (int d=0; d<NUM_DIGITAL; d++)
  {
    int val = digitalRead(d);  // Read the voltage
    if (prevDigital[d] != val)
    {
      noteOn(3, 32+d, val );
      prevDigital[d] = val;
      needFlush = true;
    }
  }
  
  if (needFlush)
    MidiUSB.flush();

  delay(1);
}
