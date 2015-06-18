#! /usr/bin/env Rscript

#this is just a demo of using Cox model to estimate the patients' survival radio

#use Cph to fit Cox model and ues the overall suvrvival ratio at 12,18,24 months
#multiply the exp(coefficients with individual variables) to get the individual risk ratio at
#specified time points



#just use 515 completed data 

#input Survival package
library('survival')

#Prostate cancer survival prediction challenge

#choose CoreTable as the features set
#input coretable data
rawMatrix <- as.matrix(read.csv('../data/CoreTable_training.csv',header=T))


#choose 8 factors mentioned in baseline method:
#ECOG performance status, disease site, LDH (defined as > 1 x ULN), opioid analgesic use,
#albumin, hemoglobin, PSA, and alkaline phosphatase

featureSet <- data.frame(as.numeric(rawMatrix[,'ECOG_C']),as.numeric(rawMatrix[,'ALP'])
                         ,as.numeric(rawMatrix[,'HB'])
                         ,as.numeric(rawMatrix[,'LDH'])
                         ,as.numeric(rawMatrix[,'PSA']),as.numeric(rawMatrix[,'ALB'])
                         ,rawMatrix[,57:75]
                         ,rawMatrix[,'ANALGESICS'])

colnames(featureSet,do.NULL=F)
colnames(featureSet) <- c('ECOG_C','ALP','HB','LDH','PSA','ALB',colnames(rawMatrix)[57:75],'ANALGESICS')


#transform data format into numeric 

for(i in 7:(ncol(featureSet)-1)){
  featureSet[,i] <- ifelse(featureSet[,i] =='Y',1,0)
}

featureSet[,'ANALGESICS'] <- ifelse(featureSet[,'ANALGESICS']=='YES',1,0)

#check each column and delete all NA column

check <- c()
for(i in 1:ncol(featureSet)){
  if(all(is.na(featureSet[,i])))
    check <- c(check,i)
}
featureSet <- featureSet[,-check]



#choose survival time & status, which in Coretable.csv are called LKADT_P & DEATH
#and transform them into numeric
survivalData <- data.frame(as.numeric(rawMatrix[,'LKADT_P'])
                           ,ifelse(rawMatrix[,'DEATH'] == 'YES',1,0))

colnames(survivalData) <- c('time','status')




#clean NA elements in training data set (that is not a good choose)!!!!!!
#and get 515 complete records
index <- c()

for(i in 1:(nrow(featureSet))){
  if(anyNA(featureSet[i,])){
    index <- c(index,i)
  }
}

# the independent variables 
featureSet <- featureSet[-index,]

# the dependent variables 
survivalData <- survivalData[-index,]

time <- survivalData[[1]]
status <- survivalData[[2]]

#construct 10 folds 
folds <- split(1:nrow(featureSet),1:10)

#use cph function to create Cox model
library('rms')
#use timeROC function to calculate the t-AUC which is the performance of the model
library('timeROC')

#just choose 1st fold to be the test set
i = 1
test_fold <- featureSet[folds[[i]],]

#use other folds to be the training set
training_fold <- featureSet[-folds[[i]],]
  

#fit Cox model
#Surv(time,status) means creating two columns vector like this:
#time to event(death)  status
#   232                   1    -> indicating this person lived 232 days and died
#   432                   0    -> indicating this person's final knowing lived period is 432 and he may quit the trial(censored)
#   ...                 ...
#
#use Surv ~ variables to fit the model
cph.test <- cph(Surv(time[-folds[[i]]],status[-folds[[i]]])~ ECOG_C + ALP + HB + LDH + PSA + ALB + BONE+RECTAL+LYMPH_NODES+KIDNEYS+LUNGS+LIVER+PLEURA+OTHER+PROSTATE+   
                    ADRENAL+BLADDER + COLON+ PERITONEUM + SOFT_TISSUE + 
                    ABDOMINAL+ANALGESICS
                  ,data = training_fold,surv = T ,x = T ,y = T)

#get 12,18,24 months overall survival risk radio
g <- Survival(cph.test)
pr <- g(times=c(360,540,720))

#get the coefficients of Cox model
coef <- cph.test$coef

#use the test set to check the performanece
risk_score <- c()
  for(j in 1: nrow(test_fold))
    risk_score <- c(risk_score,exp(sum(coef * test_fold[j,]))*pr[1])
#get the t-AUC 
  ROC.risk <- timeROC(T=time[folds[[i]]],delta=status[folds[[i]]],marker=risk_score,cause=1,times=360,iid=T)
  ROC.risk


