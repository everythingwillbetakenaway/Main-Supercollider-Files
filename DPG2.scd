(
var bells, folder, midiport, index1, index2,
testVar1 = true,  testVar2 = false, testVar3 = true, testVar4 = false,
playerNode ,synthNode, routineNode,
raddd = 3,
midiOutMN = MIDIOut.newByName("Cirklon", "Port 1"),
var0=63,var1=63,var2=63,var3=63,var4=63,var5=63,var6=63,
var7=63,var8=63,var9=63,var10=63,var11=63,var12=63,var13=63,
var14=63,var15=63,var16=63,var17=63,var18=63,var19=63,var20=63,
var21=63,var22=63,var23=63,var24=63,var25=63,var26=63,var27=63;
/*
CV #01 = Echophon Feedback CV Input
CV #02 = Echophon Pitch-1 CV Input
CV #03 = MMG Res CV Input
CV #04 = MMG Mode CV Input
CV #05 = Maths CH-4 Fall CV Input
CV #06 = Maths CH-1 Fall CV Input
CV #07 = Math CH-2 Input
CV #08 = ModDemix CH-2 Modulation Input

CV #09 = Echophon Echo Time CV Input
CV #10 = Echophon Mix CV Input
CV #11 = Echophon Pitch Depth Input
CV #12 = MMG Freq-2 Input
CV #13 = Maths CH-4 Rise CV Input
CV #14 = Maths CH-1 Gate Input
CV #15 = ModDemix CH-1 Input
CV #16 = Phonogene Varispeed Input

GATE #1 = Null
GATE #2 = Null
GATE #3 = Make Noise CH-3 Input
GATE #4 = Phonogene Rec Input
GATE #5 = Null
GATE #6 = ModDemix CH-1 Modulation Input
GATE #7 = Echophon Tempo
GATE #8 = Make Noise CH-4 Trig Input & Cycle Input

Maths CH-1 Integral Output (Alttaki) --> Phonogene Play
Maths CH-1 Normal Output (Ustteki) --> Phonogene SOS
Maths INV Output -->  Gene-Size CV Input
Maths CH-4 Normal Output (Ustteki) --> ModDemix CH-2 Input
ModDemix CH-1 Output --> Phonogene Slide CV Input
ModDemix CH-2 Output --> MMG Freq-1 Input

Notes:
White Knobs -> Maths CH-2 Attenuator                      disinda hepsi sonuna kadar saat yonunde
Blue Knobs -> Maths Modulu disinda ve Phonogene Varispeed disinda hepsi sonuna kadar anti-saat yonunde
Maths Blue Knobs-> Hepsi 12 yonunde!
Echophon Feedback saat 21:00 Yonunde
*/

/*folder = PathName.new("/Users/EmanTnuocca/Documents/SC CODES/samplesformakenoise/");
folder.entries.do({
	arg path;
	makeNoise = makeNoise.add(Buffer.read(s, path.fullPath));
});*/

SynthDef(\MakeNoisePlayer, {
	arg out = 0, bufnum = 0, ratio = 1, amp = 1, multout, gate = 1;
	var playbuf, out1, busout, env;
	playbuf = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * ratio, doneAction:2);
	Out.ar(out, 0.25 *  playbuf); //audio output
}).add;
MIDIdef.cc(\MakeNoiseCC, {arg ...args;
	index1 = args[1];
	index2 = args[0];
	x = case
	{ index1 == 0 }    { var0=index2;
		testVar4 = true;
		Routine {
			testVar4 = false;
		}.play;
		if(((var0 < 20) && (testVar1 == true)), {
			testVar1 = false;
			testVar2 = true;
			routineNode = Routine {
				playerNode = Synth.new(\MakeNoisePlayer, [\bufnum, ~makeNoise[var1]]);
				    4.wait;
				testVar1 = true;
				testVar2 = false;
			}.play;
		});
		if(((var0 >= 20) && (testVar2 == true)), {
			routineNode.stop;
			playerNode.free;
			testVar1 = true;
			testVar2= false;
		});
		if(((var0 > 110) && (testVar3 == true)), {
			testVar3 = false;
			routineNode = Routine {
				midiOutMN.noteOn(15, 60, 90);   //slide stop
				0.1.wait;
				midiOutMN.noteOn(13, 60, 125);   //gene stop
				0.1.wait;
				playerNode = Synth(\MakeNoisePlayer, [\bufnum, ~makeNoise[var1], \out, 2]);
				midiOutMN.noteOn(14, 60, 90);   //rec start
				0.1.wait;
				midiOutMN.noteOff(14, 60, 90); //rec stop
				4.wait;
				midiOutMN.noteOff(15, 60, 90); //slide start
				0.1.wait;
				midiOutMN.noteOff(13, 60, 125); //gene start
				2.wait;
				testVar3 = true;
			}.play;
		});
	}
	{ index1 == 1 }    { var1=index2;
		if(testVar4==true, {
			testVar4 = false;
			routineNode = Routine {
				midiOutMN.noteOn(15, 60, 90);   //slide stop
				0.1.wait;
				midiOutMN.noteOn(13, 60, 125);   //gene stop
				0.1.wait;
				playerNode = Synth(\MakeNoisePlayer, [\bufnum, ~makeNoise[var1], \out, 2]);
				midiOutMN.noteOn(14, 60, 90);   //rec start
				0.1.wait;
				midiOutMN.noteOff(14, 60, 90); //rec stop
				4.wait;
				midiOutMN.noteOff(15, 60, 90); //slide start
				0.1.wait;
				midiOutMN.noteOff(13, 60, 125); //gene start
				2.wait;
			}.play;
			"NAZISALUTE!".postln;});
	}
	{ index1 == 2 }    { var2=index2;}
	{ index1 == 3 }    { var3=index2;}
	{ index1 == 4 }    { var4=index2;}
	{ index1 == 5 }    { var5=index2;}
	{ index1 == 6 }    { var6=index2;}
	{ index1 == 7 }    { var7=index2;}
	{ index1 == 8 }    { var8=index2;}
	{ index1 == 9 }    { var9=index2;}
	{ index1 == 10}    {var10=index2;}
	{ index1 == 11}    {var11=index2;}
},(0..11),srcID:~midiInINST2,chan:0).permanent_(true);




//player area//
synthNode = SynthDef(\DPG2,{ arg out=0;
	Out.ar(out,AudioIn.ar([2,2]))
}).play;
SynthDef(\DPG2Diskout, {arg bufnum;
	DiskOut.ar(bufnum, AudioIn.ar(2))
}).add;
)

/*
//freeze, geneshift, cutoff clock atama yap
//ekstra filter at sc domain
//unutma herseye dijital lfo atabiirsin
~midiport.noteOn(15, 60, 90);   //slide stop
~midiport.noteOff(15, 60, 90); //slide start

~midiport.noteOn(14, 60, 90);   //rec start
~midiport.noteOff(14, 60, 90); //rec stop

~midiport.noteOn(13, 60, 125);   //gene stop
~midiport.noteOff(13, 60, 125); //gene start

;

chan cc cont
*/

