# The goal of this code is to remove detections that do not fit with the modEL. 
# Unfortunately, this is mostly manual work
# An example could be back and forth movements bewteen two different
# sites. This codes allows you to mannually remove detections at specific sites
# Steps:
# 1.Make an empty csv with the same headers as the detections csvs. Put this in a folder in your data_outout folder
# 2.look up the tag ID using the fish check function, then save that tag's dtaframe as a csv
# 3. in that csv, copy the detections that you want to remove
# 4. place those detections in the csv that you made in step 1
# 5. rmove the dets that are in this csv (the one from step 1) from your overall detections file ( code for this is at the end of this script)

library(tidyverse)

# use the data that you ran through the 16km predator filter:
dets_pred_filtered<- read_csv("data_output/Predator_Filter/AllDets_PredFiltered_16.csv")
dets_up <- read_csv("data_output/Predator_Filter/UpperDets_PredFiltered_16.csv")
dets_ds <- read_csv("data_output/Predator_Filter/DeltaDets_PredFiltered_16.csv")

# Then run fish_check function (located: C:\Users\chause\Documents\GitHub\JSATS_SpringRun_19\script\rkm_plotcode_eachTag_GS.R)

# Next, for each tag that you made notes on that does fit the model, remove the detections that dont fit

# Upper Release Fish ----
fishcheck("BA72", dets_up, "figure_output/")
unique(tBA72$`GPS Names`) # want to remove MAC detections. Looked up the tide for this day and show that high tide was at 11:00 am, 
# which means that it is more plausible for the fish to have gone to Mac at 10:30, and to have been pushed by the tides back to TC 
# and then detected at TC by 13:30
length(tBA72$`GPS Names`[grepl(pattern = "MAC", x = tBA72$`GPS Names`)])
write_csv(tBA72, "data_output/Edited_TagDetHistories_forModel/tBA72.csv")

fishcheck("BB34", dets_up, "figure_output/")
write_csv(tBB34, "data_output/Edited_TagDetHistories_forModel/tBB34.csv") # removed from the second blw newman chunk to the end

fishcheck("BD6C", dets_up, "figure_output/")
write_csv(tBD6C, "data_output/Edited_TagDetHistories_forModel/tBD6C.csv") # Removed OR Hwy4 dets

fishcheck("BDAB", dets_up, "figure_output/") # issued remedied with pred filter

fishcheck("C24A", dets_up, "figure_output/") # issued remedied with pred filter ALSO REMOVED CHUNK OF HOR_SM1
write_csv(tC24A, "data_output/Edited_TagDetHistories_forModel/tC24A.csv")

fishcheck("C2AD", dets_up, "figure_output/")
write_csv(tC2AD, "data_output/Edited_TagDetHistories_forModel/tC2AD.csv") # removed from the second blw_newman chunk on down

fishcheck("C352", dets_up, "figure_output/")
write_csv(tC352, "data_output/Edited_TagDetHistories_forModel/tC352.csv") # removed from the second HOR_SM to the end.
# reason for this (instead of just removing the movement from howard back to HOR_SM is because a. thats a long
# distance to move upstream in a zone not tidally affected, and b. the fish was moving at 4.22 km per day up til Howard,
# and then from howard on it was moving 15 km/ day, so I think it was eaten at Howard, and the predator went back up
# to HOR, and then back down to MAC)

fishcheck("C455", dets_up, "figure_output/")
write_csv(tC455, "data_output/Edited_TagDetHistories_forModel/tC455.csv") # removed the OR_HOR between the HOR_SM

fishcheck("C514", dets_up, "figure_output/") # REMOVED EVERYTHING AFTER FIRST BLW NEWMAN
write_csv(tC514, "data_output/Edited_TagDetHistories_forModel/tC514.csv")

fishcheck("C5A4", dets_up, "figure_output/")
write_csv(tC5A4, "data_output/Edited_TagDetHistories_forModel/tC5A4.csv") # REMOVED THE HOR_SM BTWN SJ_HOR AND HOWARD

fishcheck("C8AB", dets_up, "figure_output/")
write_csv(tC8AB, "data_output/Edited_TagDetHistories_forModel/tC8AB.csv")# REMOVED THE SECOND CHUNK OF HOR_SM 

