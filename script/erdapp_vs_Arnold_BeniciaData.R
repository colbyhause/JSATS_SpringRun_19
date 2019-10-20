# This script is just comparing the Benicia data pulled from erdap vs the data provided by Arnold. Arnold said that this 
# data is not the full set, as they are still downloading receivers


Noaa_data<- read_csv("data/PartialBeniciaData_FromArnold.csv")

ben_noaa<- Noaa_data[grep("Benicia", Noaa_data$LOC), ]

erdapp <- read_csv("data/Data_from_erdapp.csv")

ben_erdapp <- erdapp[grep("Ben", erdapp$location), ]

