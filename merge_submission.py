#! /usr/bin/env python3.4

def merge(model):
	predFile = open(model+"/pred_1a.txt", "r")
	pred = predFile.readlines()
	submitFile = open(model+"/submission_1a.csv", "w")
	lines = ["RPT,RISK\n"]
	for i in range(len(rpt)):
		lines.append(rpt[i].strip("\n")+","+pred[i])
	submitFile.writelines(lines)

	predFile = open(model+"/pred_1b.txt", "r")
	pred = predFile.readlines()
	submitFile = open(model+"/submission_1b.csv", "w")
	lines = ["RPT,RISK\n"]
	for i in range(len(rpt)):
		lines.append(rpt[i].strip("\n")+","+pred[i])
	submitFile.writelines(lines)

rptFile = open("data/rpt_for_test.txt", "r")
rpt = rptFile.readlines()

merge("xgboost")

