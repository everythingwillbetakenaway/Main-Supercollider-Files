(
var
inst1 = Buffer.alloc(s, 44100 * 19.0, 1),
inst2 = Buffer.alloc(s, 44100 * 19.0, 1),
inst3 = Buffer.alloc(s, 44100 * 19.0, 1),
inst4 = Buffer.alloc(s, 44100 * 19.0, 1),
inst5 = Buffer.alloc(s, 44100 * 19.0, 1),
inst6 = Buffer.alloc(s, 44100 * 19.0, 1),
songStartTrig = Bus.control(s,1),
var0=63,var1=63,var2=63,var3  =63,var4 =63, var5=63, var6  =63,
var7=63,var8=63,var9=63,var10=63,var11=63,var12=63,var13=63,
var14=63,var15=63,var16=63,var17=63,var18=63,var19=63,var20=63,
abc1 = Bus.audio(s,1),
abc2 = Bus.audio(s,1),
abc3 = Bus.audio(s,1),
abc4 = Bus.audio(s,1),
abc5 = Bus.audio(s,1),
abc6 = Bus.audio(s,1),
noteArrayDrumSmpl = Array.newClear(128),
index1,index2;
SynthDef(\DrumSmpl_Recorder, { arg out = 0, bufnum = inst1, starter = 0;
	var formant,abc;
	formant = SoundIn.ar(1,1,0);
	abc = Changed.ar(formant,0.05) + T2A.ar(InTrig.kr(songStartTrig)) ;
	RecordBuf.ar(formant, bufnum, doneAction: 2,
		loop: SetResetFF.ar(DC.ar(1),abc),
		run:((SetResetFF.ar(DC.ar(1),abc) * -1) + 1),
		trigger:((SetResetFF.ar(DC.ar(1),abc) * -1) + 1)//abc-0.001
	);
}).add;
SynthDef(\DrumSmpl, { arg out = 0, bufnum = inst1, ratio = 1, amp = 0.1, totVol = 0.1, tottotVOLVOL = 0, gate = 1;
	var playbuf,comp;
		var env = Env.asr(0.01, 1, 0.01);
	    var gen = EnvGen.kr(env, gate, doneAction: 2);
	//playbuf = BufRd.ar(1, bufnum, Phasor.ar(0, BufRateScale.kr(bufnum) * 1, 0.1, BufFrames.kr(bufnum)), loop:0, interpolation:4);
	playbuf = PlayBuf.ar(1,bufnum,ratio);
	FreeSelfWhenDone.kr(playbuf); // frees the synth when the PlayBuf is finished
	comp =  Compander.ar(playbuf, playbuf,
		thresh: 0.01,
		slopeBelow: 10,
		slopeAbove: 1,
		clampTime: 0.01,
		relaxTime: 0.01
	);
	comp = comp * ((totVol + amp -18 + tottotVOLVOL).dbamp);
	Out.ar([0,1], comp * gen);
	Out.ar(out, comp * gen);
}).add;
MIDIdef.noteOn(\DrumSmplController, {arg vel, note;
	case
	{ note == 48 }   { noteArrayDrumSmpl[48] = Synth(\DrumSmpl,
		[
			\bufnum, inst1,
			\ratio, (var0-63).midiratio,
			\amp, vel.linlin(0,127,-18,18),
			\totVol, var6.linlin(0,127,-24,24),
			\tottotVOLVOL, var7.linlin(0,127,-24,24),
			\out, abc1]);~test_DrumSmpl1 = 1;}
	{ note == 49 }   { noteArrayDrumSmpl[49] = Synth(\DrumSmpl,
		[
			\bufnum, inst2,
			\ratio, (var1-63).midiratio,
			\amp, vel.linlin(0,127,-18,18),
			\totVol, var8.linlin(0,127,-24,24),
			\tottotVOLVOL, var7.linlin(0,127,-24,24),
			\out, abc2]);~test_DrumSmpl2 = 1;}
	{ note == 50 }   { noteArrayDrumSmpl[50] = Synth(\DrumSmpl,
		[
			\bufnum, inst3,
			\ratio, (var2-63).midiratio,
			\amp, vel.linlin(0,127,-18,18),
			\totVol, var9.linlin(0,127,-24,24),
			\tottotVOLVOL, var7.linlin(0,127,-24,24),
			\out, abc3 ]);~test_DrumSmpl3 = 1;}
	{ note == 51 }   { noteArrayDrumSmpl[51] =  Synth(\DrumSmpl,
		[
			\bufnum, inst4,
			\ratio, (var3-63).midiratio,
			\amp, vel.linlin(0,127,-18,18),
			\totVol, var11.linlin(0,127,-24,24),
			\tottotVOLVOL, var7.linlin(0,127,-24,24),
			\out, abc4]);~test_DrumSmpl4 = 1;}
	{ note == 52 }   { noteArrayDrumSmpl[52] = Synth(\DrumSmpl,
		[
			\bufnum, inst5,
			\ratio, (var4-63).midiratio,
			\amp, vel.linlin(0,127,-18,18),
			\totVol, var12.linlin(0,127,-24,24),
			\tottotVOLVOL, var7.linlin(0,127,-24,24),
			\out, abc5]);~test_DrumSmpl5 = 1;}
	{ note == 53 }   {noteArrayDrumSmpl[53] =  Synth(\DrumSmpl,
		[
			\bufnum, inst6,
			\ratio, (var5-63).midiratio,
			\amp, vel.linlin(0,127,-18,18),
			\totVol, var13.linlin(0,127,-24,24),
			\tottotVOLVOL, var7.linlin(0,127,-24,24),
			\out, abc6]);~test_DrumSmpl6 = 1;}
},srcID:~midiInINST6,chan:0).permanent_(true);
MIDIdef.cc(\DrumSmplCC, {arg ...args;
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
	{ index1 == 7 }    { var7=index2;}//volume
	{ index1 == 8 }    { var8=index2;}
	{ index1 == 9 }    { var9=index2;}
	{ index1 == 10}   { var10=index2;}
	{ index1 == 11}   { var11=index2;}
	{ index1 == 12}   { var12=index2;}
	{ index1 == 13}   { var13=index2;}
	{ index1 == 14}   { var14=index2;}//bank
	{ index1 == 15}   { var12=index2;}
	{ index1 == 16}   { var12=index2;}
	{ index1 == 17}   { var12=index2;}
	{ index1 == 80 }    { ~testcase = index2}//for protecting the synths
	;
},(0..127),srcID:~midiInINST6,chan:0).permanent_(true);
MIDIdef.noteOff(\noteoffmykeyDrumSmpl, {arg vel, note;
	noteArrayDrumSmpl[note].set(\gate,0);
},srcID:~midiInINST6,chan:0).permanent_(true);
MIDIdef.noteOn(\test4,
	{arg ...args;
		if ( (args[1] == 36) && (~testcase == 2), {Synth(\DrumSmpl_Recorder, [\bufnum, inst1])});
		if ( (args[1] == 38) && (~testcase == 2), {Synth(\DrumSmpl_Recorder, [\bufnum, inst2])});
		if ( (args[1] == 40) && (~testcase == 2), {Synth(\DrumSmpl_Recorder, [\bufnum, inst3])});
		if ( (args[1] == 41) && (~testcase == 2), {Synth(\DrumSmpl_Recorder, [\bufnum, inst4])});
		if ( (args[1] == 43) && (~testcase == 2), {Synth(\DrumSmpl_Recorder, [\bufnum, inst5])});
		if ( (args[1] == 45) && (~testcase == 2), {Synth(\DrumSmpl_Recorder, [\bufnum, inst6])});
		if ( (args[1] == 42) && (~testcase == 2), {//COPY PURPOSE
			inst1.write(("~/Music/composition/drummzz/ch1_" ++ var14.asString ++ "show.aiff").standardizePath, "aiff", "int16", -1, 0, false);
			inst2.write(("~/Music/composition/drummzz/ch2_" ++ var14.asString ++ "show.aiff").standardizePath, "aiff", "int16", -1, 0, false);
			inst3.write(("~/Music/composition/drummzz/ch3_" ++ var14.asString ++ "show.aiff").standardizePath, "aiff", "int16", -1, 0, false);
			inst4.write(("~/Music/composition/drummzz/ch4_" ++ var14.asString ++ "show.aiff").standardizePath, "aiff", "int16", -1, 0, false);
			inst5.write(("~/Music/composition/drummzz/ch5_" ++ var14.asString ++ "show.aiff").standardizePath, "aiff", "int16", -1, 0, false);
			inst6.write(("~/Music/composition/drummzz/ch6_" ++ var14.asString ++ "show.aiff").standardizePath, "aiff", "int16", -1, 0, false);
		});
		if ( (args[1] == 44) && (~testcase == 2), {//LOAD PURPOSE
			inst1.read(("~/Music/composition/drummzz/ch1_" ++ var14.asString ++ "show.aiff").standardizePath,);
			inst2.read(("~/Music/composition/drummzz/ch2_" ++ var14.asString ++ "show.aiff").standardizePath,);
			inst3.read(("~/Music/composition/drummzz/ch3_" ++ var14.asString ++ "show.aiff").standardizePath,);
			inst4.read(("~/Music/composition/drummzz/ch4_" ++ var14.asString ++ "show.aiff").standardizePath,);
			inst5.read(("~/Music/composition/drummzz/ch5_" ++ var14.asString ++ "show.aiff").standardizePath,);
			inst6.read(("~/Music/composition/drummzz/ch6_" ++ var14.asString ++ "show.aiff").standardizePath,);
		});
},srcID:~midiInINST6,chan:0).permanent_(true); // match any noteOn
SynthDef(\DrumSmpl1Diskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(abc1,1));
}).add;
SynthDef(\DrumSmpl2Diskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(abc2,1));
}).add;
SynthDef(\DrumSmpl3Diskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(abc3,1));
}).add;
SynthDef(\DrumSmpl4Diskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(abc4,1));
}).add;
SynthDef(\DrumSmpl5Diskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(abc5,1));
}).add;
SynthDef(\DrumSmpl6Diskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(abc6,1));
}).add;
//cheers

~sysrt = { arg src, chan, val;    if(chan == 10,  {  songStartTrig.value = 10 })};

MIDIIn.addFuncTo(\sysrt, ~sysrt);
)