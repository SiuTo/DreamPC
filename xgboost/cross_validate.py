#! /usr/bin/env python

from format_data import formatData
from train_xgboost import train
import csv
import random

dataCSV = csv.reader(open("../data/data_train.csv", "r"))
data = [row for row in dataCSV]
random.shuffle(data)
pos = len(data)//10

realFile = open("real_value.csv", "w")
lines = ["LKADT_P,DEATH\n"]
for i in range(pos):
	lines.append("{},{}\n".format(data[i][0], data[i][1]))
realFile.writelines(lines)

for i in range(pos):
	data[i][0] = 0
formatData(data[pos:], "train")
formatData(data[:pos], "test")

train()

