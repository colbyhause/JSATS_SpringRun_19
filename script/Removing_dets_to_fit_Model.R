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

###############################################################################################################################
###############################################################################################################################
###############################################################################################################################
#IGNORE THIS SECTION BELOW:-----
# it was created when dets_ds was a truncated file- was missing bridge data for some reason, which is why i was re-doing some old work since it was an old file
# I am keeping all the work just so i know what i did, but for all other purposes skip down to the 1/3/20 section
# Sun Dec 08 15:11:36 2019 ------------------------------
# CONTINUED ON Sun Dec 22 18:57:01 2019 ------------------------------

# I realized that since cvp_D did not record any detections, I can't determine which fish actually entered the cvp just from the upstream receiver
# bc those fish  could have been detected at cvp_u and then kept swimming towards CC. Therefore, I am pulling out every tag detected at cvp_u, looking at its detection
# history, and determing its most likely route, bc the code that makes the encounter history will just not let other detection histories be an option 
# for E2, A12, and on from there.  

dets_up <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/OLD_files/BeforeCVPU_edits/dets_up_PF16_ModelEdited_relLoc_GG_Ben_chipps_120319.csv")
dets_ds <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/OLD_files/BeforeCVPU_edits/dets_ds_PF16_ModelEdited_relLoc_GG_Ben_chipps_120319.csv")

# UPSTREAM REL FISH:

cvp_a <- dets_up %>% 
  filter(`GPS Names` == "CVPU_J")
length(unique(cvp_a$Hex))

cvp_b <- dets_up %>% 
  filter(`GPS Names` == "CVP_Tank3_J"|`GPS Names` == "CVP_Tank1_J"|`GPS Names` == "CVP_Tank2_J"|`GPS Names` == "CVP_Tank4_J")
length(unique(cvp_b$Hex)) # no fish detected in the tanks from the upstream rel group

unique(cvp_a$Hex) # "BAB8" "BB0A" "BB26" "BBB6" "C2A6" "C2B4" "C652"
fishcheck("BAB8", dets_up, "figure_output/") # Removed cvpU dets and ended at ORHwy4
write_csv(tBAB8, "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/B1toJP_included_back_in_for_FINAL_Fullmodel/CVPU_tags/UpperRel/BAB8.csv")

fishcheck("BB0A", dets_up, "figure_output/") # no changes needed, ends at cvpu

fishcheck("BB26", dets_up, "figure_output/") # remove CCRGD dets and end at cvpu
write_csv(tBB26, "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/B1toJP_included_back_in_for_FINAL_Fullmodel/CVPU_tags/UpperRel/BB26.csv")

fishcheck("BBB6", dets_up, "figure_output/") # no changes needed, ends at cvpu

fishcheck("C2A6", dets_up, "figure_output/")# remove cc_rgu and orhwy4 dets and end at cvpu
write_csv(tC2A6, "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/B1toJP_included_back_in_for_FINAL_Fullmodel/CVPU_tags/UpperRel/C2A6.csv")

fishcheck("C2B4", dets_up, "figure_output/") # no changes needed, ends at cvpu

fishcheck("C652", dets_up, "figure_output/") # removed Orhyw4, end at cvpu
write_csv(tC652, "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/B1toJP_included_back_in_for_FINAL_Fullmodel/CVPU_tags/UpperRel/C652.csv")

#### ^ These tags are in the file: C:\Users\chause\Documents\GitHub\JSATS_SpringRun_19\data_output\Edited_TagDetHistories_forModel\Fies_w_GG_Chipps_data\Tags_w_Dets_to_be_Removed\
#### B1toJP_included_back_in_for_FINAL_Fullmodel\CVPU_tags\UpperRel\UpRel_Remove_BAB8_BB26_C2A6_C652.csv

# Read in data and the csv made above:
dets_up <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/OLD_files/BeforeCVPU_edits/dets_up_PF16_ModelEdited_relLoc_GG_Ben_chipps_120319.csv")
BAB8_BB26_C2A6_C652_remove <- read_csv("data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/B1toJP_included_back_in_for_FINAL_Fullmodel/CVPUtags_UpperRel/UpRel_Remove_BAB8_BB26_C2A6_C652.csv")

#remove dets:
dets_up_cvpEdited <- dets_up %>%
  anti_join(BAB8_BB26_C2A6_C652_remove, by = c("dtf", "Hex", "GPS Names", "rkm", "Genrkm", "Rel_group", 
                                         "FishID", "Lat", "Lon", "Weight", "Length"))

