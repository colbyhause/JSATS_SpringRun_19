# Plotting Tag Effect tank data

library(ggplot2)
install.packages("tidyverse")
library(tidyverse)

#truncate raw file so it goes quicker through filter
te.dat.raw <- read.csv("Z:/Shared/Projects/JSATS/DSP_Spring-Run Salmon/2019/2019DOWNLOADS/TagEffectsTank2019/052019/Lotek117_052019_WHSfiltered.csv")
trunc_dat <- te.dat.raw [39546574:nrow(te.dat.raw), ]
write.csv(trunc_dat, "Z:/Shared/Projects/JSATS/DSP_Spring-Run Salmon/2019/2019DOWNLOADS/TagEffectsTank2019/052019/Lotek117_052019_trunc.csv")

#FILTER FILE USING UCD FILTER
#
#
#
#read in UCD filtered Lotek data: 
te.dat <- read.csv("C:/Users/chause/Documents/GitHub/JSATS_SpringRun19_Filtering/accepted/0001_117_accepted.csv")

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


