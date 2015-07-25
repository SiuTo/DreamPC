#! /usr/bin/env Rscript

library("survival")
library("gbm")

train <- function(dtrain, dtest)
{
	cat("\tTraining...\n")
	gbm.obj <- gbm(Surv(LKADT_P, DEATH) ~ ., distribution="coxph", data=dtrain, n.trees=5000, cv.folds=5)
	best.iter <- gbm.perf(gbm.obj, method="cv")
	print(best.iter)

	cat("\tPredicting...\n")

	gbm.pred <- predict(gbm.obj, newdata=dtest, best.iter)
	dpred_train <- gbm.obj$fit
	dpred_1a <- exp(gbm.pred)
	dpred_1b <- exp(gbm.pred)

	return(list(a_train=dpred_train, a=dpred_1a, b=dpred_1b))
}

