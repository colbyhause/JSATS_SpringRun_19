# This is code to make new R dataframe and csvs of detection data. As of 8/13/19, this detectiondata includes detectionsup to JP, 
# I still need to get estuary data from arnold

library(tidyverse)
library(lubridate)
library(tibble)

# read in detection file, all groups
dets_raw <- read_csv("data/2019Detections_uptoJP.csv") # 3609774 records

# change TagID_Hex to Hex because most of the coding uses Hex
colnames(dets_raw)[3] <- "Hex"

# Remove Receiver 2016-6002. This was a real time at Hills RT site but the clock was messed up during deployment and then it died 
# being able to screen shot the clock. It was determined that the clock was off during deployment because this receiver was detecting fish
# sometimes at the exact second that the hills 1 and 2 receivers were detecting the same fish, which is impossible. Also this
# receiver has issues and needed to be updated (which also updated the clocks), but it never had one. Removing it from the whole dataset
# is best.

r20166002 <-dets_raw[dets_raw$RecSN == "2016-6002", ] # 417 records
dets <- dets_raw[!dets_raw$RecSN == "2016-6002", ] # 3609357 records , meaning it removed the 417 we wanted it to

# change DetectDateTime to dtf (dtf is used in most of the coding from here on out...):
colnames(dets)[2] <- ("dtf") 

#make dtf column adate time format
class(dets$dtf)
dets_ds$dtf <- mdy_hms(dets_ds$dtf)
class(dets$dtf) # double check that it changed to PosixCT

# split into upstream and downstream groups:
dets_up<- dets[dets$Rel_group == "2019UP", ]
dets_ds<- dets[dets$Rel_group == "2019DS", ]


# Save as rds's and csv's:
write_csv(dets, "data_output/DetectionFiles/dets_allgroups.csv" )

write_csv(dets_up, "data_output/DetectionFiles/upper_dets_raw.csv")
write_csv(dets_up, "data_output/DetectionFiles/delta_dets_raw.csv")

write_rds(dets_up, "data_output/DetectionFiles/upper_dets_raw.rds")
write_rds(dets_ds, "data_output/DetectionFiles/delta_dets_raw.rds")

# To run Transit rate code, your detection csv's need to include the release point as a "detection":
# Make these csvs by pulling info from the tagging form in the access database:
upstream_rel_detection <- read_csv("data/UpstreamRelGroup_toBind.csv")
delta_rel_detection <- read_csv("data/DeltaRelGroup_toBind.csv")

# make sure dtf col is in datetime format:
class(upstream_rel_detection$dtf)
class(delta_rel_detection$dtf)
upstream_rel_detection$dtf <- mdy_hms(upstream_rel_detection$dtf)
delta_rel_detection$dtf <- mdy_hms(delta_rel_detection$dtf)
class(upstream_rel_detection$dtf)
class(delta_rel_detection$dtf)

#read in your detection csvs:
dets_up_forModel <- read_csv("data_output/DetectionFiles/dets_up_forModel.csv")
dets_ds_forModel <- read_csv("data_output/DetectionFiles/dets_ds_forModel.csv")

dets_up_PF16_Modeledited__reldet <- rbind(dets_up_forModel, upstream_rel_detection)
tail(dets_up_PF16_Modeledited__reldet) #check that it binded
dets_ds_PF16_Modeledited__reldet <- rbind(dets_ds_forModel, delta_rel_detection)
tail(dets_ds_PF16_Modeledited__reldet) #check that it binded

#save the files:
write_csv(dets_up_PF16_Modeledited__reldet, "data_output/DetectionFiles/det_up_PF16_ModelEdited_relLoc.csv")
write_csv(dets_ds_PF16_Modeledited__reldet, "data_output/DetectionFiles/det_ds_PF16_ModelEdited_relLoc.csv")



###############################################################################################################################
# Running through the above steps but with detection files that include Chipps and GG Data
# Tue Sep 17 11:11:47 2019 ------------------------------

