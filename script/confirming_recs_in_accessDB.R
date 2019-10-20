# The purpose of this code is to (double) check to make sure that all your files made it into the database.
# You will need to export you detections table from access to a csv and save it in the data folder of this project
# Then read in that file, and get all the rec names and make sure you check off that they are in the databae on 
# the Tracking_Filtered_Files2019.xls sheet located Z:\Shared\Projects\JSATS\DSP_Spring-Run Salmon\2019\DetectionFilter

library(tidyverse)

# replace the file below with whichever file you exported from the detections table from access
dets_access <- read_csv("data/t2019TagDetections_fromAccess_080719.csv") # this csv is just the tekno receivers and the 1 ats that had data

ids <- unique(dets_access$RecSN)
ids_ordered <- order(ids)
ids[ids_ordered]
length(ids)


# checking total records for each data dump into DB
sumCombo_HORflow<- read_csv("C:/Users/chause/Documents/2019Filtering/2019FILTERED/Tekno/accepted/combined_files/SUMcombo_HORflow.csv")
sumComb_SJ <- read_csv("C:/Users/chause/Documents/2019Filtering/2019FILTERED/Tekno/accepted/combined_files/SUMcombo_SJ.csv")
jp2 <- read_csv("C:/Users/chause/Documents/2019Filtering/2019FILTERED/Tekno/accepted/combined_files/0001_2017-6055_accepted.csv")

