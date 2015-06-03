#! /usr/bin/env python3.4

rptFile = open("rpt_for_test.txt", "r")
rpt = rptFile.readlines()

predFile = open("pred_xgboost_1a.txt", "r")
pred = predFile.readlines()
submitFile = open("submission_1a.csv", "w")
lines = ["RPT,RISK\n"]
for i in range(len(rpt)):
	lines.append(rpt[i].strip("\n")+","+pred[i])
submitFile.writelines(lines)

predFile = open("pred_xgboost_1b.txt", "r")
pred = predFile.readlines()
submitFile = open("submission_1b.csv", "w")
lines = ["RPT,RISK\n"]
for i in range(len(rpt)):
	lines.append(rpt[i].strip("\n")+","+pred[i])
submitFile.writelines(lines)

