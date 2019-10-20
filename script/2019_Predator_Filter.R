#Use this code to specify the amount of upstream movement considered as "predation" and then filter out those 
#detections. min_distance_rkm is the distance you set for the removal of detections: any fish that has moved that value 
#or more upstream will be removed from data set

library(tidyverse)

# First Run the upriver_movement_jsats function in the Rmd: 
# C:\Users\chause\Documents\GitHub\JSATS_SpringRun_19\script\Predator_removal_Code.Rmd

# read in detection files for each group:
dets<- read_csv("data_output/DetectionFiles/dets_allgroups.csv") 
dets_up<- read_rds("data_output/upper_dets_raw.rds")
dets_ds<- read_rds("data_output/delta_dets_raw.rds")

#Run fucntion on data:
#(the removed detections file will just get dropped in your working directory, change the name and add it to the 
#appropriate folder)
all_dets_pred_filtered_16<- upriver_movement_jsats(dets, dets, 16) 
write_csv(all_dets_pred_filtered_16, "data_output/Predator_Filter/AllDets_PredFiltered_16.csv")


upperDets_pred_filtered_16 <- upriver_movement_jsats(dets_up, dets_up, 16) 
write_csv(upperDets_pred_filtered_16, "data_output/Predator_Filter/UpperDets_PredFiltered_16.csv")

DeltaDets_pred_filtered_16 <- upriver_movement_jsats(dets_ds, dets_ds, 16) 
write_csv(DeltaDets_pred_filtered_16, "data_output/Predator_Filter/DeltaDets_PredFiltered_16.csv")


##################################################################################################################################
# Running predator filter on detectfile file that now inlcudes Chipps and GG data
# # Tue Sep 17 10:31:56 2019 ------------------------------

library(tidyverse)
# First Run the upriver_movement_jsats function in the Rmd: 
# C:\Users\chause\Documents\GitHub\JSATS_SpringRun_19\script\Predator_removal_Code.Rmd

# read in detection files for each group:
dets<- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/2019_UCDdets_GG_Chipps_AllGroups_formatted.csv") 
dets_up<- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/upper_UCDdets_GG_Chipps_formatted.csv")
dets_ds<- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/upper_UCDdets_GG_Chipps_formatted.csv")

#Run fucntion on data:
#(the removed detections file will just get dropped in your working directory, change the name and add it to the 
#appropriate folder)
all_dets_pred_filtered_16<- upriver_movement_jsats(dets, dets, 16) 
write_csv(all_dets_pred_filtered_16, "data_output/DetectionFiles/Files_w_Bridge_Data/AllDets_w_GG_Chipps_pred_filt16.csv")

upperDets_pred_filtered_16 <-subset(all_dets_pred_filtered_16, all_dets_pred_filtered_16$Rel_group == "2019UP")
write_csv(upperDets_pred_filtered_16, "data_output/DetectionFiles/Files_w_Bridge_Data/UpperDets_w_GG_Chipps_pred_filt16.csv")

DeltaDets_pred_filtered_16 <- subset(all_dets_pred_filtered_16, all_dets_pred_filtered_16$Rel_group == "2019DS")
write_csv(DeltaDets_pred_filtered_16,"data_output/DetectionFiles/Files_w_Bridge_Data/DeltaDets_w_GG_Chipps_pred_filt16.csv")


