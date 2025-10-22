# Loading the dplyr library for data manipulation
library(dplyr)

# Assigning hierarchical data to a data frame and displaying it as a table
hierarchical_data <- data.frame(
  Country = c("USA", "Canada" , "USA", "Canada", "Mexico"),
  State_Province = c("California", "Ontario", "Texas", "Quebec", "Jalisco"),
  Population_Millions = c(39.5, 14.5, 29.0, 8.5, 8.3)
)

# Displaying the table
print(hierarchical_data)

# Ordering the data frame by Country and then State_Province
hierarchical_data_arrenged <- hierarchical_data %>% 
  arrange(Country, desc(State_Province))

# Displaying the ordered data frame
print(hierarchical_data)

hierarchical_data_grouped <- hierarchical_data %>% 
  group_by(Country) %>%
  summarise(Total_Population = sum(Population_Millions))
print(hierarchical_data_grouped)
