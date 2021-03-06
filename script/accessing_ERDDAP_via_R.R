
## Prepared by Cyril Michel on 2019-07-10; cyril.michel@noaa.gov

#################################################################
#### HOW TO PULL IN REAL-TIME FISH DETECTION DATA INTO R ########
#################################################################

## install and load the 'rerddap' library
library(rerddap)

## Find out details on the database
db <- info('FEDcalFishTrack', url = "http://oceanview.pfeg.noaa.gov/erddap/")
## This will tell you columns and their data types in database
db$variables
## This will tell you unique StudyID names
as.data.frame(tabledap('FEDcalFishTrack', url = "http://oceanview.pfeg.noaa.gov/erddap/", fields = c("Study_ID"), distinct = T))


cache_delete(dat) # run this code to clear the cache if pulling new data in 

## Download all data (will take a little while, large database).
dat <- tabledap('FEDcalFishTrack', url = "http://oceanview.pfeg.noaa.gov/erddap/")
## ALTERNATIVELY, download only the data you need, see following code snippets

## Download only data from 1 studyID, here for example, Juv_Green_Sturgeon_2018 study
dat <- tabledap('FEDcalFishTrack', url = "http://oceanview.pfeg.noaa.gov/erddap/", 'Study_ID="Juv_Green_Sturgeon_2018"')

dat <- tabledap('FEDcalFishTrack', url = "http://oceanview.pfeg.noaa.gov/erddap/", 'Study_ID="SCARF_San_Joaquin_Spring_run_2019"')
write.csv(dat, "data/Data_from_erdapp.csv")

## Download only data from 1 receiver location
dat <- tabledap('FEDcalFishTrack', url = "http://oceanview.pfeg.noaa.gov/erddap/", 'general_location="MiddleRiver"')

## Download only data from a specific time range (in UTC time)
dat <- tabledap('FEDcalFishTrack', url = "http://oceanview.pfeg.noaa.gov/erddap/", 'time>=2019-01-01', 'time<=2019-01-10')

## Download data from a combination of conditions. For example, Study_ID="MillCk_SH_Wild_S2019" and general_location="ButteBr_RT"
dat <- tabledap('FEDcalFishTrack', url = "http://oceanview.pfeg.noaa.gov/erddap/", 'Study_ID="MillCk_SH_Wild_S2019"', 'general_location="ButteBrRT"')

## Download only specific columns for a studyID (or a general location, time frame or other constraint)
dat <- tabledap('FEDcalFishTrack', url = "http://oceanview.pfeg.noaa.gov/erddap/", 'general_location="MiddleRiver"', fields = c("TagCode","Study_ID"))

## Finally, download a summary of unique records. Say for example you want to know the unique TagCodes detected in the array from a studyID
dat <- tabledap('FEDcalFishTrack', url = "http://oceanview.pfeg.noaa.gov/erddap/", 'Study_ID="DeerCk_SH_Wild_S2019"', fields = c("TagCode"), distinct = T)

## Or, number of unique fish detected at each receiver location for a studyID
dat <- tabledap('FEDcalFishTrack', url = "http://oceanview.pfeg.noaa.gov/erddap/", 'Study_ID="DeerCk_SH_Wild_S2019"', fields = c("general_location","TagCode"), distinct = T)

## PLEASE NOTE: IF A DATA REQUEST ABOVE RETURNS SIMPLY "Error: ", THIS LIKELY MEANS THE DATA REQUEST CAME UP WITH ZERO RETURNS
