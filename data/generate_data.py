#! /usr/bin/env python3.4

import csv
import random
from math import floor

def loadData(dataFileName, flag):
	dataCSV = csv.reader(open(dataFileName, "r"))
	data = [row for row in dataCSV]
	m = len(data)
	n = len(data[0])

	for j in range(n):
		cnt = 0
		for i in range(1, m):
			if data[i][j]=="" or data[i][j]==">=85" or data[i][j]=="Missing" or data[i][j]=="MISSING" or data[i][j]==".":
				cnt += 1
		if flag=="train":
			distribution.append([data[0][j]])
		if j==5:
			cnt_pos = 0
			for i in range(1, m):
				if data[i][j]=="1":
					cnt_pos += 1
			distribution[j+1] += [cnt, cnt_pos]
		elif j==7:
			cnt_pos = 0
			for i in range(1, m):
				if data[i][j]!="." and int(data[i][j])<=91:
					cnt_pos += 1
			distribution[j+1] += [cnt, cnt_pos]
		elif j==4 or j>=54:
			distribution[j+1] += [0, m-1-cnt]
		else:
			distribution[j+1] += [cnt, ""]

	for i in range(1, m):
		# DEATH
		if data[i][4]=="":
			data[i][4] = "0"
		else:
			data[i][4] = "1"

		# DISCONT
		if data[i][5]!=".":
			if int(data[i][7])<=91:
				if data[i][6]=="AE":
					data[i][5] = "1"
				elif data[i][6]=="possible_AE":
					data[i][5] = "2"
				elif data[i][6]=="progression":
					data[i][5] = "3"
			else:
				if data[i][6]=="AE":
					data[i][5] = "4"
				elif data[i][6]=="possible_AE":
					data[i][5] = "5"
				elif data[i][6]=="progression":
					data[i][5] = "6"
				elif data[i][6]=="complete":
					data[i][5] = "7"

		# AGEGRP2
		if data[i][14]=="18-64":
			data[i][14] = "1"
		elif data[i][14]=="65-74":
			data[i][14] = "2"
		elif data[i][14]==">=75":
			data[i][14] = "3"

		# RACE_C
		if data[i][15]=="Missing":
			data[i][15] = "."
		elif data[i][15]=="Asian":
			data[i][15] = "1"
		elif data[i][15]=="Black":
			data[i][15] = "2"
		elif data[i][15]=="White":
			data[i][15] = "3"
		else:
			data[i][15] = "4"

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
			data[i][21] = "."
		elif data[i][21]=="EASTERN EUROPE":
			data[i][21] = "1"
		elif data[i][21]=="WESTERN EUROPE":
			data[i][21] = "2"
		elif data[i][21]=="NORTH AMERICA":
			data[i][21] = "3"
		elif data[i][21]=="SOUTH AMERICA":
			data[i][21] = "4"
		else:
			data[i][21] = "5"

		# ECOG_C
		#if data[i][25]=="3":
		#	data[i][25] = "."

		# NON_TARGET-MHVASC
		for j in range(54, 131):
			if data[i][j]=="":
				data[i][j] = "0"
			else:
				data[i][j] = "1"

	# Normalization
	normalize_range = [16]+list(range(29, 54)) # BMI + ...
	if flag=="train":
		for j in normalize_range:
			s, cnt = 0.0, 0
			for i in range(1, m):
				if data[i][j]!=".":
					s += float(data[i][j])
					cnt += 1
			mean[j] = s/cnt
			s = 0.0
			for i in range(1, m):
				if data[i][j]!=".":
					s += (float(data[i][j])-mean[j])**2
			deviation[j] = (s/cnt)**0.5

	for j in normalize_range:
		for i in range(1, m):
			if data[i][j]!=".":
				data[i][j] = str(round((float(data[i][j])-mean[j])/deviation[j], 6))
	
	# Features selection
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
					if data[0][x] in ["DISCONT", "RACE_C", "BMI", "HGTBLCAT", "WGTBLCAT", "ECOG_C", "ALP", "ALT", "AST", "CA", "CREAT", "HB", "NEU", "PLT", "PSA", "TBILI", "WBC"]:
						miss = True
						break
					else:
						data[i][x] = "NA"
			if miss:
				continue
		else:
			for x in choose:
				if data[i][x]==".":
					data[i][x] = "NA"
		rows.append([data[i][x] for x in choose])
	
	# Shuffle data
	if flag=="train":
		random.seed(1)
		random.shuffle(rows)
	resultCSV.writerows([head]+rows)

	if flag=="test":
		prtFile = open("rpt_for_test.txt", "w")
		lines = [data[i][2]+"\n" for i in range(1, m)]
		prtFile.writelines(lines)

distriCSV = csv.writer(open("distribution.csv", "w"))
distribution = [["Feature", "# of Missing in train", "# of Positive in train", "# of Missing in test", "# of Positive in test", "# of Missing in validation", "# of positive in validation"]]
mean = [0]*130
deviation = [0]*130
#loadData("CoreTable_training.csv", "train")
#loadData("CoreTable_leaderboard.csv", "test")
#loadData("CoreTable_validation.csv", "test")
loadData("Training_set.csv", "train")
loadData("Test_set.csv", "test")
distriCSV.writerows(distribution)

