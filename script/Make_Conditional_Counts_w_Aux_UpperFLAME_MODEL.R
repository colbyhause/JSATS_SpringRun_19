# THIS CODE IS FOR THE FLAME VERSION OF THE UPPER MODEL: IE. the model designed to just focus on survival estimates from the 
# mainstem where the flame was run through
# Schematic is found in the documents folder of this project : "Flame_survival_ModelSchematic.jpg"

#
# This is Gabe Singer's Code with Colby's annotation. The first part of this code makes a dataframe that tallys up the number of 
# fish that were detected at each receiver and each subsequent downstream receiver ( in the same way that the model 
# definitions are written for USER)
# The second part of the code does the same thing, but manually for each of the dual arrays ( which need to be specified)

# Gabes Original Code is located : C:\Users\chause\Documents\GitHub\SJR_MS\script\Make_Conditional_Counts_w_Aux.R


library(tidyverse)

# Make Detection Counts ---------------------------------------------------

# Load UPPER RELEASE dataframe with just first visits ---------------------------------------------------------------
data <- readRDS("data_output/UpRel_visits2019_firstFLAME_MODEL_simplified.rds")

# Make a vector of locations that are included in model 

locs <- c('REL', 'A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'A9', 'A10', 'A11', 'B1',
          'A12', 'A13', 'A14', 'A15', 'A17') 
length(locs)

ids<- unique(data$Hex)
length(ids) #347

# Build a dataframe where rows are the tag Ids and columns are the site array locations. For each tag, a 1 will be placed in the 
# column if it was detected there, a 0 will be placed in the column if there was not detection there
#First, make an empty dataframe where row length is the # of tags and column length is the # of site array locations 
# (not including dual arrays)
enc.hist <- as.data.frame(matrix(rep(NA,(nrow = length(ids)*length(locs))),
                                 nrow = length(ids), ncol = length(locs))) # should have 347 rows ans 28 columns 

# Add column and row names
colnames(enc.hist) <- locs
rownames(enc.hist) <- ids

# Fill in data as explained above (For each tag, a 1 will be placed in the 
# column if it was detected there, a 0 will be placed in the column if there was no detection there)

for(i in 1:length(locs)) {
  subs <- subset(data, data$array.code == locs[i]) # this pulls out all the detections for the i-th place in locs vector that matches the array.code(ie. first REL,then A1, then A2, etc...)
  substag <- unique(subs$Hex) #make a vector of the unique tag IDs in subs df ( the subs df is all the tag that were detected at the array code ID that matches the i-th place)
  enc.hist[ ,i] <- ids %in% substag # Places TRUE in all the rows of the i-th column if a tag in substag matches the row names (ids)
}

#### Convert True to 1 and False to 0

enc.hist[enc.hist == "FALSE"] <- 0
enc.hist[enc.hist == "TRUE" ] <- 1


####Turn tag ID from a rowname to a column 
enc.hist<- rownames_to_column(enc.hist, var = "TagID_Hex") # turn the row names into an official column names "Tag_HexID"

# ><)))))*>  ------------- ><)))))*>  ------------- ><)))))*>  ------------- ><)))))*>  ------------- ><)))))*>  

#### Make input file for branch Model


FirstRec <- c() # make empty vector for values to go into
counter <- 1
for(i in 1:ncol(enc.hist)){ # interate through each column in enc.history
  reclist <- rep(names(enc.hist)[i + 1], length(enc.hist)-counter) # rep means to repeat. First argument is what to repeat:names(enc.hist)[i + 1]. this repeats the names (which are the column names) of enc.hist at the i-th row +1 (bc the first row, which would be the first in the iteration is "TagID_Hex"). Second arg is how many times to repeat it:length(enc.hist)-counter, which is the # of columns (or sites) minus whichever number the counter is on. This creates the list of each receiever, with ech receiver repeated the correct number of times for the model input (so Rel is repeated 28 time, A1 27, A2, 26, etc...) 
  FirstRec <- c(FirstRec, reclist) # assigns listof first receivers to Firstrec
  counter <- counter + 1 # moves counter up so it goes to the number, which decreases the number of times the next site is repeated
}
FirstRec

