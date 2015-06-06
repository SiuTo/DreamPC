#! /usr/bin/env python

import xgboost as xgb

def train(flag):
	dtrain = xgb.DMatrix("data_train.txt")

	param = {'silent':1, 'bst:eta':0.2, 'bst:gamma':2000, 'objective':'reg:linear' }
	plst = param.items()
	plst += [('eval_metric', 'auc')]

	num_round = 10
	bst = xgb.train(plst, dtrain, num_round)

	dtest = xgb.DMatrix("data_test.txt")
	ypred = bst.predict(dtest)

	pred1aFile = open("pred_1a_"+flag+".txt", "w")
	low, high = min(ypred)-10, max(ypred)+10
	lines = [str((high-ypred[i])/(high-low))+"\n" for i in range(len(ypred))]
	pred1aFile.writelines(lines)

	pred1bFile = open("pred_1b_"+flag+".txt", "w")
	lines = [str(int(round(ypred[i])))+"\n" for i in range(len(ypred))]
	pred1bFile.writelines(lines)

