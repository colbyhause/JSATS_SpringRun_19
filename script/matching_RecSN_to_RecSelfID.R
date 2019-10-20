# Checking to make sure all the receivers in the database match the naming in the receiver self-id column of the inventory. This is to 
# be able to establish referential integrity in the relationship btwn RecSN and REcSelfID in access

library(tidyverse)

# replace the file below with whichever file you exported from the detections table from access
dets_access <- read_csv("data/t2019TagDetections_fromAccess080919.csv") 
rec_inventory <- read_csv("data/2019ReceiverInventory.csv")

inv_ids <- rec_inventory$ReceiverSelfID # rec self IDs from the inventory table
rec_ids <- unique(dets_access$RecSN) # recSNs from the access detections table 

in_inv <- inv_ids %in% rec_ids # sees if the ids in the inventory table are present in the access database
inv_ids[in_inv == F] # look at all the ids that show that they are in the inventory table but not in the access db
rec_ids[order(rec_ids)] # put them into ascending order


in_access <- rec_ids %in% inv_ids # sees if the ids in the access table are present in the inventory table
rec_ids[in_access == F]# look at all the ids that show that they are in the access table but not in the inventory table 


