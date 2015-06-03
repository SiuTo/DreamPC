#! /usr/bin/env Rscript

source("score.R")

dtest <- read.csv("data_test.csv")
dpred_1a <- read.csv("submission_1a.csv")
score_q1a(dtest[, "LKADT_P"], dtest[, "DEATH"], dpred_1a[, "RISK"])
dpred_1b <- read.csv("submission_1b.csv")
score_q1b(dpred_1b[, "RISK"], dtest[, "LKADT_P"], dtest[, "DEATH"])

