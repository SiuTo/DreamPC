#! /usr/bin/env Rscript

library("randomForestSRC")

options(rf.cores=detectCores()-1, mc.cores=detectCores()-1)

train <- function(dtrain, dtest)
{
	dtrain$DISCONT <- as.factor(dtrain$DISCONT)
	dtest$DISCONT <- as.factor(dtest$DISCONT)

	index1 <- which(dtrain$DISCONT==1 | dtrain$DISCONT==2)
	index2 <- sample(which(dtrain$DISCONT==3 | dtrain$DISCONT==4 | dtrain$DISCONT==5 | dtrain$DISCONT==6 | dtrain$DISCONT==7), length(index1))
	dtrain <- dtrain[sample(c(index1, index2)), ]

	cat("\tTraining...\n")
	rf.obj <- rfsrc(DISCONT ~ ., dtrain, nsplit=2, na.action="na.impute")

	cat("\tPredicting...\n")
	rf.pred <- predict(rf.obj, dtest, na.action="na.impute")

	return(rf.pred$predicted[, "1"]+rf.pred$predicted[, "2"])
}

