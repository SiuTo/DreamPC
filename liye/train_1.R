#! /usr/bin/env Rscript

library(glmnet)

#data preperation is the same way i did before
train <- function(dtrain,dtest){

  origin_survival_time <- dtrain$LKADT_P
  origin_death <- dtrain$DEATH
  
  #features_selected_by_hand <- c(
  #  'ADRENAL','PATHFRAC', 'LIVER', 'PLEURA', 'MHPSYCH', 'GIBLEED', 'MI', 'BONE', 'MHCARD', 'ANALGESICS',
  #  'TURP', 'ANTI_ANDROGENS', 'LYMPH_NODES', 'CORTICOSTEROID', 'CHF', 'MHRESP', 'NEU', 'CEREBACC', 'MHGEN',
  #  'OTHER', 'MHHEPATO', 'MHNERV', 'DVT', 'WBC', 'BILATERAL_ORCHIDECTOMY', 'MHVASC', 'AGEGRP2',
  #  'MHEYE', 'BETA_BLOCKING', 'ACE_INHIBITORS', 'HB', 'MHMUSCLE', 'MHBLOOD', 'BISPHOSPHONATE', 'MHINVEST',
  #  'MHEAR', 'NON_TARGET', 'GLUCOCORTICOID', 'MHNEOPLA', 'ESTROGENS', 'MHENDO', 'GONADOTROPIN', 'CA'
  #)
  #
  #selected_features <- dtrain[,features_selected_by_hand]
  #dtest <- dtest[, features_selected_by_hand]
  
  selected_features <- dtrain[,-(1:2)]
  dtest <- dtest[, -(1:2)]
  
  response <- Surv(origin_survival_time,origin_death,type='right')
  
  #ues lasso to choosing variables among 43 variables

  lasso <- cv.glmnet(as.matrix(selected_features),response,family = 'cox',nfolds = 10)
  #using the lambda which gives the minimum Cvm to predict the risk score
  #i will do this process within the following loop
  #now i has to find out the variables chosn by lasso
  #coef(lasso,s='lambda.min')

    #try to solve 
    #Error in Design(eval.parent(m)) : 
    #dataset ddist not found for options(datadist=)
    
    #PAN PAN PAN
    #note 8th iteration the ARTTHROM variables causes a failure
    #since the contingency table of this guy is this 
    #ARTTHROM 0   1
    #death0 555   0
    #1 442   1
    #i decided to ture off this guy
    
    #get survival ratio at specify time points
    
    #there are two different ways to calculate the HR for test set
    #1 using predict function and use exp;
    x_beta <- predict(lasso,as.matrix(dtest),s = 'lambda.min')
    
    return(list(a=exp(x_beta),b=exp(x_beta)))
   
  
  
}
