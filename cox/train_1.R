#! /usr/bin/env Rscript

library("survival")

train <- function(dtrain, dtest)
{
	cat("\tTraining...\n")
	cox.obj <- coxph(Surv(LKADT_P, DEATH) ~ ., dtrain)

	cat("\tPredicting...\n")
	dpred_train <- predict(cox.obj, dtrain, type="risk")

	cox.pred <- predict(cox.obj, dtest, type="risk")
	dpred_1a <- cox.pred

	dpred_1b <- cox.pred

	return(list(a_train=dpred_train, a=dpred_1a, b=dpred_1b))
}