SecondRec <- c() # make empty vector for values to go into
recnames <- names(enc.hist)[3:length(enc.hist)]# assign site name vector starting from A1 (skipping TagID_Hex and Rel)
recnames <- c(recnames, "x") # add x to end of rec names vector
for(i in 1:length(recnames)){ # now iterating through the new list of rec names, which starts with A1 and ends at x
  reclist <- recnames[i:length(recnames)] # new rec list starting from i to end of recnames ( so list gets shorter by 1 with each iteration)
  SecondRec <- c(SecondRec, reclist) # assign second rec list column to empty vector
}
SecondRec

## cbind results of above loops
receivers <- cbind(FirstRec, SecondRec)  ###It works!!!!!!

## Now fill last column based on the enc.hist df
enc.hist$x <- rep(1, nrow(enc.hist)) # add a row to tally fish detected at a receiver and then never again 
totals <- c() # make empyty totals vector
for(i in 1: nrow(receivers)){ # interating through each row in the receivers df (df that just has first rec and second rec)
  first <- receivers[i, 1] # assigns first as the value in the first column in the i-th row of the receiver df
  second <- receivers[i, 2] # assigns second to be the value in the second column in the i-th row of the receiver df
  first <- which(colnames(enc.hist) == first) # returns the position of where "first" value in reciever df matches in enc.history df. So for first iteration, first would be "REL", which would return a value of 2 bc its the 2nd column in enc.hist df
  second <- which(colnames(enc.hist)== second)# again, returns the position of where "second" value in reciever df matches in enc.history df. So for first iteration, first would be "A1", which would return a value of 3 bc its the 2nd column in enc.hist df
  twos <- ifelse(enc.hist[, first]==1 & enc.hist[, second]==1 & rowSums(enc.hist[, first:second])==2, T, F)# function is saying if the row of the site column assigned in "first" (wich will change as loop iterates) =  1 and the row of site column assigned to "second" value is 1 and those rows add up to 2, then twos object is T, and it calculates this for each row. if not it is F (rules of the ifelse function)
  sums <-  length(which(twos))# sums the numbers of TRUEs, could also be expressed as sums<- length(twos[twos == "TRUE"])
  ifelse(sums>= 1, totals <- c(totals, sums), totals <- c(totals, 0)) # if the sum is greater than or equal to 1, totals column gets filled with that sum, if not true then it is given the value of 0
}
totals
input <- data.frame(cbind(receivers, totals)) # Conditional likelihoods,  auxiliary ones for dual arrays are below
write.csv(input, 'data_output/User_Model_Input/2019_UpperRelease_counts_FLAME_MODEL_simplified.csv')

# ><)))))*>  ------------- ><)))))*>  ------------- ><)))))*>  ------------- ><)))))*>  ------------- ><)))))*>  

# Make auxiliary likelihoods for dual arrays ---------------------------------
# I should really turn this into a function

#  Make auxiliary likelihoods for dual arrays ------------------------

ORHOR_dual <- data %>% # pull out only the detection data that is at the dual array
  filter(site.code %in% c("B1a", "B1b")) %>% 
  group_by(Hex) %>% 
  count(site.code)

ORHOR_ids <- unique(ORHOR_dual$Hex) # get all the tag ID from the sunsetted group
ORHOR_locs <- c("B1a", "B1b")

ORHOR_enc.hist <-  as.data.frame(matrix(rep(NA,(length(ORHOR_ids)*length(ORHOR_locs))), # make enc hist matrix like above
                                        length(ORHOR_ids), length(ORHOR_locs))) 
# name columns and rows
colnames(ORHOR_enc.hist) <-  ORHOR_locs
rownames(ORHOR_enc.hist) <-  ORHOR_ids

## fill in data frame
for (i in 1:length(ORHOR_locs)) {
  subs <- ORHOR_dual[ORHOR_dual$site.code == ORHOR_locs[i],]
  substag <- unique(subs$Hex)
  ORHOR_enc.hist[,i] <- ORHOR_ids %in% substag
}

## convert TRUE to '1' and FALSE to '0'
ORHOR_enc.hist[ORHOR_enc.hist==TRUE] <- 1
ORHOR_enc.hist[ORHOR_enc.hist==FALSE] <- 0

