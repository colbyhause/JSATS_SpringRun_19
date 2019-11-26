# Determining if the number of Chipps and GG detection from the original raw files that Arnold sent match up with the ones he sent
#  in the file that came off of the real time data.

library(tidyverse)

dat_RT <- read_csv("data/Files_From_NOAA/JSATS_Filter_SJ_Scarf_2019_20190919_2111_B.csv") # this file is from Arnold, it is all 
#the RT data he pulled from the Bridges combined ito one file 
  
dat_manualDL <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/2019_UCDdets_GG_Chipps_AllGroups_RAW.csv")

chipps <- dat_RT[grep("Chipps", dat_RT$LOC), ] 
nrow(chipps) # 13035 compared to 13799 in the database
length(unique(chipps$Hex)) # 45 tags 

GG <- dat_RT[grep("GG", dat_RT$LOC), ] 
nrow(GG) # 3794 from RT file compared to 4036 in the access database 
length(unique(GG$Hex)) # 34 tags


chipps_md <- dat_manualDL[grep("Chipps", dat_manualDL$`GPS Names`), ] 
nrow(chipps_md) #13799 
length(unique(chipps_md$TagID_Hex)) # 45 tags - same as the one from the RT download.


GG_md <- dat_manualDL[grep("GG", dat_manualDL$`GPS Names`), ] 
nrow(GG_md) # 4036 in the access database 
length(unique(GG_md$TagID_Hex)) # 34 tags: matches the number of tags from the RT file 


###################################### CONCLUSION ######################################################################
# While the UCD filter kept more data than the NOAA filter, both filters kept the same number of tags, which is most important.
# Can conlcude that it is fine to use the data from the NOAA filtered file 