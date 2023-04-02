###############################
# Penguin analysis script
#
# This script loads the processed, cleaned data, 
# does a simple analysis and saves the results
# to the results folder
###############################

## ---- setup -----
# load needed packages. make sure they are installed.
require(ggplot2) #for plotting
require(lattice) # for plotting
require(magrittr) #for piping
require(knitr) #for formatting output


# path to data and results 
data_path <- "../../Data/Processed_data/"

results_path <- "../../Results/"
results_pathQ1 <- "../../Results/Q1/"
results_pathQ2 <- "../../Results/Q2/"
results_pathQ3 <- "../../Results/Q3/"
results_pathQ4 <- "../../Results/Q4/"

## ---- functions ----
# function to paste path to output filenames.

addpath <- function( filename, path=data_path ) {
    location <- paste( path, filename, sep="")
	return( location )
}

## ---- loaddata ----
# load data. 
dat <- readRDS( addpath("processeddata.rds", data_path) )


## ---- summarize ----
# create summary table of the data using skimr to use in paper.
# includes variables, sample size, mean, standard error.

sk <- skimr::skim(dat)  # save skim object
sk <- as.data.frame(sk) # save as data.frame
head(sk)  # see the variable names

nrows <- dim(dat)[1] # total number of rows
sk$N <- nrows - sk$n_missing  # sample size of each variable

## ---- summary.table ----
# select only the variable, N, mean, sd, and category counts

sk.table <- sk[c("skim_variable", "N", "numeric.mean", "numeric.sd", "factor.top_counts")]
names(sk.table) <- c("Variable", "N", "Mean", "SE", "Counts") # rename SD as SE
sk.table$SE <- sk.table$SE/sqrt(sk.table$N) # calculate SE

options(knitr.kable.NA = "")
knitr::kable(sk.table, digits=2)


# save summary table
saveRDS(sk.table, file = addpath("summary_table.rds", results_path))


## ---- header ----
######################################
# Data fitting/statistical analysis
######################################

############################
#### First model fit


# Q1: Do species differ in culmen length?


## ---- culmenL_species_boxplot ----

# plot to screen
with(dat, plot(culmen_length ~ species, xlab="Species", ylab="Culmen Length (mm)"))

# plot to .png file
png(filename = addpath("culmenL_species_bars.png", results_pathQ1))
 with(dat, plot(culmen_length ~ species, xlab="Species", ylab="Culmen Length (mm)"))
dev.off()


## ---- culmenL_species_density ----

# create plot and send to screen
p <- dat %>%    # culmen length density by species
       ggplot( aes(x=culmen_length)) + 
       geom_density( aes(fill=species), alpha=.5) +
        xlab("Culmen Length (mm)") + 
  ylab("Density") 
p

# save ggplot objects using `ggsave()` 
ggsave(filename = addpath("culmenL_species_density.png", results_pathQ1), plot=p) 


## ---- culmenL_species_aov ----
# fit linear model using culmen length as outcome, species as predictor

lm.fit.s <- lm(culmen_length ~ species, dat)  
anova.table.s <- anova(lm.fit.s)

# print to screen the anova table
print(anova.table.s)

# save anova table to file in Results folder  
saveRDS(anova.table.s, file = addpath("culmenL_species_anova.rds", results_pathQ1))




## ---- comment2 ----
############################
#### Second model fit


# Q2: Does sex have an affect on culmen length?


## ---- culmenL_species_sex_aov ----

# fit linear model using culmen length as outcome, species and sex as predictors

lm.fit.sx <- lm(culmen_length ~ species + sex, dat)  
anova.table.sx <- anova(lm.fit.sx)
print(anova.table.sx)
saveRDS(anova.table.sx, file = addpath("culmenL_species_sex_anova.rds", results_pathQ2))


## ---- culmenL_sex_species_aov ----

# fit linear model again, but fit sex first then species as predictors

lm.fit.xs <- lm(culmen_length ~ sex + species, dat)  
anova.table.xs <- anova(lm.fit.xs)
print(anova.table.xs)
saveRDS(anova.table.xs, file = addpath("culmenL_sex_species_anova.rds", results_pathQ2))


## ---- culmenL_species_sex_density ----

# create plot, subseted by species and faceted by sex

q <- dat %>%    # culmen lenth density by species
       ggplot( aes(x=culmen_length)) + 
       geom_density( aes(fill=c(species)), alpha=.5) +
       facet_grid(sex ~ .) +
       xlab("Culmen Length (mm)") + 
  ylab("Density") 

q

ggsave(filename = addpath("culmenL_species_sex_density.png", results_pathQ2), plot=q) 


## ---- comment3 ----
############################
#### Third model fit


# Q3: Does Island have an affect on culmen length?


## ---- culmenL_species_island_aov ----
# fit linear model using culmen length as outcome, species and island as predictors

lm.fit.si <- lm(culmen_length ~ species + island, dat)  
anova.table.si <- anova(lm.fit.si)
print(anova.table.si)

saveRDS(anova.table.si, file = addpath("culmenL_species_island_anova.rds", results_pathQ3))


## ---- culmenL_island_species_aov ----
# fit linear model using culmen length as outcome again, but fit island first then species as predictors

lm.fit.is <- lm(culmen_length ~ island + species, dat)  
anova.table.is <- anova(lm.fit.is)
print(anova.table.is)

saveRDS(anova.table.is, file = addpath("culmenL_island_species_anova.rds", results_pathQ3))


## ---- culmenL_species_island_density ----

# create plot, subseted by species and faceted by island

r <- dat %>%    # culmen lenth density by species
       ggplot( aes(x=culmen_length)) + 
       geom_density( aes(fill=c(species)), alpha=.5) +
       facet_grid(island ~ .) +
       xlab("Culmen Length (mm)") + 
  ylab("Density") 
r

ggsave(filename = addpath("culmenL_species_island_density.png", results_pathQ3), plot=r) 


## ---- comment4 ----
############################
#### Fourth model fit


# Q4: Do size and species have an effect on culmen length?


## ---- culmenL_mass_species_plot ----

xyplot(culmen_length ~ body_mass, data=dat, groups=species, type=c("p","r"), auto.key=TRUE, xlab="Body Mass (g)", ylab="Culmen Length (mm)")

png(filename = addpath("culmenL_mass_species_plot.png", results_pathQ4))
  with(dat, xyplot(culmen_length ~ body_mass, data=dat, groups=species, type=c("p","r"), auto.key=TRUE, xlab="Body Mass (g)", ylab="Culmen Length (mm)")
)
dev.off()


## ---- culmenL_mass_species_aov ----

# fit linear model using culmen length as outcome, species and body mass as predictors
# with interaction

lm.fit.cm <- lm(culmen_length ~ body_mass * species, data = dat) 
anova.table.cm <- anova(lm.fit.cm)
print(anova.table.cm)

saveRDS(anova.table.cm, file = addpath("culmenL_mass_species_anova.rds", results_pathQ4))

















