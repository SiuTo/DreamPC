#! /usr/bin/env Rscript

source("../score.R")

iAUC <- 0.0
RMSE <- 0.0

print(paste("cIndex", "auc12", "auc18", "auc24", "iAUC", "RMSE", sep=" "), quote=FALSE)

for (i in 0:9)
{
	dtest <- read.csv(paste("real_value_", i, ".csv", sep=""))
	dpred_1a <- read.table(paste("pred_1a_", i, ".txt", sep=""))
	a <- score_q1a(dtest[, "LKADT_P"], dtest[, "DEATH"], dpred_1a[,1])
	iAUC <- iAUC + a$iAUC
	dpred_1b <- read.table(paste("pred_1b_", i, ".txt", sep=""))
	b <- score_q1b(dpred_1b[,1], dtest[, "LKADT_P"], dtest[, "DEATH"])
	RMSE <- RMSE + b
	print(paste(round(a$cIndex, 3), round(a$auc12, 3), round(a$auc18, 3), round(a$auc24, 3), round(a$iAUC, 3), round(b, 3), sep=" "), quote=FALSE)
}

print(paste("iAUC: ", round(iAUC/10, 3)), quote=FALSE)
print(paste("RMSE: ", round(RMSE/10, 3)), quote=FALSE)

