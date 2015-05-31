#! /usr/bin/env python3.4

def loadcsv(dataFileName, distriFileName, resultFileName):
	dataFile = open(dataFileName, "r")
	lines = dataFile.readlines()
	data = [lines[i].strip("\n").split(",") for i in range(len(lines))]
	m = len(data)
	n = len(data[0])
	for i in range(m):
		for j in range(n):
			data[i][j] = data[i][j].strip('"')

	distriFile = open(distriFileName, "w")
	lines = ["Feature, # of Missing, # of Positive\n"]
	for j in range(n):
		cnt = 0
		for i in range(1, m):
			if data[i][j]=="" or data[i][j]==">=85" or data[i][j]=="Missing" or data[i][j]=="MISSING" or data[i][j]==".":
				if data[i][j]=='.':
					data[i][j] = "0"
				cnt += 1
		if j==4 or j>=54:
			lines.append("{},0,{}\n".format(data[0][j], m-1-cnt))
		else:
			lines.append("{},{},\n".format(data[0][j], cnt))
	distriFile.writelines(lines)

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
	choose = [False]*n
	for st in featureFile.readlines():
		choose[feature[st.strip("\n")]] = True
	
	resultFile = open(resultFileName, "w")
	lines = []
	for i in range(m):
		line = ""
		for j in range(0, n):
			if choose[j]:
				line += str(data[i][j])+","
		lines.append(line[:-1]+"\n")
	resultFile.writelines(lines)

loadcsv("CoreTable_training.csv", "distribution_train.csv", "data_train.csv")
#loadcsv("CoreTable_leaderboard.csv", "distribution_test.csv", "data_test.csv")

