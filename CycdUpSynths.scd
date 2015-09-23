
s = Server.default;
s.boot;
thisProcess.openPorts; // list all open ports

n = NetAddr.localAddr

l =	OSCFunc(
	{ |msg, time, addr, recvPort|
		Ndef(\x).set(\bike_parameter, msg[1].asFloat);
	}
	, '/data1'); // path



x = OSCFunc.trace(true);
x = OSCFunc.trace(false);

m.disable;
l.disable;
j.disable;
(
Ndef(\x).clear;
Ndef(\chaos, {
	// "...useful values from just below 1.0 to just above 2.0.
	// Towards 2.0 the sound crackles."
	Crackle.ar(SinOsc.ar(0.5, 0, 0.5, 1.5), 0.1)
});
Ndef(\x).ar(2);

Ndef(\x,{ | amp=1.0, freq=70, chaosAmp=1.0, trig,
	bike_parameter=1.0 // Parameters that the bike modulates
	lfo_freq=15.0, lfo_amt=1.0
	|
	freq = freq + (200.0 * bike_parameter);
	amp = amp * bike_parameter * 4.0;
	l = Pulse.kr(lfo_freq, mul: lfo_amt * bike_parameter / 2.0 , add: 1.0 - (lfo_amt * bike_parameter / 2.0));

	a = SinOsc.ar(freq + LFNoise1.ar(0.1!2,5),(Ndef(\x) +  Ndef(\chaos).ar) * chaosAmp * LFNoise1.ar(0.1!2,3), LFNoise1.ar(3,6)).tanh;
	5.do{
		a = AllpassL.ar(a,0.3,{0.2.rand+0.1}!2, 2)
	};

	a.tanh * amp * l;
}).play;
Ndef(\x).set(\lfo_amt, 0.5)
Ndef(\x).set(\lfo_amt, 1.0)
Ndef(\x).set(\lfo_freq, 1.0)

Ndef(\chaos).fadeTime = 1;
Ndef(\x).fadeTime = 1;
Ndef(\x).set(\freq, 50);
Ndef(\x).set(\chaosAmp, 0.0);
Ndef(\x).set(\chaosAmp, 1.0);
Ndef(\x).set(\chaosAmp, 5.0);
Ndef(\x).set(\amp, 1.0);
Ndef(\x).set(\amp, 0.0);
)

// By defining different chaos functions we get different effects as they feed into
// the playing Ndef(\x)
(
	Ndef(\chaos, {
		HenonC.ar(
			SampleRate.ir/8,
			LFNoise2.kr(1, 0.2, 1.2),
			LFNoise2.kr(1, 0.15, 0.15)
		) * 0.05
	});
)
(
	Ndef(\chaos, {
		LinCongC.ar(
			LFNoise2.kr(1, 1e4, 1e4),
			LFNoise2.kr(0.1, 0.5, 1.4),
			LFNoise2.kr(0.1, 0.1, 0.1),
			LFNoise2.kr(0.1)
		) * 0.5
	}).play;
)
(
Ndef(\chaos, {
	LatoocarfianC.ar(
		SampleRate.ir/4,
		LFNoise2.kr(2,1.5,1.5),
		LFNoise2.kr(2,1.5,1.5),
		LFNoise2.kr(2,0.5,1.5),
		LFNoise2.kr(2,0.5,1.5)
	) * 0.5
})
)
(
	Ndef(\chaos, { QuadC.ar(SampleRate.ir/4) * 0.2 })
)
