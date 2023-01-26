library(arules)
library(reshape2)
library(tidyr)

## --------------- Activity 1 ----------------- ##

setwd("/Users/junlongng/Desktop/NTU/Year_2/Semester 2/BC2407 Analytics II/BC2407 Course Materials/S3 Association Rules")

df = read.csv("/Users/junlongng/Desktop/NTU/Year_2/Semester 2/BC2407 Analytics II/BC2407 Course Materials/S3 Association Rules/milk.csv")

## We shall start with the longdata format
longdata = df
longdata
longdata = melt(data = longdata, id.vars = "ID")
longdata = subset(longdata, value != 0)
## Removing the ID & Index column
longdata = longdata[,1:2]


## We will now convert long to wide data type 
widedata = df
widedata
## Need to remove the index column: ID each row has been considered as a transaction. Hence index column is redundant as an identifier.
widedata = widedata[,-1]




## -------------------- Activity 2 -------------- ##

#Converting from dataframe to transactions datatype using arules package

widedata[] = lapply(widedata,factor)
## All columns to factor datatype instead of integer & save it as a dataframe

summary(widedata)

## Checking that all are factorial data type
str(widedata)



## Converting the datatype to a transaction data format
trans = as(widedata, "transactions")

## Inspecting the transactions datatype
inspect(trans)

## Generating Rules
## There are three parameters controlling the number of rules to be generated. Support, confidence and lift. Lift is generated using support. Confidence is one of the major parameters to filter generated result.

## Source: https://towardsdatascience.com/association-rule-mining-in-r-ddf2d044ae50

## A default parameter for example: APparameter is 1, this means that rules with only one item will be created. Hence this means that no matter what other items are involved the item in the RHS will appear with the probability given by the rule's confidence. We can adjust the parameter values for the rules such as: setting minlen to be a higher value


## Trying it out with a wide data
ruleswide = apriori(data = trans, parameter = list(minlen = 2, supp = 0.4, conf = 0.3, target = "rules"))
summary(ruleswide)
## This returns us a set of 65 rules.
## From these 65 rules, we shall inspect the top 10 rules by support, confidence, lift
# inspect(head(ruleswide, n = 10, by ="support"))
# inspect(head(ruleswide, n = 10, by ="confidence"))
# inspect(head(ruleswide, n = 10, by ="lift"))
rules.wide = inspect(ruleswide)


## Trying it out with a long data
longdata

## Converting Longdata to Widedata by formatting values to be logical
longdata2 = data.frame(lapply(widedata, as.logical))
longdata2 = longdata[,-1]

trans2 = as(longdata2, "transactions")
trans2

ruleslong = apriori(data = trans2, parameter = list(minlen = 2, supp = 0.4, conf = 0.3, target = "rules"))

summary(ruleslong)
inspect(ruleslong)
## even though parameters values are the same, they give different results. Long data type produces lesser rules as compared to a wide data type. 