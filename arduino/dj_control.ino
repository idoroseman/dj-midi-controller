// this code is for MH-??? handhelp microphone

#include "MIDIUSB.h"

int pttPin = A0;
int b1Pin = A4;
int b2Pin = A5;

bool needFlush = false;
int prev_ptt = 1;
int prev_key = -1;

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

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  needFlush = false;

  int ptt = digitalRead(pttPin);
  if (ptt != prev_ptt)
  {
    needFlush = true;
    Serial.print("ptt ");
    Serial.print(ptt);
    Serial.println();
    noteOn(1, 60, 127);
    noteOff(1, 60, 127);
    prev_ptt = ptt;
  }
  
  int col = rton(analogRead(b1Pin));
  int row = rton(analogRead(b2Pin));
  int key = -1;
  if ((col > -1) && (row > -1))
    key = row * 5 + col;
  if (key != prev_key)
  {
    needFlush = true;
    if (key == -1)
      noteOff(0, 30+prev_key, 64);
    else
      noteOn(0, 30+key, 64);
    prev_key = key;
  }

  if (needFlush)
    MidiUSB.flush();
  delay(10);
}

int rton(int v)
{
  if (v>1010)
    return -1;
  if (v>950)
    return 4;
  if (v>850)
    return 3;
  if (v>730)
    return 2;
  if (v>500)
    return 1;
  return 0;
}
