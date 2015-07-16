#! /usr/bin/env Rscript

model <- commandArgs(TRUE)[1]

source(paste(model, "train.R", sep="/"))

dtrain <- read.csv("data/data_train.csv")
dtest <- read.csv("data/data_test.csv")
dpred <- train(dtrain, dtest)
write.table(dpred$a, paste(model, "pred_1a_final.txt", sep="/"), quote=FALSE, row.names=FALSE, col.names=FALSE)
write.table(dpred$b, paste(model, "pred_1b_final.txt", sep="/"), quote=FALSE, row.names=FALSE, col.names=FALSE)

