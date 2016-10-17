// DPG UNIVERSAL CH1-bitwo

(

SynthDef(\DPG1,{ arg out=0;
	Out.ar(out,AudioIn.ar([1,1]))
}).play;

//notes: may add delay or stuff like that
/*SynthDef("DPG1-Diskout", {arg bufnum;
	DiskOut.ar(bufnum, In.ar(1,1));
}).add;*/
SynthDef(\DPG1Diskout, {arg bufnum;
	DiskOut.ar(bufnum, AudioIn.ar(1))
}).add;


// DPG UNIVERSAL CH1-bitwo



)
/*
// DPG UNIVERSAL CH2-ikitwo
/*SynthDef("DPG2",{ arg out=0;
	Out.ar(out,AudioIn.ar([1,2]));
}).play;*/

//notes: may


(
var pitches = (0..14), // replace with other pitches you want
move = 0, window, slider;
window = GUI.window.new("Mouse Transport", Rect(5, 100, 500, 50)); slider = GUI.slider.new(window, Rect(5, 5, 490, 20))
.action_({ |view|
move = (view.value * 4 - 2).round;
})
.value_(0.5); window.front;"/Users/EmanTnuocca/Downloads/joeGendy.rtf"


p = Pbind(
// Pfunc is the direction to move through the array // it could be anything
// - could read from MIDI or HID and convert it into a step
// - could be a GUI control, as it is here
\degree, Pwalk(pitches, Pfunc { move }, 1, 7), \dur, 0.25
"/Users/EmanTnuocca/Downloads/joeGendy.rtf"
).play;
)


OSCFunc


(
OSCdef(
key: \whatever,
func: {arg ...args; args.postln},
path: '/stuff')
)

*/