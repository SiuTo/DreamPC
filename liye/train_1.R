#! /usr/bin/env Rscript

#data preperation is the same way i did before
train <- function(dtrain,dtest){

	split <- nrow(dtrain)

  coreData <- rbind(dtrain, dtest)
	m <- nrow(coreData)
  #coreData <- read.csv('CoreTable_training.csv',header = T)
  
  library(rms)
  library(survival)
  
  #store the survival time and status
  origin_survival_time <- coreData$LKADT_P
  origin_death <- coreData$DEATH
  #transfrom the death factor into binary vector
  origin_death <- ifelse(origin_death == 'YES',1,0)
  
  #ALP ~ CREACLCA
  commonfeatures <- coreData[30:54]
  commonfeaturesnames <- colnames(coreData)[30:54]
  
  mulfeature <- matrix(nrow = m)
  for(i in 1:length(commonfeatures)){
    mulfeature <- cbind(mulfeature,as.numeric(as.matrix(commonfeatures[i],ncol = 1,nrow = m)))  
  }
  
  mulfeature <- mulfeature[,-1]
  
  colnames(mulfeature,do.NULL=F)
  colnames(mulfeature) <- commonfeaturesnames
  
  
  #delete those variables have less than 1000 records
  index <- c()
  
  for(i in 1:ncol(mulfeature)){
    if(sum(!is.na(mulfeature[,i])) < 1000)
      index <- c(index,i)
  }
  
  mulfeature <- mulfeature[,-index]
  
  
  #add age variable
  
  age <- as.numeric(as.matrix(coreData[14],ncol = 1,nrow = m))
  
  #first delete age_group variable
  #add age_group variable
  AGEGRP2 <- ifelse(coreData[15] == '18-64',1,ifelse(coreData[15] == '65-74',2,3))
  
  #add bmi variable
  bmi <- as.numeric(as.matrix(coreData[17],ncol = 1,nrow = m))
  
  #add weight
  weight <- as.numeric(as.matrix(coreData[20],ncol = 1,nrow = m))
  
  mulfeature <- cbind(mulfeature,AGEGRP2,bmi,weight)
  
  #process those binary features
  binary_variable <- coreData[55:length(coreData)]
  
  index <- c()
  for(i in 1:length(binary_variable)){
    if(all(is.na(binary_variable[i])))
      index <- c(index,i)
  }
  
  binary_variable <- binary_variable[-index]
  
  for(i in 1:length(binary_variable))
    binary_variable[i] <- ifelse(binary_variable[i] == 'Y',1,ifelse(binary_variable[i] == 'YES',1,0))
  
  #all the variables are stores in the maritx called mulfeature
  mulfeature <- as.matrix(cbind(mulfeature,binary_variable))
  
  #analysis this matrix
  #this time i want to check each feature's range,yes the range
  #the ranges is stored in the HR.csv
  #i choose the following variables:
  #ADRENAL PATHFRAC LIVER PLEURA MHPSYCH GIBLEED MI BONE MHCARD ANALGESICS
  #TURP ANTI_ANDROGENS LYMPH_NODES CORTICOSTEROID CHF MHRESP NEU CEREBACC MHGEN
  #OTHER MHHEPATO MHNERV DVT WBC BILATERAL_ORCHIDECTOMY MHVASC AGEGRP2
  #MHEYE BETA_BLOCKING ACE_INHIBITORS HB MHMUSCLE MHBLOOD BISPHOSPHONATE MHINVEST
  #MHEAR NON_TARGET GLUCOCORTICOID MHNEOPLA ESTROGENS MHENDO GONADOTROPIN CA
  
  features_selected_by_hand <- c(
    'ADRENAL','PATHFRAC', 'LIVER', 'PLEURA', 'MHPSYCH', 'GIBLEED', 'MI', 'BONE', 'MHCARD', 'ANALGESICS',
    'TURP', 'ANTI_ANDROGENS', 'LYMPH_NODES', 'CORTICOSTEROID', 'CHF', 'MHRESP', 'NEU', 'CEREBACC', 'MHGEN',
    'OTHER', 'MHHEPATO', 'MHNERV', 'DVT', 'WBC', 'BILATERAL_ORCHIDECTOMY', 'MHVASC', 'AGEGRP2',
    'MHEYE', 'BETA_BLOCKING', 'ACE_INHIBITORS', 'HB', 'MHMUSCLE', 'MHBLOOD', 'BISPHOSPHONATE', 'MHINVEST',
    'MHEAR', 'NON_TARGET', 'GLUCOCORTICOID', 'MHNEOPLA', 'ESTROGENS', 'MHENDO', 'GONADOTROPIN', 'CA'
  )
  
  selected_features <- mulfeature[,features_selected_by_hand]
  
  #delete the rows have NA
  
  index <- c()
  for(i in 1:m){
    if(any(is.na(selected_features[i,]))) index <- c(index,i)
  }
  
  selected_features <- data.frame(selected_features[-index,])
  
  
  
  response <- Surv(origin_survival_time[-index],origin_death[-index],type='right')
  
  #ues lasso to choosing variables among 43 variables
  library(glmnet)

  dtest <- selected_features[-(1:split), ]
  selected_features <- selected_features[1:split, ]

  response <- response[1:split,]
	print(head(response))
  
  lasso <- cv.glmnet(as.matrix(selected_features),response,family = 'cox',nfolds = 10)
  #using the lambda which gives the minimum Cvm to predict the risk score
  #i will do this process within the following loop
  #now i has to find out the variables chosn by lasso
  #coef(lasso,s='lambda.min')

    #try to solve 
    #Error in Design(eval.parent(m)) : 
    #dataset ddist not found for options(datadist=)
    dd <- datadist(selected_features)
    options(datadist = 'dd')
    
    #PAN PAN PAN
    #note 8th iteration the ARTTHROM variables causes a failure
    #since the contingency table of this guy is this 
    #ARTTHROM 0   1
    #death0 555   0
    #1 442   1
    #i decided to ture off this guy
    
    #get survival ratio at specify time points
    
    #there are two different ways to calculate the HR for test set
    #1 using predict function and use exp
    x_beta <- predict(lasso,as.matrix(dtest),s = 'lambda.min')
    
    return(list(exp(x_beta),exp(x_beta)))
    
  
  
}
