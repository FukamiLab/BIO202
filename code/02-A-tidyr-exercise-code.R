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
download.file(url = "https://raw.githubusercontent.com/FukamiLab/BIO202/master/data/BIO46_W2017_lichens.csv",
              destfile = "data/BIO46_W2017_lichens.csv",
              method = "auto"
)
# This file contains data on algal haplpotypes sampled by the winter 2017 BIO46 class.
download.file(url = "https://raw.githubusercontent.com/FukamiLab/BIO202/master/data/BIO46_W2017_algae.csv",
              destfile = "data/BIO46_W2017_algae.csv",
              method = "auto"
)


# Read downloaded file into dataframes
trees_raw <- read.csv("data/BIO46_W2017_trees.csv")
lichens_raw <- read.csv("data/BIO46_W2017_lichens.csv")
algae_raw <- read.csv("data/BIO46_W2017_algae.csv")



######################################
## Examine data with dplyr          ##


library(dplyr)
library(tidyr)
library(ggplot2)

# Open vingnette on join functions that merge two tables
vignette("two-table", package = "dplyr")

# Add LichenID and TreeID columns to algae data

algae <- lichens_raw %>% 
  select(LichenID, TreeID) %>%
  right_join(algae_raw)

# Add column that tells if sequencing was a success or failure and give NA if not sequenced.

algae <- algae %>%
  mutate(Seq_success = GenotypeID != '',
         GenotypeID = ifelse(Seq_success, as.character(GenotypeID), NA))

# make a table about algal data for each lichen sampled, including no. of successful sequences,
# no. of genotypes, find no. of singletons and doubletons so chao1 can be caluculated, and chao 1 index

# try table(algae$GenotypeID)

lichen <- algae %>%
  group_by(LichenID) %>%
  summarise(Num_seqs = sum(Seq_success),
            Num_genotypes = n_distinct(GenotypeID, na.rm = TRUE),
            f1 = sum(table(GenotypeID) == 1),
            f2 = sum(table(GenotypeID) == 2),
            Chao1 = Num_genotypes + f1*(f1-1)/(2*(f2+1)))

# Add all tree info to lichen data

lichen <- lichen %>%
  left_join(lichens_raw) %>%
  left_join(trees_raw, by = 'TreeID', suffix = c(".lichen", ".tree"))

# make a data table that shows how many of which algal genotype was found in which lichen

lichenXgeno_long <- algae %>%
  filter(Seq_success == TRUE) %>%
  group_by(LichenID) %>%
  count(GenotypeID) 

# Use lichenXgeno_long to make a lichen x algal genotype matrix

lichenXgeno <- lichenXgeno_long %>%
  spread(key = GenotypeID, value = n)

##########################################################################################
#      Doing the "Plotting data with ggplot2" exercise from the class web site           #

# Exercise 1

qplot(Lon, Lat, colour = Chao1, data = lichen)

ggplot(lichen, aes(Lon, Lat, colour = Chao1)) +
 geom_point() 

# Exercise 2 (plot for each of the three tree species)

ggplot(lichen, aes(Lon, Lat, colour = Chao1)) +
  geom_point() +
  facet_grid(~ Genus_species.tree)

ggplot(lichen, aes(Lon, Lat, colour = Chao1)) +
  geom_point() +
  facet_wrap(~ Genus_species.tree)












