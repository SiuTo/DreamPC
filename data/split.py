#! /usr/bin/env python3.4

import random

originFile = open("CoreTable_training.csv", "r")
trainFile = open("Training_set.csv", "w")
testFile = open("Test_set.csv", "w")
lines = originFile.readlines()
colnames = lines[0]
del lines[0]
random.seed(10)
random.shuffle(lines)
pos = len(lines)//10
trainFile.writelines([colnames]+lines[pos:])
testFile.writelines([colnames]+lines[0:pos])

