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

predFile = open("pred_xgboost.txt", "w")
lines = [str(ypred[i])+"\n" for i in range(len(ypred))]
predFile.writelines(lines)