nrow(BAB8_BB26_C2A6_C652_remove) # 8444 rows
nrow(dets_up) # 1268708
1268708- 8444 # =  1260264
nrow(dets_up_cvpEdited) #  1260264 looks good



# DOWNSTREAM REL FISH:
dets_ds <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/OLD_files/BeforeCVPU_edits/dets_ds_PF16_ModelEdited_relLoc_GG_Ben_chipps_120319.csv")

cvp_a_ds <- dets_ds %>% 
  filter(`GPS Names` == "CVPU_J")
length(unique(cvp_a_ds$Hex))


cvp_b_ds <- dets_ds %>% 
  filter(`GPS Names` == "CVP_Tank3_J"|`GPS Names` == "CVP_Tank1_J"|`GPS Names` == "CVP_Tank2_J"|`GPS Names` == "CVP_Tank4_J")
length(unique(cvp_b_ds$Hex))

tag_list_a <- unique(cvp_a_ds$Hex) # "BA75" "BA8E" "BA9D" "BAA3" "BAC5" "BB75" "BB7A" "BB8A" "BCA5" "BCB5" "BDA4" "BE96" "C494" "C896" "C95B" "C972" "C9A6" "CA16" "CA57" "CA8C" "CA9D"
#"CAA3" "CAA7" "CACB" "CB29" "CB5B" "CB5D" "CB6E" "CBA9"

tag_list_b <- unique(cvp_b_ds$Hex) # "BB8A" "BDA4" "C896" "CA8C" "CA9D" <------ THESE WERE ALL TAKEN CARE OF IN LIST ABOVE 

# Run fishcheck function in the fishcheck_PlotEachTag_GS.R script

#for cvp_a
for (i in tag_list_a) {
  print(i)
  fishcheck_loop(ID = i, Detections = dets_ds, plot_file_location =  "figure_output/TagPlots_GabesCode/CVPU_tags/DurhamRel/CVP_a/", 
                 csv_file_location =  "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/B1toJP_included_back_in_for_FINAL_Fullmodel/CVPU_tags/DurhamRel/")
}



#BA8E: CVPU to MidR_hwy4 # spent a day at each location, judgement call: removing cvpu dets ending at MidRhwy4
#BA9D CVPU to ORhwy4: only spent 2 hrs at cvpu, removing cvpu dets and ending at orhyw4
#BA75: no changes, ends at cvpu
#BAA3: cvpu to CC: remove cvpu and end at cc
#BAC5: cvpu back to OR HOR, remove ORHOR and SM@ dets and end at cvpu 
#BB7A :cvpu to orhwy4: remove orhwy4 and end at cvpu
#BB8A: detected from 3/14- 4/17 at HOR_junc, then at cvpu. remove cvpu dets and end at HORjunc
#BB75: cvpu to orhwy4: remove orhwy4 end at cvpu
#BCA5: no chnages, ends at cvpu
#BCB5: cvpu to orhwy4: remove orhwy4 and end at cvpu
#BDA4: no changes, ends at cvptank. detected at the DFRel rec from 3/13 to 4/7. Does not seem like smolt behavior hold for that long but it could have been in the flooded areas. 
#BE96: no changes, ends at cvpu
#C9A6: cvpu to ccrgd: remove cvpu and end at ccrgd 
#C95B: no changes, ends at cvpu
#C494: OR HOR to cvpu: but sepent 2 full days at HORjnc and then detected at CVPU a month later: ending detections at HOR junc, removing ORHOR and cvpu dets
#C896: no changes, ends at cvp tank
#C972: no changes, ends at cvpuend at cvp tank
#CA8C: or hor and then a month later shows up at cvpu, then to or hwy4 back to cvpu to tank. remove cvpu and tank, end at ORhwy4
#CA9D: cvpu to or hwy4 to cvpu to tank. remove cvpu and tank, end at or hwy4
#CA16: cvpu to orhwy4, reove cpu and end at or hwy4
#CA57: no changes, ends at cvpu
#CAA3: no changes, ends at cvpu
#CAA7: cvpu to orhwy4 to to cvpu to ccRGU back to cvpu back to or hwy4. remove everthing else, end at the first or hwy4
#CACB: cvpu to orhwy4, removed orhwy4 ended at cvpu
#CB5B: no changes ends at cvpu
#Cb5D: cvpu to orhwy4 to jp: remove cvpu, end at jp
#CB6E:orhwy4 for 5 days then to cvpu then ccrgd. End at orhwy4
#CB29:no chnages, ends at cvpu
#CBA9: cvpu to orhwy4 to jp, remove cvpu and end at jp


