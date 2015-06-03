#! /usr/bin/env Rscript

source("../score.R")

dtest <- read.csv("real_value.csv")
dpred_1a <- read.table("pred_1a.txt")
score_q1a(dtest[, "LKADT_P"], dtest[, "DEATH"], dpred_1a[,1])
dpred_1b <- read.table("pred_1b.txt")
score_q1b(dpred_1b[,1], dtest[, "LKADT_P"], dtest[, "DEATH"])

