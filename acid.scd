(
var
var0=63,var1=63,var2=63,var3=63,var4=63,var5=63,var6=63,
var7=63,var8=63,var9=63,var10=63,var11=63,var12=63,var13=63,
noteArrayAcid = Array.newClear(128),
abc = Bus.audio(s,1),
index1,index2;
SynthDef(\Acid, {
	arg outBus=0, gate=1, pitch=50, amp=0.1, totVol,
	fltAtk,fltDec,fltSus,fltRel,fltAmt,fltRz,
	volAtk,volDec,volSus,volRel,volAmt;
	var env1, env2, out , tenv;
	env1 = EnvGen.ar(
		Env.adsr(
			attackTime:volAtk,
			decayTime:volDec,
			sustainLevel:gate * volSus,
			releaseTime:volRel,
	), gate, 1,doneAction:2);
	env2 = EnvGen.ar(Env.adsr(fltAtk, fltDec, fltSus, fltRel, fltAmt, -4), gate);
	out = LFPulse.ar(pitch.midicps, 0.0, 0.51, 2, -1);
	out = BLowPass4.ar(out, ((pitch + env2).clip2(124)).midicps, fltRz,0.1);
	//out = RLPF.ar(out, (pitch + env2).midicps, fltRz);
	out = out * env1* ((totVol + amp -15).dbamp);
	Out.ar(abc, out);
	Out.ar(outBus, out.dup);
}).add;
MIDIdef.noteOn(\AcidController, {arg vel, note;
	if(noteArrayAcid[note] !== nil,noteArrayAcid[note].free);
	noteArrayAcid[note] = Synth(\Acid,[\pitch, note, \amp, vel.linlin(0,127,-12,12),\gate, 1,
		\fltAtk,  var0.linexp(0,127,0.0005,0.01),
		\fltDec,  var1.linexp(0,127,0.01,20),
		\fltSus,  var2.linlin(0,127,0,1),
		\fltRel,  var3.linexp(0,127,0.01,10),
		\fltAmt,   var4,
		\fltRz,    var5.linexp(0,127,1,0.001),
		//
		\volAtk,  var6.linexp(0,127,0.0001,1),
		\volDec,  var8.linexp(0,127,0.01,20),
		\volSus,  var9.linlin(0,127,0,1),
		\volRel,  var10.linexp(0,127,0.01,10),
		\totVol, var7.linlin(0,127,-24,24);]);
	~test_Acid = 1;
},srcID:~midiInINST2,chan: 8).permanent_(true);
MIDIdef.noteOff(\noteoffmykeyAcid, {arg vel, note;
	noteArrayAcid[note].set(\gate,0);
	noteArrayAcid[note] = nil;
},srcID:~midiInINST2,chan:8).permanent_(true);
MIDIdef.cc(\AcidCC, {arg ...args;
	index1 = args[1];
	index2 = args[0];
	x = case
	{ index1 == 0 }   { var0=index2;}
	{ index1 == 1 }   { var1=index2;}
	{ index1 == 2 }   { var2=index2;}
	{ index1 == 3 }   { var3=index2;}
	{ index1 == 4 }   { var4=index2;}
	{ index1 == 5 }   { var5=index2;}
	{ index1 == 6 }   { var6=index2;}
	{ index1 == 7 }   { var7=index2;}
	{ index1 == 8 }   { var8=index2;}
	{ index1 == 9 }   { var9=index2;}
	{ index1 == 10}   { var10=index2;}
	{ index1 == 11}   { var11=index2;}
	{ index1 == 12}   { var12=index2;};
},(0..10),srcID:~midiInINST2,chan:8).permanent_(true);
SynthDef(\AcidDiskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(abc,1));
}).add;
)
