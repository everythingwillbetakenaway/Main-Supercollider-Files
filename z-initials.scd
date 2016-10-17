(
Server.supernova;
//s.options.device ="Forte";     // use a specific soundcard
s.options.numOutputBusChannels =4;

~midiInINST1= MIDIIn.findPort("Cirklon", "Port 1").asMIDIInPortUID;
~midiInINST2= MIDIIn.findPort("Cirklon", "Port 2").asMIDIInPortUID;
~midiInINST3= MIDIIn.findPort("Cirklon", "Port 3").asMIDIInPortUID;
~midiInINST4= MIDIIn.findPort("Cirklon", "Port 4").asMIDIInPortUID;
~midiInINST5= MIDIIn.findPort("Cirklon", "Port 5").asMIDIInPortUID;
~midiInINST6= MIDIIn.findPort("Cirklon", "Port 6").asMIDIInPortUID;
~test_DPG1 = 1;
~test_DPG2 = 1;

s.options.hardwareBufferSize = 256;//orj
s.options.maxNodes = 2048;
s.options.numWireBufs = 1024;
s.options.memSize = 131072 * 16;
s.options.sampleRate = 44100;
s.options.blockSize = 32;//orjj
s.options.numBuffers = 2048;
s.latency = 0.02;
//s.options.verbosity = -2;

MIDIIn.connectAll;
s.boot;
s.waitForBoot({
	"z-SampleReader.scd".loadRelative;

	"acid.scd".loadRelative;
	"Appajax-2000.scd".loadRelative;
	"DPG2.scd".loadRelative;
	"DrumSmpl.scd".loadRelative;
	"Etna.scd".loadRelative;
	//"Inferno.scd".loadRelative;
	"Lumbricost.scd".loadRelative;
	"Manchun.scd".loadRelative;
	"Masibo.scd".loadRelative;
	"Massaka.scd".loadRelative;
	"p5pwm.scd".loadRelative;
	"senjin.scd".loadRelative;
	"SOShats.scd".loadRelative;
	"SOStom.scd".loadRelative;
	"SOSkick.scd".loadRelative;
	"SOSsnare.scd".loadRelative;
	"SumanGuru.scd".loadRelative;
	"THE WITCH PLANE.scd".loadRelative;

	Routine {5.5.wait;"z-Metronome.scd".loadRelative(action: {"a".speak;})}.play;
	//Routine {2.5.wait;"SampleReader.scd".loadRelative}.play;
	//Routine {2.6.wait;"Masibo.scd".loadRelative}.play;
	v = s.volume;
	v.volume = -3;

});

//cirklon port1 -> make noise sequence etmek icin cv out u var
~midiOutKey = MIDIOut.newByName("Cirklon", "Port 2").latency_(0.001);
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