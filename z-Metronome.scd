(
var noteArrayMetronome = Array.newClear(128);
SynthDef(\Metronome, {arg tempo=1, filterfreq = 1000, rq=1.0, gate = 1, amp = 1, release = 1, pitch;
	var env, signal, gen;
	var rho, theta, b1, b2;
	b1 = 2 * 0.996839 * cos(0.0931624);
	b2 = 0.996839.squared.neg;
	env = Env.adsr(0.02, release, amp);
	gen = EnvGen.ar(env, gate, doneAction: 2);
	signal = SOS.ar(gen, 1.0, 0.0, 0.0, b1, b2);
	signal = RHPF.ar(signal, pitch, rq);
	DetectSilence.ar(signal,doneAction: 2);
	Out.ar(0, 0.15 * Pan2.ar(signal, 0));
}).add;
MIDIdef.noteOn(\MetronomeController, {arg vel, note;
	noteArrayMetronome[note] = Synth(\Metronome,[\pitch, note.midicps, \amp, vel.linlin(0,127,0,0.9),\gate, 1,]);
},srcID:~midiInINST5,chan: 15).permanent_(true);
/*MIDIdef.noteOff(\noteoffmykeyMetronome, {arg vel, note;
	noteArrayMetronome[note].set(\gate,0);
},srcID:~midiInINST5,chan:15).permanent_(true);*/
)