# NOW NEED TO REMOVE THE DETECTIONS ABOVE (FROM BOTH UPSTREAM AND DOWNSTREAM RELEASES) FROM THE DATAFRAME.I saved all the detections to be reoved (above) in file:
# C:\Users\chause\Documents\GitHub\JSATS_SpringRun_19\data_output\Edited_TagDetHistories_forModel\Fies_w_GG_Chipps_data\Tags_w_Dets_to_be_Removed\B1toJP_included_back_in_for_FINAL_Fullmodel\CVPU_tags\DurhamRel\CVPURemove.csv
# START HERE#######
#Read IN DETECTION FILES TO REMOVE:
#downstream:
CVPU_TO_REMOVE_ds <- read_csv("data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/B1toJP_included_back_in_for_FINAL_Fullmodel/CVPU_tags/DurhamRel/CVPURemove.csv")
#upstream:
BAB8_BB26_C2A6_C652_remove <- read_csv("data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/B1toJP_included_back_in_for_FINAL_Fullmodel/CVPU_tags/UpperRel/UpRel_Remove_BAB8_BB26_C2A6_C652.csv")

#read in most recent detection files from each group:
dets_up <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/OLD_files/BeforeCVPU_edits/dets_up_PF16_ModelEdited_relLoc_GG_Ben_chipps_120319.csv")
dets_ds <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/OLD_files/BeforeCVPU_edits/dets_ds_PF16_ModelEdited_relLoc_GG_Ben_chipps_120319.csv")


# remove these detctions from respectiive file above:
# upstream remove detects:
dets_up_cvpEdited <- dets_up %>%
  anti_join(BAB8_BB26_C2A6_C652_remove, by = c("dtf", "Hex", "GPS Names", "rkm", "Genrkm", "Rel_group", 
                                               "FishID", "Lat", "Lon", "Weight", "Length"))

nrow(BAB8_BB26_C2A6_C652_remove) # 8444 rows
nrow(dets_up) # 1268708
1268708- 8444 # =  1260264
nrow(dets_up_cvpEdited) #  1260264 looks good

# downstream remove detects:

dets_ds_cvpEdited <- dets_ds %>%
  anti_join(CVPU_TO_REMOVE_ds, by = c("dtf", "Hex", "GPS Names", "rkm", "Genrkm", "Rel_group", 
                                               "FishID", "Lat", "Lon", "Weight", "Length"))

nrow(CVPU_TO_REMOVE_ds) # 45115 rows
nrow(dets_ds) # 2326856 # this is where i figured out something was messed up, this file is only 2326856 rows long and should be 2366555
#2326856- 45115 # =  2281741
2366555 - 45115 # = 2321440
nrow(dets_ds_cvpEdited) # 2281741  looks good (old)
2332364 # removed only 34,191 not 45115

###below i am trying to figure out what messed up:----
t3 <- which(dets_ds$ID %in% CVPU_TO_REMOVE_ds$ID == T)# these are the detections from the cvpu to remove list that are IN the detection file 
t4 <- which(CVPU_TO_REMOVE_ds$ID %in% dets_ds[t3, ]$ID == F) # these are the detections from the the cvpu to removelist that are not in t3
not_in_cvpuremove_list <- CVPU_TO_REMOVE_ds[t4, ]
unique(not_in_cvpuremove_list$Hex)

bad_dets_that_are_in_detsds <- dets_ds[t3, ]
nrow(bad_dets_that_are_in_detsds) #34191
unique(bad_dets_that_are_in_detsds$Hex)

bb8a <- dets_ds %>% 
  filter(Hex == "BB8A")


test <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/dets_ds_16pf_ModelEdited_GG_Ben_Chipps_FINAL.csv")


nrow(CVPU_TO_REMOVE_ds %>% 
       filter(Hex == "BAC5")) #52

nrow(CVPU_TO_REMOVE_ds %>% 
       filter(Hex == "BB8A")) #3110

nrow(CVPU_TO_REMOVE_ds %>% 
       filter(Hex == "CA9D")) #2572

nrow(CVPU_TO_REMOVE_ds %>% 
       filter(Hex == "CA8C")) #2645

nrow(CVPU_TO_REMOVE_ds %>% 
       filter(Hex == "CAA7")) #3410

2572+3110+52+2645+3410 #11789
45115-34191

#BAC5: cvpu back to OR HOR, remove ORHOR and SM@ dets and end at cvpu 
#BB8A: detected from 3/14- 4/17 at HOR_junc, then at cvpu. remove cvpu dets and end at HORjunc
#CA9D: cvpu to or hwy4 to cvpu to tank. remove cvpu and tank, end at or hwy4

