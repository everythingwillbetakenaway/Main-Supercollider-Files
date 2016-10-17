(
var
annesi,
var0=63,var1=63,var2=63,var3=63,var4=63,var5=63,var6=63,
var7=63,var8=63,var9=63,var10=63,var11=63,var12=63,var13=63,
var14=63,var15=63,var16=63,var17=63,var18=63,var19=63,var20=63,
var21=63,var22=63,var23=63,var24=63,var25=63,var26=63,var27=63,
var28=63,var29=63,var30=63,var31=63,var32=63,var33=63,var34=63,
var35=63,var36=63,var37=63,var38=63,var39=63,var40=63,var41=63,
var42=63,var43=63,var44=63,var45=63,var46=63,var47=63,var48=63,
var49=63,var50=63,var51=63,var52=63,var53=63,var54=63,var55=63,
var56=63,var57=63,var58=63,var59=63,var60=63,var61=63,var62=63,
var63=63,var64=63,var65=63,var66=63,var67=63,var68=63,var69=63,
velglob=63, velfreq =63,
noteArrayBD = nil,
noteArrayCYM = nil,
noteArrayHH = nil,
noteArrayPRC = nil,
noteArraySD = nil,
noteArrayCLP = nil,
noteArrayTOM = nil,
noteArrayEFX = nil,
betassBD = 0,
betassCYM = 0,
betassHH = 0,
betassPRC = 0,
betassSD = 0,
betassCLP = 0,
betassTOM = 0,
betassEFX = 0,
headnoBD,
headnoCYM,
headnoHH,
headnoPRC,
headnoSD,
headnoCLP,
headnoTOM,
headnoEFX,
index1,index2;
SynthDef(\Masibo, {
	arg out,  bufnum = 0, ratio = 1, totVol = 0.1, tottotVOLVOL = 0, amp = 1, multout, gate = 1;
	var playbuf, out1, busout, env, snd;
	playbuf = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum) * ratio, doneAction:0);
	env =  EnvGen.ar(Env.asr, gate);
	DetectSilence.ar(playbuf,doneAction:2);
	out1 = env * playbuf;
	Out.ar(out, out1);
}).add;
SynthDef(\MasiboBDefkt, {|
	out =0 gate= 1 denem 6 amp 1 totVol 1 tottotVOLVOL 1
	fftRate 2048 filtType 0  filtFreq 19000 mixMy 0 mixEfx 4
	|
	var source, rhpf, rlpf, limit;//garip pitchshiftekle
	source = In.ar(~effektbusBD,1);
	source = DFM1.ar(source, filtFreq, 0.34, 1, filtType);
	rhpf = source;
	rlpf = source;
	rlpf = FFT(LocalBuf(fftRate), rlpf, 0.5, 1, 1);
	rlpf = PV_MagSmear(rlpf, mixEfx);
	rlpf = IFFT(rlpf);
	rlpf =	WaveLoss.ar(rlpf, 3, 40, 2, mul: 1);
	rlpf =     XFade2.ar(rhpf, rlpf, mixMy) ; //dry wet
	DetectSilence.ar(rlpf, amp: 0.002, doneAction:2);
	//rlpf = LeakDC.ar(rlpf);
	rlpf = rlpf * ((totVol + amp -15 + tottotVOLVOL).dbamp);
	rlpf = rlpf * KeyState.kr(18, 1, 0, 0.1);
	Out.ar(out, [rlpf,rlpf]);
	Out.ar(~abcBD, rlpf);
}).add;
SynthDef(\MasiboCYMefkt, {|out =0 gate= 1 freqHP= 20 freqLP= 20000 samplerate 44100  samplersmooth 1 limitdest 0.01 limitamp 5 amp 1 totVol 1 tottotVOLVOL 1 out2|
	var source, hpf, lpf, crush, limit;
	source = In.ar(~effektbusCYM,1);//gecenin 05:24:22 3 jan 2001,smooth decimator ve sineshaperi acil durumlarda ayni yere koy
	hpf = BHiPass.ar(source, Lag2.kr(freqHP, 0.07), 0.6);
	limit = BLowPass.ar(hpf, Lag3.kr(freqLP, 0.07), 0.6);
	limit =  SmoothDecimator.ar(limit, samplerate, samplersmooth);
	limit = SineShaper.ar(limit, limitdest , limitamp);
	limit = limit * 0.75;
	limit = limit * ((totVol + amp -15 + tottotVOLVOL).dbamp);
	DetectSilence.ar(limit, amp: 0.002, doneAction:2);
	limit = limit * KeyState.kr(19, 1, 0, 0.1);
	Out.ar(out, [limit,limit]);
	Out.ar(~abcCYM, limit);
}).add;
MIDIdef.noteOn(\MasiboController, {arg vel, note;
	case

	{ note == 48 }   {
		annesi = 512;
		case
		{(var4 > 63) && (var5 > 63) }   { annesi = 4096 }
		{(var4 > 63) && (var5 <= 63) }  { annesi = 256 }
		{(var4 <= 63) && (var5 > 63) }  { annesi = 128 }
		{(var4 <= 63) && (var5 <= 63) } { annesi = 64  };
		if(betassBD == 0,  {betassBD = 1;headnoBD = Synth(\MasiboBDefkt, [\fftRate, annesi]).onFree{betassBD = 0}});
		if(noteArrayBD !== nil, {noteArrayBD.set(\gate, -1.001); noteArrayBD = nil});

		if (var3 > 63,
			{ headnoBD.set(\filtFreq, var3.linexp(64,127, 20, 20000), \filtType, 1) },
			{ headnoBD.set(\filtFreq, var3.linexp(0,63, 20, 20000), \filtType, 0) });
		if (var4 > 63,
			{ headnoBD.set(\mixEfx, var4.linlin(64,127, 0, 40)) },
			{ headnoBD.set(\mixEfx, var4.linlin(0,63, 40, 0)) });
		if (var5 > 63,
			{ headnoBD.set(\mixMy, var5.linlin(64,127, -1, 1)) },
			{ headnoBD.set(\mixMy, var5.linlin(0,63, 1, -1)) });
		headnoBD.set(
			\amp, vel.linlin(0,127,-12,12),
			\totVol, var2.linlin(0,127,-24,24),
			\tottotVOLVOL, var7.linlin(0,127,-24,24),
			\denem, var3);
		noteArrayBD = Synth.before(headnoBD, \Masibo,
			[
				\bufnum, ~drumBD[var0],
				\ratio, (var1-63).midiratio,
				\gate, 1,
				\out, ~effektbusBD
	]).onFree{noteArrayBD = nil};~test_MasiboBD = 1; }

	{ note == 49 }   {
		if(betassCYM == 0,  {betassCYM = 1;headnoCYM = Synth(\MasiboCYMefkt).onFree{betassCYM = 0}});
		if(noteArrayCYM !== nil, {noteArrayCYM.set(\gate, -1.1 /*orijinal 1.02di*/); noteArrayCYM = nil});
		if (var10 > 63,
			{ headnoCYM.set(\freqHP, var10.linexp(64,127, 20, 20000), \freqLP, 20000) },
			{ headnoCYM.set(\freqLP, var10.linexp(0,63, 20, 20000), \freqHP, 20) });
		headnoCYM.set(
			\amp, vel.linlin(0,127,-12,12),
			\samplerate, var11.linexp(0,127, 450, 44100),
			\samplersmooth, var11.linexp(0,127, 1, 0.0001),
			\totVol, var9.linlin(0,127,-24,24),
			\tottotVOLVOL, var7.linlin(0,127,-24,24),
			\limitdest, var12.linexp(0,127, 0.33, 0.01),
			\limitamp, var12.linexp(0,127,4,110));

		noteArrayCYM = Synth.before(headnoCYM, \Masibo,
			[
				\bufnum, ~drumCYM[var6],
				\ratio, (var8-63).midiratio,
				\gate, 1,
				\out, ~effektbusCYM
	]).onFree{noteArrayCYM = nil};~test_MasiboCYM = 1; }
},srcID:~midiInINST3,chan: 11).permanent_(true);
/*MIDIdef.noteOff(\noteoffmykeymasibo, {arg vel, note;
case
//{ note == 48 }   {noteArrayBD.set(\gate,0);noteArrayBD = nil;}
},srcID:~midiInINST3,chan:11);
*/
MIDIdef.cc(\masiboCC, {arg ...args;
	if(betassCYM == 0,  {betassCYM = 1;headnoCYM = Synth(\MasiboCYMefkt).onFree{betassCYM = 0}});
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
	{ index1 == 23}    { var23=index2;}
	{ index1 == 24}    { var24=index2;}
	{ index1 == 25}    { var25=index2;}
	{ index1 == 26}    { var26=index2;}
	{ index1 == 27}    { var27=index2;}
	{ index1 == 28}    { var28=index2;}
	{ index1 == 29}    { var29=index2;}
	{ index1 == 30}    { var30=index2;}
	{ index1 == 31}    { var31=index2;}
	{ index1 == 32}    { var32=index2;}
	{ index1 == 33}    { var33=index2;}
	{ index1 == 34}    { var34=index2;}
	{ index1 == 35}    { var35=index2;}
	{ index1 == 36}    { var36=index2;}
	{ index1 == 37}    { var37=index2;}
	{ index1 == 38}    { var38=index2;}
	{ index1 == 39}    { var39=index2;}
	{ index1 == 40}    { var40=index2;}
	{ index1 == 41}    { var41=index2;}
	{ index1 == 42}    { var42=index2;}
	{ index1 == 43}    { var43=index2;}
	{ index1 == 44}    { var44=index2;}
	{ index1 == 45}    { var45=index2;}
	{ index1 == 46}    { var46=index2;}
	{ index1 == 47}    { var47=index2;}
	{ index1 == 48}    { var48=index2;}
	{ index1 == 49}    { var49=index2;}
	{ index1 == 50}    { var50=index2;}
	{ index1 == 51}    { var51=index2;}
	{ index1 == 52}    { var52=index2;}
	{ index1 == 53}    { var53=index2;}
	{ index1 == 54}    { var54=index2;}
	{ index1 == 55}    { var55=index2;}
	{ index1 == 56}    { var56=index2;}
	{ index1 == 57}    { var57=index2;};
	if (var10 > 63,
		{ headnoCYM.set(\freqHP, var10.linexp(64,127, 20, 20000), \freqLP, 20000) },
		{ headnoCYM.set(\freqLP, var10.linexp(0,63, 20, 20000), \freqHP, 20) });
	headnoCYM.set(
		\samplerate, var11.linexp(0,127, 450, 44100),
		\samplersmooth, var11.linexp(0,127, 1, 0.0001),
		\totVol, var9.linlin(0,127,-24,24),
		\tottotVOLVOL, var7.linlin(0,127,-24,24),
		\limitdest, var12.linexp(0,127, 0.33, 0.01),
		\limitamp, var12.linexp(0,127,4,110));

},(0..90),srcID:~midiInINST3,chan:11).permanent_(true);
SynthDef(\MasiboBDDiskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(~abcBD,1));
}).add;
SynthDef(\MasiboCYMDiskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(~abcCYM,1));
}).add;/*
SynthDef(\MasiboHHDiskout, {arg bufnum;
DiskOut.ar(bufnum, In.ar(~abcHH,1));
}).add;
SynthDef(\MasiboPRCDiskout, {arg bufnum;
DiskOut.ar(bufnum, In.ar(~abcPRC,1));
}).add;
SynthDef(\MasiboSDDiskout, {arg bufnum;
DiskOut.ar(bufnum, In.ar(~abcSD,1));
}).add;
SynthDef(\MasiboCLPDiskout, {arg bufnum;
DiskOut.ar(bufnum, In.ar(~abcCLP,1));
}).add;
SynthDef(\MasiboTOMDiskout, {arg bufnum;
DiskOut.ar(bufnum, In.ar(~abcTOM,1));
}).add;
SynthDef(\MasiboEFXDiskout, {arg bufnum;
DiskOut.ar(bufnum, In.ar(~abcEFX,1));
}).add;*/
)

