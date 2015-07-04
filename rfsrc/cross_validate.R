#! /usr/bin/env Rscript

source("../score.R")
source("train_rfsrc.R")

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
	train(dtrain, dtest, i-1)
	
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