fishcheck("BA64", dets_edited_for_model, file_location = "figure_output/")
write_csv(tBA64, "data_output/Edited_TagDetHistories_forModel/tBA64.csv") # REMOVED SECOND CHUNK OF HOR_SM 

fishcheck("BAB8", dets_edited_for_model, file_location = "figure_output/") # REMOVED LAST CHUNK OF OR HWY4 DETS-- check on this one again 
# once you get data from arnold 
write_csv(tBAB8, "data_output/Edited_TagDetHistories_forModel/tBAB8.csv")

fishcheck("BB24", dets_edited_for_model, file_location = "figure_output/")
write_csv(tBB24, "data_output/Edited_TagDetHistories_forModel/tBB24.csv") # REMOVED SECOND CHUNK OF HOR_SM DETS

fishcheck("C652", dets_edited_for_model, file_location = "figure_output/")
write_csv(tC652, "data_output/Edited_TagDetHistories_forModel/tC652.csv")# removed or hw4 dets- check on this one again 
# once you get data from arnold 

# Delta Release Fish ----
fishcheck("BAC5", dets_ds, "figure_output/")
write_csv(tBAC5, "data_output/Edited_TagDetHistories_forModel/tBAC5.csv")# REMOVED EVEYTHING BELOW CVPU

fishcheck("BAD9", dets_ds, "figure_output/")
write_csv(tBAD9, "data_output/Edited_TagDetHistories_forModel/tBAD9.csv") # REMOVED EVERYTHING BELOW SJ_HOR

fishcheck("BAE5", dets_ds, "figure_output/")
write_csv(tBAE5, "data_output/Edited_TagDetHistories_forModel/tBAE5.csv") # NOT SURE WHY THE PREDATOR FILTER ISNT REMOVING THESE DETECTS
# MANUALLY REMOVED EVERYTHING BELOW DF REL REC
 
fishcheck("BD5E", dets_ds, "figure_output/")
write_csv(tBD5E, "data_output/Edited_TagDetHistories_forModel/tBD5E.csv")

fishcheck("BE96", dets_ds, "figure_output/")
write_csv(tBE96, "data_output/Edited_TagDetHistories_forModel/tBE96.csv") # REMOVED THE OR_HWY4 CHUNK IN BETWEEN
# THE CVPU CHUNKS- DOUBLE CHECK THIS DECISON AFTER GETTING ARNOLDS DATA

fishcheck("C4A6", dets_ds, "figure_output/")
write_csv(tC4A6, "data_output/Edited_TagDetHistories_forModel/tC4A6.csv") #REMOVED THE LAST HOR_SM DETS

fishcheck("C4B2", dets_ds, "figure_output/")
write_csv(tC4B2, "data_output/Edited_TagDetHistories_forModel/tC4B2.csv")# REMOVED LAST CHUNK OF HOWARD

fishcheck("C596", dets_ds, "figure_output/")
write_csv(tC596, "data_output/Edited_TagDetHistories_forModel/tC596.csv") # REMOVED LAST CHUNK OF MIDR HWY4

fishcheck("C852", dets_ds, "figure_output/")
write_csv(tC852, "data_output/Edited_TagDetHistories_forModel/tC852.csv") # REMOVED DF_REL DETS

fishcheck("C95E", dets_ds, "figure_output/")
write_csv(tC95E, "data_output/Edited_TagDetHistories_forModel/tC95E.csv")# REMOVED THE LAST 3 HOR_SM DETS

fishcheck("C968", dets_ds, "figure_output/")
write_csv(tC968, "data_output/Edited_TagDetHistories_forModel/tC968.csv") # REMOVED THE LAST 2 CHUNKS OF DF AND
#DF_RELREC DETS

fishcheck("CA4B", dets_ds, "figure_output/")
write_csv(tCA4B, "data_output/Edited_TagDetHistories_forModel/tCA4B.csv") #REMOVED THE LAST CHUNK OF HOR_SM DETS

fishcheck("CA8C", dets_ds, "figure_output/")
write_csv(tCA8C, "data_output/Edited_TagDetHistories_forModel/tCA8C.csv") #REMOVED THE ORHWY4 DETS INBETWEEN THE CVPU DETS- 
#DOUBLE CHECK THIS TAG WHEN YOU GET ARNOLD DATA

