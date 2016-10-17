//sampleno freqno volume filter
//sample start if it hits again
//remove limiters
//plugin checker
(
var
var0=63,var1=63,var2=63,var3=63,var4=63,var5=63,var6=63,
var7=63,var8=63,var9=63,var10=63,var11=63,var12=63,var13=63,
var14=63,var15=63,var16=63,var17=63,var18=63,var19=63,var20=63,
var21=63,var22=63,var23=63,var24=63,var25=63,var26=63,var27=63,
var28=63,var29=63,var30=63,var31=63,var32=63,var33=63,var34=63,
noteArrayEtna1 = nil,
noteArrayEtna2 = nil,
noteArrayEtna3 = nil,
noteArrayEtna4 = nil,
noteArrayEtna5 = nil,
noteArrayEtna6 = nil,
noteArray = Array.newClear(128),
betass1 = 0,
betass2 = 0,
betass3 = 0,
betass4 = 0,
betass5 = 0,
betass6 = 0,
headno1,
headno2,
headno3,
headno4,
headno5,
headno6,


index1,index2;
/*drum1, drum2, drum3, drum4, drum5, drum6, folder;

drum1 = Array.new;
drum2 = Array.new;
drum3 = Array.new;
drum4 = Array.new;
drum5 = Array.new;
drum6 = Array.new;

folder = PathName.new("/Users/EmanTnuocca/Documents/SC CODES/SA909_Samples/SA909_BD/");
folder.entries.do({
	arg path;
	drum1 = drum1.add(Buffer.read(s, path.fullPath));
});

folder = PathName.new("/Users/EmanTnuocca/Documents/SC CODES/SA909_Samples/SA909_Cym/");
folder.entries.do({
	arg path;
	drum2 = drum2.add(Buffer.read(s, path.fullPath));
});

folder = PathName.new("/Users/EmanTnuocca/Documents/SC CODES/SA909_Samples/SA909_HH/");
folder.entries.do({
	arg path;
	drum3 = drum3.add(Buffer.read(s, path.fullPath));
});

folder = PathName.new("/Users/EmanTnuocca/Documents/SC CODES/SA909_Samples/SA909_Perc/");
folder.entries.do({
	arg path;
	drum4 = drum4.add(Buffer.read(s, path.fullPath));
});

folder = PathName.new("/Users/EmanTnuocca/Documents/SC CODES/SA909_Samples/SA909_SD/");
folder.entries.do({
	arg path;
	drum5 = drum5.add(Buffer.read(s, path.fullPath));
});

folder = PathName.new("/Users/EmanTnuocca/Documents/SC CODES/SA909_Samples/SA909_Tom/");
folder.entries.do({
	arg path;
	drum6 = drum6.add(Buffer.read(s, path.fullPath));
});
*/
// ilk row sample ,
// ikinci freq
/*
limiting = PitchShift.ar(source, windowSize:0.1, pitchRatio:freqshift);
NoiseChorus.ar
MantissaMask.ar(snd, 3);
Shaper.ar
Rings.ar cymbal hihat hipasss gorevi
Resonz.ar cymbal hihat hipasss gorevi kesisnnnn bak bunlar kick in clip i gibi
LFDNoise1 veya LFDNoise3 ile direk bir sinyali carp
Formlet.ar
tomda FOS.ar i kullan
COsc a genel olarak bak
APF.ar neymis bak
compander yap limiter yerine
*/
// uc freq
SynthDef(\Etna, {

	arg out,  bufnum = 0, ratio = 1, totVol = 0.1, tottotVOLVOL = 0, amp = 1, multout, gate = 1;
	var playbuf, out1, busout, env, snd;
	playbuf = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum) * ratio, doneAction:0);
	snd =  BufRd.ar(
		numChannels: 1,
		bufnum: bufnum,
		phase: Phasor.ar(
			trig: gate,
			rate: (BufRateScale.kr(bufnum) * ratio),
			start: 0,
			end: BufFrames.kr(bufnum),
			resetPos:0),
		loop: 0,
		interpolation:2);
	env =  EnvGen.ar(Env.asr, gate, doneAction:2);
	out1 = env * playbuf;
	out1 = out1 * ((totVol + amp -18 + tottotVOLVOL).dbamp);
	Out.ar(out, out1);
}).add;

