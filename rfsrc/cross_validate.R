#! /usr/bin/env Rscript

source("../score.R")
library("randomForestSRC")

options(rf.cores=detectCores()-1, mc.cores=detectCores()-1)

data <- read.csv("../data/data_train.csv")
cat("", file="result.txt")
m <- ceiling(nrow(data)/10)
for (i in 0:0)
{
	left <- i*m+1
	right <- min((i+1)*m, nrow(data))
	dtrain <- data.frame(data[-(left:right),])
	dtest <- data.frame(data[left:right,])
	write.table(dtrain, paste("data_train_", i, ".txt", sep=""), quote=FALSE, row.names=FALSE)
	write.table(dtest, paste("data_test_", i, ".txt", sep=""), quote=FALSE, row.names=FALSE)

	print(paste("Fold:", i))
	print("Training...")
	rf.obj <- rfsrc(Surv(LKADT_P, DEATH) ~ ., dtrain, nsplit=3, importance="none")

	print("Predicting...")
	rf.pred <- predict(rf.obj, dtest)
	l <- min(rf.pred$predicted)-10
	h <- max(rf.pred$predicted)+10
	dpred_1a <- round((h-rf.pred$predicted)/(h-l), 3)
	write.table(dpred_1a, "pred_1a.txt", quote=FALSE, row.names=FALSE, col.names=FALSE)
	dpred_1b <- round(rf.pred$predicted)
	write.table(dpred_1b, "pred_1b.txt", quote=FALSE, row.names=FALSE, col.names=FALSE)

	print("Evaluating...")
	a <- score_q1a(dtest[, "LKADT_P"], dtest[, "DEATH"], dpred_1a)
	b <- score_q1b(dpred_1b, dtest[, "LKADT_P"], dtest[, "DEATH"])
	cat(round(c(a$cIndex, a$auc12, a$auc18, a$auc24, a$iAUC, b), 3), "\n", file="result.txt", append=TRUE)

	print("Finish.")
}

