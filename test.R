#! /usr/bin/env Rscript

question <- commandArgs(TRUE)[1]
model <- commandArgs(TRUE)[2]

source("rfsrc/factor.R")
source("score.R")
source("imputation.R")
source(paste(model, "/train_", question, ".R", sep=""))

dtrain <- read.csv("data/data_train.csv")
dtest <- read.csv("data/data_test.csv")
if (model=="rfsrc")
{
	dtrain <- toFactors(dtrain)
	dtest <- toFactors(dtest)
}
time <- dtest$LKADT_P
status <- dtest$DEATH
dtest$LKADT_P <- 0
dtest$DEATH <- 1

dtrain <- imputation(dtrain)
dtest <- imputation(rbind(dtest[,-(1:2)],dtrain[,-(1:2)]))[1:nrow(dtest),]
dtest <- cbind(0,1,dtest)
colnames(dtest)[1:2] <- c("LKADT_P", "DEATH")

dpred <- train(dtrain, dtest)
if (question=="1")
{
	write.table(round(dpred$a, 3), paste(model, "pred_1a_final.txt", sep="/"), quote=FALSE, row.names=FALSE, col.names=FALSE)
	write.table(round(dpred$b), paste(model, "pred_1b_final.txt", sep="/"), quote=FALSE, row.names=FALSE, col.names=FALSE)
	a <- score_q1a(time, status, dpred$a)
	b <- score_q1b(dpred$b, time, status)
	print(a)
	print(b)
}else
{
	write.table(round(dpred, 3), paste(model, "pred_2_final.txt", sep="/"), quote=FALSE, row.names=FALSE, col.names=FALSE)
}

