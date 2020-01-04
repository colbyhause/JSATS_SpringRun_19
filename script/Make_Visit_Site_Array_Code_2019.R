# Tue Aug 20 14:07:58 2019 ------------------------------
# Updated for actual 2019 full model:  Mon Nov 25 16:30:24 2019 ------------------------------

# The goals of this code are to 
# 1. truncate your data to only include the sites you are using for the model
# 2. Add site array codes to all of your receiver locations
# 3. Simplify detection history by reducing detections down to first and last detection at each location

# Gabe's original code is located :C:\Users\chause\Documents\GitHub\SJR_MS\script\Make_Visit_Site_Arrary_Code.R

library(tidyverse)
library(here)
library(readxl)


# First: read in finalized detection data. The data below had a 16 km predator filter applied to it, plus it was run 
#through RKM plot code (located in script/ rkm_plotcode_eachTag_GS) to visually idientify weird movements that wont fit the model
# and then manually remove those detections (direction for  removing detections can be found here: C:\Users\chause\Documents\GitHub\
# JSATS_SpringRun_19\script\Removing_dets_to_fit_Model.R ). Release Location csvs were also included in these files 

dets_all <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/OLD_files/dets_allgroups_16pf_ModelEdited_GG_Ben_Chipps_FINAL.csv")
#dets_up <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/dets_up_PF16_ModelEdited_relLoc_GG_Ben_chipps_120319.csv")
#dets_ds <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/dets_ds_PF16_ModelEdited_relLoc_GG_Ben_chipps_120319.csv")

# latest files from 1/3/20
#dets_up <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/dets_up_PF16_ModelEdited_relLoc_GG_Ben_chipps_010320FINAL.csv")
#dets_ds <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/dets_ds_PF16_ModelEdited_relLoc_GG_Ben_chipps_010320FINAL.csv")
dets_up <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/dets_up_PF16_ModelEdited_relLoc_GG_Ben_chipps_010320FINAL_2.csv")
dets_ds <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/dets_ds_PF16_ModelEdited_relLoc_GG_Ben_chipps_010320FINAL_2.csv")

# DOUBLE CHECK you have all recievers you want in here:
length(unique(dets_all$`GPS Names`)) # only 113 compared to the 136 i have in my rec locations csv
names <- unique(dets_all$`GPS Names`)
names[order(unique(dets_all$`GPS Names`))]
#***************** Confirmed that I have all the receievrs I need except for Benicia11, this reciever was in the deployments table but not in the file
#that Anrnold gave me. Notes on all this and cofirming the receivers is located:
#C:\Users\chause\Documents\GitHub\JSATS_SpringRun_19\documents\CondfirmingLocationsTableRecwithFullModelData.txt


