#! /usr/bin/env python3.4

import sys

question = sys.argv[1]
model = sys.argv[2]

rptFile = open("data/rpt_for_test.txt", "r")
rpt = rptFile.readlines()

if question=="1":
	predFile = open(model+"/pred_1a_final.txt", "r")
	pred = predFile.readlines()
	submitFile = open(model+"/submission_1a.csv", "w")
	lines = ["RPT,RISK\n"]
	for i in range(len(rpt)):
		lines.append(rpt[i].strip("\n")+","+pred[i])
	submitFile.writelines(lines)

	predFile = open(model+"/pred_1b_final.txt", "r")
	pred = predFile.readlines()
	submitFile = open(model+"/submission_1b.csv", "w")
	lines = ["RPT,TIMETOEVENT\n"]
	for i in range(len(rpt)):
		lines.append(rpt[i].strip("\n")+","+pred[i])
	submitFile.writelines(lines)
else:
	predFile = open(model+"/pred_2_final.txt", "r")
	pred = predFile.readlines()
	submitFile = open(model+"/submission_2.csv", "w")
	lines = ["RPT,RISK,DISCONT\n"]
	for i in range(len(rpt)):
		lines.append(rpt[i].strip("\n")+","+pred[i])
	submitFile.writelines(lines)

