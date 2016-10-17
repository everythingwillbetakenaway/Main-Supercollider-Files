(
var index1,index2,ratio=0.01,
var0=63,var1=63,var2=63,var3=62,var4= 63,var5= 63,
var6=63,var7=63,var8=63,var9=63,var10=63,var11=63,var12=63,abc = Bus.audio(s,1);
SynthDef(\SOShats,
	{arg out = 0, freq = 6000, sust = 0.1, amp = 0.8, totVol = 0.5, rez = 1;
		var root_cymbal, root_cymbal_square, root_cymbal_pmosc;
		var initial_bpf_contour, initial_bpf, initial_env;
		var body_hpf, body_env;
		var cymbal_mix;

		root_cymbal_square = Pulse.ar(freq, 0.5, mul: 1);
		root_cymbal_pmosc = PMOsc.ar(root_cymbal_square,
			[freq*1.34, freq*2.405, freq*3.09, freq*1.309],
			[310/1.3, 26/0.5, 11/3.4, 0.72772],
			mul: 1,
			add: 0);
		root_cymbal = Mix.new(root_cymbal_pmosc);
		initial_bpf_contour = Line.ar(15000, 9000, 0.1);
		initial_env = EnvGen.ar(Env.perc(0.005, sust), 1.0);
		initial_bpf = BPF.ar(root_cymbal, initial_bpf_contour, mul:initial_env,rq:rez);
		body_env = EnvGen.ar(Env.perc(0.005, sust, 1, -2), 1.0, doneAction: 2);
		body_hpf = BHiPass4.ar(in: root_cymbal, freq: Line.ar(9000, 12000, sust),mul: body_env, add: 0, rq: rez);
		cymbal_mix = Mix.new([initial_bpf, body_hpf]) * amp;
		cymbal_mix = cymbal_mix.softclip(1) * totVol;
		Out.ar(abc, cymbal_mix);
		Out.ar(out, [cymbal_mix, cymbal_mix])
}).add;
MIDIdef.noteOn(\SOShatsController, {arg vel, note;
	Synth(\SOShats,[\freq, note.midicps, \amp, vel.linexp(0,127,0.1,1),
		\rez,  var0.linlin(0,127,0.34,1.4),
		\rand,   var1.linexp(0,127,0.75,1.33966),
		\sust,   var2.linexp(0,127,0.01,1),
		\trigRt, var3.linexp(0,127,1,400),
		\attk,   var4.linexp(0,127,0.0001,5),
		\rel,    var5.linexp(0,127,0.01,10),
		//
		\totVol, var7.linexp(0,127,0.01,1);]);
	~test_SOShats = 1;
},srcID:~midiInINST1,chan:7).permanent_(true);
MIDIdef.cc(\SOShatsCC, {arg ...args;
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
},(0..10),srcID:~midiInINST1,chan:7).permanent_(true);
SynthDef(\SOShatsDiskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(abc,1));
}).add;
)