#### Only pull out the detections for the receivers we want in the full model
#1. Define which receivers are in the 2019 model ------------------------------------------------------
#(see schematic in the documents folder)
gps_names <-(unique(dets_all$`GPS Names`))
gps_names[order(gps_names)]
model_recs <- c("CC_intake_J",            
                "CC_RGD_1_J",             
                "CC_RGD_2_J",             
                "CC_RGD_3_J",             
                "CC_RGD_4_J",              
                "CC_RGU1_J",               
                "CC_RGU2_J",               
                "CVP_Tank3_J",            
                "CVPU_J",                
                "Delt_TC_2_J",             
                "HOR_AM1",                
                "HOR_AM2",                
                "HOR_AM3",                 
                "HOR_AM4",                 
                "HOR_AM6",                 
                "HOR_AM7",                
                "HOR_AM8",                 
                "HOR_AM9",              
                "HOR_SM1",                 
                "HOR_SM2",                
                "HOR_SM3",                 
                "HOR_SM4",                 
                "HOR_SM7",                 
                "HOR_SM8",                
                "MidR_hwy4_1_J",          
                "MidR_hwy4_2_J",          
                "MidR_hwy4_3_J",           
                "MidR_hwy4_4_J",          
                "OR_HOR_1_J",              
                "OR_HOR_2_J",              
                "OR_HOR_3_J",              
                "OR_HOR_4_J",             
                "OR_hwy4_1_J",             
                "OR_hwy4_2_J",             
                "OR_hwy4_3_J",             
                "OR_hwy4_4_J",            
                "SJ_BCA_1_J",              
                "SJ_BCA_2_J",              
                "SJ_Blw_Newman_1_J",       
                "SJ_Blw_Newman_2_J",      
                "SJ_Blw_Release_1_J",      
                "SJ_Blw_Release_2_J",      
                "SJ_BlwCrowsLanding_1_J",  
                "SJ_BlwCrowsLanding_2_J", 
                "SJ_BlwWGrayson_1_J",      
                "SJ_BlwWGrayson_2_J",      
                "SJ_Durhamferry_1_J",      
                "SJ_Durhamferry_2_J",     
                "SJ_Hills_1_J",            
                "SJ_Hills_2_J",            
                "SJ_Hills_RT_1_US",       
                "SJ_Hills_RT_2_DS",        
                "SJ_HOR_1_J",              
                "SJ_HOR_2_J",              
                "SJ_Howard_1_J",          
                "SJ_Howard_2_J",  
                "SJ_JP_1_J",
                "SJ_JP_2_J",               
                "SJ_JP_3_J",               
                "SJ_JP_4_J",            
                "SJ_JP_5_J",               
                "SJ_JP_6_J",               
                "SJ_JP_7_J",               
                "SJ_JP_8_J",              
                "SJ_MAC_1_J",              
                "SJ_MAC_2_J",              
                "SJ_MAC_3_J",              
                "SJ_MAC_4_J",             
                "SJ_Moss_1_J",             
                "SJ_Moss_2_J",             
                "SJ_Mud_SL_Conf_J",        
                "SJ_SJG_1_J",             
                "SJ_SJG_2_J",            
                "SJ_SJG_3_J",              
                "SJ_SJG_4_J",  
                "GG1",
                "GG1.5",
                "GG1.7", # not in 2019 deployment
                "GG2.1",
                "GG2.5", # lost during deployment 
                "GG3.1",
                "GG3.5", # not in 2019 deployment
                "GG4",
                "GG4.5", # not in 2019 deployment
                "GG5.1",
                "GG5.5", # not in 2019 deployment
                "GG6",
                "GG6.5",
                "GG7",
                "GG7.2",
                "GG7.5",
                "GG7.7", # not in 2019 deployment
                "GG8",
                "GG8.4", # not in 2019 deployment
                "GG9",
                "Benicia01",
                "Benicia02",
                "Benicia03",
                "Benicia04",
                "Benicia05",
                "Benicia06",
                "Benicia07",
                "Benicia08",
                "Benicia09",
                "Benicia10",
                "Benicia11",
                "Benicia12",
                "Benicia13",
                "Benicia14",
                "Benicia15",
                "Benicia16",
                'Chipps1.1', 
                'Chipps1.2', 
                'Chipps1.3', 
                'Chipps1.4', 
                'Chipps1.5', 
                'Chipps2.1', 
                'Chipps2.3', 
                'Chipps2.4', 
                'Chipps2.5',
                "Upstream_Release", 
                "Downstream_Release")

# See which recievers are in our dataset but not on this list:
model_recs %in% gps_names
model_recs[model_recs %in% gps_names == F] # says which ones are in model_recs and not in our dataset

# took out "SJ_Durhamferry_RelRec_J" from this model due to extremely low detection probability

# Pull out only the detections from the receivers in the model_recs string using the %in% function:
# Upper:----
truncated_dets_up<- dets_up %>% 
  filter(`GPS Names` %in% model_recs) # must do Detect_Location %in% model_recs bc the way this function works is it returns 
#a TRUE if there is a match on the LEFT side, so you have to put the list of things that you what you want to match up on the RIGHT
# you could also write the code out this way:
#truncated <- upper[upper$Detect_Location %in% model_recs, ]

#delta:----
truncated_dets_ds <- dets_ds %>% 
  filter(`GPS Names` %in% model_recs)

#### Adding Site Codes (THIS IS OLD...)
# below are the Detection_location to site code pairings:
# Rel - Upstream_Release
# A1 - SJ_Blw_Release_1_J, SJ_Blw_Release_2_J,  
# A2 - SJ_Mud_SL_Conf_J
# A3 - SJ_Blw_Newman_1_J, SJ_Blw_Newman_2_J  
# A4 - SJ_Hills_1_J,SJ_Hills_2_J, SJ_Hills_RT_1_US,SJ_Hills_RT_2_DS 
# A5 - SJ_BlwCrowsLanding_1_J & SJ_BlwCrowsLanding_2_J
# A6 - SJ_BlwWGrayson_1_J & SJ_BlwWGrayson_2_J
# A7 - SJ_Durhamferry_RelRec_J
# A8 - SJ_Durhamferry_1_J & SJ_Durhamferry_2_J
# A9 - SJ_BCA_1_J,  SJ_BCA_2_J,
# A10 - SJ_Moss_1_J, SJ_Moss_2_J 
# A11 - HOR_AM1, HOR_AM2, HOR_AM3, HOR_AM4,HOR_AM6, HOR_AM7, HOR_AM8, HOR_AM9, HOR_SM1,HOR_SM2,                
        #HOR_SM3, HOR_SM4,HOR_SM7,HOR_SM8