SynthDef(\Etna1Effect, {|out =0 gate= 1 freqHP= 20 freqLP= 20000|
	var source, limiting, rhpf, rlpf;
	source = In.ar(~effektbus1etna,1);
	rhpf = BHiPass.ar(source, freqHP, 0.5);
	rlpf = BLowPass.ar(rhpf, freqLP, 0.5);
	limiting = Limiter.ar(rlpf, 0.95, 0.0001);
	DetectSilence.ar(rlpf, doneAction:2);
	Out.ar(out, [limiting,limiting]);
	Out.ar(~abc1etna, limiting);
}).add;

SynthDef(\Etna2Effect, {|out =0 gate= 1 freqHP= 20 freqLP= 20000|
	var source, limiting, rhpf, rlpf;
	source = In.ar(~effektbus2etna,1);
	rhpf = RHPF.ar(source, freqHP, 0.5);
	rlpf = RLPF.ar(rhpf, freqLP, 0.5);
	limiting = Limiter.ar(rlpf, 0.95, 0.0001);
	DetectSilence.ar(limiting, doneAction:2);
	Out.ar(out, [limiting,limiting]);
	Out.ar(~abc2etna, limiting);
}).add;

SynthDef(\Etna3Effect, {|out =0 gate= 1 freqHP= 20 freqLP= 20000|
	var source, limiting, rhpf, rlpf;
	source = In.ar(~effektbus3etna,1);
	rhpf = RHPF.ar(source, freqHP, 0.5);
	rlpf = RLPF.ar(rhpf, freqLP, 0.5);
	limiting = Limiter.ar(rlpf, 0.95, 0.0001);
	DetectSilence.ar(limiting, doneAction:2);
	Out.ar(out, [limiting,limiting]);
	Out.ar(~abc3etna, limiting);
}).add;

SynthDef(\Etna4Effect, {|out =0 gate= 1 freqHP= 20 freqLP= 20000|
	var source, limiting, rhpf, rlpf;
	source = In.ar(~effektbus4etna,1);
	rhpf = RHPF.ar(source, freqHP, 0.5);
	rlpf = RLPF.ar(rhpf, freqLP, 0.5);
	limiting = Limiter.ar(rlpf, 0.95, 0.0001);
	DetectSilence.ar(limiting, doneAction:2);
	Out.ar(out, [limiting,limiting]);
	Out.ar(~abc4etna, limiting);
}).add;

SynthDef(\Etna5Effect, {|out =0 gate= 1 freqHP= 20 freqLP= 20000|
	var source, limiting, rhpf, rlpf;
	source = In.ar(~effektbus5etna,1);
	rhpf = BHiPass.ar(source, freqHP, 0.5);
	rlpf = BLowPass.ar(rhpf, freqLP, 0.5);
	limiting = Limiter.ar(rlpf, 0.95, 0.0001);
	DetectSilence.ar(limiting, doneAction:2);
	Out.ar(out, [limiting,limiting]);
	Out.ar(~abc5etna, limiting);
}).add;

SynthDef(\Etna6Effect, {|out =0 gate= 1 freqHP= 20 freqLP= 20000|
	var source, limiting, rhpf, rlpf;
	source = In.ar(~effektbus6etna,1);
	rhpf = RHPF.ar(source, freqHP, 0.5);
	rlpf = RLPF.ar(rhpf, freqLP, 0.5);
	limiting = Limiter.ar(rlpf, 0.95, 0.0001);
	DetectSilence.ar(limiting, doneAction:2);
	Out.ar(out, [limiting,limiting]);
	Out.ar(~abc6etna, limiting);
}).add;