#"BA8E" "BA9D" "BAA3" "BB75" "BB7A" "BCB5" "C494" "C9A6" "CA16" "CA8C" "CA9D" "CAA7" "CACB" "CB5D" "CB6E" "CBA9"

which(dets_ds_cvpEdited %in% CVPU_TO_REMOVE_ds == T)

# the original way i figuredout something was wrong was bc on 12/24 i used write () instead of write_csv() so the files never wrote, so on 1/3/20 i had to remake the files and thats where i found issues
#write to final csvs:
write(dets_up_cvpEdited, "data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/dets_up_PF16_ModelEdited_relLoc_GG_Ben_chipps_122419.csv")
write(dets_ds_cvpEdited, "data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/dets_ds_PF16_ModelEdited_relLoc_GG_Ben_chipps_122419.csv")

#####################################################################################################################################################
#####################################################################################################################################################
# Fri Jan 03 15:02:05 2020 ------------------------------
#USE THIS CODE BELOW:

# I realized that since cvp_D did not record any detections, I can't determine which fish actually entered the cvp just from the upstream receiver
# bc those fish  could have been detected at cvp_u and then kept swimming towards CC. Therefore, I am pulling out every tag detected at cvp_u, looking at its detection
# history, and determing its most likely route, bc the code that makes the encounter history will just not let other detection histories be an option 
# for E2, A12, and on from there.  

dets_up <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/OLD_files/BeforeCVPU_edits/dets_up_PF16_ModelEdited_relLoc_GG_Ben_chipps_120319.csv")
dets_ds <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/OLD_files/BeforeCVPU_edits/dets_ds_PF16_ModelEdited_relLoc_GG_Ben_chipps_120319.csv")

# UPSTREAM REL FISH:

cvp_a <- dets_up %>% 
  filter(`GPS Names` == "CVPU_J")
length(unique(cvp_a$Hex)) #7

cvp_b <- dets_up %>% 
  filter(`GPS Names` == "CVP_Tank3_J"|`GPS Names` == "CVP_Tank1_J"|`GPS Names` == "CVP_Tank2_J"|`GPS Names` == "CVP_Tank4_J")
length(unique(cvp_b$Hex)) # no fish detected in the tanks from the upstream rel group

unique(cvp_a$Hex) # "BAB8" "BB0A" "BB26" "BBB6" "C2A6" "C2B4" "C652"
fishcheck("BAB8", dets_up, "figure_output/") # Removed cvpU dets and ended at ORHwy4
write_csv(tBAB8, "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/B1toJP_included_back_in_for_FINAL_Fullmodel/CVPU_tags/UpperRel/BAB8.csv")

fishcheck("BB0A", dets_up, "figure_output/") # no changes needed, ends at cvpu

fishcheck("BB26", dets_up, "figure_output/") # remove CCRGD dets and end at cvpu
write_csv(tBB26, "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/B1toJP_included_back_in_for_FINAL_Fullmodel/CVPU_tags/UpperRel/BB26.csv")

fishcheck("BBB6", dets_up, "figure_output/") # no changes needed, ends at cvpu

fishcheck("C2A6", dets_up, "figure_output/")# remove cc_rgu and orhwy4 dets and end at cvpu
write_csv(tC2A6, "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/B1toJP_included_back_in_for_FINAL_Fullmodel/CVPU_tags/UpperRel/C2A6.csv")

fishcheck("C2B4", dets_up, "figure_output/") # no changes needed, ends at cvpu

fishcheck("C652", dets_up, "figure_output/") # removed Orhyw4, end at cvpu
write_csv(tC652, "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/B1toJP_included_back_in_for_FINAL_Fullmodel/CVPU_tags/UpperRel/C652.csv")

#### ^ These tags are in the file: C:\Users\chause\Documents\GitHub\JSATS_SpringRun_19\data_output\Edited_TagDetHistories_forModel\Fies_w_GG_Chipps_data\Tags_w_Dets_to_be_Removed\
#### B1toJP_included_back_in_for_FINAL_Fullmodel\CVPU_tags\UpperRel\UpRel_Remove_BAB8_BB26_C2A6_C652.csv

# DOWNSTREAM REL FISH:
dets_ds <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/OLD_files/BeforeCVPU_edits/dets_ds_PF16_ModelEdited_relLoc_GG_Ben_chipps_120319.csv")

cvp_a_ds <- dets_ds %>% 
  filter(`GPS Names` == "CVPU_J")
length(unique(cvp_a_ds$Hex)) #28


