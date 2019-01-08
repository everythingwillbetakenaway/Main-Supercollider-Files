(
var
nova = ParGroup.new,
var0=63,var1=63,var2=63,var3  =63,var4 =63, var5=63, var6=63,
var7=63,var8=63,var9=63,var10=63,var11=63,var12=63,var13=63,
var14=63,var15=63,var16=63,var17=63,var18=63,var19=63,var20=63,
var21=63,var22=63,var23=63,var24=63,var25=63,var26=63,var27=63,
var28=63,var29=63,var30=63,var31=63,var32=63,var33=63,var34=63,
var35=63,var36=63,var37=63,var38=63,var39=63,var40=63,var41=63,
vr = Array.fill(128, 63),
defme,
noteArraySenjin,
headno,
betass = 0,
index1,index2;
SynthDef(\Senjin,{
	|out= 0 freq = 63 amp = 63 gate=1 totVol = 63
	osc1vibRate=63 osc1vibDept=63 osc1widFrq=63 osc1widMul=63 osc1widAadd=63 oscMix=63
	osc2vibRate=63 osc2vibDept=63 osc2widFrq=63 osc2widMul=63 osc2widAadd=63 osc2pitch=63
	frqLag = 63 sub    = 63 k1     = 77 d1length1=63 d2length1=63 mixTube1=63 //bliptreegelcek denem
	volAtk = 63 volDec = 63 volSus = 63 volRel = 63 fltFrq = 63 fltRes = 63
	fltAtk = 63 fltDec = 63 fltSus = 63 fltRel = 63 fltAmt = 63 fltOvr = 63
	//tri sub osc degisimi
	|
	//synthsection
	var pulse, filter,envAdsr, env, envEfk, envFltAdsr, envFlt, chorus;
	pulse = Pulse.ar(
		freq:(Lag2.kr(freq.midicps,  frqLag.linexp(0,127,0.01,4)) *[
			Vibrato.kr(
				freq:1,
				rate:osc1vibRate.linexp(0,127,0.01,100),
				depth:osc1vibDept.linexp(0,127,0.0002,2)),
			Vibrato.kr(
				freq:(osc2pitch.linlin(0,127,0,127)-63).midiratio,
				rate:osc2vibRate.linexp(0,127,0.01,100),
				depth:osc2vibDept.linexp(0,127,0.0002,2))]).fold(10,19000),
		width:[
			LFCub.kr(osc1widFrq.linexp(0,127,0.02,200),0.8,osc1widMul.linexp(0,127,0.001,0.5), osc1widAadd.linlin(0,127,0.00,1.00)),
			LFCub.kr(osc2widFrq.linexp(0,127,0.02,200), 0, osc2widMul.linexp(0,127,0.001,0.5), osc2widAadd.linlin(0,127,0.00,1.00))
		],
		mul:[oscMix.linexp(0,127,1.00,0.04),oscMix.linexp(0,127,0.04,1.00)]
	);
	pulse = pulse + BlitB3Tri.ar(freq.midicps/2,mul:sub.linexp(63,127,0.005,0.05)) + BlitB3Square.ar(freq.midicps/2,mul:sub.linexp(0,63,0.6,0.06));
	pulse = XFade2.ar(
		Wrap.ar(Fold.ar(0.5*
			TwoTube.ar(pulse,
				k:k1.linlin(0,127,-1.00,1.00),
				loss:0.99,
				d1length:d1length1.linexp(0,127,1,3000),
				d2length:d2length1.linexp(0,127,1,3000)
	),-0.9,0.9),-0.9,0.9),pulse,mixTube1.linlin(0,127,-1.0,1.0));
	pulse = pulse + CrossoverDistortion.ar(pulse, 0.425, 0.65,1 );
	envAdsr = Env.adsr(
		attackTime:volAtk.linexp(0,127,0.001,10),
		decayTime:volDec.linexp(0,127,0.01,20),
		sustainLevel:volSus.linlin(0,127,0,1),
		releaseTime:volRel.linexp(0,127,0.3,10));
	env = EnvGen.ar(envAdsr,gate, doneAction:2);
	envFltAdsr = Env.adsr(
		attackTime:fltAtk.linexp(0,127,0.001,10),
		decayTime:fltDec.linexp(0,127,0.01,20),
		sustainLevel:fltSus.linlin(0,127,0,1),
		releaseTime:fltRel.linexp(0,127,0.01,10));
	envFlt = EnvGen.ar(envFltAdsr,gate, fltAmt, doneAction:0);
	//keyboard tracking filter cutoff
	filter = DFM1.ar(
		in:pulse,
		freq:Lag3.ar(((freq.linlin(0,127,0, 64) + envFlt + fltFrq.linlin(0,127,0, 64)).clip2(126)).midicps,0.01),
		res:fltRes.linexp(0,127,2,0.02),
		inputgain:fltOvr.linlin(0,127, 0,2),
		mul: 0.25);
	filter = Mix(filter)*env;
	//envEfk = Linen.kr(gate, 0.1, 1, 0.1, 2);
	chorus= Splay.ar(Array.fill(4,{ //HATA!>?HATA!>?HATA!>?HATA!>?HATA!>?HATA!>?HATA!>?HATA!>?HATA!>?HATA!>?HATA!>?
		var maxdelaytime= rand(0.005,0.02);

		DelayC.ar(filter, maxdelaytime,LFNoise1.kr(Rand(0.1,0.6),0.25*maxdelaytime,0.75*maxdelaytime) )
	}));
	chorus = Compander.ar(4*(filter + chorus),filter,0.4,1,4,mul: 0.5);
	chorus= chorus * Lag2.kr(((totVol.linlin(0,127,-24,24) -15 + amp.linlin(0,127,-12,12)).dbamp),0.05);
	chorus = Mix.new(chorus);
	Out.ar(1, chorus);


}).add;
//chorus and compression
/*
SynthDef(\SenjinEffect, {|out =0 gate= 1 test=  0 totVol= 8|
var source = In.ar(out,2);
var chorus;
var env = Linen.kr(gate, 0.1, 1, 0.1, 2);
chorus= Splay.ar(Array.fill(4,{
var maxdelaytime= rand(0.005,0.02);

DelayC.ar(source[0], maxdelaytime,LFNoise1.kr(Rand(0.1,0.6),0.25*maxdelaytime,0.75*maxdelaytime) )
}));
chorus = Compander.ar(4*(source + chorus),source,0.4,1,4);
chorus= chorus * ((totVol -18).dbamp);
chorus = Mix.new(chorus);
DetectSilence.ar(chorus, doneAction:2);
Out.ar([0,1], chorus);
}).add;
*/
defme = { arg a1,b1,c1; var a =
	[
		\osc1vibRate,   vr[0],
		\osc1vibDept,  vr[1],
		\osc1widFrq,  vr[2],
		\osc1widMul, vr[3],
		\osc1widAadd,  vr[4],
		\oscMix,    vr[5],
		//
		\osc2vibRate,   vr[6],
		\osc2vibDept,   vr[8],
		\osc2widFrq,  vr[9],
		\osc2widMul,  vr[11],
		\osc2widAadd,  vr[12],
		\osc2pitch,  vr[13],
		//
		\frqLag, vr[14],
		\sub, vr[15],
		\k1, vr[16],
		\d1length1, vr[17],
		\d2length1, vr[18],
		\mixTube1, vr[19],
		//
		\volAtk, vr[20],
		\volDec, vr[21],
		\volSus, vr[22],
		\volRel, vr[23],
		\fltFrq, vr[24],
		\fltRes, vr[25],
		//
		\fltAtk, vr[26],
		\fltDec, vr[27],
		\fltSus, vr[28],
		\fltRel, vr[29],
		\fltAmt, vr[30],
		\fltOvr, vr[31],
		//
		\totVol,  vr[7]];
	if(a1 == 1) { [\freq, b1, \amp, c1.linlin(0,127,-12,12), \gate, 1] ++ a} {a}};
MIDIdef.noteOn(\SenjinController, {arg vel, note;
	//	if(noteArray !== nil,noteArray.free);
	if(betass == 0 ,
		{betass = 1; noteArraySenjin = Synth(\Senjin,defme.value(1, note, vel),nova).onFree{betass = 0}},
		{nova.setControls(defme.value(1,note,vel));});
},srcID:~midiInINST1,chan: 13).permanent_(true);
MIDIdef.noteOff(\noteoffmykeySenjin, {arg vel, note;
	noteArraySenjin.get(\freq, {arg value;
		if(value == note,
			{
				noteArraySenjin.set(\gate,0);
				//noteArraySenjin = nil
	})});
},srcID:~midiInINST1,chan:13).permanent_(true);
MIDIdef.cc(\SenjinCC, {arg ...args;
	vr[args[1]] = args[0];
	if(betass == 1 , {nova.setControls(defme.value(0))});//tim duncan
},(0..39),srcID:~midiInINST1,chan:13).permanent_(true);
)
/*
s.queryAllNodes; // note the default group (ID 1)
a;
y = 0;
y;
~betass;
Synth( \Senjin).onFree{~betass = 0};
y.get(\test, { arg value; ("freq is now:" + value + "Hz").postln; });
~betass = 0;
~abc = y.query;
y;

~  */


// (
// {
// 	var delay1, delay2, source;
//
// 	//k from -1 to 1
//
// 	//in samples
// 	delay1= 100;
// 	delay2= 400;
//
// 	source= WhiteNoise.ar(0.5)*EnvGen.ar(Env([1,1,0],[(delay1+delay2)/SampleRate.ir,0.0]), Impulse.kr(2));
//
// 	TwoTube.ar(source,MouseX.kr(-1,1), MouseY.kr(0.09,1.01), delay1,delay2);
// }.play
//
//


