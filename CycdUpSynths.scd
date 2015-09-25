// ****************************************************
// Start this block first then scroll down and start...
// ****************************************************
(
s = Server.default;
o = s.options;
// Post the number of output channels
o.numOutputBusChannels.postln;
// Set them to a new number
o.numOutputBusChannels = 4; // The next time it boots, this will take effect
// specify a device
o.device = nil; // use the system default soundcard
//o.device = "MOTU Traveler";

s.boot;
thisProcess.openPorts; // list all open ports
n = NetAddr.localAddr;

Ndef(\bike1).clear;
Ndef(\bike2).clear;
Ndef(\bike3).clear;
Ndef(\bike4).clear;

// This is the generic "synth" that all bikes play, with varying parameters
y = { | amp=1.0, freq=70, chaos_amp=0.6, trig,
	bike_parameter=0.2 // Parameters that the bike modulates
	freq_mod = 0.10, // 10% of frequency
	lfo_freq=15.0, lfo_amt=0.0,
	chaos_source=\chaos |

	freq = freq - (freq * freq_mod * (1.0 - bike_parameter));
	amp = amp * bike_parameter * 1.0;
	l = Pulse.kr(lfo_freq, mul: lfo_amt * bike_parameter / 2.0 , add: 1.0 - (lfo_amt * bike_parameter / 2.0));

	a = SinOsc.ar(freq + LFNoise1.ar(0.1!2,5),(Ndef(\bike1) +  Ndef(chaos_source).ar) * chaos_amp * LFNoise1.ar(0.1!2,3), LFNoise1.ar(3,6)).tanh;
	5.do{
		a = AllpassL.ar(a,0.3,{0.2.rand+0.1}!2, 2)
	};

	a.tanh * amp * l;
};

Ndef(\chaos, {
	// "...useful values from just below 1.0 to just above 2.0.
	// Towards 2.0 the sound crackles."
	Crackle.ar(SinOsc.ar(0.5, 0, 0.5, 1.5), 0.1)
});
Ndef(\HenonChaos, {
	HenonC.ar(
		SampleRate.ir/8,
		LFNoise2.kr(1, 0.2, 1.2),
		LFNoise2.kr(1, 0.15, 0.15)
	) * 0.05
});
Ndef(\LinChaos, {
	LinCongC.ar(
		LFNoise2.kr(1, 1e4, 1e4),
		LFNoise2.kr(0.1, 0.5, 1.4),
		LFNoise2.kr(0.1, 0.1, 0.1),
		LFNoise2.kr(0.1)
	) * 0.5
});
Ndef(\LatooChaos, {
	LatoocarfianC.ar(
		SampleRate.ir/4,
		LFNoise2.kr(2,1.5,1.5),
		LFNoise2.kr(2,1.5,1.5),
		LFNoise2.kr(2,0.5,1.5),
		LFNoise2.kr(2,0.5,1.5)
	) * 0.5
});

Ndef.new(\bike1,y).ar(1,0);
Ndef.new(\bike2,y).ar(1,1);
Ndef.new(\bike3,y).ar(1,2);
Ndef.new(\bike4,y).ar(1,3);
)
// ****************************************************
// ...this block 2nd, then scroll down and start...
// ****************************************************
(
// *****************************************
// HERE IS WHERE ALL THE PARAMETERS ARE SET!
// *****************************************
Ndef(\bike1).set(\freq, 60);
Ndef(\bike2).set(\freq, 180);
Ndef(\bike3).set(\freq, 480);
Ndef(\bike4).set(\freq, 120);

// "Mixing" between voices is done here...
Ndef(\bike1).set(\amp, 1.0);
Ndef(\bike2).set(\amp, 1.0);
Ndef(\bike3).set(\amp, 0.7);
Ndef(\bike4).set(\amp, 0.7);

Ndef(\bike1).set(\chaos_source, \LatooChaos);
Ndef(\bike2).set(\chaos_source, \HenonChaos);
Ndef(\bike3).set(\chaos_source, \LatooChaos);
Ndef(\bike4).set(\chaos_source, \LinChaos);

Ndef(\bike1).set(\chaos_amp, 0.4);
Ndef(\bike2).set(\chaos_amp, 0.4);
Ndef(\bike3).set(\chaos_amp, 1.2);
Ndef(\bike4).set(\chaos_amp, 0.7);

Ndef(\bike1).set(\lfo_amt, 0.0);
Ndef(\bike2).set(\lfo_amt, 0.0);
Ndef(\bike3).set(\lfo_amt, 0.3);
Ndef(\bike4).set(\lfo_amt, 0.0);

// END OF THE PARAMETER SECTION
)
// ****************************************************
// ...this block 3rd
// ****************************************************
(
Ndef(\bike1).play;
Ndef(\bike2).play;
Ndef(\bike3).play;
Ndef(\bike4).play;

Ndef(\bike1).fadeTime = 0.2;
Ndef(\bike2).fadeTime = 0.2;
Ndef(\bike3).fadeTime = 0.2;
Ndef(\bike4).fadeTime = 0.2;


a =	OSCFunc(
	{ |msg, time, addr, recvPort|
		Ndef(\bike1).set(\bike_parameter, msg[1].asFloat);
	}
	, '/data1'); // path

b =	OSCFunc(
	{ |msg, time, addr, recvPort|
		Ndef(\bike2).set(\bike_parameter, msg[1].asFloat);
	}
	, '/data2'); // path
c =	OSCFunc(
	{ |msg, time, addr, recvPort|
		Ndef(\bike3).set(\bike_parameter, msg[1].asFloat);
	}
	, '/data3'); // path
d =	OSCFunc(
	{ |msg, time, addr, recvPort|
		Ndef(\bike4).set(\bike_parameter, msg[1].asFloat);
	}
	, '/data4'); // path
)

x = OSCFunc.trace(true);
x = OSCFunc.trace(false);

a.disable;
b.disable;
c.disable;
d.disable;

Ndef(\bike1).set(\bike_parameter, 0.0);
Ndef(\bike2).set(\bike_parameter, 0.0);
Ndef(\bike3).set(\bike_parameter, 0.0);
Ndef(\bike4).set(\bike_parameter, 0.0);
Ndef(\bike1).set(\bike_parameter, 0.5);
Ndef(\bike2).set(\bike_parameter, 0.5);
Ndef(\bike3).set(\bike_parameter, 0.5);
Ndef(\bike4).set(\bike_parameter, 0.5);
Ndef(\bike1).set(\bike_parameter, 1.0);
Ndef(\bike2).set(\bike_parameter, 1.0);
Ndef(\bike3).set(\bike_parameter, 1.0);
Ndef(\bike4).set(\bike_parameter, 1.0);

Ndef(\bike1).set(\lfo_amt, 0.0)
Ndef(\x).set(\lfo_amt, 1.0)
Ndef(\x).set(\lfo_freq, 1.0)
Ndef(\x).set(\chaos_source, \LatooChaos)

Ndef(\chaos).fadeTime = 1;
Ndef(\x).set(\freq, 50);
Ndef(\x).set(\chaos_amp, 0.0);
Ndef(\x).set(\chaos_amp, 0.5);
Ndef(\x).set(\chaos_amp, 5.0);
Ndef(\x).set(\amp, 1.0);
Ndef(\x).set(\amp, 0.0);