cvp_b_ds <- dets_ds %>% 
  filter(`GPS Names` == "CVP_Tank3_J"|`GPS Names` == "CVP_Tank1_J"|`GPS Names` == "CVP_Tank2_J"|`GPS Names` == "CVP_Tank4_J")
length(unique(cvp_b_ds$Hex))

tag_list_a <- unique(cvp_a_ds$Hex)  #"BA75" "BA8E" "BA9D" "BAA3" "BAC5" "BB75" "BB7A" "BCA5" "BCB5" "BDA4" "BE96" "C494" "C896" "C95B" 
#"C972" "C9A6" "CA16" "CA57" "CA8C" "CA9D" "CAA3" "CAA7" "CACB" "CB29" "CB5B" "CB5D" "CB6E" "CBA9"

tag_list_b <- unique(cvp_b_ds$Hex) # "BDA4" "C896"" <------ THESE WERE ALL TAKEN CARE OF IN LIST ABOVE 

# Run fishcheck function in the fishcheck_PlotEachTag_GS.R script

#for cvp_a
for (i in tag_list_a) {
  print(i)
  fishcheck_loop(ID = i, Detections = dets_ds, plot_file_location =  "figure_output/TagPlots_GabesCode/CVPU_tags/DurhamRel/CVP_a/CORRECTED_010320/", 
                 csv_file_location =  "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/B1toJP_included_back_in_for_FINAL_Fullmodel/CVPUtags_DurhamRel_corrected/")
}

#same = -SAME AS CSV IN THE PREVIOUS ROUND OF EDITS (from 12/12)
#different = - DIFFERENT FROM THE CSV IN THE PREVIOUS ROUND OF EDITS (from 12/12)

#same #"BA75" no changes ends at CVPU
#same #"BA8E"  CVPU to MidR_hwy4 # spent a day at each location, judgement call: removing cvpu dets ending at MidRhwy4
#same #"BA9D" CVPU to ORhwy4: only spent 2 hrs at cvpu, removing cvpu dets and ending at orhyw4
#same #"BAA3" cvpu to CC: remove cvpu and end at cc
#different #"BAC5" no changes, ends at cvpu
#same #"BB75"  cvpu to orhwy4: remove orhwy4 end at cvpu
#same #"BB7A" :cvpu to orhwy4: remove orhwy4 and end at cvpu
#same #"BCA5" no chnages, ends at cvpu
#same #"BCB5"  cvpu to orhwy4: remove orhwy4 and end at cvpu
#same #"BDA4" no changes, ends at cvptank. detected at the DFRel rec from 3/13 to 4/7. Does not seem like smolt behavior hold for that long but it could have been in the flooded areas. 
#same #"BE96" no changes, ends at cvpu
#same #"C494" OR HOR to cvpu: but sepent 2 full days at HORjnc and then detected at CVPU a month later: ending detections at HOR junc, removing ORHOR and cvpu dets
#same #"C896" no changes, ends at cvp tank
#same #"C95B" no changes, ends at cvpu
#same #"C972" no changes, ends at cvpuend at cvp tank
#same#"C9A6" cvpu to ccrgd: remove cvpu and end at ccrgd 
#same #"CA16"  cvpu to orhwy4, reove cpu and end at or hwy4
#same #"CA57" no changes, ends at cvpu
#different #"CA8C" or hor and then a month later shows up at cvpu, then to or hwy4, remove cvpu and end at ORhwy4- DIFFERENT FROM THE CSV IN THE PREVIOUS ROUND OF EDITS (from 12/12)
#different # "CA9D" cvpu to orhwy, remove cvpu and end at prhwy4
#same #"CAA3" no changes, ends at cvpu
#different #"CAA7" cvputo orhy4, remove cvpu and end at orhwy4 
#different #"CACB" no changes, ends at cvpu 
#same #"CB29" no chnages ends at cvpu
#same #"CB5B" no changes ends at cvpu
#same #"CB5D"cvpu to orhwy4 to jp: remove cvpu, end at jp
#different #"CB6E"# cvpu to ccrgd- in the first round of editing i removed the ORhwy4 dets, so now removing the ccrgd and ending at cvpu
#different #"CBA9" cvpu to orhwy4 to jp to chipps then ben then gg, remove cvpu and end at gg- previous file didnt have anything after jp, so maybe i was using a super old file??

