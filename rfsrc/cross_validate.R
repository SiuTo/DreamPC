#! /usr/bin/env Rscript

source("../score.R")
library("randomForestSRC")

options(rf.cores=detectCores()-1, mc.cores=detectCores()-1)

dtrain <- read.csv("data_train.csv")
dtest <- read.csv("data_test.csv")
dreal <- read.csv("real_value.csv")

"Training..."
rf.obj <- rfsrc(Surv(LKADT_P, DEATH) ~ ., dtrain, nsplit=10)

"Predicting..."
rf.pred <- predict(rf.obj, dtest)
l <- min(rf.pred$predicted)-10
h <- max(rf.pred$predicted)+10
dpred_1a <- (h-rf.pred$predicted)/(h-l)
write.table(dpred_1a, "pred_1a.txt", quote=FALSE, row.names=FALSE, col.names=FALSE)
dpred_1b <- rf.pred$predicted
write.table(dpred_1b, "pred_1b.txt", quote=FALSE, row.names=FALSE, col.names=FALSE)

"Evaluating..."
a <- score_q1a(dreal[, "LKADT_P"], dreal[, "DEATH"], dpred_1a)
b <- score_q1b(dpred_1b, dreal[, "LKADT_P"], dreal[, "DEATH"])
print(paste(round(a$cIndex, 3), round(a$auc12, 3), round(a$auc18, 3), round(a$auc24, 3), round(a$iAUC, 3), round(b, 3), sep=" "), quote=FALSE)

"Finish."

