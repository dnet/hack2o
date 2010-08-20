/*
 * waterlevel.pde - water level measurement with shift register
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
 *
 * Shift register used: 74HC299
 *
 * Connections:
 * Arduino  Purpose   74HC299
 *    2        CP        12
 *    3        Q7        17
 *    4        S1        19
 *    5V      Vcc    1,2,3,9,20
 *   GND      GND        10
 */

#define CP 2
#define Q7 3
#define S1 4

#define LOAD HIGH
#define SHIFT LOW

void setup() {
	pinMode(CP, OUTPUT);
	pinMode(Q7, INPUT); /* no pullup by default */
	pinMode(S1, OUTPUT);
	Serial.begin(9600);
}

void loop() {
	Serial.println(getLevel(), DEC);
	delay(1000);
}

void pulseClk() {
	/* 74HC299 can handle up to 50 MHz @ 5V */
	digitalWrite(CP, HIGH);
	digitalWrite(CP, LOW);
}

void execCmd(byte cmd) {
	/* S0 is pulled high, so S1 = HIGH loads, S1 = LOW shifts right */
	digitalWrite(S1, cmd);
	pulseClk();
}

byte readReg() {
	byte retval = 0;
	execCmd(LOAD);
	for (byte i = 0; i < 8; i++) { /* read bits one by one */
		retval = (retval << 1) | (digitalRead(Q7) == HIGH ? 1 : 0);
		execCmd(SHIFT);
	}
	return retval;
}

byte getLevel() {
	byte retval = 0;
	for (byte i = readReg(); i; i >>= 1)
		retval++;
	return retval;
}