# NOW NEED TO REMOVE THE DETECTIONS ABOVE (FROM BOTH UPSTREAM AND DOWNSTREAM RELEASES) FROM THE DATAFRAME.
# I saved all the detections to be reoved (above) in file:
#C:\Users\chause\Documents\GitHub\JSATS_SpringRun_19\data_output\Edited_TagDetHistories_forModel\Fies_w_GG_Chipps_data\Tags_w_Dets_to_be_Removed\B1toJP_included_back_in_for_FINAL_Fullmodel\CVPUtags_DurhamRel_corrected\Corrected_CVPUdurhamRel_dets_to_remove.csv")

## START HERE#######
#Read IN DETECTION FILES TO REMOVE:
#downstream:
CVPU_TO_REMOVE_ds <- read_csv("data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/B1toJP_included_back_in_for_FINAL_Fullmodel/CVPUtags_DurhamRel_corrected/Corrected_CVPUdurhamRel_dets_to_remove.csv")
#upstream:
BAB8_BB26_C2A6_C652_remove <- read_csv("data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/B1toJP_included_back_in_for_FINAL_Fullmodel/CVPUtags_UpperRel/UpRel_Remove_BAB8_BB26_C2A6_C652.csv")

#read in most recent detection files from each group:
dets_up <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/OLD_files/BeforeCVPU_edits/dets_up_PF16_ModelEdited_relLoc_GG_Ben_chipps_120319.csv")
dets_ds <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/OLD_files/BeforeCVPU_edits/dets_ds_PF16_ModelEdited_relLoc_GG_Ben_chipps_120319.csv")


# remove these detctions from respectiive file above:
# upstream remove detects:
dets_up_cvpEdited <- dets_up %>%
  anti_join(BAB8_BB26_C2A6_C652_remove, by = c("dtf", "Hex", "GPS Names", "rkm", "Genrkm", "Rel_group", 
                                               "FishID", "Lat", "Lon", "Weight", "Length"))

nrow(BAB8_BB26_C2A6_C652_remove) # 8444 rows
nrow(dets_up) # 1268708
1268708- 8444 # =  1260264
nrow(dets_up_cvpEdited) #  1260264 looks good

# downstream remove detects:

dets_ds_cvpEdited <- dets_ds %>%
  anti_join(CVPU_TO_REMOVE_ds, by = c("dtf", "Hex", "GPS Names", "rkm", "Genrkm", "Rel_group", 
                                      "FishID", "Lat", "Lon", "Weight", "Length"))

nrow(CVPU_TO_REMOVE_ds) # 32884 rows
nrow(dets_ds) # 2366555
nrow(dets_ds)-nrow(CVPU_TO_REMOVE_ds) #2333671
nrow(dets_ds_cvpEdited) # 2333671  looks good

#write to final csvs:
write_csv(dets_up_cvpEdited, "data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/dets_up_PF16_ModelEdited_relLoc_GG_Ben_chipps_010320.csv")
write_csv(dets_ds_cvpEdited, "data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/dets_ds_PF16_ModelEdited_relLoc_GG_Ben_chipps_010320.csv")

############ Still some issues when I get the new counts:
# Upstream Rel:
# 1 FISH FROM orhwy4 to TO cc

#Downstream Rel:
# 1 fish from orhwy4 to mrhwy4
# 1 fish from orhwy4 to cvp - should have been fixed last time
# 3 fish from orhwy4 to CC

dets_up_cvpEdited <-read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/dets_up_PF16_ModelEdited_relLoc_GG_Ben_chipps_010320.csv")
dets_ds_cvpEdited <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/dets_ds_PF16_ModelEdited_relLoc_GG_Ben_chipps_010320.csv")

# Figuring out the upstream Rel:----
up_orhwy4 <- dets_up_cvpEdited %>% 
  filter(`GPS Names` == "OR_hwy4_1_J"|             
           `GPS Names` =="OR_hwy4_2_J"|            
           `GPS Names` =="OR_hwy4_3_J"|            
           `GPS Names` =="OR_hwy4_4_J")
length(unique(up_orhwy4$Hex))
taglist_up_orhwy4 <-unique(up_orhwy4$Hex) #"BA69" "BA6C" "BA89" "BA99" "BAB8" "BCB2" "BD29" "BD6C" "C512" "C522" "C69A"


for (i in taglist_up_orhwy4) {
  print(i)
  fishcheck_loop(ID = i, Detections = dets_up_cvpEdited, plot_file_location =  "figure_output/TagPlots_GabesCode/ORhwy4_tags/UpstreamRel/", 
                 csv_file_location =  "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/B1toJP_included_back_in_for_FINAL_Fullmodel/ORhwy4_UpperRel/")
}

