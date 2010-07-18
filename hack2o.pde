/*
 * hack2o.pde - stepper motor powered flow controller
 *
 * Copyright (c) 2010 András Veres-Szentkirályi
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 *
 */

#include <Stepper.h>

void setup() {
	Serial.begin(9600);
	Serial.print("Initializing Stepper library...");
	Stepper myStepper(100, 8, 10, 9, 11);
	Serial.println(" done");
	Serial.print("Setting stepper speed...");
	myStepper.setSpeed(300);
	Serial.println(" done");
	Serial.println("Please begin calibration by setting the lowest position.");
	manual(&myStepper);
	Serial.println();
	Serial.println("Please continue by setting the highest postition");
	int hg = manual(&myStepper);
	Serial.println();
	Serial.print("Calibration done, height is ");
	Serial.print(hg);
	Serial.println(", entering main loop");
	while (1) {
		Serial.println("Press any key to let the water flow");
		while(!Serial.available());
		while(Serial.available()) Serial.read();
		flow(&myStepper, hg);
	}
}

void flow(Stepper* st, int hg) {
	Serial.print("Lowering pipe...");
	st->step(-hg);
	Serial.println(" done");
	Serial.print("Sleeping...");
	delay(2000);
	Serial.println(" done");
	Serial.print("Lifting pipe...");
	st->step(hg);
	Serial.println(" done");
}

int manual(Stepper* st) {
	int sum = 0, state = 0, dist, dir;
	Serial.print("Please enter direction and distance (+ up / - down), 'q' quits: ");
	while (1) {
		while (!Serial.available());
		int inp = Serial.read();
		switch (state) {
			case 0:
				switch (inp) {
					case '+':
						dir = 1;
						state = 1;
						dist = 0;
						Serial.write('+');
						break;
					case '-':
						dir = -1;
						state = 1;
						dist = 0;
						Serial.write('-');
						break;
					case 'q':
						return sum;
				}
				break;
			case 1:
				if (inp == '\r' || inp == '\n') {
					int d = dir * dist;
					sum += d;
					Serial.println();
					Serial.print("Stepping by ");
					Serial.print(d);
					Serial.print("...");
					st->step(d);
					Serial.println(" done");
					Serial.print("Please enter direction and distance (+ up / - down), 'q' quits: ");
					state = 0;
				}
				if (inp <= '9' && inp >= '0') {
					dist = dist * 10 + inp - '0';
					Serial.write(inp);
				}
				break;
		}
	}
	return sum;
}

void loop() {}
