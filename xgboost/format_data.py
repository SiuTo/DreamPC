#! /usr/bin/env python

import csv

def formatData(data, flag):
	dataTxt = open("data_"+flag+".txt", "w")
	lines = []
	for i in range(len(data)):
		line = str(data[i][0])
		for j in range(1, len(data[i])):
			line += " {}:{}".format(j, data[i][j])
		lines.append(line+"\n")
	dataTxt.writelines(lines)