# A12 - SJ_HOR_1_J & SJ_HOR_2_J
# B1a - OR_HOR_1_J,OR_HOR_2_J
# B1b - OR_HOR_3_J & OR_HOR_4_J 
# B2 - OR_hwy4_1_J, "OR_hwy4_2_J", OR_hwy4_3_J,OR_hwy4_4_J 
# C1 - MidR_hwy4_1, MidR_hwy4_2, MidR_hwy4_3, MidR_hwy4_4             
# D1a- CVPU_J
# D1b - CVP_Tank3_J
# E1a - CC_RGU1_J,CC_RGU2_J,   
# E1b - CC_RGD_1_J, "CC_RGD_2_J", "CC_RGD_3_J","CC_RGD_4_J",
# E2 - CC_intake_J
# A13 - SJ_Howard_1_J & SJ_Howard_2_J
# A14 - SJ_SJG_1_J & SJ_SJG_2_J, SJ_SJG_3_J & SJ_SJG_4_J rkm 140.33
# A15a - SJ_MAC_1_J & SJ_MAC_2_J rkm 123.23
# A15b - SJ_MAC_3_J & SJ_MAC_4_J rkm 122.34
# F1 - Delt_TC_1, Delt_TC_2 
# A16a - JP 1-4 rkm 93.74
# A16b - JP 5-8 rkm 93.04
# A17a - Chipps1.1-1.5 rkm 71.72
# A17b - Chipps2.2-2.5
# A18a - Antioch Recs
# A18b - Antioch Recs
# A19a - Benicia 1, 2, 3, 7, 12
# A19b - Benicia recs 
# A20a - Goldned Gate 6, 7, 8 rkm 1.71
# A20b - Goldned Gate 1, 2.1, 3.1, 4, 5.1 rkm 0.8