fishcheck("CA9D", dets_ds, "figure_output/")
write_csv(tCA9D, "data_output/Edited_TagDetHistories_forModel/tCA9D.csv")#REMOVED THE ORHWY4 DETS INBETWEEN THE CVPU DETS- 
#DOUBLE CHECK THIS TAG WHEN YOU GET ARNOLD DATA

fishcheck("CAA7", dets_ds, "figure_output/")
write_csv(tCAA7, "data_output/Edited_TagDetHistories_forModel/tCAA7.csv") # REMOVED ALL THE CC_RGU AND CVPU DETS INBETWEENT HE OR_HWY4 DETS
# ALSO CHECK ON THIS ONE AFTER ARNOLDS DATA IS PROVIDED

fishcheck("CAAF", dets_ds, "figure_output/") # FIXED WITH PRED FILTER

fishcheck("CB51", dets_ds, "figure_output/") # FIXED WITH PRED FILTER

fishcheck("CB57", dets_ds, "figure_output/")
write_csv(tCB57, "data_output/Edited_TagDetHistories_forModel/tCB57.csv") #REMOVED THE DF_RELRECDETS BELOW BCA

fishcheck("CB6E", dets_ds, "figure_output/")
write_csv(tCB6E, "data_output/Edited_TagDetHistories_forModel/tCB6E.csv") # REMOVED CHUNK OF ORHWY4 DETS BEFORE THE CVPU AND CCRGD DETS 

fishcheck("BDAE", dets, file_location = "figure_output/")
write_csv(tBDAE, "data_output/Edited_TagDetHistories_forModel/tBDAE.csv") #Removed TC detections since the fish made it to JP

fishcheck("BAB8", dets, file_location = "figure_output/")

# Remove detections:----
dets_pred_filtered<- ("data_output/Predator_Filter/AllDets_PredFiltered_16.csv") # read in csv of all your detections
dets_to_remove <- read_csv("data_output/Edited_TagDetHistories_forModel/Dets_to_be_Removed.csv") #35037 records

dets_edited_for_model <- dets_pred_filtered %>%
  anti_join(dets_to_remove)
length(unique(dets_to_remove$ID)) # check to make sure correct # of IDs
length(unique(dets_to_remove$Hex)) # Check to make sure correct number of tags ID,should be 34

# can also reach the same goal with this code:
  #dets_edited_for_model <- dets[!(dets$ID %in% dets_to_remove$ID), ]

# save newly edited csv for all groups:
write_csv(dets_edited_for_model, "data_output/DetectionFiles/dets_allgroups_formodel.csv")

# split new csv into the uppper and lower release groups
dets_up_forModel<- dets_edited_for_model[dets_edited_for_model$Rel_group == "2019UP", ]
dets_ds_forModel<- dets_edited_for_model[dets_edited_for_model$Rel_group == "2019DS", ]
# write these files:
write_csv(dets_up_forModel, "data_output/DetectionFiles/dets_up_forModel.csv")
write_csv(dets_ds_forModel, "data_output/DetectionFiles/dets_ds_forModel.csv")

#################################################################################################################
# Doing this again with files that include GG and Chipps Data. All I am doing this time is adding/editing the csv
# "Dets_to_be_Removed.csv", which holds all the detections in the script above that I removed the first time.
# This new file will be the one I remove from the AllDets_1_GG_Chipps_pred_filt16.csv file  located
# C:\Users\chause\Documents\GitHub\JSATS_SpringRun_19\data_output\DetectionFiles\Files_w_Bridge_Data

dets_allgroups_16pf <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/AllDets_w_GG_Chipps_pred_filt16.csv")

#upstream Release group fish:
fishcheck("BAB8", dets_allgroups_16pf, "figure_output/")
write_csv(tBAB8, "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/BAB8.csv") # Cut off data after the first Or HWY4

fishcheck("BB74", dets_allgroups_16pf, "figure_output/")
write_csv(tBB74, "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/BB74.csv") # cut off after 1st MSC

fishcheck("BD14", dets_allgroups_16pf, "figure_output/")
write_csv(tBD14, "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/BD14.csv") # Cut off data after MAC


