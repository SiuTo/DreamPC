#! /usr/bin/env Rscript

model <- commandArgs(TRUE)[1]

source("score.R")
source(paste(model, "train.R", sep="/"))

data <- read.csv("data/data_train.csv")
folds <- split(1:nrow(data), 1:10)
score <- c()
for (i in 1:10)
{
	dtrain <- data.frame(data[-folds[[i]],])
	dtest <- data.frame(data[folds[[i]],])
	time <- dtest[, "LKADT_P"]
	status <- dtest[, "DEATH"]
	dtest[, "LKADT_P"] <- 0
	dtest[, "DEATH"] <- 1
	write.csv(dtrain, paste(model, "/data_train_", i-1, ".csv", sep=""), quote=FALSE, row.names=FALSE)
	write.csv(dtest, paste(model, "/data_test_", i-1, ".csv", sep=""), quote=FALSE, row.names=FALSE)

	cat("Fold:", i-1, "\n")
	dpred <- train(dtrain, dtest)
	write.table(dpred$a, paste(model, "/pred_1a_", i-1, ".txt", sep=""), quote=FALSE, row.names=FALSE, col.names=FALSE)
	write.table(dpred$b, paste(model, "/pred_1b_", i-1, ".txt", sep=""), quote=FALSE, row.names=FALSE, col.names=FALSE)
	
	cat("\tEvaluating...\n")
	a <- score_q1a(time, status, dpred$a)
	b <- score_q1b(dpred$b, time, status)

	score <- rbind(score, round(c(a$cIndex, a$auc12, a$auc18, a$auc24, a$iAUC, b), 3))

	cat("\tFinish.\n\n")
}

avg <- c()
for (i in 1:ncol(score))
	avg <- c(avg, mean(score[,i]))
score <- rbind(score, avg)
print(score)
