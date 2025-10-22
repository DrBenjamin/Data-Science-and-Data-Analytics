# OECD Preventable Deaths Analysis
# Author: Data Science Course
# Date: 2025-10-22
# Description: Comprehensive analysis of preventable mortality data from OECD countries

# Loading required libraries
library(tidyverse)
library(lubridate)
library(scales)
library(ggplot2)
library(dplyr)
library(tidyr)


# Setting working directory to project root
setwd("/Users/ben/Documents/Studies/International Business Management (B. A.)/Data Science and Data Analytics/Projects/Data-Science-and-Data-Analytics")

# Reading the dataset
preventable_deaths <- read.csv("data/OECD_Preventable_Deaths.csv", 
                                stringsAsFactors = FALSE)

# ============================================================================
# 1. DATA EXPLORATION
# ============================================================================

# Viewing structure of the dataset
str(preventable_deaths)

# Viewing first few rows
head(preventable_deaths)

# Checking dimensions
dim(preventable_deaths)

# Viewing column names
colnames(preventable_deaths)

# Summary statistics
summary(preventable_deaths)

# Checking for missing values
colSums(is.na(preventable_deaths))


# ============================================================================
# 2. DATA CLEANING & PREPARATION
# ============================================================================

# Selecting relevant columns for analysis
df_clean <- preventable_deaths %>%
  select(REF_AREA, Reference.area, TIME_PERIOD, OBS_VALUE, 
         MEASURE, Measure, UNIT_MEASURE, Unit.of.measure,
         SEX, Sex, AGE, Age) %>%
  rename(
    country_code = REF_AREA,
    country = Reference.area,
    year = TIME_PERIOD,
    death_rate = OBS_VALUE,
    measure_type = Measure,
    sex = Sex,
    age_group = Age
  )

# Converting year to numeric
df_clean$year <- as.numeric(df_clean$year)

# Converting death_rate to numeric (handling empty strings)
df_clean$death_rate <- as.numeric(df_clean$death_rate)

# Removing rows with missing death rates
df_clean <- df_clean %>%
  filter(!is.na(death_rate))

# Viewing cleaned data structure
str(df_clean)

# Summary of cleaned data
summary(df_clean)


# ============================================================================
# 3. DESCRIPTIVE STATISTICS
# ============================================================================

# Overall statistics
cat("\n=== OVERALL STATISTICS ===\n")
cat("Mean death rate:", mean(df_clean$death_rate, na.rm = TRUE), "\n")
cat("Median death rate:", median(df_clean$death_rate, na.rm = TRUE), "\n")
cat("Standard deviation:", sd(df_clean$death_rate, na.rm = TRUE), "\n")
cat("Min death rate:", min(df_clean$death_rate, na.rm = TRUE), "\n")
cat("Max death rate:", max(df_clean$death_rate, na.rm = TRUE), "\n")

# Statistics by country
country_stats <- df_clean %>%
  group_by(country) %>%
  summarise(
    mean_rate = mean(death_rate, na.rm = TRUE),
    median_rate = median(death_rate, na.rm = TRUE),
    sd_rate = sd(death_rate, na.rm = TRUE),
    min_rate = min(death_rate, na.rm = TRUE),
    max_rate = max(death_rate, na.rm = TRUE),
    n_observations = n()
  ) %>%
  arrange(desc(mean_rate))

print(country_stats)

# Statistics by year
year_stats <- df_clean %>%
  group_by(year) %>%
  summarise(
    mean_rate = mean(death_rate, na.rm = TRUE),
    median_rate = median(death_rate, na.rm = TRUE),
    n_countries = n_distinct(country)
  ) %>%
  arrange(year)

print(year_stats)


# ============================================================================
# 4. VISUALIZATIONS
# ============================================================================

# Creating plots directory if it doesn't exist
if (!dir.exists("plots")) {
  dir.create("plots")
}

# Plot 1: Time series of average preventable death rates
p1 <- ggplot(year_stats, aes(x = year, y = mean_rate)) +
  geom_line(color = "#2C3E50", size = 1.2) +
  geom_point(color = "#E74C3C", size = 3) +
  labs(
    title = "Average Preventable Death Rates Over Time (OECD Countries)",
    subtitle = "Standardized rates per 100,000 inhabitants",
    x = "Year",
    y = "Average Death Rate",
    caption = "Source: OECD Health Statistics"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 11, color = "gray30"),
    axis.title = element_text(face = "bold")
  )

print(p1)
ggsave("plots/preventable_deaths_time_series.png", p1, width = 10, height = 6, dpi = 300)