fishcheck("BD6C", dets_allgroups_16pf, "figure_output/")
write_csv(tBD6C, "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/BD6C.csv") # Cut off data after the ORHWY4, 
#originally I had cut off out ORhwy4 and had fish going to pumps but since it was detecteted in a tank but not again at chipps 
## I am going to assume it was ina predator

fishcheck("C652", dets_allgroups_16pf, "figure_output/")
write_csv(tC652, "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/C652.csv") # Cut off data after first ORhwy4

fishcheck("BADB", dets_allgroups_16pf, "figure_output/")
write_csv(tBADB, "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/BADB.csv") # removed Detections at JP bc it does not fit the model 


#delta release receivers

fishcheck("C2D2", dets_allgroups_16pf, "figure_output/")
write_csv(tC2D2, "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/C2D2.csv") # removed whole detection history of tag

fishcheck("C92C", dets_allgroups_16pf, "figure_output/")
write_csv(tC92C, "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/C92C.csv") # removed Mac, left TC

fishcheck("CA8C", dets_allgroups_16pf, "figure_output/")
write_csv(tCA8C, "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/CA8C.csv") # removedthe second cvpu and tank 3

fishcheck("CA9D", dets_allgroups_16pf, "figure_output/")
write_csv(tCA9D, "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/CA9D.csv") # removedthe second cvpu and tank 3

fishcheck("C596", dets_allgroups_16pf, "figure_output/")
write_csv(tC596, "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/C596.csv") # removedthe second cvpu and tank 3
       
    ########## Tags that go from B1 to JP: need to take out for flame Model. Might have to put back in for complete model ##########
ds_dat<- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/dets_ds_PF16_ModelEdited_relLoc_GG_Chipps_092319.csv")

fishcheck("C26A", ds_dat, "figure_output/")
write_csv(tC26A, "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/Tags_that_had_B1toJP_Removed_for_FlameModel/C26A.csv")

fishcheck("CBA9", ds_dat, "figure_output/")
write_csv(tCBA9,  "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/Tags_that_had_B1toJP_Removed_for_FlameModel/CBA9.csv")

fishcheck("CB5D", ds_dat, "figure_output/")
write_csv(tCB5D,  "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/Tags_that_had_B1toJP_Removed_for_FlameModel/CB5D.csv")

fishcheck("CA98", ds_dat, "figure_output/")
write_csv(tCA98, "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/Tags_that_had_B1toJP_Removed_for_FlameModel/CA98.csv")


# Remove detections:----
dets_allgroups_16pf <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/AllDets_w_GG_Chipps_pred_filt16.csv")
dets_to_remove <- read_csv("data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Dets_to_be_Removed_gg_Chips_091919_final.csv") #42217 records
#make ID col numeric
dets_to_remove$ID <- as.numeric(dets_to_remove$ID )
class(dets_to_remove$ID)

nrow(dets_allgroups_16pf) # 3628261
nrow(dets_to_remove) # 43384
#3628261 - 43384 = 3584877 <---- should get back this many rows after running code below

# Remove dets to be removed from dataset
dets_edited_for_model <- dets_allgroups_16pf %>% 
  anti_join(dets_to_remove, by = c("dtf", "Hex", "GPS Names", "rkm", "Genrkm", "Rel_group", "FishID", "Lat", "Lon", "Weight", "Length"))

nrow(dets_edited_for_model)# 3584877 got it!

# Can also pull out bad dets this way
# dets_editd_for_model <- dets_allgroups_16pf[!(dets_allgroups_16pf$ID %in% dets_to_remove$ID), ] This isn't working bc the ID column 
#somehow got messed up

#length(unique(dets_to_remove$ID)) # check to make sure correct # of IDs
length(unique(dets_to_remove$Hex)) # Check to make sure correct number of tags ID,should be 36+4 -> 40 now including the B1 to JP dets from deltra rel fish for FLAME model

# save newly edited csv for all groups:
write_csv(dets_edited_for_model, "data_output/DetectionFiles/Files_w_Bridge_Data/dets_allgroups_formodel_w_GG_Chips_092419.csv")