MIDIdef.noteOn(\EtnaController, {arg vel, note;

	case
	{ note == 48 }   {if(betass1 == 0,  {betass1 = 1;headno1 = Synth(\Etna1Effect).onFree{betass1 = 0};});if(noteArrayEtna1 !== nil,noteArrayEtna1.set(\gate, -1.001));
		if (var19 > 63,
			{ headno1.set(\freqHP, var19.linexp(64,127, 20, 20000), \freqLP, 20000) },
			{ headno1.set(\freqLP, var19.linexp(0,63, 20, 20000), \freqHP, 20) });
		noteArrayEtna1 = Synth.before(headno1, \Etna,
			[
				\bufnum,~drum1[var0],
				\ratio, (var6-63).midiratio,
				\amp, vel.linlin(0,127,-18,18),
				\gate, 1,
				\totVol, var13.linlin(0,127,-24,24),
				\tottotVOLVOL, var7.linlin(0,127,-24,24),
				\out, ~effektbus1etna
	]);~test_Etna1 = 1; }

	{ note == 49 }   {if(betass2 == 0,  {betass2 = 1;headno2 = Synth(\Etna2Effect).onFree{betass2 = 0};});if(noteArrayEtna2 !== nil,noteArrayEtna2.free);
		if (var20 > 63,
			{ headno2.set(\freqHP, var20.linexp(64,127, 20, 20000), \freqLP, 20000) },
			{ headno2.set(\freqLP, var20.linexp(0,63, 20, 20000), \freqHP, 20) });
		noteArrayEtna2 = Synth.before(headno2, \Etna,
			[
				\bufnum, ~drum2[var1],
				\ratio, (var8-63).midiratio,
				\amp, vel.linlin(0,127,-18,18),
				\totVol, var14.linlin(0,127,-24,24),
				\tottotVOLVOL, var7.linlin(0,127,-24,24),
				\out, ~effektbus2etna
	]);~test_Etna2 = 1;}

	{ note == 50 }   {if(betass3 == 0,  {betass3 = 1;headno3 = Synth(\Etna3Effect).onFree{betass3 = 0};});if(noteArrayEtna3 !== nil,noteArrayEtna3.free);
		if (var21 > 63,
			{ headno3.set(\freqHP, var21.linexp(64,127, 20, 20000), \freqLP, 20000) },
			{ headno3.set(\freqLP, var21.linexp(0,63, 20, 20000), \freqHP, 20) });
		noteArrayEtna3 = Synth.before(headno3, \Etna,
			[
				\bufnum, ~drum3[var2],
				\ratio, (var9-63).midiratio,
				\amp, vel.linlin(0,127,-18,18),
				\totVol, var15.linlin(0,127,-24,24),
				\tottotVOLVOL, var7.linlin(0,127,-24,24),
				\out, ~effektbus3etna
	]);~test_Etna3 = 1;}

	{ note == 51 }   {if(betass4 == 0,  {betass4 = 1;headno4 = Synth(\Etna4Effect).onFree{betass4 = 0};});if(noteArrayEtna4 !== nil,noteArrayEtna4.free);
		if (var22 > 63,
			{ headno4.set(\freqHP, var22.linexp(64,127, 20, 20000), \freqLP, 20000) },
			{ headno4.set(\freqLP, var22.linexp(0,63, 20, 20000), \freqHP, 20) });
		noteArrayEtna4 =  Synth.before(headno4, \Etna,
			[
				\bufnum, ~drum4[var3],
				\ratio, (var10-63).midiratio,
				\amp, vel.linlin(0,127,-18,18),
				\totVol, var16.linlin(0,127,-24,24),
				\tottotVOLVOL, var7.linlin(0,127,-24,24),
				\out, ~effektbus4etna
	]);~test_Etna4 = 1;}

	{ note == 52 }   {if(betass5 == 0,  {betass5 = 1;headno5 = Synth(\Etna5Effect).onFree{betass5 = 0};});if(noteArrayEtna5 !== nil,noteArrayEtna5.free);
		if (var23 > 63,
			{ headno5.set(\freqHP, var23.linexp(64,127, 20, 20000), \freqLP, 20000) },
			{ headno5.set(\freqLP, var23.linexp(0,63, 20, 20000), \freqHP, 20) });
		noteArrayEtna5 = Synth.before(headno5, \Etna,
			[
				\bufnum, ~drum5[var4],
				\ratio, (var11-63).midiratio,
				\amp, vel.linlin(0,127,-18,18),
				\totVol, var17.linlin(0,127,-24,24),
				\tottotVOLVOL, var7.linlin(0,127,-24,24),
				\out, ~effektbus5etna
	]);~test_Etna5 = 1;}

	{ note == 53 }   {if(betass6 == 0,  {betass6 = 1;headno6 = Synth(\Etna6Effect).onFree{betass6 = 0};});if(noteArrayEtna6 !== nil,noteArrayEtna6.free);
		if (var24 > 63,
			{ headno6.set(\freqHP, var24.linexp(64,127, 20, 20000), \freqLP, 20000) },
			{ headno6.set(\freqLP, var24.linexp(0,63, 20, 20000), \freqHP, 20) });
		noteArrayEtna6 =  Synth.before(headno6, \Etna,
			[
				\bufnum, ~drum6[var5],
				\ratio, (var12-63).midiratio,
				\amp, vel.linlin(0,127,-18,18),
				\totVol, var18.linlin(0,127,-24,24),
				\tottotVOLVOL, var7.linlin(0,127,-24,24),
				\out, ~effektbus6etna
	]);~test_Etna6 = 1;}

},srcID:~midiInINST2,chan: 9).permanent_(true);
MIDIdef.noteOff(\noteoffmykeyEtna, {arg vel, note;
	case
	//	{ note == 48 }   {noteArrayEtna1.set(\gate,0);noteArrayEtna1 = nil;}
	{ note == 49 }   {noteArrayEtna2.set(\gate,0); noteArrayEtna2 = nil;}
	{ note == 50 }   {noteArrayEtna3.set(\gate,0); noteArrayEtna3 = nil;}
	{ note == 51 }   {noteArrayEtna4.set(\gate,0); noteArrayEtna4 = nil;}
	{ note == 52 }   {noteArrayEtna5.set(\gate,0); noteArrayEtna5 = nil;}
	{ note == 53 }   {noteArrayEtna6.set(\gate,0); noteArrayEtna6 = nil;}

},srcID:~midiInINST2,chan:9).permanent_(true);

