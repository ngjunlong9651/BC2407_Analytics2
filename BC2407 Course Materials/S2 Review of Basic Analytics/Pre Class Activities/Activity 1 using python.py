## Activity 1 using python

## Installing the necessary packages
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn import linear_model
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score
import math

import warnings
warnings.filterwarnings("ignore")

## Importing the data
df = pd.read_csv("/Users/junlongng/Desktop/NTU/Year_2/Semester 2/BC2407 Analytics II/BC2407 Course Materials/S2 Review of Basic Analytics/resale-flat-prices-2019.csv")

## Cool python things
print(plt.style.available)
## Can print those styled graphs
plt.style.use('ggplot')


## EDA
df.head()

## Checking for NA values
df.info()

## Seems easier than R to do EDA
df.describe


## 1 Create a derived variable “remaining_lease_years” defined as the remaining lease (in years) of the flat as in 2019 and save it as a new column.
df['remaining_lease_years'] = df['remaining_lease'].str.split(" ").str[0]
df.describe



## 2 Set the Baseline Reference level for “town” to “Yishun”.
x_cat = df[['storey_range', 'remaining_lease_years', 'town', 'floor_area_sqm']]
target_y = df['resale_price']
x_cat = pd.get_dummies(x_cat, columns=['storey_range'])
del x_cat['storey_range_01 TO 03']
x_cat = pd.get_dummies(x_cat, columns=['town'])
del x_cat['town_YISHUN'] # set as baseline reference, relevel() equivalent in R
x_cat.head()



## 3 Build a Linear Regression model using floor_area_sqm, remaining_lease_years, town, and storey_range to estimate resale_price.
lin_reg = LinearRegression()
lin_reg.fit(x_cat, target_y)
lin_reg.intercept_
lin_reg.coef_
y_pred = lin_reg.predict(x_cat)
y_pred


##4  What are the model coefficients, R2 and RMSE?
print('RMSE: %.2f' % math.sqrt(mean_squared_error(target_y, y_pred)))
print('R^2: %.2f' % r2_score(target_y, y_pred))
print("Model Coefficient: %.2f" % lin_reg.coef_)

lin_reg.coef_