#! /usr/bin/env Rscript

library("randomForestSRC")

data <- read.csv("../data/data_train.csv")
data_impute <- impute.rfsrc(Surv(LKADT_P, DEATH) ~ ., data, nsplit=2, na.action="na.impute")
write.csv(data_impute, "data_train_impute.csv", quote=FALSE, row.names=FALSE)

