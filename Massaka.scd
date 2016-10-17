(
var
index1,index2,
var0=63,var1=63,var2=62,var3=63,var4=63,var5=63,var6=63,var7=63,var8=63,var9=63,var10=63,var11=63,var12=63,var13=63,abc = Bus.audio(s,1);
SynthDef(\Massaka, {
	arg freq,amp,totVol,pan,
	tube1,  tube2,  tube3, tube1V, tube2V, tube3V,
	decNo1, decNo2, decNo3,crackF, attTim, relTim;
	var klank = DynKlank.ar(`[[tube1, tube2, tube3],[tube1V,tube2V,tube3V],[decNo1,decNo2,decNo3]],
		input:Crackle.ar(crackF,0.2),
		freqscale:freq,
		freqoffset:LFNoise0.ar(5,freq/333),
		decayscale:1);
	var env = EnvGen.ar(Env.perc(attackTime:attTim,releaseTime: relTim), levelScale: 2.2, doneAction: 2);
	var outputstage = klank *  env;
	var outring = outputstage * ((totVol + amp -15).dbamp)  ;
	Out.ar(abc, outring);
	Out.ar(0, [outring,outring])
}).add;
MIDIdef.noteOn(\MassakaController, {arg vel, note;
	Synth(\Massaka,[\freq, note.midicps, \amp, vel.linlin(0,127,-12,12),\totVol, var7.linexp(0,127,0.01,1),
		\totVol,  var7.linlin(0,127,-24,24),
		//////////////////////////////////////
		\tube1,  (var0-60).midiratio,
		\tube2,  (var1-60).midiratio,
		\tube3,  (var2-60).midiratio,
		\tube1V,  var3.linexp(0,127,0.01,0.5),
		\tube2V,  var4.linexp(0,127,0.01,0.5),
		\tube3V,  var5.linexp(0,127,0.01,0.5),
		///////   ////////////////////////////
		\decNo1,  var6.linexp(0,127,0.0001,40),
		\decNo2,  var8.linexp(0,127,0.0001,40),
		\decNo3,  var9.linexp(0,127,0.0001,40),
		\crackF,  var11.linexp(0,127,0.3,2.001),
		\attTim,  var12.linexp(0,127,0.0001,0.5),
		\relTim,  var13.linexp(0,127,0.01,30);]);
	~test_Massaka = 1;
},srcID:~midiInINST3,chan: 1).permanent_(true);
MIDIdef.cc(\MassakaCC, {arg ...args;
	index1 = args[1];
	index2 = args[0];
	x = case
	{ index1 == 0  }   { var0=index2;}
	{ index1 == 1  }   { var1=index2;}
	{ index1 == 2  }   { var2=index2;}
	{ index1 == 3  }   { var3=index2;}
	{ index1 == 4  }   { var4=index2;}
	{ index1 == 5  }   { var5=index2;}
	{ index1 == 6  }   { var6=index2;}
	{ index1 == 7  }   { var7=index2;}
	{ index1 == 8  }   { var8=index2;}
	{ index1 == 9  }   { var9=index2;}
	{ index1 == 10 }   {/*PAN*/}
	{ index1 == 11 }   { var11=index2;}
	{ index1 == 12 }   { var12=index2;}
	{ index1 == 13 }   { var13=index2;}
	{ index1 == 14 }   { };
},(0..18),srcID:~midiInINST3,chan:1).permanent_(true);
SynthDef(\MassakaDiskout, {arg bufnum;
	DiskOut.ar(bufnum, In.ar(abc,1));
}).add;
)