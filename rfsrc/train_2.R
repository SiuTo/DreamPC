#! /usr/bin/env Rscript

library("randomForestSRC")

options(rf.cores=detectCores()-1, mc.cores=detectCores()-1)

train <- function(dtrain, dtest)
{
	dtrain$DISCONT <- as.factor(dtrain$DISCONT)
	dtest$DISCONT <- as.factor(dtest$DISCONT)

	cat("\tTraining...\n")
	rf.obj <- rfsrc(DISCONT ~ ., dtrain, nsplit=2, na.action="na.impute")

	cat("\tPredicting...\n")
	rf.pred <- predict(rf.obj, dtest, na.action="na.impute")

	return(rf.pred$predicted[, "1"]+rf.pred$predicted[, "2"])
}

