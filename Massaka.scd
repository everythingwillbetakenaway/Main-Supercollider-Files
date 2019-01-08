(
var
nova = ParGroup.new,
vr = Array.fill(128, 63),
defme;
SynthDef(\Massaka, {
	arg freq,amp,totVol,pan,dengele,
	tube1,  tube2,  tube3,  tube1V, tube2V, tube3V,
	decNo1, decNo2, decNo3, crackF, attTim, relTim,
	attTm2, relTm2, fltFrq, fltBW, envDep,
	oscRt1, oscDp1,oscRt2, oscDp2,oscRt3, oscDp3;
	var klank = DynKlank.ar(`[[Vibrato.ar(tube1,oscRt1,oscDp1,iphase:Rand(2pi)), Vibrato.kr(tube2,oscRt2,oscDp2), Vibrato.kr(tube3,oscRt3,oscDp3)],[tube1V,tube2V,tube3V],[decNo1,decNo2,decNo3]],
		input:Crackle.ar(crackF,0.2),
		freqscale:freq,
		freqoffset:LFNoise0.ar(5,freq/333),
		decayscale:1);
	var env = EnvGen.ar(Env.perc(attackTime:attTim,releaseTime: relTim), levelScale: 2.2, doneAction: 2);
	var env2 = EnvGen.ar(Env.perc(attackTime:attTm2,releaseTime: relTm2), levelScale: envDep, doneAction: 0);
	var outputstage = klank *  env;
	var outputstage2 = dengele * outputstage;
	var filterme = Resonz.ar(outputstage2, Lag2.kr(Clip.kr(fltFrq + env2, 20, 20000),0.01), fltBW);
	var outring = filterme * ((totVol + amp -15).dbamp);
		outring = LeakDC.ar(outring);
	Out.ar(1, outring)
}).add;
defme = { arg a1,b1,c1; var a =
	[
		\totVol,  vr[7].linlin(0,127,-24,24),
		//////////////////////////////////////
		\tube1,  (vr[0]-60).midiratio,
		\tube2,  (vr[1]-60).midiratio,
		\tube3,  (vr[2]-60).midiratio,
		\tube1V,  vr[3].linexp(0,127,0.01,0.5),
		\tube2V,  vr[4].linexp(0,127,0.01,0.5),
		\tube3V,  vr[5].linexp(0,127,0.01,0.5),
		///////   ////////////////////////////
		\decNo1,  vr[6].linexp(0,127,0.0001,40),
		\decNo2,  vr[8].linexp(0,127,0.0001,40),
		\decNo3,  vr[9].linexp(0,127,0.0001,40),
		\crackF,  vr[11].linexp(0,127,0.3,2.001),
		\attTim,  vr[12].linexp(0,127,0.0001,0.5),
		\relTim,  vr[13].linexp(0,127,0.01,30),
		///////////////////////////////////////
		\fltFrq, vr[14].linexp(0,127,50,19000),
		\fltBW,  vr[15].linexp(0,127,0.001,1),
		\dengele, vr[15].linexp(0,127,100,1),
		\envDep, ((20000-vr[14].linexp(0,127,50,19000)) * vr[16].linlin(0,127,0,1)),
		\attTm2, vr[17].linexp(0,127,0.0001,5.5),
		\relTm2, vr[18].linexp(0,127,0.01,30),
		///////////////////////////////////////
		\oscRt1, vr[19].linlin(0,127,0.02,20),
		\oscDp1, vr[20].linlin(0,127,0,0.7),
		\oscRt2, vr[21].linlin(0,127,0.02,20),
		\oscDp2, vr[22].linlin(0,127,0,0.7),
		\oscRt3, vr[23].linlin(0,127,0.02,20),
		\oscDp3, vr[24].linlin(0,127,0,0.7),
	];
		if(a1 == 1) { [\freq, b1.midicps, \amp, c1.linlin(0,127,-12,12)] ++ a} {a}};
MIDIdef.noteOn(\MassakaController, {arg vel, note;
	Synth(\Massaka,defme.value(1, note, vel),nova);
	~test_Massaka = 1;
},srcID:~midiInINST3,chan: 1).permanent_(true);
MIDIdef.cc(\MassakaCC, {arg ...args;
	vr[args[1]] = args[0];
	nova.setControls(defme.value(0));
},(0..25),srcID:~midiInINST3,chan:1).permanent_(true);
)