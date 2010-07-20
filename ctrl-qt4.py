#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# ctrl-qt4.py - GUI controller written using the QT4 framework
#
# Copyright (c) 2010 András Veres-Szentkirályi
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

from PyQt4 import QtGui, QtCore
from optparse import OptionParser
import sys
import serial

def enter():
	com.write('q')

class CalButton(QtGui.QPushButton):
	def __init__(self, text):
		QtGui.QPushButton.__init__(self, text)
		self.connect(self, QtCore.SIGNAL('clicked()'), self.clickd)

	def clickd(self):
		com.write(str(self.text()) + "\n")

class MainWindow(QtGui.QWidget):
	def __init__(self, parent = None):
		QtGui.QWidget.__init__(self, parent)
		self.setWindowTitle('Hack2O')
		vbox = QtGui.QVBoxLayout()
		vbox.addWidget(QtGui.QLabel('1. Drive to lowest, Enter.\n' +
			'2. Drive to highest, Enter.\n3. Press Enter to irrigate.'))
		bl = [50, 100, 200, 500, 1000] # steps
		bl.reverse()
		for i in bl:
			btn = CalButton('+' + str(i))
			vbox.addWidget(btn);
		bl.reverse()
		dbtn = QtGui.QPushButton('Enter');
		vbox.addWidget(dbtn)
		self.connect(dbtn, QtCore.SIGNAL('clicked()'), enter)
		for i in bl:
			btn = CalButton('-' + str(i))
			vbox.addWidget(btn);
		self.setLayout(vbox)
		self.resize(150, 300)
		self.center()

	def center(self):
		screen = QtGui.QDesktopWidget().screenGeometry()
		size = self.geometry()
		self.move((screen.width() - size.width()) / 2, (screen.height() - size.height()) / 2)


parser = OptionParser()
parser.add_option('-p', '--port', dest='port', help='serial port to use')
(options, args) = parser.parse_args()

port = options.port
if port is None:
	port = '/dev/ttyUSB0'

com = serial.Serial(port, 9600)
app = QtGui.QApplication(sys.argv)

w = MainWindow()
w.show()

retval = app.exec_()
com.close()
sys.exit(retval)
