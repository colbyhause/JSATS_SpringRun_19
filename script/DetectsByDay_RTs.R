# Mon Jul 15 14:07:23 2019 ------------------------------
# Written by : Colby Hause


library(tidyverse)
library(lubridate)


# Goal: The following code plots detections from RT data (extracted from the cloud by Matt) each day. Purpose is to easily see
# that each reciever was getting detections each day (ie funcitoning properly)
# The data that you need is a large csv with the combined detections from all the smaller file that matt pulls from the 
# cloud (these small files write to the cloud liek every 2 hours, so they must all be combined into one csv)


#Read in the large, single realtime file the Matt combined to run through filter
RTdat <- read_csv("data/datalines.csv2", headerInFile == T)

# Now look at each receiver seperately:

# RT 2015-6037 at the CVP_U:---- 
#1. Make dataframe that pulls out only this receiver and calculates detections per dat in 2019   
rt_20153037_2019 <- subset(RTdat, RTdat$X1 == "156037") %>% 
  mutate(day = format(as.Date(X3), '%Y-%m-%d')) %>% 
  group_by(day) %>% 
  filter(day > "2019-01-01") %>% 
  tally()

#2.  Change day to a date, not character (or it wont plot)
rt_20153037_2019$day <- ymd(rt_20153037_2019$day)
class(rt_20153037_2019$day)

#3.  Plot receiver Detections: 
plot(x = rt_20153037_2019$day, y = rt_20153037_2019$n, ylim = c(0, 2000),  main = "2019 Detections on 2015-6037")


# RT 2017-6069 in the Tanks---- 
#1. Make dataframe that pulls out only this receiver and calculates detections per dat in 2019 
rt_20176069_2019 <- subset(RTdat, RTdat$X1 == "176069") %>% 
  mutate(day = format(as.Date(X3), '%Y-%m-%d')) %>% 
  group_by(day) %>% 
  filter(day > "2019-01-01") %>% 
  tally()

#2.  Change day to a date, not character (or it wont plot)
rt_20176069_2019$day <- ymd(rt_20176069_2019$day)
class(rt_20176069_2019$day)

#3.  Plot receiver Detections: 
plot(x = rt_20176069_2019$day, y = rt_20176069_2019$n, main = "2019 Detections on 2017-6069")


# RT 2017-6070 in the Tanks---- 
#1. Make dataframe that pulls out only this receiver and calculates detections per dat in 2019 
rt_20176070_2019 <- subset(RTdat, RTdat$X1 == "176070") %>% 
  mutate(day = format(as.Date(X3), '%Y-%m-%d')) %>% 
  group_by(day) %>% 
  filter(day > "2019-01-01") %>% 
  tally()

#2.  Change day to a date, not character (or it wont plot)
rt_20176070_2019$day <- ymd(rt_20176070_2019$day)
class(rt_20176070_2019$day)

#3.  Plot receiver Detections: 
plot(x = rt_20176070_2019$day, y = rt_20176070_2019$n, main = "2019 Detections on 2017-6070")

# RT 2017-6071 in the Tanks---- 
#1. Make dataframe that pulls out only this receiver and calculates detections per dat in 2019 
rt_20176071_2019 <- subset(RTdat, RTdat$X1 == "176071") %>% 
  mutate(day = format(as.Date(X3), '%Y-%m-%d')) %>% 
  group_by(day) %>% 
  filter(day > "2019-01-01") %>% 
  tally()

#2.  Change day to a date, not character (or it wont plot)
rt_20176071_2019$day <- ymd(rt_20176071_2019$day)
class(rt_20176071_2019$day)

#3.  Plot receiver Detections: 
plot(x = rt_20176071_2019$day, y = rt_20176071_2019$n, main = "2019 Detections on 2017-6071")

# RT 2017-6072 in the Tanks---- 
#1. Make dataframe that pulls out only this receiver and calculates detections per dat in 2019 
rt_20176072_2019 <- subset(RTdat, RTdat$X1 == "176072") %>% 
  mutate(day = format(as.Date(X3), '%Y-%m-%d')) %>% 
  group_by(day) %>% 
  filter(day > "2019-01-01") %>% 
  tally()

#2.  Change day to a date, not character (or it wont plot)
rt_20176072_2019$day <- ymd(rt_20176072_2019$day)
class(rt_20176072_2019$day)

#3.  Plot receiver Detections: 
plot(x = rt_20176072_2019$day, y = rt_20176072_2019$n, main = "2019 Detections on 2017-6072")


