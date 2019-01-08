(
var
nova3030303 = ParGroup.new,
vr = Array.fill(128, 63),
defme,
noteArray3030303 = Array.newClear(128);
SynthDef(\sd3030303, {
	arg outBus=0, gate=1, pitch=50, amp=0.1, totVol,
	fltCtf,fltDec,fltDst,fltPitchMod,fltAmt,fltRz,fltRza,
	volAtk,volDec,volSus,volRel,volAmt;
	var env1, env2, out , tenv;
	env1 = EnvGen.ar(
		Env.adsr(
			attackTime:volAtk,
			decayTime:volDec,
			sustainLevel:gate * volSus,
			releaseTime:volRel,
	), gate, 1,doneAction:2);
	env2 = EnvGen.ar(Env.perc(0.01, fltDec, fltAmt, -4));
	out = LFPulse.ar(pitch.midicps, 0.0, 0.51, 2, -1);
	//out = BLowPass4.ar(out, ((pitch + env2).clip2(124)).midicps, fltRz,0.1);
	//out = RLPFD.ar(out, ((fltAtk + pitch + env2).midicps) * ((1 + tanh(fltRza))/2), fltRz, fltRz);
	out = RLPFD.ar(out, (fltCtf  + pitch.linlin(0,127,0,fltPitchMod) + env2).midicps, fltRz, fltRza);
	out = out * env1 *((totVol + amp -15).dbamp);
	Out.ar(1, out);
}).add;
defme = { arg a1,b1,c1; var a =
	[
		\fltCtf,  vr[0].linlin(0,127,-63,64), //cutoff freq
		\fltDec,  vr[1].linlin(0,127,0,5),
		\fltDst,  vr[2].linlin(0,127,0,1),
		\fltPitchMod,  vr[3].linlin(0,127,0,127), //filter pitch mod
		\fltAmt,   vr[4],
		\fltRz,    vr[5].linlin(0,127,0,1),
		\fltRza,   vr[5].linlin(0,127,-pi,pi),
		//
		\volAtk,  vr[6].linexp(0,127,0.01,10),
		\volDec,  vr[8].linlin(0,127,0,5),
		\volSus,  vr[9].linexp(0,127,0.01,1),
		\volRel,  vr[10].linexp(0,127,0.01,10),
		\totVol, vr[7].linlin(0,127,-24,24)];
	if(a1 == 1, { [\pitch, b1, \amp, c1.linlin(0,127,-12,12)] ++ a} ,{a});
};
MIDIdef.noteOn(\controller3030303, {arg vel, note;
	if(noteArray3030303[note] !== nil,noteArray3030303[note].free);
	noteArray3030303[note] = Synth(\sd3030303,defme.value(1, note, vel),nova3030303);
	~test_3030303 = 1;
},srcID:~midiInINST2,chan: 8).permanent_(true);
MIDIdef.noteOff(\noteoffmykey3030303, {arg vel, note;
	noteArray3030303[note].set(\gate,0);
	noteArray3030303[note] = nil;
},srcID:~midiInINST2,chan:8).permanent_(true);
MIDIdef.cc(\cc3030303, {arg ...args;
	vr[args[1]] = args[0];
	nova3030303.setControls(defme.value(0));
},(0..10),srcID:~midiInINST2,chan:8).permanent_(true);
)