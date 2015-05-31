#! /usr/bin/env python3.4

prtFile = open("prt_for_test.txt", "r")
prt = prtFile.readlines()
predFile = open("pred_xgboost.txt", "r")
pred = predFile.readlines()
submitFile = open("submission.csv", "w")
lines = ["PRT,RISK"]
for i in range(len(prt)):
	lines.append(prt[i].strip("\n")+","+pred[i])
submitFile.writelines(lines)