view(ORHOR_enc.hist)

ORHOR_enc.hist$B1ab <- ifelse(ORHOR_enc.hist$B1a==1 & ORHOR_enc.hist$B1b == 1, 1, 0) # says if fish was detected (==1) at B1a and if fish was detected at B1b (==1) then B1ab  = 1, if those arguments dont hold true not it equals 0
ORHOR_enc.hist$B1a0 <- ifelse(ORHOR_enc.hist$B1a==1 & ORHOR_enc.hist$B1b == 0, 1, 0) # says if fish was detected (==1) at B1a and if fish was not detected at B1b (==0) then B1a0 = 1, if those arguments dont hold true then it equals 0
ORHOR_enc.hist$B10b <- ifelse(ORHOR_enc.hist$B1a==0 & ORHOR_enc.hist$B1b == 1, 1, 0) # says if fish was not detected (==0) at B1a and if fish was detected at B1b (==1) then B10b = 1, if those arguments dont hold true then it equals 0

view(ORHOR_enc.hist)

ORHOR_dual <- ORHOR_enc.hist %>% 
  select(B1ab, B1a0, B10b) %>% 
  summarise_all(funs(sum)) # the funs function says to apply the sum function to all of the columns (i think..)

#  Make auxiliary likelihoods for dual arrays (JP: which is 17a and 17b) ------------------------

JP_dual <- data %>% # pull out only the detection data that is at the dual array
  filter(site.code %in% c("A17a", "A17b")) %>% 
  group_by(Hex) %>% 
  count(site.code)

JP_ids <- unique(JP_dual$Hex) # get all the tag ID from the sunsetted group
JP_locs <- c("A17a", "A17b")

JP_enc.hist <-  as.data.frame(matrix(rep(NA,(length(JP_ids)*length(JP_locs))), # make enc hist matrix like above
                                     length(JP_ids), length(JP_locs))) 
# name columns and rows
colnames(JP_enc.hist) <-  JP_locs
rownames(JP_enc.hist) <-  JP_ids

## fill in data frame
for (i in 1:length(JP_locs)) {
  subs <- JP_dual[JP_dual$site.code == JP_locs[i],]
  substag <- unique(subs$Hex)
  JP_enc.hist[,i] <- JP_ids %in% substag
}

## convert TRUE to '1' and FALSE to '0'
JP_enc.hist[JP_enc.hist==TRUE] <- 1
JP_enc.hist[JP_enc.hist==FALSE] <- 0

view(JP_enc.hist)

JP_enc.hist$A17ab <- ifelse(JP_enc.hist$A17a==1 & JP_enc.hist$A17b == 1, 1, 0) # says if fish was detected (==1) at A17a and if fish was detected at A17b (==1) then A17ab  = 1, if those arguments dont hold true not it equals 0
JP_enc.hist$A17a0 <- ifelse(JP_enc.hist$A17a==1 & JP_enc.hist$A17b == 0, 1, 0) # says if fish was detected (==1) at A17a and if fish was not detected at A17b (==0) then A17a0 = 1, if those arguments dont hold true then it equals 0
JP_enc.hist$A170b <- ifelse(JP_enc.hist$A17a==0 & JP_enc.hist$A17b == 1, 1, 0) # says if fish was not detected (==0) at A17a and if fish was detected at A17b (==1) then A170b = 1, if those arguments dont hold true then it equals 0

view(JP_enc.hist)

JP_dual <- JP_enc.hist %>% 
  select(A17ab, A17a0, A170b) %>% 
  summarise_all(funs(sum)) # the funs function says to apply the sum function to all of the columns (i think..)


## Bind and write to csv --------------------------------------------------------------------------------------------------

Aux <- rbind(t(ORHOR_dual), 
             t(JP_dual))
# t() function transposes the data, ie. makes the columns the rows 

write.csv(Aux, "data_output/User_Model_Input/2019_UpperRel_Cond_Aux_counts_FLAME_MODEL_simplified.csv")

###############################################################################################################################
###############################################################################################################################
###############################################################################################################################
###############################################################################################################################
###############################################################################################################################
###############################################################################################################################
# Fri Sep 20 14:11:01 2019 ------------------------------

