(
var index1,index2,ratio=0.01,
var0=63,var1=63,var2=63,var3=62,var4= 63,var5= 63,
var6=63,var7=63,var8=63,var9=63,var10=63,var11=63,var12=63,abc = Bus.audio(s,1);
SynthDef(\SOSkick,
	{ arg out = 0, freq = 50, modFrq = 3, modInd = 4, sust = 0.01, amp = 0.8, noiseL = 0.025, vol=0.25,rez=1;
		var pitch_contour, drum_osc, drum_lpf, drum_env;
		var beater_source, beater_hpf, beater_lpf, lpf_cutoff_contour, beater_env;
		var kick_mix;
		pitch_contour = Line.ar(freq*2, freq, 0.02);
		drum_osc = PMOsc.ar(	pitch_contour,
			modFrq,
			modInd/1.3,
			mul: 1,
			add: 0);
		drum_lpf = LPF.ar(in: drum_osc, freq: 1000, mul: 1, add: 0);
		drum_env = drum_lpf * EnvGen.ar(Env.perc(0.005, sust), 1.0, doneAction: 2);
		beater_source = WhiteNoise.ar(noiseL);
		beater_hpf = BHiPass4.ar(in: beater_source, freq: 500, mul: 1, add: 0, rq:rez);
		lpf_cutoff_contour = Line.ar(6000, 500, 0.03);
		beater_lpf = BLowPass4.ar(in: beater_hpf, freq: lpf_cutoff_contour, mul: 1, add: 0, rq:rez);
		beater_env = beater_lpf * EnvGen.ar(Env.perc(0.005, sust), 1.0, doneAction: 2);
		kick_mix = Mix.new([drum_env, beater_env]) * amp;
		kick_mix = kick_mix.clip2(1) * vol;
		Out.ar(abc, kick_mix);
		Out.ar(0, [kick_mix, kick_mix])
	}
).add;
MIDIdef.noteOn(\SOSkickSeat, {arg vel, note;
	Synth(\SOSkick,[\freq, note.midicps, \amp, vel.linexp(0,127,0.1,2),
		\modFrq,    var0.linexp(0,127,0.1,260),
		\modInd,    var1.linexp(0,127,0.01,2000),
		\sust,      var2.linlin(0,127,0.01,1),
		\noiseL,    var3.linexp(0,127,0.0025,0.25),
		\vol,       var7.linexp(0,127,0.03,1),
		\rez,       var4.linexp(0,127,0.1,10);

	]);
	~test_SOSkick = 1;
},srcID:~midiInINST1,chan: 4).permanent_(true);
MIDIdef.cc(\SOSkickCC, {arg ...args;
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
},(0..10),srcID:~midiInINST1,chan:4).permanent_(true);
SynthDef(\SOSkickDiskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(abc,1));
}).add;
)


