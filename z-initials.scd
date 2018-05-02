(
Server.scsynth;
s.options.device ="Babyface Pro (70795866)";     // use a specific soundcard
s.options.numOutputBusChannels =12;
s.options.numInputBusChannels =4;

MIDIIn.connectAll;

~midiInINST1= MIDIIn.findPort("Cirklon", "Port 1").asMIDIInPortUID;
~midiInINST2= MIDIIn.findPort("Cirklon", "Port 2").asMIDIInPortUID;
~midiInINST3= MIDIIn.findPort("Cirklon", "Port 3").asMIDIInPortUID;
~midiInINST4= MIDIIn.findPort("Cirklon", "Port 4").asMIDIInPortUID;
~midiInINST5= MIDIIn.findPort("Cirklon", "Port 5").asMIDIInPortUID;
~midiInINST6= MIDIIn.findPort("Cirklon", "Port 6").asMIDIInPortUID;

~test_DPG1 = 1;
~test_DPG2 = 1;

s.options.hardwareBufferSize = 64;//orj 256
s.options.maxNodes = 2048;
s.options.numWireBufs = 1024;
s.options.memSize = 131072 * 16;
s.options.sampleRate = 44100;
s.options.blockSize = 32;//orjj 32
s.options.numBuffers = 2048;
s.latency = 0.02; //uncomment here
//s.recSampleFormat = float
s.options.verbosity = -2; //IMPORTANT ALWAYS OPEN
s.boot;
s.waitForBoot({
	"z-SampleReader.scd".loadRelative;
	"DX7.scd".loadRelative;
	"DX8.scd".loadRelative;


	"3030303.scd".loadRelative;
	"Appajax-2000.scd".loadRelative;
	//"Inferno.scd".loadRelative;
	"Lumbricost.scd".loadRelative;
	"Manchun.scd".loadRelative;
	"Masibo.scd".loadRelative;
	"Massaka.scd".loadRelative;
	"p5pwm.scd".loadRelative;
	"senjin.scd".loadRelative;
});

//cirklon port1 -> make noise sequence etmek icin cv out u var
~midiOutKey = MIDIOut.newByName("Cirklon", "Port 2").latency_(0.02);
//cirklon port3 -> infernoya midi mesajlari yollamak icin var,

/*FOR USB MIDI KEYBOARDS
MIDIdef.noteOn(\notenote,
	{arg vel, note, chan, srci;
		//[vel, note, chan, srci].postln;
		~midiOutKey.noteOn(1, note, vel);
},srcID:~midiKeyboard).permanent_(true);
MIDIdef.noteOff(\notenoteOFF,
	{arg vel, note, chan, srci;
		//[note, vel, chan, srci].postln;
		~midiOutKey.noteOff(1, note, vel);
},srcID:~midiKeyboard).permanent_(true);
*/
)
