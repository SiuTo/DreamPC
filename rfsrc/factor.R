#! /usr/bin/env Rscript

toFactors <- function(data)
{
	if (any(colnames(data)=="DISCONT")) data$DISCONT <- factor(data$DISCONT, ordered=FALSE, levels=1:7)
	if (any(colnames(data)=="AGEGRP2")) data$AGEGRP2 <- factor(data$AGEGRP2, ordered=TRUE)
	if (any(colnames(data)=="RACE_C")) data$RACE_C <- factor(data$RACE_C, ordered=FALSE)
	if (any(colnames(data)=="REGION_C")) data$REGION_C <- factor(data$REGION_C, ordered=FALSE)
	return(data)
}