#the tag that goes from orhwy4 to cc : BCB2
# BCB2: CCRGU to orhwy4: remove the ccrgu and end at orhwy4
#^ These detections to remove are save here: C:\Users\chause\Documents\GitHub\JSATS_SpringRun_19\data_output\Edited_TagDetHistories_forModel\Fies_w_GG_Chipps_data\Tags_w_Dets_to_be_Removed\B1toJP_included_back_in_for_FINAL_Fullmodel\ORhwy4_UpperRel\Orhwy4_upperRel_toRemove.csv

# Figuring out Downstream rel:----
# # 1 fish from orhwy4 to mrhwy4
# 1 fish from orhwy4 to cvp - should have been fixed last time
# 3 fish from orhwy4 to CC

DS_orHwy4 <- dets_ds_cvpEdited %>% 
  filter(`GPS Names` == "OR_hwy4_1_J"|             
          `GPS Names` =="OR_hwy4_2_J"|            
         `GPS Names` =="OR_hwy4_3_J"|            
         `GPS Names` =="OR_hwy4_4_J")
length(unique(DS_orHwy4$Hex))
taglist_ds_orhwy4 <-unique(DS_orHwy4$Hex)

for (i in taglist_ds_orhwy4) {
  print(i)
  fishcheck_loop(ID = i, Detections = dets_ds_cvpEdited, plot_file_location =  "figure_output/TagPlots_GabesCode/ORhwy4_tags/DurhamRel/", 
                 csv_file_location =  "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/B1toJP_included_back_in_for_FINAL_Fullmodel/ORhwy4_DurhamRel/")
}


# function to merge all the csvs into one file: 
batch_read <- function(path, pattern, recursive = FALSE, read_fun, ...) {
  data.files <- list.files(path, pattern = pattern, recursive = recursive)
  data <- lapply(paste0(path, data.files), read_fun, ...)
  data <- do.call("rbind", data)
  data
}

ds_orhwy4_MergedData <- batch_read(path = "data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/B1toJP_included_back_in_for_FINAL_Fullmodel/ORhwy4_DurhamRel/", 
           pattern = ".csv", recursive = F, read_fun = read_csv)
length(unique(ds_orhwy4_MergedData$Hex)) # 29

# Find the tag that has mrhwy4 in it:
orhwy4_mrhwy4_tag <-ds_orhwy4_MergedData %>% 
  filter(`GPS Names` ==  "MidR_hwy4_1_J" |
           `GPS Names` ==  "MidR_hwy4_2_J" |
           `GPS Names` == "MidR_hwy4_4_J"|
           `GPS Names` == "MidR_hwy4_3_J")
unique(orhwy4_mrhwy4_tag$Hex)
# tag is C976  # removingmrhwy4 and ending at orhwy4 bc this movement happened on an ebb tide                 

# Find the tag that has cvp in it
orhwy4_cvp_tag <- ds_orhwy4_MergedData %>% 
  filter (`GPS Names` == "CVPU_J")
unique(orhwy4_cvp_tag$Hex)
#tag is CACB # for some reason i didnt take these dets out above but marked it as good, i removed them and put them in the file;
#C:\Users\chause\Documents\GitHub\JSATS_SpringRun_19\data_output\Edited_TagDetHistories_forModel\Fies_w_GG_Chipps_data\Tags_w_Dets_to_be_Removed\B1toJP_included_back_in_for_FINAL_Fullmodel\CVPUtags_DurhamRel_corrected\Corrected_CVPdsRel_remove.csv
#^ this file also include all the cvp dets to remove from above, i just had to rename it bc the excel wouldnt let me save it with such a long name

# Find the tag that has cc in it:
orhwy4_cc_tag <-ds_orhwy4_MergedData %>% 
         filter(`GPS Names` =="CC_RGD_1_J" |           
         `GPS Names` =="CC_RGD_2_J" |           
         `GPS Names` =="CC_RGD_3_J"|           
         `GPS Names` =="CC_RGD_4_J"|             
         `GPS Names` =="CC_RGU1_J" |              
         `GPS Names` =="CC_RGU2_J")
unique(orhwy4_cc_tag$Hex) 
# tags are "C596" "CA2D" "CBAC"
# "C596" : ccrgu to orhwy4, removed ccrgu,end at orhwy4 
# "CA2D" : ccrgu to orhwy4, removed ccrgu,end at orhwy4 
# "CBAC" : ccrgu to orhwy4, removed ccrgu,end at orhwy4
# 

test <- read_csv("data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/B1toJP_included_back_in_for_FINAL_Fullmodel/CVPUtags_DurhamRel_corrected/Corrected_CVPUdurhamRel_dets_to_remove.csv")
test %>% 
  filter(`GPS Names`=="CABC")

