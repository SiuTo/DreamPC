#! /usr/bin/env Rscript

library("randomForestSRC")

options(rf.cores=detectCores()-1, mc.cores=detectCores()-1)

data <- read.csv("../data/data_train.csv")
data <- impute.rfsrc(Surv(LKADT_P, DEATH) ~ ., data, nsplit=2)
rf.obj <- rfsrc(Surv(LKADT_P, DEATH) ~ ., data, nsplit=2)
topvars <- var.select(object = rf.obj)$topvars
write.table(topvars, "features_list.txt", quote=FALSE, row.names=FALSE, col.names=FALSE)