MIDIdef.cc(\EtnaCC, {arg ...args;
	index1 = args[1];
	index2 = args[0];
	x = case
	{ index1 == 0 }    { var0=index2;}
	{ index1 == 1 }    { var1=index2;}
	{ index1 == 2 }    { var2=index2;}
	{ index1 == 3 }    { var3=index2;}
	{ index1 == 4 }    { var4=index2;}
	{ index1 == 5 }    { var5=index2;}
	{ index1 == 6 }    { var6=index2;}
	{ index1 == 7 }    { var7=index2;}
	{ index1 == 8 }    { var8=index2;}
	{ index1 == 9 }    { var9=index2;}
	{ index1 == 10}    { var10=index2;}
	{ index1 == 11}    { var11=index2;}
	{ index1 == 12}    { var12=index2;}
	{ index1 == 13}    { var13=index2;}
	{ index1 == 14}    { var14=index2;}
	{ index1 == 15}    { var15=index2;}
	{ index1 == 16}    { var16=index2;}
	{ index1 == 17}    { var17=index2;}
	{ index1 == 18}    { var18=index2;}
	{ index1 == 19}    { var19=index2;}
	{ index1 == 20}    { var20=index2;}
	{ index1 == 21}    { var21=index2;}
	{ index1 == 22}    { var22=index2;}
	{ index1 == 23 }   { var23=index2;}
	{ index1 == 24 }   { var24=index2;}
	{ index1 == 25 }   { var25=index2;}
	{ index1 == 26 }   { var26=index2;}
	{ index1 == 27 }   { var27=index2;}
	{ index1 == 28 }   { var28=index2;}
	{ index1 == 29 }   { var29=index2;}
	{ index1 == 30}    { var30=index2;}
	{ index1 == 31}    { var31=index2;}
	{ index1 == 32}    { var32=index2;}

},(0..27),srcID:~midiInINST2,chan:9).permanent_(true);
SynthDef(\Etna1Diskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(~abc1etna,1));
}).add;
SynthDef(\Etna2Diskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(~abc2etna,1));
}).add;
SynthDef(\Etna3Diskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(~abc3etna,1));
}).add;
SynthDef(\Etna4Diskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(~abc4etna,1));
}).add;
SynthDef(\Etna5Diskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(~abc5etna,1));
}).add;
SynthDef(\Etna6Diskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(~abc6etna,1));
}).add;
)

