#! /usr/bin/env python3.4

import sys

model = sys.argv[1]

rptFile = open("data/rpt_for_test.txt", "r")
rpt = rptFile.readlines()

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