# THIS CODE IS FOR THE NEW FLAME VERSION OF THE UPPER MODEL: IE. the model designed to just focus on survival estimates from the 
# mainstem where the flame was run through
# This model is the same as above except JP is combined into one line and model ends at chipps
# Schematic is found in the documents folder of this project : "Flame_survival_ModelSchematic_Chipps.jpg"

#
# This is Gabe Singer's Code with Colby's annotation. The first part of this code makes a dataframe that tallys up the number of 
# fish that were detected at each receiver and each subsequent downstream receiver ( in the same way that the model 
# definitions are written for USER)
# The second part of the code does the same thing, but manually for each of the dual arrays ( which need to be specified)

# Gabes Original Code is located : C:\Users\chause\Documents\GitHub\SJR_MS\script\Make_Conditional_Counts_w_Aux.R


library(tidyverse)

# Make Detection Counts ---------------------------------------------------

# Load UPPER RELEASE dataframe with just first visits ---------------------------------------------------------------
data <- read_csv("data_output/UpRel_visits2019_firstFLAME_MODEL_w_Chipps_092319.csv")

# Make a vector of locations that are included in model 

locs <- c('REL', 'A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'A9', 'A10', 'A11', 'B1',
          'A12', 'A13', 'A14', 'A15', 'A16', 'A17') 
length(locs)

ids<- unique(data$Hex)
length(ids) #347

# Build a dataframe where rows are the tag Ids and columns are the site array locations. For each tag, a 1 will be placed in the 
# column if it was detected there, a 0 will be placed in the column if there was not detection there
#First, make an empty dataframe where row length is the # of tags and column length is the # of site array locations 
# (not including dual arrays)
enc.hist <- as.data.frame(matrix(rep(NA,(nrow = length(ids)*length(locs))),
                                 nrow = length(ids), ncol = length(locs))) # should have 347 rows ans 28 columns 

# Add column and row names
colnames(enc.hist) <- locs
rownames(enc.hist) <- ids

# Fill in data as explained above (For each tag, a 1 will be placed in the 
# column if it was detected there, a 0 will be placed in the column if there was no detection there)

for(i in 1:length(locs)) {
  subs <- subset(data, data$array.code == locs[i]) # this pulls out all the detections for the i-th place in locs vector that matches the array.code(ie. first REL,then A1, then A2, etc...)
  substag <- unique(subs$Hex) #make a vector of the unique tag IDs in subs df ( the subs df is all the tag that were detected at the array code ID that matches the i-th place)
  enc.hist[ ,i] <- ids %in% substag # Places TRUE in all the rows of the i-th column if a tag in substag matches the row names (ids)
}

#### Convert True to 1 and False to 0

enc.hist[enc.hist == "FALSE"] <- 0
enc.hist[enc.hist == "TRUE" ] <- 1


####Turn tag ID from a rowname to a column 
enc.hist<- rownames_to_column(enc.hist, var = "TagID_Hex") # turn the row names into an official column names "Tag_HexID"

# ><)))))*>  ------------- ><)))))*>  ------------- ><)))))*>  ------------- ><)))))*>  ------------- ><)))))*>  

#### Make input file for branch Model


FirstRec <- c() # make empty vector for values to go into
counter <- 1
for(i in 1:ncol(enc.hist)){ # interate through each column in enc.history
  reclist <- rep(names(enc.hist)[i + 1], length(enc.hist)-counter) # rep means to repeat. First argument is what to repeat:names(enc.hist)[i + 1]. this repeats the names (which are the column names) of enc.hist at the i-th row +1 (bc the first row, which would be the first in the iteration is "TagID_Hex"). Second arg is how many times to repeat it:length(enc.hist)-counter, which is the # of columns (or sites) minus whichever number the counter is on. This creates the list of each receiever, with ech receiver repeated the correct number of times for the model input (so Rel is repeated 28 time, A1 27, A2, 26, etc...) 
  FirstRec <- c(FirstRec, reclist) # assigns listof first receivers to Firstrec
  counter <- counter + 1 # moves counter up so it goes to the number, which decreases the number of times the next site is repeated
}
FirstRec

