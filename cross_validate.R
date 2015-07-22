#! /usr/bin/env Rscript

question <- commandArgs(TRUE)[1]
model <- commandArgs(TRUE)[2]

source("score.R")
source(paste(model, "/train_", question, ".R", sep=""))

data <- read.csv("data/data_train.csv")
if (model=="rfsrc")
{
	if (any(colnames(data)=="DISCONT")) data$DISCONT <- factor(data$DISCONT, ordered=FALSE)
	if (any(colnames(data)=="AGEGRP2")) data$AGEGRP2 <- factor(data$AGEGRP2, ordered=TRUE)
	if (any(colnames(data)=="RACE_C")) data$RACE_C <- factor(data$RACE_C, ordered=FALSE)
	if (any(colnames(data)=="REGION_C")) data$REGION_C <- factor(data$REGION_C, ordered=FALSE)
}
score <- c()

if (question=="1")
{
	folds <- split(1:nrow(data), 1:10)
	for (i in 1:10)
	{
		dtrain <- data.frame(data[-folds[[i]],])
		dtest <- data.frame(data[folds[[i]],])
		time <- dtest$LKADT_P
		status <- dtest$DEATH
		dtest$LKADT_P <- 0
		dtest$DEATH <- 1
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
}else
{
	folds <- split(1:nrow(data), 1:4)
	for (i in 1:4)
	{
		dtrain <- data.frame(data[-folds[[i]],])
		dtest <- data.frame(data[folds[[i]],])
		write.csv(dtrain, paste(model, "/data_train_", i-1, ".csv", sep=""), quote=FALSE, row.names=FALSE)
		write.csv(dtest, paste(model, "/data_test_", i-1, ".csv", sep=""), quote=FALSE, row.names=FALSE)

		cat("Fold:", i-1, "\n")
		dpred <- train(dtrain, dtest)
		write.table(dpred, paste(model, "/pred_2_", i-1, ".txt", sep=""), quote=FALSE, row.names=FALSE, col.names=FALSE)
		
		cat("\tEvaluating...\n")
		auc <- score_q2(dpred, dtest$DISCONT==1 | dtest$DISCONT==2)

		score <- rbind(score, round(auc, 3))

		cat("\tFinish.\n\n")
	}
}

avg <- c()
for (i in 1:ncol(score))
	avg <- c(avg, mean(score[,i]))
score <- rbind(score, avg)
print(score)

