(//		{headno.set(\lfoAmt, vr[17].linexp(63,0,1,(vr[13].linexp(0,127,100,20000))))});
var
nova = ParGroup.new,
vr = Array.fill(128, 63),
defme,defEFX,
effektbus = Bus.audio(s,1),
betass = 0, headno,
noteArray = Array.newClear(128);
SynthDef(\Appajax2000,
	{ //Beginning of Ugen function
		arg midiPitch, art1, art2,amp, gate=1, att = 0.01, dec = 0.01, eqn = 0.5, chaos, fader = 0, pitchVoice2, totVol, relTimeAll;
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
SynthDef(\Appajax2000Effect, {|out =1 gate= 1 freqHP= 20 freqLP= 20000 filtRes=0.5 delme = 0.003 delRes = 0.6 delRez = 0.22
	delFlt = 10000 delTim = 2 delFed = 0.5 lfoFrq = 1 lfoAmt = 1 dryWet = 0.5 lagKarme = 0.12
	|
	var source, limiting, rhpf, rlpf, delayHotLine, delayFiltLine,	delayLFOLine, delayDryWet;
	source = In.ar(effektbus,1);
	source = LeakDC.ar(source);
	rhpf = BHiPass.ar(source, Lag3.kr(freqHP, 0.07), filtRes);
	rlpf = BLowPass.ar(rhpf, Lag3.kr(freqLP, 0.07), filtRes);
	//rlpf = Streson.ar(rlpf, delme.reciprocal, delRes);
	delayLFOLine = SinOsc.ar(lfoFrq, mul: lfoAmt, add: delFlt);
	delayFiltLine = BLowPass4.ar(rlpf, Lag2.ar(Fold.ar(delayLFOLine,10,20000),lagKarme),delRez);
	delayHotLine = CombC.ar(delayFiltLine, Lag2.kr(delTim,1.9), Lag2.kr(delTim,1.9),delFed);
	delayDryWet = XFade2.ar(rlpf,delayHotLine,dryWet);
	DetectSilence.ar(delayDryWet, time: 4, doneAction:2);
	Out.ar(out, delayDryWet);
}).add;
defme = { arg a1,b1,c1; var a =
	[
		\art1, vr[0].linexp(0,127, 0.01, 200),
		\chaos, vr[1].linexp(0,127, 20, 44100),
		\art2, vr[2].linexp(0,127, 0.01, 2000),
		\eqn, vr[3].linlin(0,127, -0.99, 0.99),
		\pitchVoice2, vr[4],
		\fader, vr[5].linlin(0,127,-1, 1),
		\totVol, vr[7].linlin(0,127,-24,24),
		\relTimeAll, vr[12].linexp(0,127,0.05,20)
	];
	if(a1 == 1) { [\midiPitch, b1, \amp, c1.linlin(0,127,-12,12)] ++ a} {a}
};
defEFX = {
		if(betass == 0,  {betass = 1;headno = Synth.after(nova,\Appajax2000Effect).onFree{betass = 0};});
	if (vr[6] > 63,
		{ headno.set(\freqHP, vr[6].linexp(64,127, 20, 20000), \freqLP, 20000) },
		{ headno.set(\freqLP, vr[6].linexp(0,63, 20, 20000), \freqHP, 20) });
	if((vr[13].lincurve(0, 127, 10, 20000, curve: 2)>10000),
		{
			headno.set(\lfoAmt, vr[17].linexp(0,127,1,(20000-(vr[13].lincurve(0, 127, 10, 14000, curve: 2)))))
		},
		{	headno.set(\lfoAmt, vr[17].linexp(0,127,1,vr[13].lincurve(0, 127, 10, 20000, curve: 2)))});
	headno.set(
		\filtRes, vr[8].linlin(0,127,1,0),
		\delme, vr[9].midicps,
		\delRes, vr[11].linlin(0,127, 0, 1),
		\delFlt, vr[13].lincurve(0, 127, 10, 20000, curve: 2),
		\delRez,  vr[13].linlin(0,127,0.23,0.0001),
		\lagKarme, vr[13].linlin(0,127,0.11,0.001),
		\delTim, vr[14].linexp(0,127,0.01, 4),
		\delFed, vr[15].linlin(0,127,0, 20),
		\lfoFrq, vr[16].linlin(0,127,0.1,60),
		\dryWet, vr[18].linlin(0,127,-1,1)
	);
};
MIDIdef.noteOn(\Appajax2000Seat, {arg vel, note;
	defEFX.value;
	if(noteArray[note] !== nil,noteArray[note].free);
	noteArray[note] = Synth(\Appajax2000,defme.value(1, note, vel),nova);
	~test_Appajax2000 = 1;
},srcID:~midiInINST1,chan: 2).permanent_(true);
MIDIdef.noteOff(\noteoffmykeyAppajax2000, {arg vel, note;
	noteArray[note].set(\gate,0);
	noteArray[note] = nil;
},srcID:~midiInINST1,chan:2).permanent_(true);
MIDIdef.cc(\AppajaxCC, {arg ...args;
	vr[args[1]] = args[0];
	defEFX.value;/////BUNU YAPAMAZSIN
	nova.setControls(defme.value(0));
},(0..28),srcID:~midiInINST1,chan:2).permanent_(true);
)

