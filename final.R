#! /usr/bin/env Rscript

question <- commandArgs(TRUE)[1]
model <- commandArgs(TRUE)[2]

source("rfsrc/factor.R")
source(paste(model, "/train_", question, ".R", sep=""))

dtrain <- read.csv("data/data_train.csv")
dtest <- read.csv("data/data_test.csv")
if (model=="rfsrc")
{
	dtrain <- toFactors(dtrain)
	dtest <- toFactors(dtest)
}

dpred <- train(dtrain, dtest)
if (question=="1")
{
	write.table(round(dpred$a, 3), paste(model, "pred_1a_final.txt", sep="/"), quote=FALSE, row.names=FALSE, col.names=FALSE)
	write.table(round(dpred$b), paste(model, "pred_1b_final.txt", sep="/"), quote=FALSE, row.names=FALSE, col.names=FALSE)
}else
{
	write.table(round(dpred, 3), paste(model, "pred_2_final.txt", sep="/"), quote=FALSE, row.names=FALSE, col.names=FALSE)
}

