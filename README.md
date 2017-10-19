# FDS-Ex4-CHIS
Springboard: Foundations of Data Science - Exercise 4 - Data Viz - CHIS.R

# Getting Started
This R code runs in RStudio using R version 3.4.1. You need the dplyr, ggplot2, reshape2 and ggthemes libraries installed. You need to download CHIS2009_reduced_2 (no file extension) which is used in the code. Save CHIS.R and CHIS2009_reduced_2 in the same folder and alter the environment working directory using setwd() to your location.

# Variables
The data is a subset of the California Health Information Survey (CHIS) which contains 436 variables across nearly 50,000 rows. For analysis, only ten variables have been taken and a small number of rows have been filtered to remove <5% of records based on those falling outside the four main ethnic groups. The variables retained are:
- RBMI: BMI Category description
- BMI_P: BMI value
- RACEHPR2: race
- SRSEX: sex
- SRAGE_P: age
- MARIT2: Marital status
- AB1: General Health Condition
- ASTCUR: Current Asthma Status
- AB51: Type I or Type II Diabetes
- POVLL: Poverty level

# Running the Code
Run CHIS.R line by line to see my work. The whole code (except setwd) can be sourced to see the mosaic plot output.

# Author
James Hooi
