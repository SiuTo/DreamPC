#! /usr/bin/env Rscript

library("randomForestSRC")

options(rf.cores=detectCores()-1, mc.cores=detectCores()-1)

train <- function(dtrain, dtest)
{
	cat("\tTraining...\n")
	rf.obj <- rfsrc(Surv(LKADT_P, DEATH) ~ ., dtrain, nsplit=2, na.action="na.impute")

	cat("\tPredicting...\n")
	rf.pred <- predict(rf.obj, dtest, na.action="na.impute")
	interval <- range(rf.pred$predicted)
	delta <- (interval[2]-interval[1])*0.01
	interval <- c(interval[1]-delta, interval[2]+delta)
	dpred_1a <- round((rf.pred$predicted-interval[1])/(interval[2]-interval[1]), 3)

	survival <- rf.pred$survival
	delta <- survival[, 1:(ncol(survival)-1)]-survival[,2:ncol(survival)]
	dpred_1b <- rf.pred$time.interest[apply(delta, 1, which.max)]

	return(list(a=dpred_1a, b=dpred_1b))
}

