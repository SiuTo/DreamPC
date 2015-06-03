#! /usr/bin/env python

import xgboost as xgb

dtrain = xgb.DMatrix("data_train.txt")

param = {'bst:max_depth':2, 'bst:eta':1, 'silent':1, 'objective':'reg:linear' }
param['nthread'] = 4
plst = param.items()
plst += [('eval_metric', 'auc')]
plst += [('eval_metric', 'ams@0')]

num_round = 10
bst = xgb.train(plst, dtrain, num_round)

dtest = xgb.DMatrix("data_test.txt")
ypred = bst.predict(dtest)

pred1aFile = open("pred_1a.txt", "w")
low, high = min(ypred)-10, max(ypred)+10
lines = [str((high-ypred[i])/(high-low))+"\n" for i in range(len(ypred))]
pred1aFile.writelines(lines)

pred1bFile = open("pred_1b.txt", "w")
lines = [str(ypred[i])+"\n" for i in range(len(ypred))]
pred1bFile.writelines(lines)

