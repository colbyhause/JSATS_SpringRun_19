# The goal is to determine if the query run by access created duplicate records, bc the total between upstream release and downstream
# release records should add to 3609774 but they add to 3640540, which is 766 more than there should be. 
library(tidyverse)

us_rel <- read_csv("data/qFishByRelGroup_CH_UP.csv")
dups<- duplicated(us_rel$ID)
duplicated_ids <- us_rel$ID[dups == T]
length(duplicated_ids)
#says 735 dups

# both groups combined:
all_grps <- read_csv("data/qFishByRelGroup_CH_ALLgroups.csv")
dups<- duplicated(all_grps$ID)
duplicated_ids <- all_grps$ID[dups == T]
length(duplicated_ids)
# come out exactly right: 766 duplicate IDS. 735 are from the upstream release group fish, the rest are from DS rel group fish
duplicated_ids


# now look at the other data from these IDS
dup_rows <- all_grps[dups, ]
write_csv(dup_rows, "data_output/DuplicatedRows_fromAccess080919.csv")
# looks like all the duplicates came from MAC3
