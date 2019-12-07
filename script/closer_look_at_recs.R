### This ic code to look and see at how many fish were detected at certain locations, also to pull out all the dtection histories 
### of tags detected at a certain receiver so you know how fish traveled so you can better inform your model

library(tidyverse)
# First: run the fishcheck function located in script folder (rkm_plotcode_eachTag_GS.R)
# Load your csvs:
dets<- read_csv("data_output/DetectionFiles/dets_allgroups.csv") 
dets_edited_for_model<- read_csv("data_output/DetectionFiles/dets_allgroups_formodel.csv")
dets_up_forModel<- read_csv("data_output/DetectionFiles/dets_up_forModel.csv")
dets_ds_forModel<-read_csv("data_output/DetectionFiles/dets_ds_forModel.csv")

# Looking at OR HWY4 dets and detection history of each of those tags:
CCintake_dets <- dets_edited_for_model[dets_edited_for_model$`GPS Names`==" CC_intake_J", ] # none at the intake

dets<- dets_edited_for_model
OR_hwy4_dets <- dets[dets$`GPS Names`==" OR_hwy4_2_J" | dets$`GPS Names`== "OR_hwy4_1_J" |dets$`GPS Names`== "OR_hwy4_4_J" | 
                       dets$`GPS Names`== "OR_hwy4_3_J", ]
length(unique(OR_hwy4_dets$Hex)) # 
unique(OR_hwy4_dets$Hex)
# looking at a couple of these det histories:
ORHWY4_tags <- dets_edited_for_model[dets_edited_for_model$Hex == "BA69"|
                                       dets_edited_for_model$Hex =="BA6C"|
                                       dets_edited_for_model$Hex =="BA89"|
                                       dets_edited_for_model$Hex =="BA99"|
                                       dets_edited_for_model$Hex =="BA9D"|
                                       dets_edited_for_model$Hex =="BAB8", ]

write_csv(ORHWY4_tags, "data_output/ORHWY4_tags.csv")

# Looking at MR HWY4 dets and detection history of each of those tags:
MR_hwy4_dets <- dets[dets$`GPS Names`==" MidR_hwy4_2_J" | dets$`GPS Names`== "MidR_hwy4_1_J" |dets$`GPS Names`== "MidR_hwy4_4_J" | 
                       dets$`GPS Names`== "MidR_hwy4_3_J", ]
length(unique(MR_hwy4_dets$Hex)) # only 7 fish detected at MrHwy4
unique(MR_hwy4_dets$Hex)
MRHWY4_tags <- dets_edited_for_model[dets_edited_for_model$Hex == "BA8E"|
                                       dets_edited_for_model$Hex =="C24A"|
                                       dets_edited_for_model$Hex =="C515"|
                                       dets_edited_for_model$Hex =="C596"|
                                       dets_edited_for_model$Hex =="C8D5"|
                                       dets_edited_for_model$Hex =="C976"|
                                       dets_edited_for_model$Hex =="CB2B", ]

write_csv(MRHWY4_tags, "data_output/MRHWY4_tags.csv")
# notes on MR_HWY4Tags:
# BA8E: orhor -> CVPU -> MRHWY4 ->X NEED TO CUT CVPU OUT OF THIS ONE 
# C24A: ORHOR -> MRHWY4 ->X
# C515: ORHOR -> MRHWY4 ->X
# C8D5: HOR -> MRHWY4 -> X
# C976: ORHOR -> MRHWY4 -> ORHWY4 ->X NEED TO FIX THIS ONE: end at MRHWY4
# CB2B: ORHOR -> MRHWY4 ->X
# # So looks like all fish detected at MRHWY4 died after that receiver 



# Just looking at upper river fish at MRHwy4:
MRHWY4_tags_upper <- dets_up_forModel[dets_up_forModel$Hex == "BA8E"|
                                  dets_up_forModel$Hex =="C24A"|
                                  dets_up_forModel$Hex =="C515"|
                                  dets_up_forModel$Hex =="C596"|
                                  dets_up_forModel$Hex =="C8D5"|
                                  dets_up_forModel$Hex =="C976"|
                                  dets_up_forModel$Hex =="CB2B", ]
length(unique(MRHWY4_tags_upper$Hex))
# trying to write a loop to see how many tags were detected at both gates at MR_HWy4, did not get loop working
same_dets <- NULL
for (i in 1:nrow(MR_hwy4_dets)) {
  dets_MR <- MR_hwy4_dets[order(MR_hwy4_dets$dtf), ]
  first<- dets_MR$dtf[1]
  second <- dets_MR$dtf[1+1]
  if (first-second == 0) {
    same_det1 <- dets_MR[i]
    same_det2 <- dets_MR[i+1]
    same_dets <- rbind(same_dets, data.frame(same_det1, same_det2))
  } else {
    next
    }
  if (is.na(first) == T | is.na(second) == T) {
    break
  }
}


