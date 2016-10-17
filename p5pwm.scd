(
/*
env = EnvGen.ar(Env.adsr(0.0,1.0,0.2,1.5),gate,doneAction:2);

	filter = RLPF.ar(pulse,(cutoff*(env.squared))+100,rq);
*/
var var0=63,var1=63,var2=63,var3=63,var4=63,var5=63,var6=63,
var7=63,var8=63,var9=63,var10=63,var11=63,var12=63,var13=63,
noteArrayP5pwm = Array.newClear(128),
abc = Bus.audio(s,1),
index1,index2;
SynthDef(\P5pwm,{|out= 0 freq = 440 amp = 1.0 gate=1 lfoRt = 10 lfoWdt= 0.5 fltCut= 12000 fltRes = 0.5 volAtk = 0.01 volRel = 0.5 pan = 0.0 totVol = 0.5|
	var lfo, pulse, filter, env, outputstage;
	lfo = LFTri.ar(lfoRt*[1,1.01],Rand(0,2.0)!2);
	pulse = Pulse.ar(freq*[1,1.01],lfo*lfoWdt+0.5);
	filter = RLPF.ar(pulse,fltCut,fltRes);
	env = EnvGen.ar(Env.adsr(
		attackTime: volAtk,
		decayTime: 0.1,
		sustainLevel: gate,
		releaseTime: volRel),gate,doneAction:2);
	outputstage = Mix(filter)*env * 0.25 * ((totVol + amp -15).dbamp); // * amp *totVol;
	Out.ar(abc,outputstage);
	Out.ar(out,Pan2.ar(outputstage, pan));
}).add;
MIDIdef.noteOn(\P5pwmController, {arg vel, note;
	if(noteArrayP5pwm[note] !== nil,noteArrayP5pwm[note].free);
	noteArrayP5pwm[note] = Synth(\P5pwm,[\freq, note.midicps, \amp, vel.linlin(0,127,-12,12),\gate, 1,
		\fltCut,   (var0).midicps,
		\fltRes,   var1.linexp(0,127,1,0.01),
		\volAtk,   var2.linexp(0,127,0.0001,1),
		\volRel,   var3.linexp(0,127,0.05,5),
		\lfoRt,    var4.linexp(0,127,0.1,1000),
		\lfoWdt,    var5.linexp(0,127,0.05,5),
		//
		\totVol, var7.linlin(0,127,-24,24);]);
	~test_P5pwm = 1;
},srcID:~midiInINST4,chan: 1).permanent_(true);
MIDIdef.noteOff(\noteoffmykeyP5pwm, {arg vel, note;
	noteArrayP5pwm[note].set(\gate,0);
	noteArrayP5pwm[note] = nil;
},srcID:~midiInINST4,chan:1).permanent_(true);
MIDIdef.cc(\P5pwmCC, {arg ...args;
	index1 = args[1];
	index2 = args[0];
	x = case
	{ index1 == 0 }   { var0=index2;}
	{ index1 == 1 }   { var1=index2;}
	{ index1 == 2 }   { var2=index2;}
	{ index1 == 3 }   { var3=index2;}
	{ index1 == 4 }   { var4=index2;}
	{ index1 == 5 }   { var5=index2;}
	{ index1 == 6 }   { var6=index2;}
	{ index1 == 7 }   { var7=index2;}
	{ index1 == 8 }   { var8=index2;}
	{ index1 == 9 }   { var9=index2;}
	{ index1 == 10}   { var10=index2;}
	{ index1 == 11}   { var11=index2;}
	{ index1 == 12}   { var12=index2;};
},(0..10),srcID:~midiInINST4,chan:1).permanent_(true);
SynthDef(\P5pwmDiskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(abc,1));
}).add;
)