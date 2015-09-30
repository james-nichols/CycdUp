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
)
// ****************************************************
// Start this block next AFTER WAITING JUST A MOMENT
// FOR THE SERVER TO BOOT, then scroll down...
// ****************************************************
(
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
		LFNoise2.kr(5, 1e4, 1e4),
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

Ndef.new(\bike1, { | amp=1.0, freq=70, chaos_amp=0.6, trig,
	bike_parameter=0.0 // Parameters that the bike modulates
	freq_mod = 0.40, // 40% of frequency
	lfo_freq=15.0, lfo_amt=0.0,
	chaos_source=\chaos |

	freq = freq - (freq * freq_mod * (1.0 - bike_parameter.linlin(0.0, 0.7, 0.0, 1.0)));
	amp = amp * bike_parameter * 1.0;
	l = Pulse.kr(lfo_freq, mul: lfo_amt * bike_parameter / 2.0 ,
		add: 1.0 - (lfo_amt * bike_parameter / 2.0));

	a = SinOsc.ar(freq ,//+ LFNoise1.ar(0.1,5),
		(Ndef(\bike1) +  Ndef(chaos_source).ar) * chaos_amp * LFNoise1.ar(0.1,3),
		LFNoise1.ar(3,6)).tanh;

	5.do{
		a = AllpassL.ar(a,0.3,{0.2.rand+0.1}, 2)
	};

	[(a + (chaos_amp * Ndef(chaos_source).ar)).tanh * amp * l, Silent.ar(3)];

	}
).ar(2);

Ndef(\bike2, { | amp=1.0, freq=70, chaos_amp=0.6, trig,
	bike_parameter=0.0 // Parameters that the bike modulates
	freq_mod = 0.25, // 25% of frequency
	lfo_freq=15.0, lfo_amt=0.0,
	chaos_source=\HenonChaos |

	freq = freq - (freq * freq_mod * (1.0 - bike_parameter.linlin(0.0, 0.7, 0.0, 1.0)));
	amp = amp * bike_parameter * 1.0;
	l = Pulse.kr(lfo_freq, mul: lfo_amt * bike_parameter / 2.0 ,
		add: 1.0 - (lfo_amt * bike_parameter / 2.0));

	a = SinOsc.ar(freq ,//+ LFNoise1.ar(0.1!2,5),
		(Ndef(\bike2) +  Ndef(chaos_source).ar) * chaos_amp * LFNoise1.ar(0.1,3),
		LFNoise1.ar(3,6)).tanh;

	5.do{
		a = AllpassL.ar(a,0.3,{0.2.rand+0.1}, 2)
	};

	[Silent.ar(1), (a + (chaos_amp * Ndef(chaos_source).ar)).tanh * amp * l];
	}
).ar(2);

Ndef(\bike3, { | amp=1.0, freq=70, chaos_amp=0.6, trig,
	bike_parameter=0.0 // Parameters that the bike modulates
	freq_mod = 0.25, // 20% of frequency
	lfo_freq=15.0, lfo_amt=0.0,
	chaos_source=\LatooChaos |

	freq = freq - (freq * freq_mod * (1.0 - bike_parameter.linlin(0.0, 0.7, 0.0, 1.0)));
	amp = amp * bike_parameter * 1.0;
	l = Pulse.kr(lfo_freq, mul: lfo_amt * bike_parameter / 2.0 ,
		add: 1.0 - (lfo_amt * bike_parameter / 2.0));

	a = SinOsc.ar(freq ,//+ LFNoise1.ar(0.1!2,5),
		(Ndef(\bike3) +  Ndef(chaos_source).ar) * chaos_amp * LFNoise1.ar(0.1,3),
		LFNoise1.ar(3,6)).tanh;

	5.do{
		a = AllpassL.ar(a,0.3,{0.2.rand+0.1}, 2)
	};

	[Silent.ar(1), Silent.ar(1), (a + (chaos_amp * Ndef(chaos_source).ar)).tanh * amp * l, Silent.ar(1)];
	}
).ar(4);

Ndef(\bike4, { | amp=1.0, freq=70, chaos_amp=0.6, trig,
	bike_parameter=0.0 // Parameters that the bike modulates
	freq_mod = 0.25, // 20% of frequency
	lfo_freq=15.0, lfo_amt=0.0,
	chaos_source=\LinChaos |

	freq = freq - (freq * freq_mod * (1.0 - bike_parameter.linlin(0.0, 0.7, 0.0, 1.0)));
	amp = amp * bike_parameter * 1.0;
	l = Pulse.kr(lfo_freq, mul: lfo_amt * bike_parameter / 2.0 ,
		add: 1.0 - (lfo_amt * bike_parameter / 2.0));

	a = SinOsc.ar(freq ,//+ LFNoise1.ar(0.1!2,5),
		(Ndef(\bike4) +  Ndef(chaos_source).ar) * chaos_amp * LFNoise1.ar(0.1,3),
		LFNoise1.ar(3,6)).tanh;

	5.do{
		a = AllpassL.ar(a,0.3,{0.2.rand+0.1}, 2)
	};

	[Silent.ar(1), Silent.ar(1), Silent.ar(1), (a + (chaos_amp * Ndef(chaos_source).ar)).tanh * amp * l];
	}
).ar(4);

)
// ****************************************************
// ...and start this block 3rd, then scroll down and start...
// ****************************************************
(
// HERE IS WHERE ALL THE PARAMETERS ARE SET!
Ndef(\bike1).set(\freq, 60);
Ndef(\bike2).set(\freq, 180);
Ndef(\bike3).set(\freq, 360);
Ndef(\bike4).set(\freq, 120);

// "Mixing" between voices is done here...
Ndef(\bike1).set(\amp, 1.0);
Ndef(\bike2).set(\amp, 0.85);
Ndef(\bike3).set(\amp, 0.55);
Ndef(\bike4).set(\amp, 0.7);

Ndef(\bike1).set(\chaos_source, \LatooChaos);
Ndef(\bike2).set(\chaos_source, \HenonChaos);
Ndef(\bike3).set(\chaos_source, \LatooChaos);
Ndef(\bike4).set(\chaos_source, \LinChaos);

Ndef(\bike1).set(\chaos_amp, 0.4);
Ndef(\bike2).set(\chaos_amp, 0.5);
Ndef(\bike3).set(\chaos_amp, 1.5);
Ndef(\bike4).set(\chaos_amp, 1.2);

Ndef(\bike1).set(\lfo_amt, 0.0);
Ndef(\bike2).set(\lfo_amt, 0.0);
Ndef(\bike3).set(\lfo_amt, 0.5);
Ndef(\bike4).set(\lfo_amt, 0.4);
)
// ****************************************************
// ...and start this block last
// ****************************************************
(
Ndef(\bike1).play;
Ndef(\bike2).play;
Ndef(\bike3).play;
Ndef(\bike4).play;

Ndef(\bike1).fadeTime = 0.1;
Ndef(\bike2).fadeTime = 0.1;
Ndef(\bike3).fadeTime = 0.1;
Ndef(\bike4).fadeTime = 0.1;

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

// ************************************************************
// DON'T WORRY ABOUT THIS STUFF BELOW... IT'S JUST FOR TESTING.
// ************************************************************

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

