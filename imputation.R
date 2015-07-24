#! /usr/bin/env Rscript

library(yaImpute)
#library(fastICA)
#library(vegan)

imputation <- function(train,distance_measure = 'raw',imputation_measure = 'mean',k = 10)
{
  
  na_columns <- which(apply(train,2,function(x) any(is.na(x))))
  
 
  full_records <- train[,-na_columns]
  
  
  for(i in 1:length(na_columns))
  {
    knn <- yai(x = full_records,y = train[,na_columns[i]],k = k,noRefs = T , method = distance_measure)
    im <- impute(knn,method = imputation_measure,method.factor = imputation_measure)
    
    train[is.na(train[,na_columns[i]]),na_columns[i]] <- im[1]
    
  }
  
  return(train)
}

