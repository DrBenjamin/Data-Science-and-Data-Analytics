# Installing devtools
install.packages("devtools")
library(devtools)

# Installing Github R package
install_github("DrBenjamin/ourdata", force = TRUE)

# Loading package
library(ourdata)

# Opening help of package
??ourdata

# Showing welcome message
ourdata()

# Printing some datasets
print(koelsch)
print(kirche)

# Using help function from the package for a specific function from the `ourdata` R package
help(combine)

# Using the `combine` function from the `ourdata` R package to combine two vectors into a data frame
combine(kirche$Jahr, koelsch$Jahr, kirche$Austritte, koelsch$Koelsch)
