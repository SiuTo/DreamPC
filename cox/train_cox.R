#! /usr/bin/env Rscript

library("survival")

train <- function(dtrain, dtest, flag)
{
	cat("\tTraining...\n")
	cox.obj <- coxph(Surv(LKADT_P, DEATH) ~ ., dtrain)

	cat("\tPredicting...\n")
	cox.pred <- predict(cox.obj, dtest, type="risk")
	dpred_1a <- cox.pred
	write.table(dpred_1a, paste("pred_1a_", flag, ".txt", sep=""), quote=FALSE, row.names=FALSE, col.names=FALSE)

	dpred_1b <- cox.pred
	write.table(dpred_1b, paste("pred_1b_", flag, ".txt", sep=""), quote=FALSE, row.names=FALSE, col.names=FALSE)

	return(list(a=dpred_1a, b=dpred_1b))
}

