#! /usr/bin/env python3.4

import csv

def formatData(flag):
	dataCSV = csv.reader(open("../data/data_"+flag+".csv", "r"))
	data = [row for row in dataCSV]
	dataTxt = open("data_"+flag+".txt", "w")
	lines = []
	for i in range(1, len(data)):
		line = str(data[i][0])
		for j in range(1, len(data[i])):
			line += " {}:{}".format(j, data[i][j])
		lines.append(line+"\n")
	dataTxt.writelines(lines)

formatData("train")
formatData("test")

