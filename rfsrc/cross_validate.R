#! /usr/bin/env Rscript

source("../score.R")
library("randomForestSRC")

options(rf.cores=detectCores()-1, mc.cores=detectCores()-1)

data <- read.csv("../data/data_train.csv")
folds <- split(1:nrow(data), 1:10)
score <- c()
for (i in 1:10)
{
	dtrain <- data.frame(data[-folds[[i]],])
	dtest <- data.frame(data[folds[[i]],])
	write.csv(dtrain, paste("data_train_", i-1, ".csv", sep=""), quote=FALSE, row.names=FALSE)
	write.csv(dtest, paste("data_test_", i-1, ".csv", sep=""), quote=FALSE, row.names=FALSE)

	cat("Fold:", i-1, "\n")
	cat("\tTraining...\n")
	rf.obj <- rfsrc(Surv(LKADT_P, DEATH) ~ ., dtrain, nsplit=3, importance="none")

	cat("\tPredicting...\n")
	rf.pred <- predict(rf.obj, dtest)
	#l <- min(rf.pred$predicted)-10
	#h <- max(rf.pred$predicted)+10
	#dpred_1a <- round((h-rf.pred$predicted)/(h-l), 3)
	dpred_1a <- round(rf.pred$predicted, 3)
	write.table(dpred_1a, paste("pred_1a_", i-1, ".txt", sep=""), quote=FALSE, row.names=FALSE, col.names=FALSE)
	dpred_1b <- round(rf.pred$predicted)
	write.table(dpred_1b, paste("pred_1b_", i-1, ".txt", sep=""), quote=FALSE, row.names=FALSE, col.names=FALSE)

	cat("\tEvaluating...\n")
	a <- score_q1a(dtest[, "LKADT_P"], dtest[, "DEATH"], dpred_1a)
	b <- score_q1b(dpred_1b, dtest[, "LKADT_P"], dtest[, "DEATH"])

	score <- rbind(score, round(c(a$cIndex, a$auc12, a$auc18, a$auc24, a$iAUC, b), 3))

	cat("\tFinish.\n\n")
}
avg <- c()
for (i in 1:ncol(score))
	avg <- c(avg, mean(score[,i]))
score <- rbind(score, avg)
print(score)

