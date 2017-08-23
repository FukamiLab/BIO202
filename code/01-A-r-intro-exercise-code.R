# Example code for Introduction to R exercise
# Author: Jes Coyle
# Date: Aug. 23, 2017
# Description: Downloads an example data file from the course website and reads it into R.

###################################
## Download data and read into R ##

# Check whether a folder named data exists in the current working directory
if(dir.exists("data")) {
  
  # If it already exists, do nothing.

} else {
  
  # If it doesn't exits, make a new folder named code
  dir.create("data")
  
}

# Download file from course website to the data folder
# This file contains data on trees sampled by the winter 2017 BIO46 class.
download.file(url = "https://raw.githubusercontent.com/FukamiLab/BIO202/master/data/BIO46_W2017_trees.csv",
              destfile = "data/BIO46_W2017_trees.csv",
              method = "auto"
)

# Read downloaded file into a dataframe called raw_data
raw_data <- read.csv("data/BIO46_W2017_trees.csv")

# Print the content of raw_data to the console
raw_data

##################
## Examine Data ##

# View summary statistics for each column in raw_data
summary(raw_data)

# Count the number of rows in raw_data (e.g. the number of trees)
nrow(raw_data)

# Calulate the mean latitude across all trees
mean(raw_data$Lat)

# Count the number of times each tree species occurs in the Genus_species column of raw_data
table(raw_data$Genus_species)