# split new csv into the uppper and lower release groups
dets_up_forModel<- dets_edited_for_model[dets_edited_for_model$Rel_group == "2019UP", ]
dets_ds_forModel<- dets_edited_for_model[dets_edited_for_model$Rel_group == "2019DS", ]


# write these files:
write_csv(dets_up_forModel, "data_output/DetectionFiles/Files_w_Bridge_Data/dets_up_formodel_w_GG_Chips_092419.csv")
write_csv(dets_ds_forModel, "data_output/DetectionFiles/Files_w_Bridge_Data/dets_ds_formodel_w_GG_Chips_092419.csv")

#Now pull these 2 files ^^^ into the script" formatting_detection_csvs" to add the release location to them


###############################################################################################################################
###############################################################################################################################
# Doing this one last time again with files that include Benicia data- so now this data should include all the river/ delta data
# PLUS all bridge data from NOAA (chipps, Ben, GG). All I am doing now is adding/editing the csv
# Dets_to_be_Removed_gg_Chips_091919_final.csv", which holds all the detections in the script above that I removed the 
# first time + the second time (can follow trail in code above)
dets_allgroups_16pf <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/AllDets_w_GG_Ben_Chipps_pred_filt16_FINAL.csv")

# Below is running file with detections that have been removed from the data:
dets_to_remove <- read_csv("data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Dets_to_be_Removed_gg_Chips_091919_final.csv")

#******* NOW: I NEED TO ADD THESE DETECTIONS BACK INTO DATA FILE, . These are detections that go from B1 to JP, 
#which I took out for the flame model because it didnt fit the schematic (I lump the whole interior delta together) but
# inthe Full model fish can go from B1 to JP, so I need to make sure these fish get accounted for:

fishcheck("C26A", ds_dat, "figure_output/")
write_csv(tC26A, "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/Tags_that_had_B1toJP_Removed_for_FlameModel/C26A.csv")

fishcheck("CBA9", ds_dat, "figure_output/")
write_csv(tCBA9,  "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/Tags_that_had_B1toJP_Removed_for_FlameModel/CBA9.csv")

fishcheck("CB5D", ds_dat, "figure_output/")
write_csv(tCB5D,  "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/Tags_that_had_B1toJP_Removed_for_FlameModel/CB5D.csv")

fishcheck("CA98", ds_dat, "figure_output/")
write_csv(tCA98, "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/Tags_that_had_B1toJP_Removed_for_FlameModel/CA98.csv")

####neeed to fix the code below:########
# Remove the dets_to_remove files from the dataset, and then use that data to go through all individual tag plots:
nrow(dets_to_remove) # 43384 rows 
nrow(dets_allgroups_16pf) # 3681078 rows

B1toJP_tagsToPutBackIn <- dets_to_remove[dets_to_remove$Hex == "C26A" 
                                         |dets_to_remove$Hex == "CBA9"
                                         | dets_to_remove$Hex == "CB5D" 
                                         | dets_to_remove$Hex == "CA98", ]

################################################---READ ME---################################################################
#For the tags that were detected at the SWP intake and then again at JP, read info from tommys email about the salvage and 
#release process, document located : Z:\Shared\Projects\JSATS\DSP_Spring-Run Salmon\2019\2019Maps\Information_on_SWPandCVP_ReleaseLocations.doc
#Locations of releases also located here: Z:\Shared\Projects\JSATS\DSP_Spring-Run Salmon\2019\2019Maps\Pumping Facilities Salvaged Fish Release sites.kmz
##### tag BADB on 4/10 at 5:03: the tide at 9415144 Port Chicago, CA NOAA station (just upstream of Benicia) says it was on the 
# desending limb of the hydrograph. so theoretically fish sould not have been pushed back to JP
##### tag  C26A on 3/19: the tide at 9415144 Port Chicago, CA NOAA station (just upstream of Benicia) says it was nearly peak
# high tide at the time C62A was detected at JP (19:28). So this this is a fish may have been salvaged and released and got pushed back up to JP
# CONCLUSION: since there is only one fish I would be comcfortable saying that it was actually a salmon, and theortically
#  the release locations ARE downstream of JP and the only way they would get detected at JP is from swimming up 
#  volitionaly(unlikely), pushed from the tides(likely), or from being in a predator( also likely) I am going to just keep
#  the model having CC go to Chipps instead of JP, and remove the inbetween JP detections. 

