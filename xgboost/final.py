#! /usr/bin/env python

from format_data import formatData
from train_xgboost import train
import csv

def loadFinalData(flag):
	dataCSV = csv.reader(open("../data/data_"+flag+".csv", "r"))
	data = [row for row in dataCSV]
	formatData(data[1:], flag)

loadFinalData("train")
loadFinalData("test")
train("final")

