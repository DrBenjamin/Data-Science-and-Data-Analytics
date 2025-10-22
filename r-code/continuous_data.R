# Loading the dplyr library for data manipulation
install.packages(dplyr)
library(tidyverse)

# Assigning continuous data to a data frame and displaying it as a table
continuous_data <- data.frame(
  Height = c(170, 165, 180, 175, 160, 175, 175, 168, 175, 182),
  Weight = c(70, 60, 80, 75, 55, 90, 68, 62, 78, 85)
)

# Displaying the original data as a table
print(continuous_data)

# Ordering the data frame by Height_cm in ascending order
ordered_data <- continuous_data %>%
  arrange(desc(Height), Weight) %>%
  count(Height)

# Displaying the ordered data frame
print(ordered_data)