# 2.Use function to add site code column to upper/delta detection files -------------------------------------------------------
# using subset [rows, columns] to filter rows using grep function (grep(pattern,where to look) and add "site.code" a the column. 
add_array_codes <- function(detection_file) {
  detection_file[grep('Upstream_Release', detection_file$`GPS Names`), 'site.code' ] <- 'REL'
  detection_file[grep("Downstream_Release", detection_file$`GPS Names`), 'site.code' ] <- 'REL'
  detection_file[grep('SJ_Blw_Release_1_J', detection_file$`GPS Names`), 'site.code' ] <- 'A1'
  detection_file[grep('SJ_Blw_Release_2_J', detection_file$`GPS Names`), 'site.code' ] <- 'A1'
  detection_file[grep('SJ_Mud_SL_Conf_J', detection_file$`GPS Names`), 'site.code' ] <- 'A2'
  detection_file[grep('SJ_Blw_Newman_1_J', detection_file$`GPS Names`), 'site.code' ] <- 'A3'
  detection_file[grep('SJ_Blw_Newman_2_J', detection_file$`GPS Names`), 'site.code' ] <- 'A3'
  detection_file[grep('SJ_Hills_2_J', detection_file$`GPS Names`), 'site.code' ] <- 'A4'
  detection_file[grep('SJ_Hills_1_J', detection_file$`GPS Names`), 'site.code' ] <- 'A4'
  detection_file[grep('SJ_Hills_2_J', detection_file$`GPS Names`), 'site.code' ] <- 'A4'
  detection_file[grep('SJ_Hills_RT_1_US', detection_file$`GPS Names`), 'site.code' ] <- 'A4'
  detection_file[grep('SJ_Hills_RT_2_DS', detection_file$`GPS Names`), 'site.code' ] <- 'A4'
  detection_file[grep('SJ_BlwCrowsLanding_1_J', detection_file$`GPS Names`), 'site.code' ] <- 'A5'
  detection_file[grep('SJ_BlwCrowsLanding_2_J', detection_file$`GPS Names`), 'site.code' ] <- 'A5'
  detection_file[grep('SJ_BlwWGrayson_1_J', detection_file$`GPS Names`), 'site.code' ] <- 'A6'
  detection_file[grep('SJ_BlwWGrayson_2_J', detection_file$`GPS Names`), 'site.code' ] <- 'A6'
  #detection_file[grep('SJ_Durhamferry_RelRec_J', detection_file$`GPS Names`), 'site.code' ] <- 'A7' #not using this one in Full model
  detection_file[grep('SJ_Durhamferry_1_J', detection_file$`GPS Names`), 'site.code' ] <- 'A8'
  detection_file[grep('SJ_Durhamferry_2_J', detection_file$`GPS Names`), 'site.code' ] <- 'A8'
  detection_file[grep('SJ_BCA_1_J', detection_file$`GPS Names`), 'site.code' ] <- 'A9'
  detection_file[grep('SJ_BCA_2_J', detection_file$`GPS Names`), 'site.code' ] <- 'A9'
  detection_file[grep('J_Moss_1_J', detection_file$`GPS Names`), 'site.code' ] <- 'A10'
  detection_file[grep('J_Moss_2_J', detection_file$`GPS Names`), 'site.code' ] <- 'A10'
  detection_file[grep('HOR_AM1', detection_file$`GPS Names`), 'site.code' ] <- 'A11'
  detection_file[grep('HOR_AM2', detection_file$`GPS Names`), 'site.code' ] <- 'A11'
  detection_file[grep('HOR_AM3', detection_file$`GPS Names`), 'site.code' ] <- 'A11'
  detection_file[grep('HOR_AM4', detection_file$`GPS Names`), 'site.code' ] <- 'A11'
  detection_file[grep('HOR_AM6', detection_file$`GPS Names`), 'site.code' ] <- 'A11'
  detection_file[grep('HOR_AM7', detection_file$`GPS Names`), 'site.code' ] <- 'A11'
  detection_file[grep('HOR_AM8', detection_file$`GPS Names`), 'site.code' ] <- 'A11'
  detection_file[grep('HOR_AM9', detection_file$`GPS Names`), 'site.code' ] <- 'A11'
  detection_file[grep('HOR_SM1', detection_file$`GPS Names`), 'site.code' ] <- 'A11'
  detection_file[grep('HOR_SM2', detection_file$`GPS Names`), 'site.code' ] <- 'A11'
  detection_file[grep('HOR_SM3', detection_file$`GPS Names`), 'site.code' ] <- 'A11'
  detection_file[grep('HOR_SM4', detection_file$`GPS Names`), 'site.code' ] <- 'A11'
  detection_file[grep('HOR_SM7', detection_file$`GPS Names`), 'site.code' ] <- 'A11'
  detection_file[grep('HOR_SM8', detection_file$`GPS Names`), 'site.code' ] <- 'A11'
  detection_file[grep('SJ_HOR_1_J', detection_file$`GPS Names`), 'site.code' ] <- 'A12'
  detection_file[grep('SJ_HOR_2_J', detection_file$`GPS Names`), 'site.code' ] <- 'A12'
  detection_file[grep('OR_HOR_1_J', detection_file$`GPS Names`), 'site.code' ] <- 'B1a'
  detection_file[grep('OR_HOR_2_J', detection_file$`GPS Names`), 'site.code' ] <- 'B1a'
  detection_file[grep('OR_HOR_3_J', detection_file$`GPS Names`), 'site.code' ] <- 'B1b'
  detection_file[grep('OR_HOR_4_J', detection_file$`GPS Names`), 'site.code' ] <- 'B1b'
  detection_file[grep('OR_hwy4_1_J', detection_file$`GPS Names`), 'site.code' ] <- 'B2'
  detection_file[grep('OR_hwy4_3_J', detection_file$`GPS Names`), 'site.code' ] <- 'B2'
  detection_file[grep('OR_hwy4_2_J', detection_file$`GPS Names`), 'site.code' ] <- 'B2'
  detection_file[grep('OR_hwy4_4_J', detection_file$`GPS Names`), 'site.code' ] <- 'B2'
  detection_file[grep('MidR_hwy4_1', detection_file$`GPS Names`), 'site.code' ] <- 'C1a'
  detection_file[grep('MidR_hwy4_2', detection_file$`GPS Names`), 'site.code' ] <- 'C1a'
  detection_file[grep('MidR_hwy4_3', detection_file$`GPS Names`), 'site.code' ] <- 'C1b'
  detection_file[grep('MidR_hwy4_4', detection_file$`GPS Names`), 'site.code' ] <- 'C1b'
  detection_file[grep('CVPU_J', detection_file$`GPS Names`), 'site.code' ] <- 'D1a'
  detection_file[grep('CVP_Tank3_J', detection_file$`GPS Names`), 'site.code' ] <- 'D1b'
  detection_file[grep('CC_RGU1_J', detection_file$`GPS Names`), 'site.code' ] <- 'E1a'
  detection_file[grep('CC_RGU2_J', detection_file$`GPS Names`), 'site.code' ] <- 'E1a'
  detection_file[grep('CC_RGD_1_J', detection_file$`GPS Names`), 'site.code' ] <- 'E1b'
  detection_file[grep('CC_RGD_2_J', detection_file$`GPS Names`), 'site.code' ] <- 'E1b'
  detection_file[grep('CC_RGD_3_J', detection_file$`GPS Names`), 'site.code' ] <- 'E1b'
  detection_file[grep('CC_RGD_4_J', detection_file$`GPS Names`), 'site.code' ] <- 'E1b'
  detection_file[grep('CC_intake_J', detection_file$`GPS Names`), 'site.code' ] <- 'E2'
  detection_file[grep('SJ_Howard_1_J', detection_file$`GPS Names`), 'site.code' ] <- 'A13'
  detection_file[grep('SJ_Howard_2_J', detection_file$`GPS Names`), 'site.code' ] <- 'A13'
  detection_file[grep('SJ_SJG_1_J', detection_file$`GPS Names`), 'site.code' ] <- 'A14'
  detection_file[grep('SJ_SJG_2_J', detection_file$`GPS Names`), 'site.code' ] <- 'A14'
  detection_file[grep('SJ_SJG_3_J', detection_file$`GPS Names`), 'site.code' ] <- 'A14'
  detection_file[grep('SJ_SJG_4_J', detection_file$`GPS Names`), 'site.code' ] <- 'A14'
  detection_file[grep('SJ_MAC_1_J', detection_file$`GPS Names`), 'site.code' ] <- 'A15a'
  detection_file[grep('SJ_MAC_2_J', detection_file$`GPS Names`), 'site.code' ] <- 'A15a'
  detection_file[grep('SJ_MAC_3_J', detection_file$`GPS Names`), 'site.code' ] <- 'A15b'
  detection_file[grep('SJ_MAC_4_J', detection_file$`GPS Names`), 'site.code' ] <- 'A15b'
  detection_file[grep('Delt_TC_1', detection_file$`GPS Names`), 'site.code' ] <- 'F1'
  detection_file[grep('Delt_TC_2', detection_file$`GPS Names`), 'site.code' ] <- 'F1'
  detection_file[grep('SJ_JP_1', detection_file$`GPS Names`), 'site.code' ] <- 'A16a'
  detection_file[grep('SJ_JP_2', detection_file$`GPS Names`), 'site.code' ] <- 'A16a'
  detection_file[grep('SJ_JP_3', detection_file$`GPS Names`), 'site.code' ] <- 'A16a'
  detection_file[grep('SJ_JP_4', detection_file$`GPS Names`), 'site.code' ] <- 'A16a'
  detection_file[grep('SJ_JP_5', detection_file$`GPS Names`), 'site.code' ] <- 'A16b'
  detection_file[grep('SJ_JP_6', detection_file$`GPS Names`), 'site.code' ] <- 'A16b'
  detection_file[grep('SJ_JP_7', detection_file$`GPS Names`), 'site.code' ] <- 'A16b'
  detection_file[grep('SJ_JP_8', detection_file$`GPS Names`), 'site.code' ] <- 'A16b'
  detection_file[grep('Chipps1.1', detection_file$`GPS Names`), 'site.code' ] <- 'A17a'
  detection_file[grep('Chipps1.2', detection_file$`GPS Names`), 'site.code' ] <- 'A17a'
  detection_file[grep('Chipps1.3', detection_file$`GPS Names`), 'site.code' ] <- 'A17a'
  detection_file[grep('Chipps1.4', detection_file$`GPS Names`), 'site.code' ] <- 'A17a'
  detection_file[grep('Chipps1.5', detection_file$`GPS Names`), 'site.code' ] <- 'A17a'
  detection_file[grep('Chipps2.1', detection_file$`GPS Names`), 'site.code' ] <- 'A17b'
  detection_file[grep('Chipps2.2', detection_file$`GPS Names`), 'site.code' ] <- 'A17b'
  detection_file[grep('Chipps2.3', detection_file$`GPS Names`), 'site.code' ] <- 'A17b'
  detection_file[grep('Chipps2.4', detection_file$`GPS Names`), 'site.code' ] <- 'A17b'
  detection_file[grep('Chipps2.5', detection_file$`GPS Names`), 'site.code' ] <- 'A17b'
  detection_file[grep('Benicia01', detection_file$`GPS Names`), 'site.code' ] <- 'A18b'
  detection_file[grep('Benicia02', detection_file$`GPS Names`), 'site.code' ] <- 'A18b'
  detection_file[grep('Benicia03', detection_file$`GPS Names`), 'site.code' ] <- 'A18b'
  detection_file[grep('Benicia04', detection_file$`GPS Names`), 'site.code' ] <- 'A18b'
  detection_file[grep('Benicia05', detection_file$`GPS Names`), 'site.code' ] <- 'A18b'
  detection_file[grep('Benicia06', detection_file$`GPS Names`), 'site.code' ] <- 'A18b'
  detection_file[grep('Benicia07', detection_file$`GPS Names`), 'site.code' ] <- 'A18b'
  detection_file[grep('Benicia08', detection_file$`GPS Names`), 'site.code' ] <- 'A18b'
  detection_file[grep('Benicia09', detection_file$`GPS Names`), 'site.code' ] <- 'A18a'
  detection_file[grep('Benicia10', detection_file$`GPS Names`), 'site.code' ] <- 'A18a'
  detection_file[grep('Benicia11', detection_file$`GPS Names`), 'site.code' ] <- 'A18a'
  detection_file[grep('Benicia12', detection_file$`GPS Names`), 'site.code' ] <- 'A18a'
  detection_file[grep('Benicia13', detection_file$`GPS Names`), 'site.code' ] <- 'A18a'
  detection_file[grep('Benicia14', detection_file$`GPS Names`), 'site.code' ] <- 'A18a'
  detection_file[grep('Benicia15', detection_file$`GPS Names`), 'site.code' ] <- 'A18a'
  detection_file[grep('Benicia16', detection_file$`GPS Names`), 'site.code' ] <- 'A18a'
  detection_file[grep('GG1', detection_file$`GPS Names`), 'site.code' ] <- 'A19b'
  detection_file[grep('GG1.5', detection_file$`GPS Names`), 'site.code' ] <- 'A19b'
  detection_file[grep('GG1.7', detection_file$`GPS Names`), 'site.code' ] <- 'A19b'
  detection_file[grep('GG2.1', detection_file$`GPS Names`), 'site.code' ] <- 'A19b'
  detection_file[grep('GG2.5', detection_file$`GPS Names`), 'site.code' ] <- 'A19b'
  detection_file[grep('GG3.1', detection_file$`GPS Names`), 'site.code' ] <- 'A19b'
  detection_file[grep('GG3.5', detection_file$`GPS Names`), 'site.code' ] <- 'A19b'
  detection_file[grep('GG4', detection_file$`GPS Names`), 'site.code' ] <- 'A19b'
  detection_file[grep('GG4.5', detection_file$`GPS Names`), 'site.code' ] <- 'A19b'
  detection_file[grep('GG5.1', detection_file$`GPS Names`), 'site.code' ] <- 'A19b'
  detection_file[grep('GG5.5', detection_file$`GPS Names`), 'site.code' ] <- 'A19a'
  detection_file[grep('GG6', detection_file$`GPS Names`), 'site.code' ] <- 'A19a'
  detection_file[grep('GG6.5', detection_file$`GPS Names`), 'site.code' ] <- 'A19a'
  detection_file[grep('GG7', detection_file$`GPS Names`), 'site.code' ] <- 'A19a'
  detection_file[grep('GG7.2', detection_file$`GPS Names`), 'site.code' ] <- 'A19a'
  detection_file[grep('GG7.5', detection_file$`GPS Names`), 'site.code' ] <- 'A19a'
  detection_file[grep('GG7.7', detection_file$`GPS Names`), 'site.code' ] <- 'A19a'
  detection_file[grep('GG8', detection_file$`GPS Names`), 'site.code' ] <- 'A19a'
  detection_file[grep('GG8.4', detection_file$`GPS Names`), 'site.code' ] <- 'A19a'
  detection_file[grep('GG9', detection_file$`GPS Names`), 'site.code' ] <- 'A19a'
  return(detection_file)
}

