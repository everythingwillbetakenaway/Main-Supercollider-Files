(
var index1,index2,ratio=0.01,//ratio 1 ve 2 seklinde iki tane yap birtanesi amp
var0=63,var1=63,var2=63,var3=62,var4=63,var5= 63,var6= 63,
var7=63,var8=63,var9=63,var10=63,var11=63,var12=63,var13=63,
var14= 63,var15= 63,var16= 63,var17=63,var18=63,var19=63,
var20=63,var21=63,var22=63,var23=63,var24=63,var25=63,var26=63,
var27=63,var28=63,var29=63,var30=63,
abc = Bus.audio(s,1), effektbus = Bus.audio(s,1),
betass = 0, headno,
noteArray = Array.newClear(128);
SynthDef(\Appajax2000,
	{ //Beginning of Ugen function
		arg midiPitch, art1, art2,amp, gate, att = 0.01, dec = 0.01, eqn = 0.5, chaos, fader = 0, pitchVoice2, totVol, relTimeAll;
		var voice1RandNoise, voice1NoiseInput, voice1Sound, delayTimeVoice1;
		var voice2RandNoise, voice2NoiseInput, voice2Sound, delayTimeVoice2;
		var burstEnv,legalPitches; //Variable declarations
		var out, seco, noise, mixer, voicefilt, mixVoices;
		//end of variables
		delayTimeVoice1 =  midiPitch.midicps.reciprocal;
		voice1RandNoise = EnvGen.ar(Env.perc(att, dec));
		voice1NoiseInput = LatoocarfianL.ar(chaos, LFNoise1.ar(1000, 3), LFNoise1.ar(1000, 3), LFNoise1.ar(1000, 0.45, 1.1 ) ,LFNoise1.ar(500, 0.45, 1.1 ), mul:voice1RandNoise); //Noise burst
		voice1Sound =  CombL.ar(voice1NoiseInput, delayTimeVoice1, delayTimeVoice1, art1, add: voice1NoiseInput); //Echo chamber
		//end of sound #1
		delayTimeVoice2 =  Vibrato.kr((midiPitch + (pitchVoice2 - 60 )).midicps,0.5,0.005).reciprocal;
		voice2NoiseInput = TGaussRand.ar(-1, 1, Dust2.ar(20000));
		voice2RandNoise = GaussTrig.ar(2);
		voice2Sound = Pluck.ar(voice2NoiseInput, voice1NoiseInput, delayTimeVoice2, delayTimeVoice2, art2, eqn);
		//end of sound #2
		mixVoices = XFade2.ar(voice1Sound, voice2Sound, fader);
		voicefilt = RLPF.ar(mixVoices, LFNoise1.kr(10, 1000, 15000), mul: 0.25);
		DetectSilence.ar(voicefilt,amp:0.0001, doneAction:2);
		out = voicefilt * EnvGen.ar(Env.cutoff(relTimeAll, gate), gate, doneAction:2);
		out = ((totVol + amp -15).dbamp) * out;
		Out.ar(effektbus, out)
}).add;
SynthDef(\Appajax2000Effect, {|out =0 gate= 1 freqHP= 20 freqLP= 20000 filtRes=0.5 delme = 0.003 delRes = 0.6 delRez = 0.22
	delFlt = 10000 delTim = 2 delFed = 0.5 lfoFrq = 1 lfoAmt = 1 dryWet = 0.5 lagKarme = 0.12
	|
	var source, limiting, rhpf, rlpf, delayHotLine, delayFiltLine,	delayLFOLine, delayDryWet;
	source = In.ar(effektbus,1);
	source = LeakDC.ar(source);
	rhpf = BHiPass.ar(source, Lag3.kr(freqHP, 0.07), filtRes);
	rlpf = BLowPass.ar(rhpf, Lag3.kr(freqLP, 0.07), filtRes);
	rlpf = Streson.ar(rlpf, delme.reciprocal, delRes);
	rlpf = LeakDC.ar(rlpf);
	delayLFOLine = SinOsc.ar(lfoFrq, mul: lfoAmt, add: delFlt);
	delayFiltLine = IIRFilter.ar(rlpf, Lag2.ar(Fold.ar(delayLFOLine,10,20000),lagKarme),delRez);
	delayHotLine = CombC.ar(delayFiltLine, Lag2.kr(delTim,1.9), Lag2.kr(delTim,1.9),delFed);
	delayDryWet = XFade2.ar(rlpf,delayHotLine,dryWet);
	DetectSilence.ar(delayDryWet, time: 4, doneAction:2);
	Out.ar(out, [delayDryWet,delayDryWet]);
	Out.ar(abc, delayDryWet);
}).add;
MIDIdef.noteOn(\Appajax2000Seat, {arg vel, note;
	if(betass == 0,  {betass = 1;headno = Synth(\Appajax2000Effect).onFree{betass = 0};});
	if(noteArray[note] !== nil,noteArray[note].free);
	if (var6 > 63,
		{ headno.set(\freqHP, var6.linexp(64,127, 20, 20000), \freqLP, 20000) },
		{ headno.set(\freqLP, var6.linexp(0,63, 20, 20000), \freqHP, 20) });
	if((var13.lincurve(0, 127, 10, 20000, curve: 2)>10000),
		{
			headno.set(\lfoAmt, var17.linexp(0,127,1,(20000-(var13.lincurve(0, 127, 10, 14000, curve: 2)))))
		},
		{	headno.set(\lfoAmt, var17.linexp(0,127,1,var13.lincurve(0, 127, 10, 20000, curve: 2)))});
	headno.set(
		\filtRes, var8.linlin(0,127,1,0),
		\delme, var9.midicps,
		\delRes, var11.linlin(0,127, 0, 1),
		\delFlt, var13.lincurve(0, 127, 10, 20000, curve: 2),
		\delRez,  var13.linlin(0,127,0.23,0.0001),
		\lagKarme, var13.linlin(0,127,0.11,0.001),
		\delTim, var14.linexp(0,127,0.01, 4),
		\delFed, var15.linlin(0,127,0, 20),
		\lfoFrq, var16.linlin(0,127,0.1,60),
		\dryWet, var18.linlin(0,127,-1,1)
	);
	noteArray[note] = Synth.before(headno,
		\Appajax2000,[
			\midiPitch, note,
			\amp, vel.linlin(0,127,-12,12),
			\gate, 1,
			\art1, var0.linexp(0,127, 0.01, 200),
			\chaos, var1.linexp(0,127, 20, 44100),
			\art2, var2.linexp(0,127, 0.01, 2000),
			\eqn, var3.linlin(0,127, -0.99, 0.99),
			\pitchVoice2, var4,
			\fader, var5.linlin(0,127,-1, 1),
			\totVol, var7.linlin(0,127,-24,24),
			\relTimeAll, var12.linexp(0,127,0.05,20);
	]);
	~test_Appajax2000 = 1;
},srcID:~midiInINST1,chan: 2).permanent_(true);
MIDIdef.noteOff(\noteoffmykeyAppajax2000, {arg vel, note;
	noteArray[note].set(\gate,0);
	noteArray[note] = nil;
},srcID:~midiInINST1,chan:2).permanent_(true);
MIDIdef.cc(\AppajaxCC, {arg ...args;
	index1 = args[1];
	index2 = args[0];
	x = case
	{ index1 == 0  }   { var0=index2; }
	{ index1 == 1  }   { var1=index2; }
	{ index1 == 2  }   { var2=index2; }
	{ index1 == 3  }   { var3=index2; }
	{ index1 == 4  }   { var4=index2; }
	{ index1 == 5  }   { var5=index2; }
	{ index1 == 6  }   { var6=index2; }
	{ index1 == 7  }   { var7=index2; }
	{ index1 == 8  }   { var8=index2; }
	{ index1 == 9  }   { var9=index2; }
	{ index1 == 10 }   { var10=index2;}
	{ index1 == 11 }   { var11=index2;}
	{ index1 == 12 }   { var12=index2;}
	{ index1 == 13 }   { var13=index2;}
	{ index1 == 14 }   { var14=index2;}
	{ index1 == 15 }   { var15=index2;}
	{ index1 == 16 }   { var16=index2;}
	{ index1 == 17 }   { var17=index2;}
	{ index1 == 18 }   { var18=index2;}
	{ index1 == 19 }   { var19=index2;}
	{ index1 == 20 }   { var20=index2;}
	{ index1 == 21 }   { var21=index2;}
	{ index1 == 22 }   { var22=index2;}
	{ index1 == 23 }   { var23=index2;}
	{ index1 == 24 }   { var24=index2;}
	{ index1 == 25 }   { var25=index2;}
	{ index1 == 26 }   { var26=index2;}
	{ index1 == 27 }   { var27=index2;}
	{ index1 == 28 }   { var28=index2;};
	if(betass == 0,  {betass = 1;headno = Synth(\Appajax2000Effect).onFree{betass = 0};});
	if (var6 > 63,
		{ headno.set(\freqHP, var6.linexp(64,127, 20, 20000), \freqLP, 20000) },
		{ headno.set(\freqLP, var6.linexp(0,63, 20, 20000), \freqHP, 20) });
	if (10000 < var13.lincurve(0, 127, 10, 20000, curve: 2),
		{

			headno.set(\lfoAmt, var17.linexp(0,127,1,(20000-(var13.lincurve(0, 127, 10, 14000, curve: 2)))))
			//		{headno.set(\lfoAmt, var17.linexp(63,0,1,(var13.linexp(0,127,100,20000))))});
		},
		{
			headno.set(\lfoAmt, var17.linexp(0,127,1,var13.lincurve(0, 127, 10, 20000, curve: 2)))
	});
	headno.set(
		\filtRes, var8.linlin(0,127,1,0),
		\delme, var9.midicps,
		\delRes, var11.linlin(0,127, 0, 1),
		\delFlt, var13.lincurve(0, 127, 10, 20000, curve: 2),
		\delRez,  var13.linlin(0,127,0.23,0.0001),
		\lagKarme, var13.linlin(0,127,0.11,0.001),
		\delTim, var14.linexp(0,127,0.01, 4),
		\delFed, var15.linlin(0,127,0, 20),
		\lfoFrq, var16.linlin(0,127,0.1,60),
		\dryWet, var18.linlin(0,127,-1,1)
	);
},(0..28),srcID:~midiInINST1,chan:2).permanent_(true);
SynthDef(\Appajax2000Diskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(abc,1));
}).add;
)

