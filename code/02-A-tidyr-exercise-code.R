# Code for the Introduction to ggplot2 and dplyr exercise
# Author: Jes Coyle
# Date: Sept. 13, 2017
# Description: Downloads an example data file from the course website and reads it into R.
#              Manipulates the data using dplyr functions.
#              Comments are intentionally missing and should be filled in by student as a part of the exercise.

######################################
## Download data and read into R    ##

# Check whether a folder named data exists in the current working directory
if(dir.exists("data")) {
  
  # If it already exists, do nothing.

} else {
  
  # If it doesn't exits, make a new folder named data
  dir.create("data")
  
}

# Download file from course website to the data folder
# This file contains data on trees sampled by the winter 2017 BIO46 class.
download.file(url = "https://raw.githubusercontent.com/FukamiLab/BIO202/master/data/BIO46_W2017_trees.csv",
              destfile = "data/BIO46_W2017_trees.csv",
              method = "auto"
)
# This file contains data on lichen sampled by the winter 2017 BIO46 class.
download.file(url = "https://raw.githubusercontent.com/FukamiLab/BIO202/master/data/BIO46_W2017_lichen.csv",
              destfile = "data/BIO46_W2017_trees.csv",
              method = "auto"
)
# This file contains data on algal haplpotypes sampled by the winter 2017 BIO46 class.
download.file(url = "https://raw.githubusercontent.com/FukamiLab/BIO202/master/data/BIO46_W2017_algae.csv",
              destfile = "data/BIO46_W2017_trees.csv",
              method = "auto"
)

# Read downloaded file into dataframes
trees_raw <- read.csv("data/BIO46_W2017_trees.csv")
lichens_raw <- read.csv("data/BIO46_W2017_lichens.csv")
algae_raw <- read.csv("data/BIO46_W2017_algae.csv")



######################################
## Examine data with dplyr          ##


library(dplyr)


algae <- lichens_raw %>% 
         select(LichenID, TreeID) %>%
         right_join(algae_raw)



spread

gather

filter

unite

mutate

group_by

summarise













