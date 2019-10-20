# This code converts UTM coordinates (in this case Zone 10, from Mike's array) to decimal degrees, which is the format needed
# for the DSP access database

library(tidyverse)
library(rgdal)

Mikes_notes<-read_csv("data/2019deploymentNotes_MIKE.csv") # upload file that has the utm coords
utm <- Mikes_notes[, c(5,6)] # just pull out those Northing and Easting coords

utmcoords <- SpatialPoints(cbind(utm$E,utm$N), proj4string=CRS("+proj=utm +zone=10")) # make UTM a spatial point
decdegs <-  spTransform(utmcoords,CRS("+proj=longlat")) # convert utm coords to dec degrees
plot(decdegs) # plot it to make sure they all are grouped together

df_decdegs <- as.data.frame(decdegs) # make dataframe so you can write to file
colnames(df_decdegs) <- c("Long", "Lat") # add row names
df_decdegs_ID <- cbind(Mikes_notes[, 1], df_decdegs) # add the rec ID column back in

write_csv(x = df_decdegs_ID, path = "data_output/2019HORflow_Coords_DecDegs.csv")
