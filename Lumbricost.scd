(
var
nova = ParGroup.new,
vr = Array.fill(128, 63),
defme;
SynthDef(\Lumbricost, {arg attTim= 1,relTim=2.5,amp = 1 ,scale= 6, offset = 40,synch = 10, timescale = 10, widthmod = 0.4, width = 0.2, totVol, reso, mode, fltDep, fltFrq, relFlt, attFlt, fltFlw;
	var generation =
	Pulse.ar(SinOsc.kr(5/synch, mul: scale, add: offset),EnvGen.kr(Env.perc(0.01, relTim), Impulse.ar(30/synch),widthmod,width,timescale), mul: 0.1) +
	Pulse.ar(SinOsc.kr(7/synch, mul: scale, add: offset),EnvGen.kr(Env.perc(0.01, relTim), Impulse.ar(7/synch),widthmod,width,timescale), mul: 0.1) +
	Pulse.ar(SinOsc.kr(9/synch, mul: scale, add: offset),EnvGen.kr(Env.perc(0.01, relTim), Impulse.ar(2/synch),widthmod,width,timescale), mul: 0.1) +
	Pulse.ar(SinOsc.kr(10/synch, mul: scale, add: offset),EnvGen.kr(Env.perc(0.01, relTim), Impulse.ar(5/synch),widthmod,width,timescale), mul: 0.1) +
	Pulse.ar(SinOsc.kr(3/synch, mul: scale, add: offset),EnvGen.kr(Env.perc(0.01, relTim), Impulse.ar(9/synch),widthmod,width,timescale), mul: 0.1) +
	Pulse.ar(SinOsc.kr(2/synch, mul: scale, add: offset),EnvGen.kr(Env.perc(0.01, relTim), Impulse.ar(40/synch),widthmod,width,timescale), mul: 0.1);
	var env = generation * Env.perc(attackTime:attTim,releaseTime: relTim).ar(2);
	var env2 = Env.perc(attackTime:attFlt,releaseTime: relFlt,level: fltDep).ar(2);
	var filterme = BMoog.ar(env, Clip.kr(fltFrq + env2 + (fltFlw * offset), 20, 20000), reso , mode);
	var env1 = LeakDC.ar(filterme);
	var out =  env1* ((totVol + amp -15).dbamp);
	Out.ar(1,out);
}).add;
defme = { arg a1,b1,c1; var a =
	[
		\scale,   vr[0].linexp(0,127,0.005,500),
		\synch,  vr[1].linexp(0,127,0.001,1000),
		\timescale,   vr[2].linexp(0,127,0.001,10),
		\widthmod,   vr[3].linlin(0,127,0,1),
		\width,  vr[4].linexp(0,127,0.01,1),
		\relTim,    vr[5].linexp(0,127,0.01,2.5),
		//
		\attTim,  vr[6].linexp(0,127,0.001,1),
		\totVol, vr[7].linlin(0,127,-24,24),
		\fltFrq, vr[8].linexp(0,127,50,19000),
		\reso, vr[9].linlin(0,127,0,1),
		\mode, vr[10].linlin(0,127,0,3),
		\fltFlw, vr[11].linlin(0,127,0,1),
		//\fltEnv, ((20000-vr[8].linexp(0,127,50,19000)) * vr[11].linlin(0,127,0,1)),
		//
		\attFlt, vr[12].linexp(0,127,0.0001,5.5),
		\relFlt, vr[13].linexp(0,127,0.01,30),
	];
	if(a1 == 1) { [
		\offset, b1.midicps,
		\amp, c1.linlin(0,127,-12,12),
		\fltDep, ((20000-vr[8].linexp(0,127,50,19000) - (b1.midicps * vr[11].linlin(0,127,0,1))) * vr[14].linlin(0,127,0,1))
	] ++ a} {a}
};
MIDIdef.noteOn(\LumbricostController, {arg vel, note;
	Synth(\Lumbricost,defme.value(1, note, vel),nova);
	~test_Lumbricost = 1;
},srcID:~midiInINST6,chan: 6).permanent_(true);
MIDIdef.cc(\LumbricostCC, {arg ...args;
	vr[args[1]] = args[0];
	nova.setControls(defme.value(0));
},(0..20),srcID:~midiInINST6,chan:6).permanent_(true);
)