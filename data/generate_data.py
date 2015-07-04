#! /usr/bin/env python3.4

import csv
import random
from math import floor

def loadData(dataFileName, flag):
	dataCSV = csv.reader(open(dataFileName, "r"))
	data = [row for row in dataCSV]
	m = len(data)
	n = len(data[0])

	distriCSV = csv.writer(open("distribution_"+flag+".csv", "w"))
	distribution = [["Feature", "# of Missing", "# of Positive"]]
	for j in range(n):
		cnt = 0
		for i in range(1, m):
			if data[i][j]=="" or data[i][j]==">=85" or data[i][j]=="Missing" or data[i][j]=="MISSING" or data[i][j]==".":
				cnt += 1
		if j==4 or j>=54:
			distribution.append([data[0][j], 0, m-1-cnt])
		else:
			distribution.append([data[0][j], cnt, ""])
	distriCSV.writerows(distribution)

	for i in range(1, m):
		# DEATH
		if data[i][4]=="":
			data[i][4] = "0"
		else:
			data[i][4] = "1"

		# AGEGRP2
		if data[i][14]=="18-64":
			data[i][14] = "1"
		elif data[i][14]=="65-74":
			data[i][14] = "2"
		elif data[i][14]==">=75":
			data[i][14] = "3"

		# RACE_C
		if data[i][15]=="Missing":
			data[i][15] = "0"
		elif data[i][15]=="Asian":
			data[i][15] = "1"
		elif data[i][15]=="Black":
			data[i][15] = "2"
		elif data[i][15]=="White":
			data[i][15] = "3"
		elif data[i][15]=="Hispanic":
			data[i][15] = "4"
		elif data[i][15]=="Other":
			data[i][15] = "5"

		# HGTBLCAT
		if data[i][18]=="":
			if data[i][17]==".":
				data[i][18] = "."
			else:
				data[i][18] = str(floor(float(data[i][17])/20))
		else:
			data[i][18] = str(int(data[i][18][2:4])//2)
		
		# WGTBLCAT
		if data[i][20]=="":
			if data[i][19]==".":
				data[i][20] = "."
			else:
				data[i][20] = str(floor(float(data[i][19])/10))
		else:
			if data[i][20][4]=="-":
				data[i][20] = str(int(data[i][20][2:4])//10)
			else:
				data[i][20] = str(int(data[i][20][2:5])//10)

		# REGION_C
		if data[i][21]=="MISSING":
			data[i][21] = "0"
		elif data[i][21]=="AFRICA":
			data[i][21] = "1"
		elif data[i][21]=="ASIA/PACIFIC":
			data[i][21] = "2"
		elif data[i][21]=="EASTERN EUROPE":
			data[i][21] = "3"
		elif data[i][21]=="WESTERN EUROPE":
			data[i][21] = "4"
		elif data[i][21]=="NORTH AMERICA":
			data[i][21] = "5"
		elif data[i][21]=="SOUTH AMERICA":
			data[i][21] = "6"
		elif data[i][21]=="OTHER":
			data[i][21] = "7"

		# NON_TARGET-MHVASC
		for j in range(54, 131):
			if data[i][j]=="":
				data[i][j] = "0"
			else:
				data[i][j] = "1"

	featureFile = open("features_list.txt", "r")
	feature = {}
	for i in range(n):
		feature[data[0][i]] = i
	choose = []
	for st in featureFile.readlines():
		choose.append(feature[st.strip("\n")])
	
	resultCSV = csv.writer(open("data_"+flag+".csv", "w"))
	rows = []
	head = [data[0][x] for x in choose]
	for i in range(1, m):
		if flag=="train":
			miss = False
			for x in choose:
				if data[i][x]==".":
					if data[0][x] in ["BMI", "HGTBLCAT", "WGTBLCAT", "ECOG_C", "ALP", "ALT", "AST", "CA", "CREAT", "HB", "NEU", "PLT", "PSA", "TBILI", "WBC"]:
						miss = True
						break
					else:
						data[i][x] = "0"
			if miss:
				continue
		rows.append([data[i][x] for x in choose])
	if flag=="train":
		random.seed(1)
		random.shuffle(rows)
	resultCSV.writerows([head]+rows)

	if flag=="test":
		prtFile = open("rpt_for_test.txt", "w")
		lines = [data[i][2]+"\n" for i in range(1, m)]
		prtFile.writelines(lines)

loadData("CoreTable_training.csv", "train")
loadData("CoreTable_leaderboard.csv", "test")