library(tidyverse)
library(lubridate)

# read in detection file, all groups
dets_raw <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/2019_UCDdets_GG_Chipps_AllGroups_RAW.csv") 

# change TagID_Hex to Hex because most of the coding uses Hex
colnames(dets_raw)[3] <- "Hex"

# Remove Receiver 2016-6002. This was a real time at Hills RT site but the clock was messed up during deployment and then it died 
# being able to screen shot the clock. It was determined that the clock was off during deployment because this receiver was detecting fish
# sometimes at the exact second that the hills 1 and 2 receivers were detecting the same fish, which is impossible. Also this
# receiver has issues and needed to be updated (which also updated the clocks), but it never had one. Removing it from the whole dataset
# is best.

r20166002 <-dets_raw[dets_raw$RecSN == "2016-6002", ] # 417 records
dets <- dets_raw[!dets_raw$RecSN == "2016-6002", ] # 3609357 records , meaning it removed the 417 we wanted it to

# change DetectDateTime to dtf (dtf is used in most of the coding from here on out...):
colnames(dets)[2] <- ("dtf") 

#make dtf column adate time format
class(dets$dtf)
dets$dtf <- mdy_hms(dets$dtf)
class(dets$dtf) # double check that it changed to PosixCT

# split into upstream and downstream groups:
dets_up<- dets[dets$Rel_group == "2019UP", ]
dets_ds<- dets[dets$Rel_group == "2019DS", ]


# Save as rds's and csv's:
write_csv(dets, "data_output/DetectionFiles/Files_w_Bridge_Data/2019_UCDdets_GG_Chipps_AllGroups_formatted.csv" )

write_csv(dets_up, "data_output/DetectionFiles/Files_w_Bridge_Data/upper_UCDdets_GG_Chipps_formatted.csv")
write_csv(dets_up, "data_output/DetectionFiles/Files_w_Bridge_Data/delta_UCDdets_GG_Chipps_formatted.csv")


# To run Transit rate code, your detection csv's need to include the release point as a "detection":
# Make these csvs by pulling info from the tagging form in the access database:
upstream_rel_detection <- read_csv("data/UpstreamRelGroup_toBind.csv")
delta_rel_detection <- read_csv("data/DeltaRelGroup_toBind.csv")

# make sure dtf col is in datetime format:
class(upstream_rel_detection$dtf)
class(delta_rel_detection$dtf)
upstream_rel_detection$dtf <- mdy_hm(upstream_rel_detection$dtf)
delta_rel_detection$dtf <- mdy_hm(delta_rel_detection$dtf)
class(upstream_rel_detection$dtf)
class(delta_rel_detection$dtf)

#read in your detection csvs:
dets_up_forModel <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/dets_up_formodel_w_GG_Chips_092419.csv")
dets_ds_forModel <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/dets_ds_formodel_w_GG_Chips_092419.csv")

dets_up_PF16_Modeledited__reldet <- rbind(dets_up_forModel, upstream_rel_detection)
tail(dets_up_PF16_Modeledited__reldet) #check that it binded
nrow(dets_up_PF16_Modeledited__reldet)
dets_ds_PF16_Modeledited__reldet <- rbind(dets_ds_forModel, delta_rel_detection)
tail(dets_ds_PF16_Modeledited__reldet) #check that it binded
nrow(dets_ds_PF16_Modeledited__reldet)

#save the files:
write_csv(dets_up_PF16_Modeledited__reldet, "data_output/DetectionFiles/Files_w_Bridge_Data/dets_up_PF16_ModelEdited_relLoc_GG_chipps_092419.csv") # this file is unchanged, the same as dets_up_PF16_ModelEdited_relLoc_GG_chipps_092319.csv 
write_csv(dets_ds_PF16_Modeledited__reldet, "data_output/DetectionFiles/Files_w_Bridge_Data/dets_ds_PF16_ModelEdited_relLoc_GG_Chipps_092419.csv")
