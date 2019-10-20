library(tidyverse)
library(lubridate)

# 1. Read in the detection files. These file must have the release location as a "detection" for each 
# tag binded to the end of the file. This was done in the script " formatting_detection_csvs.R":
dets_up_transit <- read_csv("data_output/DetectionFiles/det_up_PF16_ModelEdited_relLoc.csv")
dets_ds_transit <- read_csv("data_output/DetectionFiles/det_ds_PF16_ModelEdited_relLoc.csv")

# 2.Open the "2019TransitRate.Rmd" in the script folder, load all of the functions

#Next, set up your routes:
upper_rel_routes <- c( "Upstream Release Old River Route To Ocean via OR",	"Upstream Release Old River Route To Ocean via Pumps",
                       "Upstream Release Mainstem Route To Ocean")

delta_rel_routes <- c("Delta Release Old River Route To Ocean via ORHWY4", 	"Delta Release Old River Route To Ocean via Pumps",
                      "Delta Release Mainstem Route To Ocean")


#Next, create a csv with the specific sites within each route. these are your df_locations in order route function
upper_rel_locations <- read_csv("data/2019UpperRel_Locations_transit.csv")
delta_rel_locations <- read_csv("data/2019DeltaRel_Locations_transit.csv")

# Run "changer_receiver_names function located in the 2019TransitRate.Rmd in script folder. This changes all individual 
# receiver names to one site name(so groups multiple recs at one site)

# Change rec names
dets_up_grouped <- change_receiver_names(dets_up_transit)
dets_ds_grouped <-  change_receiver_names(dets_ds_transit)

# now run "get_transit" function, also located in the 2019TransitRate.rmd
df_transit_up<- get_transit_rate(dets_up_grouped, 0, 500)
df_transit_ds<- get_transit_rate(dets_ds_grouped, 0, 500)


# Last, run the "order route function", also in the 2019TransitRate.Rmd
up_tranist_plots <- order_route(upper_rel_routes, df_transit_up, upper_rel_locations, pdf_name = "Upper Rel plot PDFs" )
ds_transit_plots <- order_route(delta_rel_routes, df_transit_ds, delta_rel_locations, pdf_name = "Delta Rel plot PDFs" )

################################################################################################################################
################################################################################################################################
# Running transit rate code on the files that indclude GG and Chipps detections

dets_up_transit <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/UpperDets_w_GG_Chipps_pred_filt16.csv")
dets_ds_transit <- read_csv("data_output/DetectionFiles/Files_w_Bridge_Data/DeltaDets_w_GG_Chipps_pred_filt16.csv")

# 2.Open the "2019TransitRate.Rmd" in the script folder, load all of the functions

#Next, set up your routes:
upper_rel_routes <- c( "Upstream Release Old River Route To Ocean via OR",	"Upstream Release Old River Route To Ocean via Pumps",
                       "Upstream Release Mainstem Route To Ocean")

delta_rel_routes <- c("Delta Release Old River Route To Ocean via ORHWY4", 	"Delta Release Old River Route To Ocean via Pumps",
                      "Delta Release Mainstem Route To Ocean")


#Next, create a csv with the specific sites within each route. these are your df_locations in order route function
upper_rel_locations <- read_csv("data/2019UpperRel_Locations_transit.csv")
delta_rel_locations <- read_csv("data/2019DeltaRel_Locations_transit.csv")

# Run "changer_receiver_names function located in the 2019TransitRate.Rmd in script folder. This changes all individual 
# receiver names to one site name(so groups multiple recs at one site)

# Change rec names
dets_up_grouped <- change_receiver_names(dets_up_transit)
dets_ds_grouped <-  change_receiver_names(dets_ds_transit)

# now run "get_transit" function, also located in the 2019TransitRate.rmd
df_transit_up<- get_transit_rate(dets_up_grouped, 0, 500)
df_transit_ds<- get_transit_rate(dets_ds_grouped, 0, 500)

# Last, run the "order route function", also in the 2019TransitRate.Rmd
up_transit_plots <- order_route(upper_rel_routes, df_transit_up, upper_rel_locations, pdf_name = "Upper Rel plot PDFs" )
ds_transit_plots <- order_route(delta_rel_routes, df_transit_ds, delta_rel_locations, pdf_name = "Delta Rel plot PDFs" )

