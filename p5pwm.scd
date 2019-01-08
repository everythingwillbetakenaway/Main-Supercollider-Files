(
/*
env = EnvGen.ar(Env.adsr(0.0,1.0,0.2,1.5),gate,doneAction:2);

filter = RLPF.ar(pulse,(cutoff*(env.squared))+100,rq);
*/
var
nova = ParGroup.new,
vr = Array.fill(128, 63),
defme,
noteArrayP5pwm = Array.newClear(128);
SynthDef(\P5pwm,{|out= 0 freq = 440 amp = 1.0 gate=1 lfoRt = 10 lfoWdt= 0.5 fltCut= 12000 fltRes = 0.5 volAtk = 0.01 volRel = 0.5 pan = 0.0 totVol = 0.5 pitch = 0 volDec = 0.5 fltAtk = 0.01 fltRel = 0.5 fltDec = 0.01 fltSus = 0.5 envDep = 1|
	var lfo, pulse, filter, env, env2, outputstage;
	lfo = LFTri.ar(lfoRt*[1,1.01],Rand(0,2.0)!2);
	pulse = Pulse.ar((freq.midicps)*[1,1.01],lfo*lfoWdt+0.5);
	env2 = EnvGen.ar(Env.adsr(
		attackTime: fltAtk,
		decayTime: fltDec,
		sustainLevel: fltSus,
		releaseTime: fltRel),gate, levelScale: envDep,doneAction:0);
	filter = RLPF.ar(pulse,((fltCut + (freq * pitch) + env2).clip(2,124)).midicps,fltRes);
	env = EnvGen.ar(Env.adsr(
		attackTime: volAtk,
		decayTime: 0.1,
		sustainLevel: gate,
		releaseTime: volRel),gate,doneAction:2);
	outputstage = Mix(filter)*env * 0.25 * ((totVol + amp -15).dbamp); // * amp *totVol;
	Out.ar(1,outputstage);
}).add;
defme = { arg a1,b1,c1; var a =
	[
		\fltCut,   vr[0],
		\fltRes,   vr[1].linexp(0,127,1,0.01),
		\volAtk,   vr[2].linexp(0,127,0.0001,1),
		\volRel,   vr[3].linexp(0,127,0.05,5),
		\lfoRt,    vr[4].linexp(0,127,0.1,1000),
		\lfoWdt,    vr[5].linexp(0,127,0.05,5),
		//
		\totVol, vr[7].linlin(0,127,-24,24),
		\pitch,  vr[6].linlin(0,127,-1,1),
		\envDep, vr[8].linlin(0,127,-127,127),
		\fltAtk, vr[9].linexp(0,127,0.0001,10),
		\fltDec, vr[10].linexp(0,127,0.0001,10),
		\fltSus, vr[11].linlin(0,127,0,1),
		\fltRel, vr[12].linexp(0,127,0.05,5),
	];
	if(a1 == 1) { [\freq, b1, \amp, c1.linlin(0,127,-12,12)] ++ a} {a}};
MIDIdef.noteOn(\P5pwmController, {arg vel, note;
	if(noteArrayP5pwm[note] !== nil,noteArrayP5pwm[note].free);
	noteArrayP5pwm[note] = Synth(\P5pwm,defme.value(1, note, vel),nova);
	~test_P5pwm = 1;
},srcID:~midiInINST4,chan: 1).permanent_(true);
MIDIdef.noteOff(\noteoffmykeyP5pwm, {arg vel, note;
	noteArrayP5pwm[note].set(\gate,0);
	noteArrayP5pwm[note] = nil;
},srcID:~midiInINST4,chan:1).permanent_(true);
MIDIdef.cc(\P5pwmCC, {arg ...args;
	vr[args[1]] = args[0];
	nova.setControls(defme.value(0));
},(0..10),srcID:~midiInINST4,chan:1).permanent_(true);
)