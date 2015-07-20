#! /usr/bin/env Rscript

library("glmnet")

data <- read.csv("../data/data_train.csv")
x <- as.matrix(data[, -(1:2)])
y <- cbind(time=data$LKADT_P, status=data$DEATH)

cv.fit <- cv.glmnet(x, y, family="cox")
plot(cv.fit)
coefficients <- coef(cv.fit, s=cv.fit$lambda.min)
active.index <- which(coefficients!=0)

write.table(c("LKADT_P", "DEATH", colnames(x)[active.index]), "lasso.txt", quote=FALSE, row.names=FALSE, col.names=FALSE)

