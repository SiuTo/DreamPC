#! /usr/bin/env Rscript

suppressMessages(library("randomForestSRC"))

options(rf.cores=detectCores()-1, mc.cores=detectCores()-1)

train <- function(dtrain, dtest)
{
	cat("\tTraining...\n")
	rf.risk <- rfsrc(Surv(LKADT_P, DEATH) ~ ., dtrain, nsplit=2, na.action="na.impute")
	rf.time <- rfsrc(LKADT_P ~ ., dtrain[, -2], na.action="na.impute")

	cat("\tPredicting...\n")
	rf.pred <- predict(rf.risk, dtest, na.action="na.impute")
	interval <- range(rf.pred$predicted)
	delta <- (interval[2]-interval[1])*0.01
	interval <- c(interval[1]-delta, interval[2]+delta)
	dpred_1a <- round((rf.pred$predicted-interval[1])/(interval[2]-interval[1]), 3)

	rf.pred <- predict(rf.time, dtest[, -2], na.action="na.impute")
	dpred_1b <- round(rf.pred$predicted)

	return(list(a=dpred_1a, b=dpred_1b))
}

