#include <Encoder.h> // Include the Encoder library.
#include <Control_Surface.h> // Include the Control Surface library
   
// Instantiate a MIDI over USB interface.
USBMIDI_Interface midi;

// I use banks to alternate enc1 between normal & 10x tune
// bank is selected by button5 (see below)
Bank<2> bank(1); // A bank with four channels, and 2 bank settings
 
// Instantiate a CCRotaryEncoder object
//                        pins // MIDI address // multiplier
Bankable::CCRotaryEncoder enc1 = { {bank, BankType::CHANGE_CHANNEL}, {A0, 14}, MCU::V_POT_1,  1, };
CCRotaryEncoder enc2 = { {4, 3}, MCU::V_POT_2,  1, };
CCRotaryEncoder enc3 = { {7, 6}, MCU::V_POT_3,  1, };
CCButton button1 = { 10, {MIDI_CC::General_Purpose_Controller_1, CHANNEL_1}, }; //enc1 button
CCButton button2 = { 2, {MIDI_CC::General_Purpose_Controller_2, CHANNEL_1}, }; // enc2 button
CCButton button3 = { 5, {MIDI_CC::General_Purpose_Controller_3, CHANNEL_1}, }; // enc3 buttpm
CCButton button4 = { 8, {MIDI_CC::General_Purpose_Controller_4, CHANNEL_1}, }; // tx toggle
//CCButton button5 = { 9, {MIDI_CC::General_Purpose_Controller_5, CHANNEL_1}, };
CCButton button6 = { 16, {MIDI_CC::General_Purpose_Controller_5, CHANNEL_1},}; // A/B rx switch


SwitchSelector selector = {bank, 9}; // button 5 is used for course/fine frequency tune

void setup() {
  // this is needed for my hardware, where enc1 gets ground signal from pin 15 of arudino 
  pinMode(15, OUTPUT);
  digitalWrite(15, LOW);

  RelativeCCSender::setMode(relativeCCmode::MACKIE_CONTROL_RELATIVE);
  Control_Surface.begin(); // Initialize Control Surface
}

void loop() {
  Control_Surface.loop(); // Update the Control Surface
}
