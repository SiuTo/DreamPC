#! /usr/bin/env Rscript

source("train_rfsrc.R")

dtrain <- read.csv("../data/data_train.csv")
dtest <- read.csv("../data/data_test.csv")
train(dtrain, dtest, "final")

