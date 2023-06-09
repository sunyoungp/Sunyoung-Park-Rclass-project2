###############################
# processing script
#
#this script loads the raw data, processes and cleans it 
#and saves it as Rds file in the Processed_data folder
#
# Note the ## ---- name ---- notation
# This is called "code chunk labels" and is done so one can 
# pull in the chunks of code into the Quarto document
# see here: https://bookdown.org/yihui/rmarkdown-cookbook/read-chunk.html
#
# We are also using some tidyverse packages to do the 
# same base R operations weʻve been learning (dplyr, tidyr, skimr)

## ---- packages --------
#load needed packages. make sure they are installed.
require(dplyr) #for data processing/cleaning
require(tidyr) #for data processing/cleaning
require(skimr) #for nice visualization of data 


## ---- loaddata1.1 --------
data_location <- "../../Data/Raw_data/penguins_raw_dirty.csv"
data_path <- "../../Data/Raw_data/"

## ---- loaddata1.2 --------
rawdata <- read.csv(data_location, check.names=FALSE)

## ---- loaddata1.3 --------
dictionary <- read.csv(paste(data_path, "datadictionary.csv", sep=""))
print(dictionary)


## ---- exploredata --------

#take a look at the data
dplyr::glimpse(rawdata)

#another way to summarize the data
summary(rawdata)

#yet another way to get an idea of the data
head(rawdata)

#this is a nice way to look at data
skimr::skim(rawdata)
 
## ---- exploredata2 --------

longnames <- names(rawdata)
names(rawdata) <- c("study_name", "sn", "species", "region", "island", "stage", "id", "clutch_completion", "egg", "culmen_length", "culmen_depth", "flipper_length", "body_mass", "sex", "delta15n", "delta13c", "comment")


## ---- cleandata1.1 --------

#check skimr or 
unique(rawdata$species)

# Letʻs save rawdata as d1, and modify d1 so we can compare versions. 

d1 <- rawdata

## ---- cleandata1.2 -------- 

ii <- grep("PengTin", d1$species)
d1$species[ii] <- "Adelie Penguin (Pygoscelis adeliae)"

#Another way:

d1$species <- sub("gTin", "guin", d1$species)

#fix rest of the typos
d1$species <- sub("gufn", "guin", d1$species)
d1$species <- sub("PeO", "Pen", d1$species)
d1$species <- sub("eMPen", "e Pen", d1$species)
d1$species <- sub("Ven", "Gen", d1$species)
d1$species <- sub("Kie", "lie", d1$species)

# look at partially fixed data again
unique(d1$species)

# check that there's only three species instead of 9.
skimr::skim(d1)

## ---- cleandata1.3 -------- 

ii <- grep("(Pygoscelis adeliae)", d1$species)
d1$species[ii] <- "Adelie"

ii <- grep("(Pygoscelis papua)", d1$species)
d1$species[ii] <- "Gentoo"

ii <- grep("(Pygoscelis antarctica)", d1$species)
d1$species[ii] <- "Chinstrap"

unique(d1$species)

## ---- cleandata2 --------

# temporarily change the culmen length variable to 'cl'
cl <- d1$culmen_length 

#find "missing" and replace it with NA
cl[ cl == "missing" ] <- NA
#coerce to numeric
cl <- as.numeric(cl)  
d1$culmen_length <- cl

# look at partially fixed data again
skimr::skim(d1)

# check the histogram to make sure the data seems reasonable.
hist(d1$culmen_length)

# check with a bivariate plot with mass.
plot(d1$body_mass, d1$culmen_length)


## ---- cleandata3.1 --------

d2 <- d1 
cl[ cl > 300 ] 


## ---- cleandata3.2 --------
cl[ !is.na(cl) & cl>300 ]
cl[ !is.na(cl) & cl>300 ] <- cl[ !is.na(cl) & cl>300 ]/10  
d2$culmen_length <- cl

skimr::skim(d2)
hist(d2$culmen_length)

plot(d2$body_mass, d2$culmen_length)


## ---- cleandata4.1 --------
hist(d2$body_mass)


## ---- cleandata4.2 --------
d3 <- d2
mm <- d3$body_mass

# replace tiny masses with NA
mm[ mm < 100 ] <- NA       

# find which rows have NA for mass
nas <- which( is.na(mm) )

# drop the penguins (rows) with missing masses
d3 <- d3[ -nas, ]

skimr::skim(d3)
hist(d3$body_mass)
plot(d3$body_mass, d3$culmen_length)


## ---- cleandata5 --------

d3$species <- as.factor(d3$species)
d3$sex <- as.factor(d3$sex)
d3$island <- as.factor(d3$island)  
skimr::skim(d3)


## ---- bivariateplots --------
# bivariate plots of each numeric variable with mass to ensure there are no further
# errors.:

plot(d3$body_mass, d3$culmen_length, xlab="Body Mass (g)", ylab="Culmen Length (mm)")
plot(d3$body_mass, d3$culmen_depth, xlab="Body Mass (g)", ylab="Culmen Depth (mm)")
plot(d3$body_mass, d3$flipper_length, xlab="Body Mass (g)", ylab="Flipper Length (mm)")
plot(d3$body_mass, d3$delta15n, xlab="Body Mass (g)", ylab="Delta 15 N")
plot(d3$body_mass, d3$delta13c, xlab="Body Mass (g)", ylab="Delta 13 C")

## ---- histograms --------

# We will not subset by region, stage as they have only 1 value
# nor eggdate and sample number which have many values

require(ggplot2)
hist(d3$body_mass)   #a single histogram of mass
d3 %>%   # mass histogram by species

    ggplot( aes(x= body_mass)) + 

   geom_histogram( aes(fill=species), alpha=.5) 

d3 %>%    # mass density by species

    ggplot( aes(x= body_mass)) + 

   geom_density( aes(fill=species), alpha=.5) 

d3 %>%    # by island

    ggplot( aes(x= body_mass)) + 

    geom_histogram( aes(fill=island), alpha=.5)  

d3 %>% 

    ggplot( aes(x= body_mass)) + 

    geom_density( aes(fill=island), alpha=.5)
    
d3 %>%   # by clutch completion

    ggplot( aes(x= body_mass)) + 

    geom_histogram( aes(fill=clutch_completion), alpha=.5)  

d3 %>% 

    ggplot( aes(x= body_mass)) + 

    geom_density( aes(fill= clutch_completion), alpha=.5) 

d3 %>% # by sex

    ggplot( aes(x= body_mass)) + 

    geom_histogram( aes(fill=sex), alpha=.5)   



d3 %>% 

    ggplot( aes(x= body_mass)) + 

    geom_density( aes(fill=sex), alpha=.5)   

## ---- finalizedata --------

d3 <- d3 %>% select(-c('study_name', 'id', 'sn')) 
skimr::skim(d3)


## ---- savedata --------
processeddata <- d3      # clean data


## ---- savedata2 --------

save_data_location <- "../../Data/Processed_data/processeddata.rds"
saveRDS(processeddata, file = save_data_location)

save_data_location_csv <- "../../Data/Processed_data/processeddata.csv"
write.csv(processeddata, file = save_data_location_csv, row.names=FALSE)


