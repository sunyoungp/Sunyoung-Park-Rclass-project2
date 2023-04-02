# Code Folder

## Code Location:

This directory contains `.R` or `.qmd` scripts in the folders as appropriate:

- Processing_code cleans raw data and converts to processed data
- Analysis_code performs analyses on cleaned data. 


## Code Design:

You can either have fewer large scripts, or multiple scripts that do only specific actions. Those can be R scripts or qmd files. In either case, document the scripts and what goes on in them so well that someone else (including future you) can easily figure out what is happening.

The scripts should load the appropriate data (e.g. raw or processed), perform actions, and save results (e.g. processed data, figures, computed values) in the appropriate folders. 

Be sure to use **relative paths** so that each script works from the working directory set to the folder that the script is in. 

## Code Documentation:

## **`Processingcode.R` - cleans raw data, outputs clean data**

**Inputs**

```{r}
reads in the following files from `../../Data/Raw_data/`
	`penguins_raw_dirty.csv` - The raw data
	`datadictionary.csv` - The data dictionary for the raw data
```

**Outputs**

```{r}
outputs to `../../Data/Processed_data/`
	`processeddata.rds` - clean data in rds (R) format
	`processeddata.csv` - clean data in .csv format
	`orig_names.rds` - short variable names associated with long original variable names in rds format
```

## **`Analysis_code.R` - cleans data, outputs exploratory and statistical analysis**

**Inputs**

```{r}
reads in the following files from `../../Data/Processed_data/`
	`processeddata.csv` - clean data in .csv format
	`processeddata.rds` - clean data in rds (R) format
```

**Outputs**
```{r}
outputs to `../../Results/`

`../../Results/Q1/` - results for question #1
	`culmenL_species_anova.rds` - culmen length by species ANOVA table in .rds (R) format
	`culmenL_species_bars.png` - culmen length by species in .png format
         `culmenL_species_density.png` - culmen length density by species plot in .png format

`../../Results/Q2/` - results for question #2
        `culmenL_sex_species_anova.rds` - culmen length by sex and species ANOVA table in .rds format
	`culmenL_species_sex_anova.rds` - culmen length by species and sex ANOVA table in .rds format
         `culmenL_species_sex_density.png` - culmen length density by species and sex plot in .png format

`../../Results/Q3/` - results for question #3
         `culmenL_island_species_anova.rds` - culmen length by island and species ANOVA table in .rds format
	`culmenL_species_island_anova.rds` - culmen length by species and island ANOVA table in .rds format
         `culmenL_species_island_density.png` - culmen length density by species and island plot in .png format

`../../Results/Q4/` - results for question #4
         `culmenL_mass_species_anova.rds` - culmen length by mass and species ANOVA table in .rds (R) format
	`culmenL_mass_species_plot.png` - culmen length by mass and species in .png format
```

