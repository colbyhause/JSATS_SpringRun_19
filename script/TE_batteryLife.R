# Plotting Tag Effect tank data

library(ggplot2)
library(tidyverse)
library(lubridate)


#truncate raw file so it goes quicker through filter
te.dat.raw <- read.csv("Z:/Shared/Projects/JSATS/DSP_Spring-Run Salmon/2019/2019DOWNLOADS/TagEffectsTank2019/052019/Lotek117_052019_WHSfiltered.csv")
trunc_dat <- te.dat.raw [39546574:nrow(te.dat.raw), ]
write.csv(trunc_dat, "Z:/Shared/Projects/JSATS/DSP_Spring-Run Salmon/2019/2019DOWNLOADS/TagEffectsTank2019/052019/Lotek117_052019_trunc.csv")

#FILTER FILE USING UCD FILTER
#
#
#
#read in UCD filtered Lotek data: 
te.dat <- read.csv("C:/Users/chause/Documents/2019Filtering/2019FILTERED/TEfiltering/accepted/0001_117_accepted.csv")

# dd just a day column
te.dat <- te.dat %>% 
  mutate(day = format(as.Date(dtf), '%Y-%m-%d'))
as.character(te.dat$day)
class(te.dat$day)

# group by day and add up how many different tags detected per day
tags.on <- te.dat %>% 
  group_by(day, Hex) %>% 
  tally()

# Make table of thw porpotion of tags still on 
prop.on <- summarize(tags.on, tags_detected = n_distinct(tags.on$Hex)) %>% 
  mutate(proportion_on  = tags_detected/50)

# Tue Mar 17 09:06:14 2020 ------------------------------
########### Making the file input for Atlas program: the tag life progam developed by UW that Rebecca Buchannan suggested ########### 
# Read in the final csv from lotek that was only filtered through the WHS host software program, this was NOT filtered by Matt's 
# filter bc it was so big it kept crashing R
library(tidyverse)
TEdat <- read_csv("Z:/Shared/Projects/JSATS/DSP_Spring-Run Salmon/2019/2019DOWNLOADS/TagEffectsTank2019/061619/030320_Lotek117_2019TETank_ProcessedFile_Final.csv")

saveRDS(TEdat,"data_output/TagEffects/2019_TEdata_complete.rds")
TEdat<- read_rds("data_output/TagEffects/2019_TEdata_complete.rds") 

colnames(TEdat) <- c("datetime", "FracSec", "Dec", "Hex", "SigStr")

# convert date function (from Matts code):
lotekDateconvert <- function(x,tz="Etc/GMT+8") {
  return (
    as.POSIXct(
      as.character(
        as.POSIXct(round(x*60*60*24), origin = "1899-12-30", tz = "GMT"),
        format="%Y-%m-%dT%H:%M:%OSZ", tz="GMT" 
      ),format="%Y-%m-%dT%H:%M:%OSZ", tz=tz
    ) )
}

# Try running a fraction of the csv in Matts filter 
TEdat_partial <- TEdat[c((nrow(TEdat)-1000):nrow(TEdat)), ]
# write to a csv:
write_csv(TEdat_partial, "data_output/TagEffects/2019_TEdata_partial.csv")

TEpartial<- read_csv("data_output/TagEffects/2019_TEdata_partial.csv")
TEpartial2 <-  TEpartial[c((nrow(TEpartial)-1000):nrow(TEpartial)), ]
write_csv(TEpartial2, "data_output/TagEffects/2019_TEdata_partial_1000.csv")

# seeing the first date in my csv:
class(TEdat[[1]])
lotekDateconvert(TEdat[[1, 1]]) # FIRST DETECTION WAS ON "2019-03-01 15:36:23 -08"

# Fix the data for the datetime column
TEdat$datetime <- lotekDateconvert(TEdat[[1]]) 
saveRDS(TEdat,"data_output/TagEffects/2019_TEdata_complete_dateCorrected.rds")
TEdat <- read_rds("data_output/TagEffects/2019_TEdata_complete_dateCorrected.rds") #START HERE#####

# FOR THE ATLAS PROGRAM, THE DATA FORMAT NEEDS TO BE:
# tag_life_days
#43.56866898
#45.99928241
#44.20954861
#So basically just a list of the number of days each tag lasted
#
#For the vitality package in R, the data format needs to be:
#   days     survival
#1	3.65e-06	1.000
#2	1.00e+00	0.999
# so basically a list of each day (1, 2, 3, 4 etc..) and the respective percentage of tags still turned on

# ATLAS format:-----

# Testing it out before putting into a for loop:
tagID <- subset(TEdat, TEdat$Hex == "BDA6")

test <- tagID %>% 
  mutate(day_only = format(as.Date(datetime), '%Y-%m-%d')) %>% 
  group_by(day_only, Hex) %>% 
  tally()

