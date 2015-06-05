#! /usr/bin/env python

import csv

def formatData(data, flag):
	if flag=="test":
		for i in range(len(data)):
			data[i][1] = 1
	dataTxt = open("data_"+flag+".txt", "w")
	lines = []
	for i in range(len(data)):
		line = str(data[i][0])
		for j in range(1, len(data[i])):
			line += " {}:{}".format(j, data[i][j])
		lines.append(line+"\n")
	dataTxt.writelines(lines)

