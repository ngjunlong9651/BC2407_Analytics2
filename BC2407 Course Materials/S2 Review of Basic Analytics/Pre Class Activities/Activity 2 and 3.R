## Activity 2 Using R

library(data.table)
library(ggplot2)
library(psych)
library(reshape)
library(rpart)
library(rpart.plot)

## Set WD
setwd("/Users/junlongng/Desktop/NTU/Year_2/Semester 2/BC2407 Analytics II/BC2407 Course Materials/S2 Review of Basic Analytics")


df1 = fread("/Users/junlongng/Desktop/NTU/Year_2/Semester 2/BC2407 Analytics II/BC2407 Course Materials/S2 Review of Basic Analytics/default.csv", stringsAsFactors = T, na.strings = c("NA","missing","","na","."))

df1
dim(df1)
#10,000 rows and 4 columns worth of data

## Checking if there are empty rows within this dataset
sum(is.na(df1))
## There are no empty values within this dataset

## Checking for skewness
describe(df1)

## Checking data type for each column
str(df1)
## Seems like each data column is appropriately categorised

##1 Build a Logistic Regression model to predict Default status.
lm = glm(Default~., data = df1, family = "binomial")
summary(lm)
## This shows us that income is not significant based on the model

lm2 = glm(Default~. -Income, data= df1, family ="binomial")
summary(lm2)

##2 What are the model coefficients and confusion matrix?
prob = predict(lm2, type="response")
prob
threshold = 0.5
lm2.predict <- ifelse(prob > threshold, "Yes", "No")


## Creating the confusion matrix
table1 <- table(Actual = df1$Default, lm2.predict, deparse.level = 2)
table1
round(prop.table(table1),3)

## Accuracy
mean(lm2.predict == df1$Default) * 100


 ##3 Which cases has P(Default = Yes) > 90%?
df1[prob > 0.9]



## Activity 3
set.seed(42)
cart1 = rpart(Default ~. -Income, data = df1, method = "class", control = rpart.control(cp=0))

printcp(cart1)
plotcp(cart1)
rpart.plot(cart1, nn = T, main = "Maximum CART Tree")

## Pruning the tree
cverrorcap = cart1$cptable[which.min(cart1$cptable[,"xerror"]),"xerror"] + cart1$cptable[which.min(cart1$cptable[,"xerror"]),"xstd"]

i = 1; j=4
while (cart1$cptable[i,j] > cverrorcap) {
  i = i+1
}

optimal_cp = ifelse(i > 1, sqrt(cart1$cptable[i,1] * cart1$cptable[i-1,1]),1)
optimal_cp
cart2 = prune(cart1, cp = optimal_cp)
rpart.plot(cart2,nn=T,main="Newer Pruned Tree")


##1. Build an optimal CART model to predict Default status. 
predictcart1 = predict(cart2, newdata = df1, type = "class")
result1 = data.frame(df1$Default, predictcart1)
cart1_accuracy = mean(predictcart1 == df1$Default)
table(actual = df1$Default, predictcart1)
cart1_accuracy = cart1_accuracy*100
cart1_accuracy

##2 How many decision rules are in the optimal CART model and what is the confusion matrix?

