# Add site codes:
truncated_dets_up<- add_array_codes(truncated_dets_up)
truncated_dets_ds<- add_array_codes(truncated_dets_ds)

# Check to make sure every site has an array code:
array_code_NAs_upper<- truncated_dets_up %>% 
  filter(is.na(site.code))
unique(array_code_NAs_upper$`GPS Names`)

array_code_NAs_delta<- truncated_dets_ds %>% 
  filter(is.na(site.code)) 
unique(array_code_NAs_delta$`GPS Names`)

#### Make Array Code ------------------------------
# the array code is the code for all the receivers at a location, so it removes the a and b in the dual arrays. 
# gsub function: setting what you want to remove as "[a-z]" allows you to match a pattern and remove all those patterns
# so this means any lowercase letter will be removed, and replaced with nothing (""). ie A11a becomes A11

truncated_dets_up<- truncated_dets_up %>% 
  mutate(array.code = gsub("[a-z]", "", truncated_dets_up$site.code)) # also works with just "[a-b]"

truncated_dets_ds<- truncated_dets_ds %>% 
  mutate(array.code = gsub("[a-z]", "", truncated_dets_ds$site.code)) # also works with just "[a-b]"

# ><)))))*>  ------------- ><)))))*>  ------------- ><)))))*>  ------------- ><)))))*>  ------------- ><)))))*>  
# Simplifying Detection History:

