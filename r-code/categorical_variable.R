library(tidyverse)

ordinal_var <- c("Medium", "High", "Low", "Very High")
categorical_var <- c("female", "male", "divers")

print(ordinal_var)

ordered_ordinal <- ordinal_var %>%
  factor(levels = c("Low", "Medium", "High", "Very High"), ordered = TRUE)

print(ordered_ordinal)

# Assigning ordinal data to a data frame and displaying it as a table
ordinal_data <- data.frame(
  Response = c("Strongly Disagree", "Disagree", "Neutral", "Agree", "Strongly Agree"),
  Value = c(5, 4, 3, 2, 1)
)

ordered_ordinal_2 <- ordinal_data %>%
  arrange(Value)
