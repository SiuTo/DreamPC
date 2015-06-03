#! /usr/bin/env python3.4

import csv

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
				if data[i][j]=='.':
					data[i][j] = "0"
				cnt += 1
		if j==4 or j>=54:
			distribution.append([data[0][j], 0, m-1-cnt])
		else:
			distribution.append([data[0][j], cnt, ""])
	distriCSV.writerows(distribution)

	for i in range(1, m):
		# DEATH
		if data[i][4]=="":
			data[i][4] = 0
		else:
			data[i][4] = 1

		# AGEGRP
		if data[i][13]==">=85":
			data[i][13] = 85

		# RACE_C
		if data[i][15]=="Missing":
			data[i][15] = 0
		elif data[i][15]=="White":
			data[i][15] = 1
		elif data[i][15]=="Black":
			data[i][15] = 2
		elif data[i][15]=="Asian":
			data[i][15] = 3
		elif data[i][15]=="Hispanic":
			data[i][15] = 4
		elif data[i][15]=="Other":
			data[i][15] = 5

		'''		
		# HEIGHTBL
		if data[i][18]=="":
			data[i][17] = round(float(data[i][17])/20)
		else:
			data[i][17] = int(data[i][18][2:3])//2
		
		# WEIGHTBL
		if data[i][20]=="":
			data[i][19] = round(float(data[i][19])/10)
		else:
			if data[i][20][4]=="-":
				data[i][19] = int(data[i][19][2:3])//10
			else:
				data[i][19] = int(data[i][19][2:4])//10
		'''

		# NON_TARGET-MHVASC
		for j in range(54, 131):
			if data[i][j]=="":
				data[i][j] = 0
			else:
				data[i][j] = 1

	featureFile = open("features_list.txt", "r")
	feature = {}
	for i in range(n):
		feature[data[0][i]] = i
	choose = []
	for st in featureFile.readlines():
		choose.append(feature[st.strip("\n")])
	
	resultCSV = csv.writer(open("data_"+flag+".csv", "w"))
	lines = []
	for i in range(0, m):
		lines.append([data[i][x] for x in choose])
	resultCSV.writerows(lines)

	if flag=="test":
		prtFile = open("rpt_for_test.txt", "w")
		lines = [data[i][2]+"\n" for i in range(1, m)]
		prtFile.writelines(lines)

loadData("CoreTable_training.csv", "train")
loadData("CoreTable_leaderboard.csv", "test")