####Arrange by Hex and datetime, combine hex and site code to make unique field---------------------------------
truncated_dets_up <- truncated_dets_up %>% 
  arrange(Hex, dtf) %>% 
  mutate(combo = paste0(Hex, site.code))

truncated_dets_ds <- truncated_dets_ds %>% 
  arrange(Hex, dtf) %>% 
  mutate(combo = paste0(Hex, site.code))

#### Keep first and last dets per visit ------------------------------------------------------------------------
#### arrange by Hex and datetime combine hex and Detct_Location to make a unique field 
upper_visit <- truncated_dets_up %>% 
  arrange(Hex, dtf) %>%
  mutate(combo = (paste0(Hex, site.code)))

delta_visit <- truncated_dets_ds %>% 
  arrange(Hex, dtf) %>%
  mutate(combo = (paste0(Hex, site.code)))

# count dets at each receiver (then, keep all 1's and max in each sequence)
upper_visit$counter <- sequence(rle(upper_visit$combo)$lengths)# rle() function counts the number of times a specific combo occur and 
# stores that in a list. For example: there are 16 detections of BA5B so for that combo it would be stored as length = 16. wrapping sequence() around
# this then makes a squence of that number. so 16 becomes 1, 2, 3, 4, ...16. These sequences of numbers are then stored in the counter column
upper_visit$first_or_last <- (lead(upper_visit$counter)-upper_visit$counter)==1 # This line of code says: in the counter vector, subtract the next
# number ( controlled by the lead () function) in the vector from the previous number in the vector. If it equals one, in the row in the column
# first_or_last will say TRUE, meaning it is the next number in the sequence for that combo (or really detection). If it does not equal 1 it will say
# FALSE instead, which means the first number for the next tag at the next receiver (ie the next combo) has been reached, and therefore the rows where
# it sayd false is the last detection of that tag at that receiver. 
# SO IN SUMMARY: TRUE means it is the next detction in that sequence of detection for that tag at that receiver. FALSE means it is the last detection
# of that tag at that receicer for that sequence.

