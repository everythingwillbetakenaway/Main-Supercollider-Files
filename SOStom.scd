(
var index1,index2,ratio=0.01,
var0=63,var1=63,var2=63,var3=62,var4= 63,var5= 63,
var6=63,var7=63,var8=63,var9=63,var10=63,var11=63,var12=63,
abc = Bus.audio(s,1);
SynthDef(\SOStom,
	{arg out = 0, sust = 0.4, drmLvl = 0.25,
		freq = 90, timbre = 1.0, amp = 0.8, totVol = 0.9;
		var drum_mode_sin_1, drum_mode_sin_2, drum_mode_pmosc, drum_mode_mix, drum_mode_env;
		var stick_noise, stick_env;
		var drum_reson, tom_mix;

		drum_mode_env = EnvGen.ar(Env.perc(0.005, sust), 1.0, doneAction: 2);
		drum_mode_sin_1 = SinOscFB.ar(freq*0.8, 0.2, drum_mode_env * 0.5);
		drum_mode_sin_2 = SinOscFB.ar(freq, 0.2, drum_mode_env * 0.5);
		drum_mode_pmosc = PMOsc.ar(	Saw.ar(freq*0.9),
			freq*0.85,
			timbre/1.3,
			mul: drum_mode_env*5,
			add: 0);
		drum_mode_mix = Mix.new([drum_mode_sin_1, drum_mode_sin_2, drum_mode_pmosc]) * drmLvl;
		stick_noise = Crackle.ar(2.01, 1);
		stick_env = EnvGen.ar(Env.perc(0.005, 0.01 * 2.5 * sust), 1.0) * 3;
		tom_mix = Mix.new([drum_mode_mix, stick_env]) * 2 * amp;
		tom_mix = tom_mix.clip2(1) * totVol;
		Out.ar(abc, tom_mix);
		Out.ar(out, [tom_mix, tom_mix])

	}
).add;
MIDIdef.noteOn(\SOStomController, {arg vel, note;
	Synth(\SOStom,[\freq, note.midicps, \amp, vel.linexp(0,127,0.1,2),
		\drmLvl,  var0.linexp(0,127,0.025,2.5),
		\timbre,   var1.linexp(0,127,0.1,10),
		\sust,      var2.linexp(0,127,0.04,4),
		\trigRt, var3.linexp(0,127,1,400),
		\attk,   var4.linexp(0,127,0.0001,5),
		\rel,    var5.linexp(0,127,0.01,30),
		//
		\totVol, var7.linexp(0,127,0.03,1);]);
	~test_SOStom = 1;

},srcID:~midiInINST1,chan: 6).permanent_(true);
MIDIdef.cc(\SOStomCC, {arg ...args;
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
},(0..10),srcID:~midiInINST1,chan:6).permanent_(true);
SynthDef(\SOStomDiskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(abc,1));
}).add;
)
