#! /usr/bin/env Rscript

source("../score.R")

iAUC <- 0.0
RMSE <- 0.0

"cIndex,auc12,auc18,auc24,iAUC,RMSE"

for (i in 0:9)
{
	dtest <- read.csv(paste("real_value_", i, ".csv", sep=""))
	dpred_1a <- read.table(paste("pred_1a_", i, ".txt", sep=""))
	a <- score_q1a(dtest[, "LKADT_P"], dtest[, "DEATH"], dpred_1a[,1])
	iAUC <- iAUC + a$iAUC
	dpred_1b <- read.table(paste("pred_1b_", i, ".txt", sep=""))
	b <- score_q1b(dpred_1b[,1], dtest[, "LKADT_P"], dtest[, "DEATH"])
	RMSE <- RMSE + b
	print(paste(a$cIndex, a$auc12, a$auc18, a$auc24, a$iAUC, b, sep=","))
}

paste("iAUC: ", iAUC/10)
paste("RMSE: ", RMSE/10)

