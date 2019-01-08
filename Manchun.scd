(
//key-follow++++envelope _EKLE
var noteArray = Array.newClear(128),
nova = ParGroup.new,
vr = Array.fill(128, 63),
defme;
// filter follow gelsin key!!!// filter follow gelsin key!!!// filter follow gelsin key!!!// filter follow gelsin key!!!
SynthDef(\Manchun,{ arg out = 0,  bufnum = ~blls[62],  freq = 60, amp = 1, gate = 1,
	//Volume Envelope Parameters
	coarse, fine,   atkVol, decVol, susVol, relVol,
	//Pitch  Envelope Parameters
	pModLo, pModHi, atkPit, decPit, susPit, relPit,
	//Lowpass Filter Frequency Parameters
	frqLPF, lpfMod, atkLPF, decLPF, susLPF, relLPF,
	//Highpass Filter Frequency Parameters
	frqHPF, hpfMod,	atkHPF, decHPF, susHPF, relHPF,
	//Sample Playback Parameters
	folLPF, folHPF,
	loopMe, smplSt, smplEd, trkVol;

	//--------------------------Signal Processing Side--------------------------\\
	//Pitch Envelope Signal
	var envPit = Env.adsr(atkPit, decPit, (susPit.dbamp), relPit,curve: [5,-7,-4]);
	var genPit = EnvGen.kr(envPit, gate, doneAction: 0);
	var start1 = smplSt.linlin(0,127,1,(BufFrames.kr(bufnum))-3);
	var end1 = BufFrames.kr(bufnum)-smplEd.linlin(0,127,( BufFrames.kr(bufnum))-start1-3, 1)-2;
	var sndsnd =  BufRd.ar(
		numChannels: 2,
		bufnum: bufnum,
		phase: Phasor.ar(
			trig: 1,
			rate: (BufRateScale.kr(bufnum) * coarse * fine * (freq.midicps)/261 * LinExp.kr(genPit,0,1,pModLo,pModHi)),
			start: start1,
			end: end1,
			resetPos:0),
		loop: loopMe,
		interpolation:4);
	//Volume Envelope Signal
	var envVol = Env.adsr(atkVol, decVol, (susVol.dbamp), relVol, curve: [5,-7,-4]);
	var genVol = EnvGen.ar(envVol, gate, doneAction: 2);

	//LowPass Filter Envelope Signal
	var envLPF = Env.adsr(atkLPF, decLPF, (susLPF.dbamp), relLPF, curve: [5,-7,-4]);
	var genLPF = EnvGen.ar(envLPF, gate, doneAction: 0);
	var loPass = BLowPass.ar(sndsnd, Clip.ar(
		(freq * folLPF).midicps + Lag2.ar(LinExp.ar(genLPF,0,1,frqLPF,lpfMod),0.002),40,20000));

	//HiPass Filter Envelope Signal
	var envHPF = Env.adsr(atkHPF, decHPF, (susHPF.dbamp), relHPF, curve: [5,-7,-4]);
	var genHPF = EnvGen.ar(envHPF, gate, doneAction: 0);
		var hiPass = BHiPass.ar(loPass, Clip.ar(
		(freq * folHPF).midicps + Lag2.ar(LinExp.ar(genHPF,0,1,frqHPF,hpfMod),0.002),40,20000),mul: 0.7);
	//Output
	var lstout = hiPass * genVol * ((amp + trkVol - 30).dbamp);
	Out.ar(1,Mix.ar(lstout));

}).add;
defme = { arg a1,b1,c1; var a4 =
	[
		\coarse,(vr[0].linlin(0,127,-64,63)+1).midiratio,
		\fine,  (vr[1].linlin(0,127,-1,1)).midiratio,
		\atkVol, vr[2].lincurve(0,127,0.0001,10,6),
		\decVol, vr[3].lincurve(0,127,0.0005,20,7),
		\susVol, vr[4].linlin(0,127,-24,0),
		\relVol, vr[5].lincurve(0,127,0.0005,20,8),

		//smplNo
		\trkVol, vr[7].linlin(0,127,-24,24),
		\smplSt, vr[8],
		\smplEd, vr[9],
		\folLPF, vr[10].linlin(0,127,-1,1),
		\folHPF, vr[11].linlin(0,127,-1,1),
		//cc 10 effect gelebilir
		//cc 11 rq? // filter follow gelsin key!!!

		\pModLo,(vr[12]-63).midiratio,
		\pModHi,(vr[13]-63).midiratio,
		\atkPit, vr[14].lincurve(0,127,0.0001,10,6),
		\decPit, vr[15].lincurve(0,127,0.0005,20,7),
		\susPit, vr[16].linlin(0,127,-24,0),
		\relPit, vr[17].lincurve(0,127,0.0005,20,8),

		\frqLPF, vr[18].linexp(0,127,20,20000),
		\lpfMod, vr[19].linexp(0,127,20,20000),
		\atkLPF, vr[20].lincurve(0,127,0.0001,10,6),
		\decLPF, vr[21].lincurve(0,127,0.0005,20,7),
		\susLPF, vr[22].linlin(0,127,-24,0),
		\relLPF, vr[23].lincurve(0,127,0.0005,20,8),

		\frqHPF, vr[24].linexp(0,127,20,20000),
		\hpfMod, vr[25].linexp(0,127,20,20000),
		\atkHPF, vr[26].lincurve(0,127,0.0001,10,6),
		\decHPF, vr[27].lincurve(0,127,0.0005,20,7),
		\susHPF, vr[28].linlin(0,127,-24,0),
		\relHPF, vr[29].lincurve(0,127,0.0005,20,8),

		\loopMe, 1];
	if(a1 == 1) { [\freq, b1, \amp, c1.linlin(0,127, 0, 24), \bufnum, ~blls[vr[6]]] ++ a4} {a4}};
MIDIdef.noteOn(\ManchunController, {arg vel, note;
	if(noteArray[note] !== nil,noteArray[note].free);
	noteArray[note] = Synth(\Manchun, defme.value(1, note, vel),nova);
	~test_Manchun = 1;
},srcID:~midiInINST4,chan: 14).permanent_(true);
MIDIdef.cc(\ManchunCC, {arg ...args;
	vr[args[1]] = args[0];
	nova.setControls(defme.value(0));
},(0..34),srcID:~midiInINST4,chan:14).permanent_(true);
MIDIdef.noteOff(\ManchunOffMykey, {arg vel, note;
	noteArray[note].set(\gate,0);
	noteArray[note] = nil;
},srcID:~midiInINST4,chan:14).permanent_(true);
)