SecondRec <- c() # make empty vector for values to go into
recnames <- names(enc.hist)[3:length(enc.hist)]# assign site name vector starting from A1 (skipping TagID_Hex and Rel)
recnames <- c(recnames, "x") # add x to end of rec names vector
for(i in 1:length(recnames)){ # now iterating through the new list of rec names, which starts with A1 and ends at x
  reclist <- recnames[i:length(recnames)] # new rec list starting from i to end of recnames ( so list gets shorter by 1 with each iteration)
  SecondRec <- c(SecondRec, reclist) # assign second rec list column to empty vector
}
SecondRec

## cbind results of above loops
receivers <- cbind(FirstRec, SecondRec)  ###It works!!!!!!

## Now fill last column based on the enc.hist df
enc.hist$x <- rep(1, nrow(enc.hist)) # add a row to tally fish detected at a receiver and then never again 
totals <- c() # make empyty totals vector
for(i in 1: nrow(receivers)){ # interating through each row in the receivers df (df that just has first rec and second rec)
  first <- receivers[i, 1] # assigns first as the value in the first column in the i-th row of the receiver df
  second <- receivers[i, 2] # assigns second to be the value in the second column in the i-th row of the receiver df
  first <- which(colnames(enc.hist) == first) # returns the position of where "first" value in reciever df matches in enc.history df. So for first iteration, first would be "REL", which would return a value of 2 bc its the 2nd column in enc.hist df
  second <- which(colnames(enc.hist)== second)# again, returns the position of where "second" value in reciever df matches in enc.history df. So for first iteration, first would be "A1", which would return a value of 3 bc its the 2nd column in enc.hist df
  twos <- ifelse(enc.hist[, first]==1 & enc.hist[, second]==1 & rowSums(enc.hist[, first:second])==2, T, F)# function is saying if the row of the site column assigned in "first" (wich will change as loop iterates) =  1 and the row of site column assigned to "second" value is 1 and those rows add up to 2, then twos object is T, and it calculates this for each row. if not it is F (rules of the ifelse function)
  sums <-  length(which(twos))# sums the numbers of TRUEs, could also be expressed as sums<- length(twos[twos == "TRUE"])
  ifelse(sums>= 1, totals <- c(totals, sums), totals <- c(totals, 0)) # if the sum is greater than or equal to 1, totals column gets filled with that sum, if not true then it is given the value of 0
}
totals
input <- data.frame(cbind(receivers, totals)) # Conditional likelihoods,  auxiliary ones for dual arrays are below
write.csv(input, 'data_output/User_Model_Input/2019_UpperRelease_counts_FLAME_MODEL_w_Chipps_092319.csv')

# ><)))))*>  ------------- ><)))))*>  ------------- ><)))))*>  ------------- ><)))))*>  ------------- ><)))))*>  

# Make auxiliary likelihoods for dual arrays ---------------------------------
# I should really turn this into a function

#  Make auxiliary likelihoods for dual arrays ------------------------

ORHOR_dual <- data %>% # pull out only the detection data that is at the dual array
  filter(site.code %in% c("B1a", "B1b")) %>% 
  group_by(Hex) %>% 
  count(site.code)

ORHOR_ids <- unique(ORHOR_dual$Hex) # get all the tag ID from the sunsetted group
ORHOR_locs <- c("B1a", "B1b")

ORHOR_enc.hist <-  as.data.frame(matrix(rep(NA,(length(ORHOR_ids)*length(ORHOR_locs))), # make enc hist matrix like above
                                        length(ORHOR_ids), length(ORHOR_locs))) 
# name columns and rows
colnames(ORHOR_enc.hist) <-  ORHOR_locs
rownames(ORHOR_enc.hist) <-  ORHOR_ids

## fill in data frame
for (i in 1:length(ORHOR_locs)) {
  subs <- ORHOR_dual[ORHOR_dual$site.code == ORHOR_locs[i],]
  substag <- unique(subs$Hex)
  ORHOR_enc.hist[,i] <- ORHOR_ids %in% substag
}

## convert TRUE to '1' and FALSE to '0'
ORHOR_enc.hist[ORHOR_enc.hist==TRUE] <- 1
ORHOR_enc.hist[ORHOR_enc.hist==FALSE] <- 0