# So need to take the tags from the B1toJP_tagsToPutBackIn object out of the dets_to_remove, then only add back in the JP dets.
# Then remove that updated dets_to_remove-object from original dataframe (dets_allgroups_16pf):

dets_to_remove_edited <- dets_to_remove %>% #43384 detections
  anti_join(B1toJP_tagsToPutBackIn, by = c("dtf", "Hex", "GPS Names", "rkm", "Genrkm", "Rel_group", 
                                           "FishID", "Lat", "Lon", "Weight", "Length")) #1167 detections
#^^^ take these detects out of the bad detects object (ie. putting them BACK into the good dataframe)
nrow(dets_to_remove_edited) # 42217, this adds up (43384-1167= 42,217)

#write this to new file:
write_csv(dets_to_remove_edited, "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/B1toJP_included_back_in_for_FINAL_Fullmodel/DetsToRemove_B1toJP_BackIn.csv")

# now manually (by hand, not in R) add the JP detections from the BADB and C62A tags back into the file above ^^. Read back into R:
dets_toRemove_NoCVPUtoJP <- read_csv("data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/B1toJP_included_back_in_for_FINAL_Fullmodel/DetsToRemove_B1toJP_BackIn.csv")

# Remove dets to be removed from dataset
PREVIOUS_dets_edited_for_model_plusNoCVPUtoJP <- dets_allgroups_16pf %>% 
  anti_join(dets_toRemove_NoCVPUtoJP, by = c("dtf", "Hex", "GPS Names", "rkm", "Genrkm", "Rel_group", "FishID", "Lat", "Lon", "Weight", "Length"))

# doing the math:
nrow(dets_allgroups_16pf) - nrow(dets_toRemove_NoCVPUtoJP) # so should be  3638383 rows in new dataset:
nrow(PREVIOUS_dets_edited_for_model_plusNoCVPUtoJP)#  3638383 rows, adds up!

# Write to file:
write_csv(PREVIOUS_dets_edited_for_model_plusNoCVPUtoJP, "data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/AllGroups_16pf_model_edited_beforeBenicia.csv")

# Now that my current dataset does not have anyone the detections that I previously flagged as bad/ wont fit model, and I added
# the B1 to JP detection histories back in by pulling those detections out of the remove bad detects csv (except
# to the histories that went from CVPU to JP- tags BADBand C62A) I  will run this file through the individual tag plotting code and pull out any last detections that dont fit the model,
#  and ADD the bad benicia detections that i find to the running remove dets csv (the one I am adding to is called:
# C:\Users\chause\Documents\GitHub\JSATS_SpringRun_19\data_output\Edited_TagDetHistories_forModel\Fies_w_GG_Chipps_data\Tags_w_Dets_to_be_Removed\B1toJP_included_back_in_for_FINAL_Fullmodel\DetsToRemove_Benicia_FINAL.csv
# and then remove those dets from the ORIGINAL detection files that I read in:
# dets_allgroups_16pf <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/AllDets_w_GG_Ben_Chipps_pred_filt16_FINAL.csv")

PREVIOUS_dets_edited_for_model_plusNoCVPUtoJP <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/AllGroups_16pf_model_edited_beforeBenicia.csv")

# first split into upper and lower release group:
dets_up <- PREVIOUS_dets_edited_for_model_plusNoCVPUtoJP[PREVIOUS_dets_edited_for_model_plusNoCVPUtoJP$Rel_group == "2019UP", ]
dets_ds <- PREVIOUS_dets_edited_for_model_plusNoCVPUtoJP[PREVIOUS_dets_edited_for_model_plusNoCVPUtoJP$Rel_group == "2019DS", ]

print_tags(df = dets_up,pdf_name = "UpperRel_IndivTagPlots_GG_Ben_Chipps")