taglife<- mutate(test, Hex = test$Hex[1], total_days = as.numeric(as.Date(test$day_only[nrow(test)]) - as.Date(test$day_only[1])))
taglife_df <- rbind(taglife_df, data.frame("tagID" = taglife$Hex[1], "days" = taglife$total_days[1]))

# it works

# ATLAS For loop:-----
taglist <- unique(TEdat$Hex)
taglife_ATLAS <- NULL

for(tag in taglist) {
  print(tag)
  tagID <- subset(TEdat, TEdat$Hex == tag)
  tag_subset <- tagID %>% 
    mutate(day_only = format(as.Date(datetime), '%Y-%m-%d')) %>% 
    group_by(day_only, Hex) %>% 
    tally()
  taglife<- mutate(tag_subset, Hex = tag_subset$Hex[1], total_days = as.numeric(as.Date(tag_subset$day_only[nrow(tag_subset)]) - as.Date(tag_subset$day_only[1])))
  taglife_ATLAS <- rbind(taglife_ATLAS, data.frame("tagID" = taglife$Hex[1], "days" = taglife$total_days[1]))
  #return()
}
# write to csv:
write_csv(taglife_ATLAS, "data_output/TagEffects/taglife_forATLAS.csv")
# edit for correct input to ATLAS program:
taglife_ATLAS_edited <- data.frame(taglife_ATLAS[, 2])
colnames(taglife_ATLAS_edited) <- "tag_life_days"
write_csv(taglife_ATLAS_edited, "data_output/TagEffects/taglife_forATLAS_edited.csv")

# VITALITY FORMAT:-----
#  so basically a list of each day (1, 2, 3, 4 etc..) and the respective percentage of tags still turned on
# # group by day and add up how many different tags detected per day

# testing out before putting into a loop: 
TEdat_days <- mutate(TEdat, day = format(as.Date(datetime), '%Y-%m-%d'))
date_list <- unique(TEdat_days$day)

date <- subset(TEdat_days, TEdat_days$day == as.character("2019-03-01"))

test <- date %>% 
  group_by(day, Hex) %>% 
  tally()

taglife<- data.frame("day" = test$day[1], survival = length(unique(test$Hex))/50)


taglife_df <- rbind(taglife_df, data.frame("tagID" = taglife$Hex[1], "days" = taglife$total_days[1]))

# vitality for loop ----
taglife_vitality <- NULL
for (date in date_list) {
  print(date)
  date_subset <- subset(TEdat_days, TEdat_days$day == date)
  surv_by_date <- date_subset %>% 
    group_by(day, Hex) %>% 
    tally()
  taglife_df <- data.frame("day" = date, "survival" = length(unique(surv_by_date$Hex))/50)
  taglife_vitality <- rbind(taglife_vitality, data.frame(taglife_df))
}
write_csv(taglife_vitality, "data_output/TagEffects/taglifedf_forVitalityModel_R.csv")

# Now, checking to see when the last detections at GG ocurrred:
UpperRelDets_2019_firstlast <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/A11_site_removed/UpRel_visits2019_firstlast_All_NOAAdata_012820FINAL_HWy4sPooled_NoA11.csv")
DeltaRelDets_2019_firstlast <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/FULLmodel_final/Full_Model_Edited/A11_site_removed/DeltaRel_visits2019_firstlast_All_NOAAdata_012820FINAL_Hwy4sPooled_NoA11.csv")

merged_dets_firstlast <- rbind(UpperRelDets_2019_firstlast, DeltaRelDets_2019_firstlast)

# see when the last fish was detected anywhere:
last_det <- max(merged_dets_firstlast$dtf) # "2019-05-29 01:06:45 UTC"
which(merged_dets_firstlast$dtf == last_det ) #10774
merged_dets_firstlast[10774, ] # detected at cvpu,  tag = BCA5

# looking at the last tag detected at GG:
GG <- merged_dets_firstlast %>% 
  filter(Genrkm < 2)
last_GG <- max(GG$dtf) #"2019-05-06 04:14:37 UTC" This is the last tag detected at GG


# 100% of tags were running on 5/29, so conclude no adjustments for battery life needed for the model 
# only 3 tags were shed during study the study window, not sure if that warrants investigation 

# make tag life plot
class(taglife_vitality$day)
taglife_curve <- ggplot(data = taglife_vitality, mapping = aes(x = as.Date(taglife_vitality$day), y = taglife_vitality$survival)) +
  geom_line() +
  xlab("Date")+
  ylab("Tags Detected (%)")+
  ggtitle("2019 Tag Life Curve")+
  geom_vline(xintercept = as.numeric(as.Date("2019-03-01")), linetype=4, col = "blue") +
  geom_vline(xintercept = as.numeric(as.Date("2019-05-29")), linetype=4, col = "blue") +
  theme_minimal()
ggsave(filename = "figure_output/TagEffects/2019TagBatteryLifePlot.pdf")
