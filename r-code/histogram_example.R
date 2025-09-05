# Coded by Rao
# This script creates a histogram using R's built-in mtcars dataset

# Loading the built-in mtcars dataset
data(mtcars)

# Creating a simple histogram of miles per gallon
hist(mtcars$mpg,
     main = "Histogram of Miles Per Gallon",
     xlab = "Miles Per Gallon",
     ylab = "Frequency",
     col = "lightblue",
     border = "black"
)

# Adding some basic statistics to the plot
abline(v = mean(mtcars$mpg), col = "red", lwd = 2, lty = 2)
legend("topright",
     legend = paste("Mean =", round(mean(mtcars$mpg), 2)),
     col = "red", lty = 2, lwd = 2
)
