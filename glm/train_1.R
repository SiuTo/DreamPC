#! /usr/bin/env Rscript

library("glmnet")

train <- function(dtrain, dtest)
{
	cat("\tTraining...\n")
	x <- as.matrix(dtrain[, -(1:2)])
	y <- cbind(time=dtrain$LKADT_P, status=dtrain$DEATH)
	fit <- glmnet(x, y, family="cox")
	cv.fit <- cv.glmnet(x, y, family="cox", nfold=5)
	lambda <- cv.fit$lambda.min

	cat("\tPredicting...\n")
	xx <- as.matrix(dtest[, -(1:2)])
	dpred_train <- predict(fit, newx=x, s=lambda, type="response")
	dpred_1a <- predict(fit, newx=xx, s=lambda, type="response")
	dpred_1b <- predict(fit, newx=xx, s=lambda, type="link")

	return(list(a_train=dpred_train, a=dpred_1a, b=dpred_1b))
}