#view(ORHOR_enc.hist)

ORHOR_enc.hist$B1ab <- ifelse(ORHOR_enc.hist$B1a==1 & ORHOR_enc.hist$B1b == 1, 1, 0) # says if fish was detected (==1) at B1a and if fish was detected at B1b (==1) then B1ab  = 1, if those arguments dont hold true not it equals 0
ORHOR_enc.hist$B1a0 <- ifelse(ORHOR_enc.hist$B1a==1 & ORHOR_enc.hist$B1b == 0, 1, 0) # says if fish was detected (==1) at B1a and if fish was not detected at B1b (==0) then B1a0 = 1, if those arguments dont hold true then it equals 0
ORHOR_enc.hist$B10b <- ifelse(ORHOR_enc.hist$B1a==0 & ORHOR_enc.hist$B1b == 1, 1, 0) # says if fish was not detected (==0) at B1a and if fish was detected at B1b (==1) then B10b = 1, if those arguments dont hold true then it equals 0

#view(ORHOR_enc.hist)

ORHOR_dual <- ORHOR_enc.hist %>% 
  select(B1ab, B1a0, B10b) %>% 
  summarise_all(funs(sum)) # the funs function says to apply the sum function to all of the columns (i think..)

#  Make auxiliary likelihoods for dual arrays (Chipps: which is 17a and 17b) ------------------------

Chipps_dual <- data %>% # pull out only the detection data that is at the dual array
  filter(site.code %in% c("A17a", "A17b")) %>% 
  group_by(Hex) %>% 
  count(site.code)

Chipps_ids <- unique(Chipps_dual$Hex) # get all the tag ID from the sunsetted group
Chipps_locs <- c("A17a", "A17b")

Chipps_enc.hist <-  as.data.frame(matrix(rep(NA,(length(Chipps_ids)*length(Chipps_locs))), # make enc hist matrix like above
                                     length(Chipps_ids), length(Chipps_locs))) 
# name columns and rows
colnames(Chipps_enc.hist) <-  Chipps_locs
rownames(Chipps_enc.hist) <-  Chipps_ids

## fill in data frame
for (i in 1:length(Chipps_locs)) {
  subs <- Chipps_dual[Chipps_dual$site.code == Chipps_locs[i],]
  substag <- unique(subs$Hex)
  Chipps_enc.hist[,i] <- Chipps_ids %in% substag
}

## convert TRUE to '1' and FALSE to '0'
Chipps_enc.hist[Chipps_enc.hist==TRUE] <- 1
Chipps_enc.hist[Chipps_enc.hist==FALSE] <- 0

view(Chipps_enc.hist)

Chipps_enc.hist$A17ab <- ifelse(Chipps_enc.hist$A17a==1 & Chipps_enc.hist$A17b == 1, 1, 0) # says if fish was detected (==1) at A17a and if fish was detected at A17b (==1) then A17ab  = 1, if those arguments dont hold true not it equals 0
Chipps_enc.hist$A17a0 <- ifelse(Chipps_enc.hist$A17a==1 & Chipps_enc.hist$A17b == 0, 1, 0) # says if fish was detected (==1) at A17a and if fish was not detected at A17b (==0) then A17a0 = 1, if those arguments dont hold true then it equals 0
Chipps_enc.hist$A170b <- ifelse(Chipps_enc.hist$A17a==0 & Chipps_enc.hist$A17b == 1, 1, 0) # says if fish was not detected (==0) at A17a and if fish was detected at A17b (==1) then A170b = 1, if those arguments dont hold true then it equals 0

view(Chipps_enc.hist)

Chipps_dual <- Chipps_enc.hist %>% 
  select(A17ab, A17a0, A170b) %>% 
  summarise_all(funs(sum)) # the funs function says to apply the sum function to all of the columns (i think..)


## Bind and write to csv --------------------------------------------------------------------------------------------------

Aux <- rbind(t(ORHOR_dual), 
             t(Chipps_dual))
# t() function transposes the data, ie. makes the columns the rows 


write.csv(Aux, "data_output/User_Model_Input/2019_UpperRel_Cond_Aux_counts_FLAME_MODEL_w_Chipps_092319.csv")