# The dets to remove for tags C976 (mrhwy4) and "C596" "CA2D" "CBAC" (ccrgu) are located in:
# C:\Users\chause\Documents\GitHub\JSATS_SpringRun_19\data_output\Edited_TagDetHistories_forModel\Fies_w_GG_Chipps_data\Tags_w_Dets_to_be_Removed\B1toJP_included_back_in_for_FINAL_Fullmodel\ORhwy4_DurhamRel\Orhwy4_toRemove.csv

###START HERE for FINAL edits----
# FIST, READ IN THE ORIGINAL DATAFRAMES FROM THE CVP EDITS:
dets_up <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/OLD_files/BeforeCVPU_edits/dets_up_PF16_ModelEdited_relLoc_GG_Ben_chipps_120319.csv")
dets_ds <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/OLD_files/BeforeCVPU_edits/dets_ds_PF16_ModelEdited_relLoc_GG_Ben_chipps_120319.csv")

#Take the 2 files that have dets to remove and merge them:
#Upstream Rel:
#upstream:
BAB8_BB26_C2A6_C652_remove <- read_csv("data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/B1toJP_included_back_in_for_FINAL_Fullmodel/CVPUtags_UpperRel/UpRel_Remove_BAB8_BB26_C2A6_C652.csv")
BCB2_remove <- read_csv("data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/B1toJP_included_back_in_for_FINAL_Fullmodel/ORhwy4_UpperRel/Orhwy4_upperRel_toRemove.csv")

up_dets_to_removed_merged <- rbind(BAB8_BB26_C2A6_C652_remove,BCB2_remove ) #8651
nrow(BAB8_BB26_C2A6_C652_remove) +nrow(BCB2_remove) #865 adds up

#downstream:
CVPU_TO_REMOVE_ds <-read_csv("data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/B1toJP_included_back_in_for_FINAL_Fullmodel/CVPUtags_DurhamRel_corrected/Corrected_CVPdsRel_remove.csv")
orhwy4_TO_REMOVE_ds <-read_csv("data_output/Edited_TagDetHistories_forModel/Fies_w_GG_Chipps_data/Tags_w_Dets_to_be_Removed/B1toJP_included_back_in_for_FINAL_Fullmodel/ORhwy4_DurhamRel/Orhwy4_toRemove.csv")

ds_dets_to_remove_merged <- rbind(CVPU_TO_REMOVE_ds, orhwy4_TO_REMOVE_ds)# 34057
nrow(CVPU_TO_REMOVE_ds) +nrow(orhwy4_TO_REMOVE_ds) #34057

#Now remove dets from respective files:
# upstream remove detects:
dets_up_Edited_FINAL <- dets_up %>%
  anti_join(up_dets_to_removed_merged, by = c("dtf", "Hex", "GPS Names", "rkm", "Genrkm", "Rel_group", 
                                               "FishID", "Lat", "Lon", "Weight", "Length"))

nrow(up_dets_to_removed_merged) #8651  rows
nrow(dets_up) # 1268708
1268708- 8651 # =  1260057
nrow(dets_up_Edited_FINAL) #  1260057 looks good


# DOWNSTREAM remove detects:
dets_ds_Edited_FINAL <- dets_ds %>%
  anti_join(ds_dets_to_remove_merged, by = c("dtf", "Hex", "GPS Names", "rkm", "Genrkm", "Rel_group", 
                                              "FishID", "Lat", "Lon", "Weight", "Length"))

nrow(ds_dets_to_remove_merged) #3407  rows
nrow(dets_ds) # 2366555
nrow(dets_ds)-nrow(ds_dets_to_remove_merged) #2332498
nrow(dets_ds_Edited_FINAL) #  2332498  looks good


#write to final csvs:
write_csv(dets_up_Edited_FINAL, "data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/dets_up_PF16_ModelEdited_relLoc_GG_Ben_chipps_010320FINAL.csv")
write_csv(dets_ds_Edited_FINAL, "data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/dets_ds_PF16_ModelEdited_relLoc_GG_Ben_chipps_010320FINAL.csv")


###NEXT STEP 12/24/19:
# Put these detection files through the tag plot code again, look at each plot, make sure everything looks good, run code to make the counts again, and then go through process of determining which parametrs to fix
# check to make sure these are resolved:
# Downstream detection histories that need to be fixed:
# B2 to A14: 1
# C1 (MR hwy4) to D1 (CVP): 1
# D1 (cvp) to E1 (cc): 3
# D1 (CVP) to A16 : 2--> double check to see if these tags were taken out before
# E2 to A14