#fishcheck("BAD0", dets_up, "figure_output/WaterfallPlots/FULL_MODEL/") This tag is ok, just goes back and forth between the hills recs
#fishcheck("BB34", dets_up, "figure_output/WaterfallPlots/FULL_MODEL/") OK
#fishcheck("BB74", dets_up, "figure_output/WaterfallPlots/FULL_MODEL/") THIS ONE IS OK BC THE HILLS RECEIEVRS END UP GETTING COMBINED IN THE MODEL
#fishcheck("BE5A", dets_up, "figure_output/WaterfallPlots/FULL_MODEL/") THIS ONE IS ALSO OK BC THE HILLS RECEIEVRS END UP GETTING COMBINED IN THE MODEL
#fishcheck("C514", dets_up, "figure_output/WaterfallPlots/FULL_MODEL/")OK- HILLS

# ALL TAGS IN UPPER RELEASE GRTOUP LOOK GOOD

print_tags(df = dets_ds,pdf_name = "DeltaRel_IndivTagPlots_GG_Ben_Chipps")

#fishcheck("BB9A", dets_ds, "figure_output/WaterfallPlots/FULL_MODEL/") # going to keep but a little suspicous. Tag was detected for a month at SJG. I dont want to take it out because there was some refuge here created by the flooding
#fishcheck("C549", dets_ds, "figure_output/WaterfallPlots/FULL_MODEL/") # Going to keep this one in. A salmon may have hung out in some rrefuge at Moss
#fishcheck("CB94", dets_ds, "figure_output/WaterfallPlots/FULL_MODEL/") # suspicous to hang around the release location for so long but going to keep it in

# these are the only tags in the lower release that I made model edits to:
fishcheck("BB8A", dets_ds, "figure_output/WaterfallPlots/FULL_MODEL/") # This one def eaten by a predator at the HOR, removed the CVPU detections
write_csv(tBB8A, "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/B1toJP_included_back_in_for_FINAL_Fullmodel/BB8A.csv")


fishcheck("C5EA", dets_ds, "figure_output/WaterfallPlots/FULL_MODEL/") # Ending this one at HOR, dont think that a salom would hang around the junction for a month
write_csv(tC5EA, "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/B1toJP_included_back_in_for_FINAL_Fullmodel/C5EA.csv")


# NOW that you have finalized the detection histories that are either predators or dont fit model, take your finalized 
# "remove bad dets "bad detection" csv and remove those dets from the original formatted, pred filtered CSV

# read in final bad detects csv:
dets_to_remove_FINAL <- read_csv("data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/B1toJP_included_back_in_for_FINAL_Fullmodel/DetsToRemove_Benicia_FINAL.csv")
nrow(dets_to_remove_FINAL) # 46516 rows

# read in original detection file with both groups (reformatted, predator filtered- also located at the top where this script starts)
dets_allgroups_16pf <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/AllDets_w_GG_Ben_Chipps_pred_filt16_FINAL.csv")
nrow(dets_allgroups_16pf) # 3681078 rows

# remove the bad dets from the file:
dets_allgroups_16pf_ModelEdited_FINAL <- dets_allgroups_16pf %>%
  anti_join(dets_to_remove_FINAL, by = c("dtf", "Hex", "GPS Names", "rkm", "Genrkm", "Rel_group", 
                                           "FishID", "Lat", "Lon", "Weight", "Length"))
nrow(dets_allgroups_16pf_ModelEdited_FINAL) #3634562, adds up!

# Split final file into upstream and downstream releases:

dets_us_16pf_ModelEdited_FINAL <- dets_allgroups_16pf_ModelEdited_FINAL[dets_allgroups_16pf_ModelEdited_FINAL$Rel_group == "2019UP", ]
dets_ds_16pf_ModelEdited_FINAL <- dets_allgroups_16pf_ModelEdited_FINAL[dets_allgroups_16pf_ModelEdited_FINAL$Rel_group == "2019DS", ]

# Write all files:
write_csv(dets_allgroups_16pf_ModelEdited_FINAL, "data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/dets_allgroups_16pf_ModelEdited_GG_Ben_Chipps_FINAL.csv")
write_csv(dets_us_16pf_ModelEdited_FINAL, "data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/dets_us_16pf_ModelEdited_GG_Ben_Chipps_FINAL.csv")
write_csv(dets_ds_16pf_ModelEdited_FINAL, "data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/dets_ds_16pf_ModelEdited_GG_Ben_Chipps_FINAL.csv")

  
