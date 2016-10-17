(
var index1,index2,ratio=0.01,
var0=63,var1=63,var2=63,var3=62,var4= 63,var5= 63,
var6=63,var7=63,var8=63,var9=63,var10=63,var11=63,var12=63,
abc = Bus.audio(s,1);
SynthDef(\SOSsnare,
	{arg out = 0, sust = 0.1, drmLvl = 0.25,
		snrLvl = 40, tight = 1000,totVol = 0.5,
		freq = 405, amp = 0.8;
		var drum_mode_sin_1, drum_mode_sin_2, drum_mode_pmosc, drum_mode_mix, drum_mode_env;
		var snare_noise, snare_brf_1, snare_brf_2, snare_brf_3, snare_brf_4, snare_reson;
		var snare_env;
		var snare_drum_mix;

		drum_mode_env = EnvGen.ar(Env.perc(0.005, sust), 1.0, doneAction: 2);
		drum_mode_sin_1 = SinOscFB.ar(freq*0.53, 0.5, drum_mode_env * 0.5);
		drum_mode_sin_2 = SinOscFB.ar(freq, 0.5, drum_mode_env * 0.5);
		drum_mode_pmosc = PMOsc.ar(	Saw.ar(freq*0.85),
			184,
			0.5/1.3,
			mul: drum_mode_env*5,
			add: 0);
		drum_mode_mix = Mix.new([drum_mode_sin_1, drum_mode_sin_2, drum_mode_pmosc]) * drmLvl;

		// choose either noise source below
		//	snare_noise = Crackle.ar(1.2, 1);
		snare_noise = LFNoise0.ar(20000, 0.1);
		snare_env = EnvGen.ar(Env.perc(0.005, sust), 1.0, doneAction: 2);
		snare_brf_1 = BRF.ar(in: snare_noise, freq: 8000, mul: 0.5, rq: 0.1);
		snare_brf_2 = BRF.ar(in: snare_brf_1, freq: 5000, mul: 0.5, rq: 0.1);
		snare_brf_3 = BRF.ar(in: snare_brf_2, freq: 3600, mul: 0.5, rq: 0.1);
		snare_brf_4 = BRF.ar(in: snare_brf_3, freq: 2000, mul: snare_env, rq: 0.0001);
		snare_reson = Resonz.ar(snare_brf_4, tight, mul: snrLvl) ;
		snare_drum_mix = Mix.new([drum_mode_mix, snare_reson]) * amp;
		snare_drum_mix = snare_drum_mix.clip2(1) * totVol;
		Out.ar(abc, snare_drum_mix);
		Out.ar(out, [snare_drum_mix, snare_drum_mix]);

	}
).add;
MIDIdef.noteOn(\SOSsnareController, {arg vel, note;
	Synth(\SOSsnare,[\freq, note.midicps, \amp, vel.linexp(0,127,0.1,5),
		\snrLvl,  var0.linexp(0,127,0.4,4000),
		\drmLvl,   var1.linexp(0,127,0.0025,25),
		\sust,   var2.linexp(0,127,0.01,1),
		\tight, var3.linexp(0,127,100,10000),
		\totVol, var7.linexp(0,127,0.02,1),
		\rel,    var5.linexp(0,127,0.01,30)
		//
		;]);
	~test_SOSsnare = 1;
},srcID:~midiInINST1,chan: 5).permanent_(true);
MIDIdef.cc(\SOSsnareCC, {arg ...args;
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
},(0..10),srcID:~midiInINST1,chan:5).permanent_(true);
SynthDef(\SOSsnareDiskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(abc,1));
}).add;
)

