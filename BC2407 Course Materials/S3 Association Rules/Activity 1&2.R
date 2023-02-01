library(arules)
library(reshape2)
library(tidyr)

## --------------- Activity 1 ----------------- ##

setwd("/Users/junlongng/Desktop/NTU/Year_2/Semester 2/BC2407 Analytics II/BC2407 Course Materials/S3 Association Rules")

df = read.csv("/Users/junlongng/Desktop/NTU/Year_2/Semester 2/BC2407 Analytics II/BC2407 Course Materials/S3 Association Rules/milk.csv")

## We shall start with splitting the data into two format
widedata = df
longdata = df
longdata = melt(data = longdata, id.vars = "ID")
longdata = subset(longdata, value != 0)
## Removing the ID & Index column
longdata = longdata[,1:2]

## Changing columns to factorial data type instead of integer values. Essentially "encoding"
summary(widedata)
widedata[] = lapply(widedata,factor)
summary(widedata)
widedata = widedata[,-1] ## Removing ID field, not really needed for analysis
str(widedata)
## 5 variables -> all factor datatype with 2 levels.


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

## Exporting results of a longdata into a csv and calling the csv back into R studio.
write.csv(longdata, "longdatatotransactions.csv", row.names = FALSE)


long_trans = read.transactions("longdatatotransactions.csv",format = "single", sep=",", header = TRUE, cols =c("ID","variable"))

## Take note that column has to match entries in the header of the file

## Convert long datatype to transactions format
long_trans = as(longdata, "transactions")

summary((long_trans))
inspect(long_trans)


ruleslong = apriori(data = long_trans, parameter = list(minlen = 2, supp = 0.4, conf = 0.3, target = "rules"))

summary(ruleslong)
inspect(ruleslong)
## even though parameters values are the same, they give different results. Long data type produces lesser rules as compared to a wide data type. 



## ------------------ Question 2 -----------------## 
## Default parameters might produce an empty set of rules as we can see in the long data type, to rectify this, we can adjust the min support parameter. 
## If you want to produce more rules using apriori algorithm, need to reduce min support to get more rules.
ruleslong = apriori(data = long_trans, parameter = list(minlen = 2, supp = 0.1, conf = 0.3, target = "rules"))



## ----------------- Question 3 -----------------##
## a) 
## What's the cause of the difference:



## b)
## Whan should you use long or wide data format:

## Long Data:
## Each row is a one-time point per subject, meaning that each row is not unique and each subject could contribute to multiple rows worth of data. Hence, long datasets are better for statistical analysis where they might be counting how much of each item is sold rather than the association between two items.

## Wide Data:
## In general, when analyzing data we should use a wide data set. This ensures that each entry in the data is unique and the subject's repeated responses will be in a single row and each response generates a separate column. Furthermore, wide data format is supported by ggplot2






