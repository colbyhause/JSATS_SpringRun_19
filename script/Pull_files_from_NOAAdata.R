# The goal of this code is to pull out the file names that you wanted out of the cluster fuck of files that Arnold dumps on you
# when you ask for data from the bridges.


library(reader)
library(filesstrings)

#1. Make a vector of all the files names you want, you will need to pull these names from the deployment table after determining
#which deployments are useful (ie. Benicia, GG, Chipps, Antioch during the correct dates)

files_noaa <- c(
'BeniciaRT_01 17128_20190313',
'BeniciaRT_02 18008_20181213',
'BeniciaRT_04 17147_20190313',
'BeniciaRT_04 17147_20190313',
'BeniciaRT_07 17143_20190312',
'BeniciaRT_09 18001_20190313',
'BeniciaRT_10 17137_20190313',
'BeniciaRT_11 17126_20190312',
'BeniciaRT_12 18006_20190312',
'BeniciaRT_13 17127 _20190312',
'BeniciaRT_15 17141_20190313',
'BeniciaRT_16 17138_20190313',
'13008___181206_141801.csv',
'13017___181023_075910.csv',
'13018___181206_151225.csv',
'13018___190322_135518.csv',
'13026___190308_135123.csv',
'13026___190604_175357.csv',
'13030___181206_122633.csv',
'13034___190220_134555.csv',
'13034___190604_181747.csv',
'13045___190322_113712.csv',
'13046___181206_144533.csv',
'13046___190322_142500.csv',
'13051___181206_135947.csv',
'13055___181206_120004.csv',
'13058___190327_124748.csv',
'15001___190208_112845.csv',
'15006___190208_124546.csv',
'15007___181206_152134.csv',
'15011___190208_115443.csv',
'15012___190208_094108.csv',
'15012___190604_180224.csv',
'15015___181206_133107.csv',
'15018___190208_122142.csv',
'15018___190604_174032.csv',
'15020___190208_110610.csv',
'15025___181206_123724.csv',
'15043___190208_101419.csv',
'15045___190208_103730.csv',
'15045___190604_182556.csv',
'16008___190328_094156.csv',
'18153_190221_184438.csv',
'19008_190221_183439.csv',
'19010___190221_180358.csv')
# '15019___181130_223821.csv', Chipps below
# '15025___190227_133627.csv',
# '13061___181130_193335.csv',
# "13051___190228_100050.csv",
# '13045___181130_211249.csv',
# "15007___190228_113449.csv",
# "15014___181130_215847.csv",
# "13008___190228_120142.csv",
# "15016___181130_222003.csv",
# "13036___190306_100708.csv",
# "15013___181130_225447.csv",
# "13071___190306_092024.csv",
# "16001___181130_203422.csv",
# "13017___190228_131046.csv",
# "13064___181130_191056.csv",
# "15015___190228_104151.csv",
# "13026___181130_213521.csv",
# "13030___190227_161002.csv",
# "13041___181130_201154.csv",
# "13055___190228_124211.csv",
# "15018___190208_122142.csv",
# "19010___190221_180358.csv",
# "15001___190208_112845.csv",
# "13046___181206_144533.csv",
# "13026___190308_135123.csv",
# "15043___190208_101419.csv",
# "15020___190208_110610.csv",
# '13034___190220_134555.csv',
# "18153_190221_184438.csv",
# "13018___181206_151225.csv",
# "15012___190208_094108.csv",
# "19008_190221_183439.csv",
# "15045___190208_103730.csv",
# "15006___190208_124546.csv",
# "15011___190208_115443.csv")

length(files_noaa) #47,#34




# This loop will locate all the files listed in the files_noaa vector from the directory with all of arnolds data (make sure all files 
# are in one folder). dir argument is the file path for where all of arnolds files are located. fn is the file name

for (i in files_noaa) {
  print(i)
file_found <- find.file(fn = i, dir = "G:/JSATS/2019/2019DOWNLOADS/Raw files from NOAA/Files_Sent_091319/ALL_Data")
if (file_found == ""){
  next
}else{
    file.move(paste0("G:/JSATS/2019/2019DOWNLOADS/Raw files from NOAA/Files_Sent_091319/ALL_Data/",i), 
             paste0("C:/Users/chause/Documents/GitHub/JSATS_SpringRun_19/data/Files_From_NOAA/", i))

  }
}

# 28 files moved over, missing 19
# # Notes to Self:
# 30 files already in folder from when I did this to the first group of files arnold sent to gabe. 
# Looking for 22 more golden gate files (making 52 files in folder total)-got all files 
# still waiting on Benicia files 