# Looking at Tc dets and detection history of each of those tags:
TC_dets <- dets[dets$`GPS Names`==" Delt_TC_1_J" | dets$`GPS Names`== "Delt_TC_2_J", ] 
length(unique(TC_dets$Hex)) # 18 fish detected at TC
unique(TC_dets$Hex)
TC_tags <- dets_edited_for_model[dets_edited_for_model$Hex == "BA62"| dets_edited_for_model$Hex =="BA72" | 
                                   dets_edited_for_model$Hex =="BB2A"| dets_edited_for_model$Hex == "BB6E"|
                                   dets_edited_for_model$Hex =="BBD5"|dets_edited_for_model$Hex == "BC52" |
                                   dets_edited_for_model$Hex =="BD14"| dets_edited_for_model$Hex =="BD6B0"|
                                   dets_edited_for_model$Hex =="BDAE"|dets_edited_for_model$Hex == "BDCA"|
                                   dets_edited_for_model$Hex =="C5A4"|dets_edited_for_model$Hex == "C6A6"|
                                   dets_edited_for_model$Hex =="C92C"|dets_edited_for_model$Hex == "C932"|
                                   dets_edited_for_model$Hex =="C9A5"|dets_edited_for_model$Hex == "CA7A"|
                                   dets_edited_for_model$Hex =="CAF2"|dets_edited_for_model$Hex == "CB45", ]
write_csv(TC_tags, "data_output/TC_tags.csv")
length(unique(TC_tags$Hex))
# of the tags listed above, 4 showed detection histories that involved back and forth btwn MAC and TC, which wont fit the model 
# but these were not noticed when going through the individual tag plots. Figure out why:
fishcheck("BBD5", dets, file_location = "figure_output/")
fishcheck("C932", dets, file_location = "figure_output/")
fishcheck("BDAE", dets, file_location = "figure_output/")
fishcheck("C92C", dets, file_location = "figure_output/")

#MR OR dets
MR_OR_dets <- dets[dets$`GPS Names`== "MidR_OR_1_J", ] 
length(unique(MR_OR_dets$Hex)) # no fish detected at MROR 

#OR MR dets
OR_MR <- dets[dets$`GPS Names`=="  OR_MidR_1_J" | dets$`GPS Names`== "OR_MidR_2_J", ] 
length(unique(OR_MR$Hex)) # also no fish detected at MROR
ORMR1<-dets[dets$RecSN == 20176022, ]  # just doubling checking with recsn
nrow(dets[dets$RecSN == 20176022, ] )  # just doubling checking with recsn
ORMR2<- dets[dets$RecSN == 20156009, ] # just doubling checking with recsn
nrow(dets[dets$RecSN == 20156009, ] )  # just doubling checking with recsn


###############################################################################################################################
###############################################################################################################################
# Mon Sep 23 09:04:03 2019 ------------------------------
#Looking at JP IDs to pull out the one that goes from B1 to JP bc that hostory does not fit the simplified flame model
library(tidyverse)
dat <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/det_up_PF16_ModelEdited_relLoc_GG_chipps.csv")

jp <- subset(dat, dat$Genrkm == 93.04 | dat$Genrkm == 93.74)
unique(jp$Hex)             

# BADB was the one I was looking for. Goes from B1 to JP
###############################################################################################################################
###############################################################################################################################
# Tue Sep 24 10:09:56 2019 ------------------------------
# Look at JP IDs to pull out the one that goes from B1 to JP bc that hostory does not fit the simplified flame model

dat<- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/dets_ds_PF16_ModelEdited_relLoc_GG_Chipps_092319.csv")

jp <- subset(dat, dat$Genrkm == 93.04 | dat$Genrkm == 93.74)
unique(jp$Hex)
# These are the 4 tags:
# "C26A"
#"CBA9"
#"CB5D"
#"CA98"

###############################################################################################################################
###############################################################################################################################
# Fri Dec 06 16:54:32 2019 ------------------------------

# When loading counts into model, I saw that there were 2 fish with E2 to A4 encounter histories. Here is how I pulled out these tag IDS:
 
data <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/UpRel_visits2019_first_All_NOAAdata_120319.csv")
# First i had to make the encouster history matrix in script Make_cond_counts_w_Aux_upp_2019

dat <- data.frame(enc.hist)
bad <- dat %>% 
  filter(E2 == 1 & A14 == 1)

# then run the fish check function to see these detection histories

# these 2 fish have E2 to A14 encounter histories- need to edit 
fishcheck("BD44", data, "figure_output/")  
fishcheck("BD50", data, "figure_output/") 
 
 
 