delta_visit$counter <- sequence(rle(delta_visit$combo)$lengths)
delta_visit$first_or_last <- (lead(delta_visit$counter)-delta_visit$counter)==1

# filter to keep first and last dets ***double check with original df to see if the code worked
UpRel_visits2019_firstlast <- upper_visit %>% 
  filter(counter==1|first_or_last==FALSE) # this is keeping just the first in the cou ter column and the last detection (denoted by FALSE in the 
# first_or_last column)
nrow(UpRel_visits2019_firstlast)

DeltaRel_visits2019_firstlast <- delta_visit %>% 
  filter(counter==1|first_or_last==FALSE)
nrow(DeltaRel_visits2019_firstlast)

# Save:
#write_csv(UpRel_visits2019_firstlast, "data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/UpRel_visits2019_firstlast_All_NOAAdata_120819.csv")
#write_csv(UpRel_visits2019_firstlast, "data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/UpRel_visits2019_firstlast_All_NOAAdata_010320FINAL.csv")
write_csv(UpRel_visits2019_firstlast, "data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/UpRel_visits2019_firstlast_All_NOAAdata_010320FINAL_2.csv")

#write_csv(DeltaRel_visits2019_firstlast, "data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/DeltaRel_visits2019_firstlast_All_NOAAdata_120819.csv")
#write_csv(DeltaRel_visits2019_firstlast, "data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/DeltaRel_visits2019_firstlast_All_NOAAdata_010320FINAL.csv")
write_csv(DeltaRel_visits2019_firstlast, "data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/DeltaRel_visits2019_firstlast_All_NOAAdata_010320FINAL_2.csv")

# filter to keep first dets
UpRel_visits2019_first <- upper_visit %>% 
  filter(counter==1)
nrow(UpRel_visits2019_first)

DeltaRel_visits2019_first <- delta_visit %>% 
  filter(counter==1)
nrow(DeltaRel_visits2019_first)

#write_csv(UpRel_visits2019_first, "data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/UpRel_visits2019_first_All_NOAAdata_120819.csv")
#write_csv(UpRel_visits2019_first, "data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/UpRel_visits2019_first_All_NOAAdata_010320FINAL.csv")
write_csv(UpRel_visits2019_first, "data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/UpRel_visits2019_first_All_NOAAdata_010320FINAL_2.csv")

#write_csv(DeltaRel_visits2019_first, "data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/DeltaRel_visits2019_first_All_NOAAdata_120819.csv")
#write_csv(DeltaRel_visits2019_first, "data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/DeltaRel_visits2019_first_All_NOAAdata_010320FINAL.csv")
write_csv(DeltaRel_visits2019_first, "data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/DeltaRel_visits2019_first_All_NOAAdata_010320FINAL_2.csv")

# ><)))))*>  ------------- ><)))))*>  ------------- ><)))))*>  ------------- ><)))))*>  ------------- ><)))))*>  

################################################ end of code for analysis ######################################################################
################################################################################################################################################
################################################################################################################################################
################################################################################################################################################

# Below is the Code Colby wrote to keep first and last detections. for some reason it keeps 138 less detectopns than gabe's code 
# so use Gabe's code for the actual analyis. This is just so you have the code on hand if you need it:

#Make vector of unique tags:
upper_tags <- unique(truncated_dets_up$Hex)
print(upper_tags)

delta_tags <- unique(truncated_dets_ds$Hex)
print(delta_tags)

#Make vector of unique sites:
#upper_sites <- unique(truncated_dets2018_upper$site.code)
upper_combo <- unique(truncated_dets_up$combo)
print(upper_combo)
delta_combo <- unique(truncated_dets_ds$combo)
print(delta_combo)

#Make empty dataframe
df_first_last_upper2019 <- NULL