# Plot 2: Country comparison (latest year available)
latest_year_data <- df_clean %>%
  group_by(country) %>%
  filter(year == max(year)) %>%
  ungroup() %>%
  arrange(desc(death_rate))

p2 <- ggplot(latest_year_data, aes(x = reorder(country, death_rate), y = death_rate)) +
  geom_col(fill = "#3498DB") +
  coord_flip() +
  labs(
    title = "Preventable Death Rates by Country",
    subtitle = paste("Latest available year for each country"),
    x = "Country",
    y = "Death Rate per 100,000",
    caption = "Source: OECD Health Statistics"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.title = element_text(face = "bold")
  )

print(p2)
ggsave("plots/preventable_deaths_by_country.png", p2, width = 10, height = 12, dpi = 300)


# Plot 3: Top 10 countries trend over time
top_10_countries <- country_stats %>%
  top_n(10, mean_rate) %>%
  pull(country)

df_top10 <- df_clean %>%
  filter(country %in% top_10_countries)

p3 <- ggplot(df_top10, aes(x = year, y = death_rate, color = country, group = country)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  labs(
    title = "Trends in Top 10 Countries with Highest Average Preventable Death Rates",
    x = "Year",
    y = "Death Rate per 100,000",
    color = "Country",
    caption = "Source: OECD Health Statistics"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 12),
    legend.position = "right"
  )

print(p3)
ggsave("plots/top10_countries_trends.png", p3, width = 12, height = 7, dpi = 300)


# Plot 4: Distribution of death rates
p4 <- ggplot(df_clean, aes(x = death_rate)) +
  geom_histogram(bins = 30, fill = "#9B59B6", color = "white", alpha = 0.8) +
  labs(
    title = "Distribution of Preventable Death Rates",
    x = "Death Rate per 100,000",
    y = "Frequency",
    caption = "Source: OECD Health Statistics"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14)
  )

print(p4)
ggsave("plots/death_rate_distribution.png", p4, width = 10, height = 6, dpi = 300)


# Plot 5: Boxplot by year
p5 <- ggplot(df_clean, aes(x = factor(year), y = death_rate)) +
  geom_boxplot(fill = "#1ABC9C", alpha = 0.7) +
  labs(
    title = "Preventable Death Rates Distribution by Year",
    x = "Year",
    y = "Death Rate per 100,000",
    caption = "Source: OECD Health Statistics"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

print(p5)
ggsave("plots/death_rate_boxplot_by_year.png", p5, width = 12, height = 6, dpi = 300)


# ============================================================================
# 5. TREND ANALYSIS
# ============================================================================

# Calculating year-over-year change
yoy_change <- df_clean %>%
  arrange(country, year) %>%
  group_by(country) %>%
  mutate(
    rate_change = death_rate - lag(death_rate),
    pct_change = (death_rate - lag(death_rate)) / lag(death_rate) * 100
  ) %>%
  filter(!is.na(rate_change))

# Average change by country
avg_change_by_country <- yoy_change %>%
  group_by(country) %>%
  summarise(
    avg_annual_change = mean(rate_change, na.rm = TRUE),
    avg_pct_change = mean(pct_change, na.rm = TRUE)
  ) %>%
  arrange(avg_annual_change)

print(avg_change_by_country)

# Countries with improving vs worsening trends
improving_countries <- avg_change_by_country %>%
  filter(avg_annual_change < 0) %>%
  arrange(avg_annual_change)

worsening_countries <- avg_change_by_country %>%
  filter(avg_annual_change > 0) %>%
  arrange(desc(avg_annual_change))

cat("\n=== COUNTRIES WITH IMPROVING TRENDS ===\n")
print(improving_countries)

cat("\n=== COUNTRIES WITH WORSENING TRENDS ===\n")
print(worsening_countries)


# ============================================================================
# 6. STATISTICAL TESTING
# ============================================================================

# Testing if there's a significant difference between first and last available years
first_last_comparison <- df_clean %>%
  group_by(country) %>%
  filter(year == min(year) | year == max(year)) %>%
  ungroup()

# ============================================================================
# 7. CORRELATION ANALYSIS
# ============================================================================

# Checking correlation between year and death rate by country
correlations <- df_clean %>%
  group_by(country) %>%
  filter(n() >= 3) %>%  # At least 3 observations
  summarise(
    correlation = cor(year, death_rate, use = "complete.obs"),
    n_years = n()
  ) %>%
  arrange(correlation)

cat("\n=== CORRELATION ANALYSIS ===\n")
print(correlations, n = 50)
