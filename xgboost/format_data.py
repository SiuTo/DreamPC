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
		for j in range(2, len(data[i])):
			if data[i][j]=="NA":
				data[i][j] = "0"
			line += " {}:{}".format(j-1, data[i][j])
		lines.append(line+"\n")
	dataTxt.writelines(lines)

