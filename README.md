# regression-prediction-r
Regression modeling and predictive analysis using R.
# Regression & Predictive Modeling in R

## Project Overview

This project focuses on regression analysis and predictive modeling using R.

The analysis was completed as part of my Data Analytics coursework as a third-year Economics with Data Science student at the University of Cassino and Southern Lazio.

The objective was to investigate the relationship between a continuous target variable and multiple predictors, compare alternative regression models, and generate predictions for an unseen test dataset.

## Dataset

The project uses a training dataset containing:

* 1,000 observations
* 9 predictor variables (`v1`–`v9`)
* 1 continuous target variable (`Y`)

A separate test dataset containing 100 observations was used to generate final predictions.

## Methodology

The analysis includes:

1. Data loading and preparation
2. Exploratory Data Analysis (EDA)
3. Missing-value checking
4. Distribution and correlation analysis
5. Outlier inspection
6. Multicollinearity analysis using Variance Inflation Factors (VIF)
7. Development of a baseline multiple linear regression model
8. Development of an enhanced regression model
9. Feature engineering using a quadratic transformation and interaction effect
10. Model comparison using RMSE, residual standard error, and adjusted R²
11. Regression diagnostics
12. Prediction of the target variable for the test dataset
13. Export of predictions to a CSV file

## Models

### Baseline Model

A multiple linear regression model was developed using the nine predictor variables.

### Enhanced Model

An enhanced model was developed by introducing:

* A quadratic transformation of `v3`
* An interaction effect between `v3` and `v7`

The models were compared using their training performance and regression statistics.

## Methods & Tools

* R
* RStudio
* Multiple Linear Regression
* Predictive Modeling
* Exploratory Data Analysis
* Feature Engineering
* Model Evaluation
* Multicollinearity Analysis
* Regression Diagnostics
* Data Visualization

### R Packages

* `dplyr`
* `car`
* `ggplot2`
* `corrplot`

## Project Files

* `regression_prediction.R` — R script containing the complete analysis

## Key Learning Outcomes

This project provided practical experience in regression modeling, exploratory data analysis, feature engineering, multicollinearity assessment, model comparison, regression diagnostics, and generating predictions for unseen data using R.
