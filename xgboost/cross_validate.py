#! /usr/bin/env python

from format_data import formatData
from train_xgboost import train
import csv
import random

dataCSV = csv.reader(open("../data/data_train.csv", "r"))
data = [row for row in dataCSV]
del data[0]
random.shuffle(data)
m = len(data)//10

for k in range(10):
	left, right = k*m, min((k+1)*m, len(data))
	realFile = open("real_value_"+str(k)+".csv", "w")
	lines = ["LKADT_P,DEATH\n"]
	for i in range(left, right):
		lines.append("{},{}\n".format(data[i][0], data[i][1]))
	realFile.writelines(lines)

	formatData(data[:left]+data[right:], "train")
	formatData(data[left:right], "test")

	train(str(k))

