(
var
annesi,
vr = Array.fill(128, 63),
helpMeh = Array.fill(128, 63),
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
	arg out,  bufnum = 0, ratio = 1, totVol = 0.1, tottotVOLVOL = 0, amp = 1, multout, gate = 1, volMeh = 1, env1;
	var playbuf, out1, busout, env, snd;
	playbuf = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum) * ratio, doneAction:0);
	env =  EnvGen.ar(Env.asr, gate, volMeh);
	DetectSilence.ar(playbuf,doneAction:2);
	env1 = Line.kr(0, 1, 10);
	FreeSelfWhenDone.kr(env1);
	out1 = env * playbuf;
	Out.ar(out, out1);
}).add;
SynthDef(\MasiboLite , {
	arg out,  bufnum = 0, testOut, ratio = 1, totVol = 0.1, boolLPF = 0, boolHPF= 0, hpFrq = 20, lpFrq = 19000, lpRq=1, hpRq=1, tottotVOLVOL = 0, multout, gate = 1, amp = 0, fltMeh = 1, decFlt = 1;
	var playbuf, out1, busout, env, snd, envFlt;
	playbuf = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum) * ratio, doneAction:0);
	env =  EnvGen.ar(Env.asr(0), gate, (totVol + amp -9 + tottotVOLVOL).dbamp);
	envFlt= EnvGen.ar(Env.linen(decFlt,1.3,1,curve: -4), gate, fltMeh);
	playbuf = BLowPass.ar(playbuf,freq:lpFrq + (envFlt * boolLPF),rq:lpRq);
	playbuf = BHiPass.ar(playbuf,freq:hpFrq + (envFlt * boolHPF),rq:hpRq);
	DetectSilence.ar(playbuf,doneAction:2);
	out1 = env * playbuf;
	Out.ar(1, out1);
	Out.ar(testOut, out1);
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
	Out.ar(1, rlpf);
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
	Out.ar(1, limit);
	Out.ar(~abcCYM, limit);
}).add;
MIDIdef.noteOn(\MasiboController, {arg vel, note;
	case

	{ (note == 48) || (note == 36) }   {
		annesi = 512;
		case
		{(vr[4] > 63) && (vr[5] > 63) }   { annesi = 4096 }
		{(vr[4] > 63) && (vr[5] <= 63) }  { annesi = 256 }
		{(vr[4] <= 63) && (vr[5] > 63) }  { annesi = 128 }
		{(vr[4] <= 63) && (vr[5] <= 63) } { annesi = 64  };
		if(betassBD == 0,  {betassBD = 1;headnoBD = Synth(\MasiboBDefkt, [\fftRate, annesi]).onFree{betassBD = 0}});
		if(noteArrayBD !== nil, {noteArrayBD.set(\gate, -1.001); noteArrayBD = nil});

		if (vr[3] > 63,
			{ headnoBD.set(\filtFreq, vr[3].linexp(64,127, 20, 20000), \filtType, 1) },
			{ headnoBD.set(\filtFreq, vr[3].linexp(0,63, 20, 20000), \filtType, 0) });
		if (vr[4] > 63,
			{ headnoBD.set(\mixEfx, vr[4].linlin(64,127, 0, 40)) },
			{ headnoBD.set(\mixEfx, vr[4].linlin(0,63, 40, 0)) });
		if (vr[5] > 63,
			{ headnoBD.set(\mixMy, vr[5].linlin(64,127, -1, 1)) },
			{ headnoBD.set(\mixMy, vr[5].linlin(0,63, 1, -1)) });
		headnoBD.set(
			\amp, vel.linlin(0,127,-12,12),
			\totVol, vr[2].linlin(0,127,-24,24),
			\tottotVOLVOL, vr[7].linlin(0,127,-24,24),
			\denem, vr[3]);
		noteArrayBD = Synth.before(headnoBD, \Masibo,
			[
				\bufnum, ~drumBD[vr[0]],
				\ratio, (vr[1]-63).midiratio,
				\gate, 1,
				\out, ~effektbusBD
	]).onFree{noteArrayBD = nil};~test_MasiboBD = 1; }

	{(note == 49) || (note == 37) }   {
		if(betassCYM == 0,  {betassCYM = 1;headnoCYM = Synth(\MasiboCYMefkt).onFree{betassCYM = 0}});
		if(noteArrayCYM !== nil, {noteArrayCYM.set(\gate, -1.1 /*orijinal 1.02di*/); noteArrayCYM = nil});
		if (vr[10] > 63,
			{ headnoCYM.set(\freqHP, vr[10].linexp(64,127, 20, 20000), \freqLP, 20000) },
			{ headnoCYM.set(\freqLP, vr[10].linexp(0,63, 20, 20000), \freqHP, 20) });
		headnoCYM.set(
			\amp, vel.linlin(0,127,-12,12),
			\samplerate, vr[11].linexp(0,127, 450, 44100),
			\samplersmooth, vr[11].linexp(0,127, 1, 0.0001),
			\totVol, vr[9].linlin(0,127,-24,24),
			\tottotVOLVOL, vr[7].linlin(0,127,-24,24),
			\limitdest, vr[12].linexp(0,127, 0.33, 0.01),
			\limitamp, vr[12].linexp(0,127,4,110));

		noteArrayCYM = Synth.before(headnoCYM, \Masibo,
			[
				\bufnum, ~drumCYM[vr[6]],
				\ratio, (vr[8]-63).midiratio,
				\gate, 1,
				\out, ~effektbusCYM
	]).onFree{noteArrayCYM = nil};~test_MasiboCYM = 1; }
	//HH lpFrq,rq:lpRq);
	{ (note == 50) || (note == 38) }   {
		//USE IT FOR MONO/POLY
		//if(betassBD == 0,  {betassBD = 1;headnoBD = Synth(\MasiboBDefkt, [\fftRate, annesi]).onFree{betassBD = 0}});
		if(noteArrayHH !== nil, {noteArrayHH.set(\gate, -1.001); noteArrayHH = nil});
		if(vr[15] > 63,
			{       //HPF
				helpMeh[0] = 19000;
				helpMeh[1] = 1;
				helpMeh[2] = vr[15].linexp(64,127,20,19000);
				helpMeh[3] = vr[16].linlin(0,127,1,0.001);
				if(vr[17]> 63,
					{helpMeh[5] = vr[17].linexp(64,127,1,19300 - helpMeh[2])},
					{helpMeh[5] = -1 * vr[17].linexp(0,63,helpMeh[2] - 20, 1)}
				);
				helpMeh[4] = 0;
			},
			{       //LPF
				helpMeh[0] = vr[15].linexp(0,63,20,19000);
				helpMeh[1] = vr[16].linlin(0,127,1, 0.001);
				helpMeh[2] = 20;
				helpMeh[3] = 1;
				if(vr[17]> 63,
					{helpMeh[4] = vr[17].linexp(64,127, 1,19300 - helpMeh[0])},
					{helpMeh[4] = -1 * vr[17].linexp(0,63,helpMeh[0] - 20, 1)}
				);
				helpMeh[5] = 0;
			}
		);
		noteArrayHH = Synth(\MasiboLite,
			[
				\bufnum, ~drumHH[vr[13]],
				\amp, vel.linlin(0,127,-12,12),
				\totVol, vr[49].linlin(0,127,-24,24),
				\tottotVOLVOL, vr[7].linlin(0,127,-24,24),
				\ratio, (vr[14]-63).midiratio,
				\lpFrq, helpMeh[0],
				\lpRq, helpMeh[1],
				\hpFrq, helpMeh[2],
				\hpRq, helpMeh[3],
				\boolLPF,helpMeh[4],
				\boolHPF,helpMeh[5],
				\decFlt, vr[18].linexp(0,127,0.001, 100),
				\gate, 1,
				\testOut, ~abcHH
		]).onFree{noteArrayHH = nil};
		~test_MasiboHH = 1;
	}
	//PRC
	{ (note == 51) || (note == 39)}   {
		if(noteArrayPRC !== nil, {noteArrayPRC.set(\gate, -1.001); noteArrayPRC = nil});
		if(vr[21] > 63,
			{       //HPF
				helpMeh[6] = 19000;
				helpMeh[7] = 1;
				helpMeh[8] = vr[21].linexp(64,127,20,19000);
				helpMeh[9] = vr[22].linlin(0,127,1,0.001);
				if(vr[23]> 63,
					{helpMeh[11] = vr[23].linexp(64,127,1,19300 - helpMeh[8])},
					{helpMeh[11] = -1 * vr[23].linexp(0,63,helpMeh[8] - 20, 1)}
				);
				helpMeh[10] = 0;
			},
			{       //LPF
				helpMeh[6] = vr[21].linexp(0,63,20,19000);
				helpMeh[7] = vr[22].linlin(0,127,1, 0.001);
				helpMeh[8] = 20;
				helpMeh[9] = 1;
				if(vr[23]> 63,
					{helpMeh[10] = vr[23].linexp(64,127, 1,19300 - helpMeh[6])},
					{helpMeh[10] = -1 * vr[23].linexp(0,63,helpMeh[6] - 20, 1)}
				);
				helpMeh[11] = 0;
			}
		);
		noteArrayPRC = Synth(\MasiboLite,
			[
				\bufnum, ~drumPRC[vr[19]],
				\amp, vel.linlin(0,127,-12,12),
				\totVol, vr[50].linlin(0,127,-24,24),
				\tottotVOLVOL, vr[7].linlin(0,127,-24,24),
				\ratio, (vr[20]-63).midiratio,
				\lpFrq, helpMeh[6],
				\lpRq, helpMeh[7],
				\hpFrq, helpMeh[8],
				\hpRq, helpMeh[9],
				\boolLPF,helpMeh[10],
				\boolHPF,helpMeh[11],
				\decFlt, vr[24].linexp(0,127,0.001, 100),
				\gate, 1,
				\testOut, ~abcPRC
		]).onFree{noteArrayPRC = nil};
		~test_MasiboPRC = 1;
	}
	//SD
	{ (note == 52) || (note == 40)}   {
		if(noteArraySD !== nil, {noteArraySD.set(\gate, -1.001); noteArraySD = nil});
		if(vr[27] > 63,
			{       //HPF
				helpMeh[12] = 19000;
				helpMeh[13] = 1;
				helpMeh[14] = vr[27].linexp(64,127,20,19000);
				helpMeh[15] = vr[28].linlin(0,127,1,0.001);
				if(vr[29]> 63,
					{helpMeh[17] = vr[29].linexp(64,127,1,19300 - helpMeh[14])},
					{helpMeh[17] = -1 * vr[29].linexp(0,63,helpMeh[14] - 20, 1)}
				);
				helpMeh[16] = 0;
			},
			{       //LPF
				helpMeh[12] = vr[27].linexp(0,63,20,19000);
				helpMeh[13] = vr[28].linlin(0,127,1, 0.001);
				helpMeh[14] = 20;
				helpMeh[15] = 1;
				if(vr[29]> 63,
					{helpMeh[16] = vr[29].linexp(64,127, 1,19300 - helpMeh[12])},
					{helpMeh[16] = -1 * vr[29].linexp(0,63,helpMeh[12] - 20, 1)}
				);
				helpMeh[17] = 0;
			}
		);
		noteArraySD = Synth(\MasiboLite,
			[
				\bufnum, ~drumPRC[vr[25]],
				\amp, vel.linlin(0,127,-12,12),
				\totVol, vr[51].linlin(0,127,-24,24),
				\tottotVOLVOL, vr[7].linlin(0,127,-24,24),
				\ratio, (vr[26]-63).midiratio,
				\lpFrq, helpMeh[12],
				\lpRq, helpMeh[13],
				\hpFrq, helpMeh[14],
				\hpRq, helpMeh[15],
				\boolLPF,helpMeh[16],
				\boolHPF,helpMeh[17],
				\decFlt, vr[30].linexp(0,127,0.001, 100),
				\gate, 1,
				\testOut, ~abcSD
		]).onFree{noteArraySD = nil};
		~test_MasiboSD = 1;
	}
	//CLP
	{ (note == 53) || (note == 41)}   {
		if(noteArrayCLP !== nil, {noteArrayCLP.set(\gate, -1.001); noteArrayCLP = nil});
		if(vr[33] > 63,
			{       //HPF
				helpMeh[18] = 19000;
				helpMeh[19] = 1;
				helpMeh[20] = vr[33].linexp(64,127,20,19000);
				helpMeh[21] = vr[34].linlin(0,127,1,0.001);
				if(vr[35]> 63,
					{helpMeh[23] = vr[35].linexp(64,127,1,19300 - helpMeh[20])},
					{helpMeh[23] = -1 * vr[35].linexp(0,63,helpMeh[20] - 20, 1)}
				);
				helpMeh[22] = 0;
			},
			{       //LPF
				helpMeh[18] = vr[33].linexp(0,63,20,19000);
				helpMeh[19] = vr[34].linlin(0,127,1, 0.001);
				helpMeh[20] = 20;
				helpMeh[21] = 1;
				if(vr[35]> 63,
					{helpMeh[22] = vr[35].linexp(64,127, 1,19300 - helpMeh[18])},
					{helpMeh[22] = -1 * vr[35].linexp(0,63,helpMeh[18] - 20, 1)}
				);
				helpMeh[23] = 0;
			}
		);
		noteArrayCLP = Synth(\MasiboLite,
			[
				\bufnum, ~drumCLP[vr[31]],
				\amp, vel.linlin(0,127,-12,12),
				\totVol, vr[52].linlin(0,127,-24,24),
				\tottotVOLVOL, vr[7].linlin(0,127,-24,24),
				\ratio, (vr[32]-63).midiratio,
				\lpFrq, helpMeh[18],
				\lpRq, helpMeh[19],
				\hpFrq, helpMeh[20],
				\hpRq, helpMeh[21],
				\boolLPF,helpMeh[22],
				\boolHPF,helpMeh[23],
				\decFlt, vr[36].linexp(0,127,0.001, 100),
				\gate, 1,
				\testOut, ~abcCLP
		]).onFree{noteArrayCLP = nil};
		~test_MasiboCLP = 1;
	}
	//TOM
	{ (note == 54) || (note == 42)}   {
		if(noteArrayTOM !== nil, {noteArrayTOM.set(\gate, -1.001); noteArrayTOM = nil});
		if(vr[39] > 63,
			{       //HPF
				helpMeh[24] = 19000;
				helpMeh[25] = 1;
				helpMeh[26] = vr[39].linexp(64,127,20,19000);
				helpMeh[27] = vr[40].linlin(0,127,1,0.001);
				if(vr[41]> 63,
					{helpMeh[29] = vr[41].linexp(64,127,1,19300 - helpMeh[26])},
					{helpMeh[29] = -1 * vr[41].linexp(0,63,helpMeh[26] - 20, 1)}
				);
				helpMeh[28] = 0;
			},
			{       //LPF
				helpMeh[24] = vr[39].linexp(0,63,20,19000);
				helpMeh[25] = vr[40].linlin(0,127,1, 0.001);
				helpMeh[26] = 20;
				helpMeh[27] = 1;
				if(vr[41]> 63,
					{helpMeh[28] = vr[41].linexp(64,127, 1,19300 - helpMeh[24])},
					{helpMeh[28] = -1 * vr[41].linexp(0,63,helpMeh[24] - 20, 1)}
				);
				helpMeh[29] = 0;
			}
		);
		noteArrayTOM = Synth(\MasiboLite,
			[
				\bufnum, ~drumTOM[vr[37]],
				\amp, vel.linlin(0,127,-12,12),
				\totVol, vr[53].linlin(0,127,-24,24),
				\tottotVOLVOL, vr[7].linlin(0,127,-24,24),
				\ratio, (vr[38]-63).midiratio,
				\lpFrq, helpMeh[24],
				\lpRq, helpMeh[25],
				\hpFrq, helpMeh[26],
				\hpRq, helpMeh[27],
				\boolLPF,helpMeh[28],
				\boolHPF,helpMeh[29],
				\decFlt, vr[42].linexp(0,127,0.001, 100),
				\gate, 1,
				\testOut, ~abcTOM
		]).onFree{noteArrayTOM = nil};
		~test_MasiboTOM = 1;
	}
	//EFX
	{ (note == 55) || (note == 43)}   {
		if(noteArrayEFX !== nil, {noteArrayEFX.set(\gate, -1.001); noteArrayEFX = nil});
		if(vr[45] > 63,
			{       //HPF
				helpMeh[30] = 19000;
				helpMeh[31] = 1;
				helpMeh[32] = vr[45].linexp(64,127,20,19000);
				helpMeh[33] = vr[46].linlin(0,127,1,0.001);
				if(vr[47]> 63,
					{helpMeh[35] = vr[47].linexp(64,127,1,19300 - helpMeh[32])},
					{helpMeh[35] = -1 * vr[47].linexp(0,63,helpMeh[32] - 20, 1)}
				);
				helpMeh[34] = 0;
			},
			{       //LPF
				helpMeh[30] = vr[45].linexp(0,63,20,19000);
				helpMeh[31] = vr[46].linlin(0,127,1, 0.001);
				helpMeh[32] = 20;
				helpMeh[33] = 1;
				if(vr[47]> 63,
					{helpMeh[34] = vr[47].linexp(64,127, 1,19300 - helpMeh[30])},
					{helpMeh[34] = -1 * vr[47].linexp(0,63,helpMeh[30] - 20, 1)}
				);
				helpMeh[35] = 0;
			}
		);
		noteArrayEFX = Synth(\MasiboLite,
			[
				\bufnum, ~drumEFX[vr[43]],
				\amp, vel.linlin(0,127,-12,12),
				\totVol, vr[54].linlin(0,127,-24,24),
				\tottotVOLVOL, vr[7].linlin(0,127,-24,24),
				\ratio, (vr[44]-63).midiratio,
				\lpFrq, helpMeh[30],
				\lpRq, helpMeh[31],
				\hpFrq, helpMeh[32],
				\hpRq, helpMeh[33],
				\boolLPF,helpMeh[34],
				\boolHPF,helpMeh[35],
				\decFlt, vr[48].linexp(0,127,0.001, 100),
				\gate, 1,
				\testOut, ~abcEFX
		]).onFree{noteArrayEFX = nil};
		~test_MasiboEFX = 1;
	}
},srcID:~midiInINST3,chan: 11).permanent_(true);
/*MIDIdef.noteOff(\noteoffmykeymasibo, {arg vel, note;
case
//{ note == 48 }   {noteArrayBD.set(\gate,0);noteArrayBD = nil;}
},srcID:~midiInINST3,chan:11);
*/
MIDIdef.cc(\masiboCC, {arg ...args;
	if(betassCYM == 0,  {betassCYM = 1;headnoCYM = Synth(\MasiboCYMefkt).onFree{betassCYM = 0}});
	vr[args[1]] = args[0];
	if (vr[10] > 63,
		{ headnoCYM.set(\freqHP, vr[10].linexp(64,127, 20, 20000), \freqLP, 20000) },
		{ headnoCYM.set(\freqLP, vr[10].linexp(0,63, 20, 20000), \freqHP, 20) });
	headnoCYM.set(
		\samplerate, vr[11].linexp(0,127, 450, 44100),
		\samplersmooth, vr[11].linexp(0,127, 1, 0.0001),
		\totVol, vr[9].linlin(0,127,-24,24),
		\tottotVOLVOL, vr[7].linlin(0,127,-24,24),
		\limitdest, vr[12].linexp(0,127, 0.33, 0.01),
		\limitamp, vr[12].linexp(0,127,4,110));

},(0..90),srcID:~midiInINST3,chan:11).permanent_(true);
SynthDef(\MasiboBDDiskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(~abcBD,1));
}).add;
SynthDef(\MasiboCYMDiskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(~abcCYM,1));
}).add;
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
}).add;
)

