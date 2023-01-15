## BC2407 Lecture 2 Pre-Class Reading Assignments

## Ng Jun Long
## U2110010D

library(data.table)
library(ggplot2)
library(psych)
library(reshape)


setwd("/Users/junlongng/Desktop/NTU/Year_2/Semester 2/BC2407 Analytics II/BC2407 Course Materials/S2 Review of Basic Analytics")

df1 = fread("/Users/junlongng/Desktop/NTU/Year_2/Semester 2/BC2407 Analytics II/BC2407 Course Materials/S2 Review of Basic Analytics/resale-flat-prices-2019.csv", stringsAsFactors = T, na.strings = c("NA","missing","","na","."))

## Conduct EDA on the dataset
df1
dim(df1)

## 22204 rows and 11 columns throughout the whole dataset
summary(df1)

## Checking the data type of each column
str(df1)


## Checking for NA values within the dataset
sum(is.na(df1))
## No NA values identified.

## Checking for skewness
describe(df1)

## Checking for outliers
meltData <- melt(df1)
p <- ggplot(meltData, aes(factor(variable), value))
p + geom_boxplot() + facet_wrap(~variable, scale="free")

## 1
## Creating a derived variable "remaining lease years" 

df1$"Remaining_Lease_Years" = 99 - (2019 - df1$lease_commence_date)
df1


## 2
## Setting the baseline reference for "town" to "Yishun"
## Town is already a factor data type
levels(df1$town)
df1$town = relevel(df1$town, ref = "YISHUN")
## Now Yishun is the baseline reference for town

## 3
## Building a linear regression model
lmprice = lm(df1$resale_price ~ df1$floor_area_sqm + Remaining_Lease_Years + town + storey_range, data = df1)

summary(lmprice)
## Multiple R-squared:  0.8416,	Adjusted R-squared:  0.8413 

# Residuals = Error = Actual price - Model Predicted price
RMSE.lmprice <- sqrt(mean(residuals(lmprice)^2)) 
summary(abs(residuals(lmprice)))
RMSE.lmprice



