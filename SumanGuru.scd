(
var var0=63,var1=63,var2=63,var3=63,var4=63,var5=63,var6=63,var7=63,index1,index2,abc = Bus.audio(s,1);
SynthDef(\Sumanguru, {arg freq,amp,
	feedB,rand,reverb,trigRt,attk,rel,
	totVol;
	var triggerSpeed = (freq/trigRt);
	var trigger = Impulse.ar(triggerSpeed);
	var simpleEnv = Env.perc(attackTime:attk,releaseTime: rel,).ar(2);
	var main = SinOscFB.ar(TExpRand.kr(freq/rand,freq*rand,trigger),feedB,
		mul:EnvGen.ar(Env.perc(0.5/triggerSpeed, 0.5/triggerSpeed),trigger)) * simpleEnv;
	var out = FreeVerb.ar(main,mix:reverb,room:reverb,damp:0.5);
	out = out *((totVol + amp -15).dbamp);
	Out.ar(abc, out);
	Out.ar([0,1],out)
}).add;
MIDIdef.noteOn(\SumanguruController, {arg vel, note;
	Synth(\Sumanguru,[\freq, note.midicps, \amp, vel.linlin(0,127,-12,12),
		\feedB,  var0.linexp(0,127,0.01,3000),
		\rand,   var1.linexp(0,127,0.75,1.33966),
		\reverb, var2.linlin(0,127,0.01,1),
		\trigRt, var3.linexp(0,127,1,400),
		\attk,   var4.linexp(0,127,0.0001,5),
		\rel,    var5.linexp(0,127,0.01,30),
		//
		\totVol, var7.linlin(0,127,-24,24);]);
	~test_Sumanguru = 1;
},srcID:~midiInINST4,chan: 0).permanent_(true);
MIDIdef.cc(\SumanguruCC, {arg ...args;
	index1 = args[1];
	index2 = args[0];
	x = case
	{ index1 == 0 }   { var0=index2;}
	{ index1 == 1 }   { var1=index2;}
	{ index1 == 2 }   { var2=index2;}
	{ index1 == 3 }   { var3=index2;}
	{ index1 == 4 }   { var4=index2;}
	{ index1 == 5 }   { var5=index2;}
	{ index1 == 7 }   { var7=index2;};
},(0..10),srcID:~midiInINST4,chan:0).permanent_(true);
SynthDef(\SumanguruDiskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(abc,1));
}).add;
)
