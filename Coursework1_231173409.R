
#' title: Time Series CW 1: Gold Price Forecasting using Prophet
#' author: Shaivi
#' date: 20-03-2026

# 1. LOAD LIBRARIES
#library(prophet)- forecasting model
#library(tidyverse)- data manipulation
# library(lubridate)- date handling
# Done in console


# 2. LOAD CSV DATA
gold_data <- read.csv("data/gold_price_1970_2026_daily.csv",stringsAsFactors = FALSE)
#keeps text as text and not categories
# View structure
str(gold_data)
head(gold_data) #to check data


# 3. CLEAN COLUMN NAMES
# Remove spaces and standardise names
names(gold_data) <- trimws(names(gold_data)) #Removes extra spaces from column names
names(gold_data) <- tolower(names(gold_data)) #Converts all column names to lowercase

# Check names
names(gold_data) # Displays cleaned column names
gold_data$date #Accesses the date column to check date data.



# 4. CONVERT DATE COLUMN
gold_data$date <- mdy(gold_data$date) # Converts date from text to proper Date format.
head(gold_data$date) #Shows first few converted dates to check
gold_data <- gold_data[!is.na(gold_data$date), ] #Removes rows where date is missing
head(gold_data$date) #Check result again


# 5. PREPARE DATA FOR PROPHET
#Creates a new dataset in the format Prophet requires:
#ds as a date column
#y as a value to forecast (gold price)
prophet_data <- data.frame(
    ds = gold_data$date,   # date column
    y = gold_data$close    # closing price
)

# Check structure
str(prophet_data)


# 6. VISUALISE DATA
#Plots gold prices over time.
plot(prophet_data$ds, prophet_data$y, type = "l",
     main = "Gold Closing Prices Over Time",
     xlab = "Year", ylab = "Price")
# The plot shows a clear long term upward trend in gold prices, with periods of volatility and sharp increases.
#This indicates sensitivity to economic conditions.

# 7. LOG TRANSFORMATION
#Applies natural log to prices
#This is done to stabilise variance, which helps understand model growth patterns better
prophet_data$y <- log(prophet_data$y)


# 8. FIT PROPHET MODEL
#Trains a forecasting model using the data
gold_model <- prophet(prophet_data)
#Important to note it shows log-transformed gold prices, not actual prices

# 9. CREATE PREDICTING FUTURE DATA
future_dates <- make_future_dataframe(gold_model, periods = 365)
#Creates future dates (1 year ahead)
#Keeps historical data too

# 10. MAKE FORECAST
gold_forecast <- predict(gold_model, future_dates)
#Generates predictions for all dates

# 11. PLOT FORECAST
plot(gold_model, gold_forecast)
#Historical gold prices and the model’s forecast for the next 365 days, including uncertainty.
# X-axis (ds) represents time in years
# Y-axis (y) represents logarithm of gold prices
#The black line is the raw historical data (after log transformation) of the observed gold price (daily)
# The blue line is a smoothed curve fitted to the data, representing teh underlying long term trend

# 12. PLOT COMPONENTS
prophet_plot_components(gold_model, gold_forecast)
#Breaks forecast into parts: trend and seasonality (yearly patterns)
#Top plot shows long-term movement of gold prices (log scale)
#X-axis shows the time
#Y-axis shows the trend value
#Observed:
    #Strong upward trend from 1970 to 2025
    #Slight flattening around 1980 to 2000
    #Faster growth after 2000
#Middle plot shows the effect of day of the week on prices
#X-axis shows the days
#Y-axis shows the small effect on price
#Observed:
    #Slight dip on Monday
    #Increase towards weekend (Saturday highest)
    #Day of week has little impact on gold prices
#Bottom plot shows the effect of time of year
#X-axis shows the day of year (can look at the year in quarters for better understanding)
#Y-axis shows the seasonal effect
#Observed:
    #Peaks around the middle of the year
    #Dips towards the end and start of the year
    #Some seasonal pattern but relatively small compared to the the trend.

#All components are in log scale, so seasonal effects represent proportional changes rather than absolute price differences

# 13. INSPECT RESULTS
#Shows last few predictions: yhat as the predicted value and yhat_lower/upper as the uncertainty range
tail(gold_forecast[, c("ds", "yhat", "yhat_lower", "yhat_upper")])
#Here selected specific columns from the forecast (ds is the date, yhat is the predicted values and yhat_lower and yhat_upper are the lower and upper bounds(uncertainity interval))
#tail() shows the last few rows

#Reverses the log transformation using exponential
gold_forecast$price <- exp(gold_forecast$yhat)
gold_forecast$price_lower <- exp(gold_forecast$yhat_lower)
gold_forecast$price_upper <- exp(gold_forecast$yhat_upper)
# The exponential reverses the log prices to the prices

#Shows readable price predictions
tail(gold_forecast[, c("ds", "price", "price_lower", "price_upper")])

#Since a logarithmic transformation was applied, the forecasted values are in log scale.
#These were transformed back using the exponential function to obtain interpretable price values.


# 14. NO SEASONALITY MODEL to create a model without yearly patterns
#MAIN QUESTION: Does seasonality matter for gold prices?
model_no_season <- prophet(prophet_data, yearly.seasonality = FALSE)
#Removed seasonality to test its importance and only modelled the trend and default weekly effects.

future2 <- make_future_dataframe(model_no_season, periods = 365)
forecast2 <- predict(model_no_season, future2)

plot(model_no_season, forecast2)
#Since the forecast did not change much, it shows that gold prices are not strongly seasonal.

# 15. RECENT DATA MODLE which used data from the year 2000 onwards
# MAIN QUESTION: What happens if we only use modern gold price behaviour?
recent_data <- prophet_data[prophet_data$ds > as.Date("2000-01-01"), ]

#Trains model on recent trends only
recent_model <- prophet(recent_data)
#Uses only modern data so it can learn recent trends instead of the long term history of gold price fluctuation
future_recent <- make_future_dataframe(recent_model, periods = 365)
forecast_recent <- predict(recent_model, future_recent)
plot(recent_model, forecast_recent)

#KEY INSIGHTS
#What you typically observe:
#Long-term upward trend- Gold prices generally increase over decades
# 1970 to 1980: Rapid increase
# 1980-2000: Relatively stable and slow growth (has dippped in between)
# 2000-2026: Strong sustained growth noticed
#Periods of sharp spikes can be linked to crises (financial instability, inflation, geopolitics).
#Volatility clusters as some periods are calm, others highly volatile.
# Gold behaves like a safe haven asset, as the price rises during uncertainty consider the 2008 financial crisis, 2021 Covid-19 pandemic, and more.

