# ***********************************************************
# 0097921_Script.R
# TUYJONOVA MAVLUDAKHON
# FINAL ASSIGNMENT: Predict Y for test_ch.csv using regression
# ***********************************************************


# 0. Cleaned workspace and set seed ---------------------------------------------
rm(list = ls())
set.seed(1)
# ------------------------------------------------------------------------------


# 1. Loaded required libraries ---------------------------------------------------
list.packages <- c("dplyr", "car", "ggplot2", "corrplot")
new.packages <- list.packages[!(list.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(dplyr)
library(car)
library(ggplot2)
library(corrplot)
# ------------------------------------------------------------------------------


# 2. Loaded data -----------------------------------------------------------------
train <- read.csv("~/FINAL PROJECT/train_ch.csv")
test  <- read.csv("~/FINAL PROJECT/test_ch.csv")

names(train)
names(test)

# Removed index column "X"
train <- train %>% select(-X)
test  <- test %>% select(-X)

# ------------------------------------------------------------------------------


# 3. Inspected structure and summary --------------------------------------------
str(train)         # Types of variables
summary(train)     # Basic statistic
# ------------------------------------------------------------------------------


# 4. Checked for missing values --------------------------------------------------
total_missing <- sum(is.na(train))
cat("Total missing values:", total_missing, "\n")
# No missing values
# ------------------------------------------------------------------------------


# 5. EDA: distributions, boxplots, correlations --------------------------------

numeric_vars <- names(train)[names(train) != "Y"]

# Pairwise scatterplot matrix
pairs(train[sapply(train, is.numeric)])


# Histograms of predictors
for (v in numeric_vars) {
  print(
    ggplot(train, aes_string(x = v)) +
      geom_histogram(bins = 30, fill="skyblue", color="black") +
      ggtitle(paste("Histogram of", v))
  )
}


# Boxplots to detect outliers
for (v in numeric_vars) {
  print(
    ggplot(train, aes_string(y = v)) +
      geom_boxplot(fill="purple", color="black") +
      ggtitle(paste("Boxplot of", v))
  )
}

# Explicit outlier conclusion:
cat("From boxplots: No severe outliers detected. Therefore, no removal/winsorization applied.\n")

# Correlation matrix
cor_matrix <- cor(train[sapply(train, is.numeric)])
corrplot(cor_matrix, method = "color", tl.cex = 0.7)
# ------------------------------------------------------------------------------


# 6. Baseline model ------------------------------------------------------------
m0 <- lm(Y ~ ., data = train)
summary(m0)

# RSE and R2 for baseline
cat("Baseline RSE:", sigma(m0), "\n")
cat("Baseline Adj R^2:", summary(m0)$adj.r.squared, "\n")

# VIF to detect collinearity
vif(m0)
# ------------------------------------------------------------------------------


# 7. Transformed model (quadratic + interaction) -------------------------------

m1 <- lm(
  Y ~ v1 + v2 + v3 + I(v3^2) + v4 + v5 + v6 + v7 + v8 + v9 + v3:v7,
  data = train
)

summary(m1)

cat("Transformed model RSE:", sigma(m1), "\n")
cat("Transformed model Adj R^2:", summary(m1)$adj.r.squared, "\n")
# ------------------------------------------------------------------------------


# 8. RMSE comparison on TRAIN and TEST -----------------------------------------

rmse <- function(y, yhat) sqrt(mean((y - yhat)^2))

# Train RMSE
rmse_m0_train <- rmse(train$Y, predict(m0, train))
rmse_m1_train <- rmse(train$Y, predict(m1, train))

# Test predictions
pred_m0_test <- predict(m0, test)
pred_m1_test <- predict(m1, test)

# Test RMSE cannot be computed because test Y is unknown.
# Only train RMSE is comparable here.

rmse_table <- data.frame(
  Model = c("Baseline m0", "Transformed m1"),
  RSE = c(sigma(m0), sigma(m1)),
  Adj_R2 = c(summary(m0)$adj.r.squared, summary(m1)$adj.r.squared),
  Train_RMSE = c(rmse_m0_train, rmse_m1_train)
)

print(rmse_table)
# ------------------------------------------------------------------------------


# 9. Diagnostics for final model -----------------------------------------------

par(mfrow = c(2,2))
plot(m1) 
# ------------------------------------------------------------------------------


# 10. Model selection -----------------------------------------------------------

# Choose m1 if it improves RSE, adjR2, and RMSE
if (rmse_m1_train < rmse_m0_train &&
    sigma(m1) < sigma(m0) &&
    summary(m1)$adj.r.squared > summary(m0)$adj.r.squared) 
{
  final_model <- m1
  cat("Selected model: m1 (transformed + interaction)\n")
} else {
  final_model <- m0
  cat("Selected model: m0 (baseline)\n")
}

# ------------------------------------------------------------------------------


# 11. Predicted Y for test set ---------------------------------------------------
Y_hat <- predict(final_model, newdata = test)
# ------------------------------------------------------------------------------


# 12. Saved predictions ----------------------------------------------------------
write.csv(data.frame(Y = Y_hat), "0097921_prediction.csv", row.names = FALSE)
cat("Prediction file created: 0097921_prediction.csv\n")
# ------------------------------------------------------------------------------ 

