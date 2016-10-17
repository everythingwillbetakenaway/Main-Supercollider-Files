(
var
var0=63,var1=63,var2=63,var3  =63,var4 =63, var5=63, var6  =63,
var7=63,var8=63,var9=63,var10=63,var11=63,var12=63,var13=63,
abc = Bus.audio(s,1),
index1,index2;
SynthDef(\Lumbricost, {arg attTim= 1,relTim=2.5,amp = 1 ,scale= 6, offset = 40,synch = 10, timescale = 10, widthmod = 0.4, width = 0.2, totVol;
	var generation =
	Pulse.ar(SinOsc.kr(5/synch, mul: scale, add: offset),EnvGen.kr(Env.perc(0.01, relTim), Impulse.ar(30/synch),widthmod,width,timescale), mul: 0.1) +
	Pulse.ar(SinOsc.kr(7/synch, mul: scale, add: offset),EnvGen.kr(Env.perc(0.01, relTim), Impulse.ar(7/synch),widthmod,width,timescale), mul: 0.1) +
	Pulse.ar(SinOsc.kr(9/synch, mul: scale, add: offset),EnvGen.kr(Env.perc(0.01, relTim), Impulse.ar(2/synch),widthmod,width,timescale), mul: 0.1) +
	Pulse.ar(SinOsc.kr(10/synch, mul: scale, add: offset),EnvGen.kr(Env.perc(0.01, relTim), Impulse.ar(5/synch),widthmod,width,timescale), mul: 0.1) +
	Pulse.ar(SinOsc.kr(3/synch, mul: scale, add: offset),EnvGen.kr(Env.perc(0.01, relTim), Impulse.ar(9/synch),widthmod,width,timescale), mul: 0.1) +
	Pulse.ar(SinOsc.kr(2/synch, mul: scale, add: offset),EnvGen.kr(Env.perc(0.01, relTim), Impulse.ar(40/synch),widthmod,width,timescale), mul: 0.1);
	var env = generation * Env.perc(attackTime:attTim,releaseTime: relTim).ar(2);
	var env1 = LeakDC.ar(env);
	var out =  env1* ((totVol + amp -15).dbamp);
	Out.ar([0,1],out);
	Out.ar(abc, out);
}).add;
MIDIdef.noteOn(\LumbricostController, {arg vel, note;
	Synth(\Lumbricost,[\offset, note.midicps, \amp, vel.linlin(0,127,-12,12), \gate, 1,
		\scale,   var0.linexp(0,127,0.005,500),
		\synch,  var1.linexp(0,127,0.001,1000),
		\timescale,   var2.linexp(0,127,0.001,10),
		\widthmod,   var3.linlin(0,127,0,1),
		\width,  var4.linexp(0,127,0.01,1),
		\relTim,    var5.linexp(0,127,0.01,2.5),
		//
		\attTim,  var6.linexp(0,127,0.001,1),
		\totVol, var7.linlin(0,127,-24,24);]);
	~test_Lumbricost = 1;
},srcID:~midiInINST6,chan: 6).permanent_(true);
MIDIdef.cc(\LumbricostCC, {arg ...args;
	index1 = args[1];
	index2 = args[0];
	x = case
	{ index1 == 0 }    { var0=index2;}
	{ index1 == 1 }    { var1=index2;}
	{ index1 == 2 }    { var2=index2;}
	{ index1 == 3 }    { var3=index2;}
	{ index1 == 4 }    { var4=index2;}
	{ index1 == 5 }    { var5=index2;}
	{ index1 == 6 }    { var6=index2;}
	{ index1 == 7 }    { var7=index2;}
	{ index1 == 8 }    { var8=index2;}
	{ index1 == 9 }    { var9=index2;}
	{ index1 == 10}   { var10=index2;}
	{ index1 == 11}   { var11=index2;}
	{ index1 == 12}   { var12=index2;};
},(0..10),srcID:~midiInINST6,chan:6).permanent_(true);
SynthDef(\LumbricostDiskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(abc,1));
}).add;
)