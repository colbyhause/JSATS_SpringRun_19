# This script is to compare the files from receivers that I downloaded in June vs the same recs that I downloaded in August- just
# to make sure I that no new fish were detected between that time so I don't have to put new files in the data base
library(tidyverse)
RGU_june<-read_csv("data/Comparing_Pump_files/0023_2015-6041_accepted_JuneDL.csv")
RGU_august <- read_csv("data/Comparing_Pump_files/0001_2015-6041_accepted_AugustDL.csv")

length(unique(RGU_june$Hex))
length(unique(RGU_august$Hex))

RGU_june_tags<- unique(RGU_june$Hex)
RGU_aug_tags <- unique(RGU_august$Hex)

RGU_june_tags[ RGU_aug_tags %in%RGU_june_tags]

RGU_aug_tags %in%RGU_june_tags
RGU_june_tags%in%RGU_aug_tags

#BB46 is in the june DL and not in the AUg DL. There are only 3 detections of this tag but it makes no sense as to why it is making 
#it through for one file and not the other. Both files are using the 3 hit filter.
# What I figured out: one detection from BB46 is missing from the RAW file in the Aug DL but it IS in the June file. The difference 
# in DLs was one was from the underwater cable and the other was from SD extract.Im not going to worry about this too much now 
# because the file that is in the database is bigger than the one that is not, but should look into comparing SD extract vs uw cable DL
# files at a later date.

CCi_june<-read_csv("data/Comparing_Pump_files/0026_2015-6046_accepted_June.csv")
CCi_august <- read_csv("data/Comparing_Pump_files/0001_20156046_accepted_Aug.csv")

length(unique(CCi_june$Hex))
length(unique(CCi_august$Hex))

CCi_june_tags<- unique(CCi_june$Hex)
CCi_august_tags <- unique(CCi_august$Hex) # same number of tags 