# Make df of first and last detections for upper release group:
for(tag in upper_tags) {
  print(tag)
  tag2 <- subset(truncated_dets_up, truncated_dets_up$Hex == tag)
  if(nrow(tag2) > 0) {
    for (site in upper_combo) {
      rec2 <- subset(tag2, tag2$combo == site)
      if (nrow(rec2)>0) {
        first_det <- min(rec2$dtf)
        last_det <- max(rec2$dtf)
        rkm <- rec2$rkm[1]
        Location <- rec2$'GPS Names'[1]
        array_code <- rec2$array.code[1]
        df_first_last_upper2019 <- rbind(df_first_last_upper2019,data.frame(tag, site, array_code, Location, first_det, last_det, rkm))
      }
    }
  }
}

# Make df of first and last detections for delta release group:
df_first_last_delta2019 <- NULL

for(tag in delta_tags) {
  print(tag)
  tag2 <- subset(truncated_dets_ds, truncated_dets_ds$Hex == tag)
  if(nrow(tag2) > 0) {
    for (site in delta_combo) {
      rec2 <- subset(tag2, tag2$combo == site)
      if (nrow(rec2)>0) {
        first_det <- min(rec2$dtf)
        last_det <- max(rec2$dtf)
        rkm <- rec2$rkm[1]
        Location <- rec2$'GPS Names'[1]
        array_code <- rec2$array.code[1]
        df_first_last_delta2019 <- rbind(df_first_last_delta2019,data.frame(tag, site, array_code, Location, first_det, last_det, rkm))
      }
    }
  }
}

#Save to data_output:

write_csv(df_first_last_upper2019, "data_output/UpRel_visits2019_firstlast.csv")
saveRDS(df_first_last_upper2019, "data_output/UpRel_visits2019_firstlast.rds")
write_csv(df_first_last_delta2019, "data_output/DeltaRel_visits2019_firstlast.csv")
saveRDS(df_first_last_delta2019, "data_output/DeltaRel_visits2019_firstlast.rds")


# Below I am comparing Colby and Gabe's code for first and last detection to see if they give the same output:
#GABE'S:
# Keep First and Last Detection per Visit ---------------------------------
# arrange by Hex and datetime combine hex and Detct_Location to make a unique field 

visit <- truncated_dets_up %>% 
  arrange(Hex, dtf) %>%
  mutate(combo = (paste0(Hex, site.code)))

# count dets at each receiver (then, keep all 1's and max in each sequence)
visit$counter <- sequence(rle(visit$combo)$lengths)

visit$first_or_last <- (lead(visit$counter)-visit$counter)==1

# filter to keep first and last dets ***double check with original df to see if the code worked
visits2019_firstlast_GABEs<- visit %>% 
  filter(counter==1|first_or_last==FALSE)

# Compare Colby's to Gabe's Code;
nrow(visits2019_firstlast_GABEs) # 4681 because it has a first detection and last detection on seperate lines
nrow(df_first_last_upper2019) # CODE WAS RUN FURTHER UP IN SCRIPT. 2387 bc has first and last detection on same line 

df_first_last_upper2019 <- read_csv("data_output/UpRel_visits2019_firstlast.csv")
colnames(df_first_last_upper2019)[2] <- "combo"
anti_join(df_first_last_upper2019, visits2019_firstlast_GABEs, by = "combo")
anti_join(visits2019_firstlast_GABEs, df_first_last_upper2019, by = "combo")

# filter to keep first dets
visits2019_firstlast_GABEs_first <- visit %>% 
  filter(counter==1)
nrow(visits2019_firstlast_GABEs_first) # 2525 compared to 2387, so adifference of 138, going to go with Gabes Code....

write_csv(visits2018_firstlast, "data_output/UpRel_visits2019_firstlast_GabesCode.csv")


#############################################################################################################################

##attempt at turning this into a function....not working----------------------------------------------------
#Before running function, make tag vector, site location name vector, and output dataframe (as NULL)
df_first_last_upper_test <- NULL
first_last_dets <- function(df,output_df_name, datetime_column_name, site_column_name, tag_vector, rec_vector) {
  for (tag in tag_vector) {
    print(tag)
    tag2<- subset(df, df$Hex == tag)
    if (nrow(tag2) >0) {
      for (rec in rec_vector) {
        #print(rec)
        rec2 <- subset(tag2, tag2$site_column_name == rec)
        if (nrow(rec2) >0) {
          first_det <- min(rec2$datetime_column_name)
          last_det <- max(rec2$datetime_column_name)
          tag_rkm <- rec2$rkm[1]
          #print(tag_rkm)
          output_df_name <- rbind(output_df_name, data.frame(tag, rec, first_det, last_det, tag_rkm))
        }        
      } 
    }   
  }
  #return(output_df_name)
}

first_last_dets(truncated_dets2018_upper, df_first_last_upper_test, DetectDateTime, Detect_Location, upper_tags, upper_sites)


