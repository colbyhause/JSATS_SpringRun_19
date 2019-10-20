library(tidyverse)

# Fri Mar 08 15:26:37 2019 ------------------------------


# seeing how many fish are going through the HIlls Ferry RT Receiver that I pulled on 3/7/19. 
#Receiver was recording data from 2/26-3/6, when solar panels were stolen and receiver died


#upload 2019 taglist
taglist_2019<- read_csv("data/taglist_2019.csv")
HillsRT_1 <- read_csv("data/2016-6002190311646.csv", col_names = FALSE) 

#will intersect work?
x <- c( 1,2,3,4,5,6)
y <- c(5)

intersect(x, y)

#yeas it does, now use Hills RT file and 2019 tag list:

det <- HillsRT_1$X5 # colum 5 is the detection col
tags <- taglist_2019$TagHex_ID # need to make into a vector for this function to work

a <- intersect(tags, det)
b<- intersect(det, tags) #seeing if I get the same thins, hard to tell just visually

#checking to see if both output the same # of tags and same tag IDs, looks like they do
intersect(a,b)

write.csv(x = a, file = "data_output/hillsRTtags_a_030819.csv")
write.csv(x = b, file = "data_output/hillsRTtags_b_030819.csv")


####Final Code####

taglist_2019<- read_csv("data/taglist_2019.csv")
HillsRT_1 <- read_csv("data/________", col_names = FALSE) # upload det file, chnage object name depending on rec

det <- HillsRT_1$X5 # colum 5 is the detection col
tags <- taglist_2019$TagHex_ID # need to make into a vector for this function to work

