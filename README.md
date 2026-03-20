# Time Series Coursework 1
# Gold Price Forecasting using Prophet
## Project Overview
This project looks at historical gold prices from 1970 to 2026 and uses the Prophet model to forecast future values. Gold is often described as a safe haven asset, meaning that its price tends to increase during periods of economic uncertainty.

The aim of this project is to analyse the behaviour of gold prices over time, build a forecasting model, and investigate whether seasonality plays an important role. The project also compares results when only recent data is used.

# Dataset
The dataset was downloaded from Kaggle in CSV format. It contains daily gold prices from 1970 to 2026. In this project, only the closing price is used, although the dataset also includes open, high, and low prices.

# Data Preparation
Before building the model, several preprocessing steps were carried out:
Column names were cleaned to remove spaces and standardise formatting
The date column was converted into a proper date format
Missing values were removed
A new dataframe was created with the required format for Prophet:
ds representing the date
y representing the closing price

# Exploratory Analysis
A plot of the gold prices shows a clear long term upward trend. There are also periods of higher volatility and sharper increases, particularly after the early 2000s. This suggests that gold prices are influenced by changing economic conditions over time.

# Model Building
A logarithmic transformation was applied to the data to stabilise variance and improve the performance of the model.
The Prophet model was then fitted to the data. This model captures different components of the time series, including the overall trend and any seasonal patterns.

# Forecasting
The model was used to forecast gold prices one year into the future (365 days). The forecast includes both predicted values and uncertainty intervals.
The results suggest that gold prices are expected to continue increasing, although the level of uncertainty becomes larger further into the future.

# Model Components
The Prophet model separates the data into different components:
  The trend component shows a strong long term increase in gold prices, with faster growth after 2000
  The weekly component shows very little variation, suggesting that the day of the week has minimal effect
  The yearly component shows small seasonal patterns, but these are relatively weak compared to the overall trend
  Overall, the trend is the main factor driving gold prices.
  
# Model Comparisons
A second model was created without yearly seasonality. The results were very similar to the original model, which suggests that seasonality does not play a major role in gold prices.
Another model was built using only data from the year 2000 onwards. This model showed a steeper upward trend, reflecting more recent market behaviour. It suggests that using recent data may provide more relevant short term forecasts.

# Key Insights
Gold prices show a strong long term upward trend, with noticeable increases after the early 2000s. There are also periods of higher volatility, often linked to economic events.
Seasonality appears to have little impact on gold prices. The forecasts indicate continued growth, although uncertainty increases over time. Models based on more recent data provide results that better reflect current trends.

# Conclusion
This project demonstrates how the Prophet model can be used for time series forecasting. The results suggest that gold prices are mainly driven by long term trends rather than seasonal effects.
While the model predicts continued growth, the uncertainty associated with these predictions increases over longer time periods. Using more recent data can improve the relevance of short term forecasts.

# Tools Used
R, Prophet, lubridate, tidyverse

# Notes
All forecasts were initially produced using log transformed data and then converted back to actual price values. Prices in the dataset are in US dollars.
Further work could include analysing other price variables or comparing gold with other financial assets.
