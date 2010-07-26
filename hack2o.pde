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

#define HEIGHT 4800

void move2bottom(Stepper *st) {
	Serial.print("Moving to bottom position...");
	while (digitalRead(7) == HIGH) st->step(-25);
	Serial.println(" done");
}

void move2top(Stepper *st) {
	Serial.print("Moving to top position...");
	st->step(HEIGHT);
	Serial.println(" done");
}

void setup() {
	pinMode(7, INPUT);
	digitalWrite(7, HIGH);
	Serial.begin(9600);
	Serial.print("Initializing Stepper library...");
	Stepper myStepper(100, 8, 10, 9, 11);
	Serial.println(" done");
	Serial.print("Setting stepper speed...");
	myStepper.setSpeed(300);
	Serial.println(" done");
	move2bottom(&myStepper);
	move2top(&myStepper);
	Serial.println("Entering main loop");
	while (1) {
		Serial.println("Press any key to let the water flow");
		while(!Serial.available());
		while(Serial.available()) Serial.read();
		flow(&myStepper);
	}
}

void flow(Stepper* st) {
	move2bottom(st);
	Serial.print("Sleeping...");
	delay(2000);
	Serial.println(" done");
	move2top(st);
}

void loop() {}
