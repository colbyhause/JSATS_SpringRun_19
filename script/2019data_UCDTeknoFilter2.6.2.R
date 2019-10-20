############################################################################################################
#            Tag Filter for JSATS Receiver Files converted from CBR description of FAST algorithm
#                 Based on algorithm interpretation by Gabe Singer (GS) and Matt Pagel (MP)
#                               Contact/primary author: Matt Pagel @ UCDavis
# 
#                      Original version coded on 05/16/2017 by GS, Damien Caillaud (DS)
#                       Contributions made by: MP, GS, Colby Hause, DS, Arnold Ammann
#                                 Version 2.6.2. Updated 2019-03-14 by MP
############################################################################################################
#                          Special Note from http://www.twinsun.com/tz/tz-link.htm:
# Numeric time zone abbreviations typically count hours east of UTC, e.g., +09 for Japan and -10 for Hawaii.
#               However, the POSIX TZ environment variable uses the opposite convention.
#         For example, one might use TZ="JST-9" and TZ="HST10" for Japan and Hawaii, respectively.
############################################################################################################

# TODO 20180313: Document max drift between window clusters
# TODO 20180313: process unknown tags too. Figure out if their PRI is near-integer seconds, less than 1hr, 1m (tester/beacon)
# TODO 20180313: for RT files, ignore incoming file name...just read them all in to a big array pre-clean.
# TODO         : implement daily temperature flux <= 4 Kelvin out of 300ish = 1.333% variance in clock rate within a day
# See also TODOs in-line


setwd("C:/Users/chause/Documents/GitHub/JSATS_SpringRun19_Filtering")
memory.limit(44000)
vTAGFILENAME = cbind(TagFilename=c("qTagListWithRelGroup.csv", "2019TEfish.csv"),PRI=c(5, 5)) # qPRIcsv_SJScarf_up.txt

DoCleanPrePre = FALSE
DoCleanRT = FALSE
DoCleanShoreRT = TRUE

DoCleanJST = FALSE
DoCleanSUM = FALSE
DoCleanLotek = TRUE
DoCleanATS = FALSE

RT_Dir = "Z:/LimitedAccess/tek_realtime_sqs/data/preprocess/"
RT_File_PATTERN = "jsats_2016901[1389]_TEK_JSATS_*|jsats_2017900[34]_JSATS_*|jsats_20169020_TEK_JSATS_17607[12]*"
SSRT_Dir = "D:/tempssd2/SS/filtered/"

RAW_DATA_DIR = "raw/"
TEKNO_SUBDIR = "./" # or "" if not in a subdirectory of data directory
ATS_SUBDIR = "" # or ""
LOTEK_SUBDIR = "" # "Lotek/cleaned with UCD tags/" # or ""

DoSaveIntermediate = TRUE # (DoCleanJST || DoCleanSUM || DoCleanATS || DoCleanLotek)
DoFilterFromSavedCleanedData = TRUE || !DoSaveIntermediate # if you're not saving the intermediate, you should do direct processing

# Algorithm constants.
FILTERTHRESH = 2 # FAST spec: 4. Arnold: 2 for ATS&Tekno, 4 for Lotek
FLOPFACTOR_2.6 = 0.006 # # FAST spec: 0.006. Arnold: .04*5 = 0.2; UCD per tag, but not per-window: 0.155-0.157
MULTIPATHWINDOW = 0.2 # FAST spec: 0.156. Arnold: 0.2
COUNTERMAX = 12 # FAST spec: 12

# add_contextmenu_winpath<-function() { # doesn't actually work properly in RStudio API
#   .rs.addJsonRpcHandler("convert_windows_path_to_R_style",makewinpath)
# }

makewinpath<-function() { # highlight a region in the file source window (up-left), then in console window (down-left) run this func to reverse \s to /s
  install.load <- function(package.name)
  {
    if (!require(package.name, character.only=T)) install.packages(package.name)
    library(package.name, character.only=T)
  }
  try({
    install.load("rstudioapi")
    adc<-rstudioapi::getSourceEditorContext()
    ps<-rstudioapi::primary_selection(adc)
    t<-ps$text
    t<-gsub("\\\\","/",t)
    rstudioapi::modifyRange(ps$`range`,t,adc$id)
    rstudioapi::setSelectionRanges(ps$`range`,adc$id)
  })
}
###Install Load Function
install.load <- function(package.name)
{
  if (!require(package.name, character.only=T)) install.packages(package.name)
  library(package.name, character.only=T)
}

install.load('tidyverse')
install.load('lubridate')
install.load('data.table')

# if using read.csv rather than fread (data.table), you'll want to 
#   1. read a few entries from each column first
#   2. set the data type accordingly and 
#   3. re-set to character if it's picky
# dathead <- read.csv(i, header=T, nrows=10)
# classes<-sapply(dathead, class)
# classes[names(unlist(list(classes[which(classes %in% c("factor","numeric"))],classes[names(classes) %in% c("time","date","dtf")])))] <- "character"
# dat <- read.csv(i, header=T, colClasses=classes)
# names(dat) # SQSQueue,SQSMessageID,ReceiverID,DLOrder,DetectionDate,TagID,TxAmplitude,TxOffset,TxNBW
# names(dat) <- c("SQSQueue","SQSMessageID","RecSN","DLOrder","dtf","Hex","TxAmplitude","TxOffset","TxNBW")

# Set up custom code for going back and forth with data table and data frame read/write files
data.table.parse<-function (file = "", n = NULL, text = NULL, prompt = "?", keep.source = getOption("keep.source"), 
                            srcfile = NULL, encoding = "unknown") { # needed for dput data.tables (rather than data.frames)
  keep.source <- isTRUE(keep.source)
  if (!is.null(text)) {
    if (length(text) == 0L) return(expression())
    if (missing(srcfile)) {
      srcfile <- "<text>"
      if (keep.source)srcfile <- srcfilecopy(srcfile, text)
    }
    file <- stdin()
  }
  else {
    if (is.character(file)) {
      if (file == "") {
        file <- stdin()
        if (missing(srcfile)) srcfile <- "<stdin>"
      }
      else {
        filename <- file
        file <- file(filename, "r")
        if (missing(srcfile)) srcfile <- filename
        if (keep.source) {
          text <- readLines(file, warn = FALSE)
          if (!length(text)) text <- ""
          close(file)
          file <- stdin()
          srcfile <- srcfilecopy(filename, text, file.mtime(filename), isFile = TRUE)
        }
        else {
          text <- readLines(file, warn = FALSE)
          if (!length(text)) text <- ""
          else text <- gsub("(, .internal.selfref = <pointer: 0x[0-9A-Fa-f]+>)","",text,perl=TRUE)
          on.exit(close(file))
        }
      }
    }
  }
  .Internal(parse(file, n, text, prompt, srcfile, encoding))
}
data.table.get <- function(file, keep.source = FALSE)
  eval(data.table.parse(file = file, keep.source = keep.source))
dtget <- data.table.get # alias

# set up functions for calculating size of folders for progress bars
list.files.size <- function(path = getwd(), full.names=TRUE, nodotdot = TRUE, ignore.case = TRUE, include.dirs = FALSE, ...) { 
  filelist <- data.table(filename=list.files(path=path, full.names=full.names, no.. = nodotdot, ignore.case = ignore.case, include.dirs = include.dirs, ...))
  filelist[,size:=file.size(filename)][,tot:=sum.file.sizes(filelist)][,perc:=size/tot]
  return(filelist)
}
sum.file.sizes <- function(DT) {
  return(unlist(DT[,.(x=sum(size))],use.names=F)[1])
}

extractSNfromFN <-function(i) {
  # get it from the first number in the filename after the last \ / or ), spanning a dash if present
  SN <- as.numeric(gsub("([A-Z 0-9/()-]*[/\\()]){0,1}([A-Z_]{0,20}|[()]){0,5}([0-9]{1,6})(-([0-9]{0,4})[0-9]{0,20})?[A-Z._-][^)\t\n-]*$", "\\3\\5", i, ignore.case=TRUE))
  if (is.null(SN) || is.na(SN) || !is.numeric(SN) || SN==9000) { # maybe Lotek from Arnold
    SN <- gsub("([A-Z 0-9/\\()_-]*[/\\()]){0,1}([A-Z_]{0,20}|[()]){0,5}([0-9]{1,6})([_-]([0-9]{0,5})[0-9]{0,20})?[A-Z._-][^)\t\n-]*$", "\\5", i, ignore.case=TRUE)
    if (is.null(SN) || is.na(SN) || !grepl("^[0-9]*$",SN) || SN==9000) SN<-0
  }
  return(SN)
}

recheckTekno <- function() { # not hooked into any other function. Will not automatically run.
  dat<-data.table()
  for(i in list.files("./accepted",full.names=TRUE)){
    id<-as.logical(file.info(i)["isdir"])
    if (is.null(id) || is.na(id)) id <- TRUE
    if (id==TRUE) next
    # if it's a dput file, read it back in, but make sure there's no funky memory addresses that were saved by data.table
    if (endsWith(i,'.dput') || endsWith(i,'.txt')) datos <-as.data.table(dtget(i))
    if (endsWith(i,'.csv')) { # if it was written to disk with fwrite, use the faster fread, but make sure to set the datetime stamps
      datos <-fread(i)
      # datos[,dtf:=as.POSIXct(dtf, format = "%Y-%m-%d %H:%M:%OSZ", tz="UTC")] # %OS6Z doesn't seem to work correctly
    }
    if (dat[,.N] > 0) {
      dat<-rbindlist(list(dat, datos))
    } else {
      dat<-datos
    }
  }
  HC<-unique(dat,by=c("Hex", "valid", "fullHex"))[,.(Hex,valid,fullHex)]
  dtvalid<-HC[valid==1]
  invalid<-HC[valid==0]
  setkey(dtvalid, Hex)
  setkey(invalid, Hex)
  invalid[dtvalid,`:=`(tot=.N,realTag=realTag),by=.EACHI,on="Hex",nomatch=NA]
  setcolorder(invalid,c("Hex","fullHex","tot","realTag","valid"))
  uiv<-unique(invalid[,.(Hex,realTag,tot)],by="Hex")
  invalid[uiv,badTagIDs:=lapply(.SD,list),on=.(Hex),by=.EACHI]
  return(unique(invalid,by="Hex")[,.(Hex,realTag,tot,badTagIDs)])
}

find_ePRI <- function(obj) {
  N<-nrow(obj)
  tmp<-data.table(merge.data.frame(x=1:COUNTERMAX,obj))
  itr<-tmp[,ic:=round(twind/x,2)]
  ll <- itr[(ic >= nPRI*0.651 & ic<=nPRI*1.3)]
  setkey(ll,ic)
  rv<-ll[,dist:=abs(nPRI-ic)][,.(tot=.N),by=.(ic,dist)][order(-tot,dist,-ic)][1]
  retval<-data.table(rep(rv$ic,N))
  return(retval)
}

magicFilter2.6 <- function(dat, countermax, filterthresh){
  blankEntry<-data.table(hit=NA, initialHit=NA, isAccepted=FALSE, nbAcceptedHitsForThisInitialHit=0, ePRI=NA)
  setkey(dat,dtf)
  if (dat[,.N] == 0) return(blankEntry)
  dat[,temporary:=as.POSIXct(dtf, format = "%m/%d/%Y %H:%M:%OS", tz="Etc/GMT+8")] # dput file stores datestamp in this basic format
  if (is.na(dat[,.(temporary)][1])) dat[,dtf:=as.POSIXct(dtf, format = "%Y-%m-%dT%H:%M:%OSZ", tz="UTC")] # fwri file stores as UTC in this format ...was in this doc as %S.%OSZ
  else dat[,dtf:=temporary]
  dat[,temporary:=NULL]
  dat[,winmax:=dtf+((nPRI*1.3*countermax)+1)]
  wind_range <- dat[,.(dtf,winmax,nPRI)]
  setkey(wind_range,dtf,winmax)
  fit <- dat[,.(dup=dtf,hit=dtf)]
  setkey(fit,dup,hit)
  fo_windows_full <- foverlaps(fit,wind_range,maxgap=0,type="within",nomatch=0,mult="all")[,`:=`(twind=hit-dtf,dup=NULL,winmax=NULL)][,c('hitsInWindow','WinID'):=list(.N,.GRP),by=dtf]
  setkey(fo_windows_full, WinID, hit)
  fo_windows <- fo_windows_full[hitsInWindow>=filterthresh]
  if (fo_windows[,.N] == 0) return(blankEntry)
  setkey(fo_windows,WinID)
  fo_windows[,ePRI:=find_ePRI(.SD),by=WinID,.SDcols=c("twind","nPRI")][,nP:=round(twind/ePRI,0)][,`:=`(maxdif=(nP+1)*FLOPFACTOR_2.6,windif=abs(nP*ePRI-twind))]
  windHits <- fo_windows[windif<=maxdif & nP<=countermax]
  if (windHits[,.N] == 0) return(blankEntry)
  setkey(windHits,WinID)
  windHits[,hitsInWindow:=.N,by=WinID][,isAccepted:=(hitsInWindow>=filterthresh)]
  windHits[hitsInWindow==1,hitsInWindow:=0]
  setkey(windHits, WinID, hit)
  earlyReject <- fo_windows_full[!windHits][hitsInWindow==1,hitsInWindow:=0][,`:=`(isAccepted=FALSE,ePRI=NA)][,.(hit,dtf,isAccepted,hitsInWindow,ePRI)]
  LT<-rbind(earlyReject,windHits[,.(hit,dtf,isAccepted,hitsInWindow,ePRI)])
  setkey(LT,dtf,hit)
  setnames(LT,c("hit","dtf","isAccepted","hitsInWindow","ePRI"),c("hit","initialHit","isAccepted","nbAcceptedHitsForThisInitialHit","ePRI"))
  return(LT)
}

dataFilter2.6 <- function(dat, filterthresh, countermax){
  res <- dat[1==0] # copies structure
  iter <- 0
  setkey(dat,Hex)
  titl<-dat[!is.na(RecSN)][1][,RecSN]
  u<-as.list(unique(dat[,.N,by = Hex][N>=filterthresh])[,1])$Hex
  if (length(u)>0) {
    timerbar<-winProgressBar(title=titl, label="Tag", min=0, max=length(u), initial=0)
    for(i in u){
      setWinProgressBar(timerbar,iter,label=i)
      ans <- magicFilter2.6(dat[Hex==i], countermax=countermax, filterthresh)
      setkey(ans,nbAcceptedHitsForThisInitialHit,isAccepted)
      ans2 <- ans[(nbAcceptedHitsForThisInitialHit >= filterthresh)&(isAccepted)]
      if (ans2[,.N]>0) {
        keep<-as.data.table(unique(ans2[,hit]))
        setkey(dat,dtf)
        setkey(keep,x)
        res <- rbind(res, dat[keep][Hex==i]) # Hex==i added 2019-03-19MP as some Loteks had identical timestamps for two detections of two tags
      }
      iter <- iter+1
    } 
    close(timerbar)
  }
  return(res)
}

##filter Loop
filterData <- function(incomingData=NULL) {
  j <- 0
  loopFiles <- function() {
    for(i in list.files("./cleaned",full.names=TRUE)){
      id<-as.logical(file.info(i)["isdir"])
      if (is.null(id) || is.na(id)) id <- TRUE
      if (id==TRUE) next
      # if it's a dput file, read it back in, but make sure there's no funky memory addresses that were saved by data.table
      if (endsWith(i,'.dput') || endsWith(i,'.txt')) datos <-as.data.table(dtget(i))
      if (endsWith(i,'.fwri')) { # if it was written to disk with fwrite, use the faster fread, but make sure to set the datetime stamps
        datos <-as.data.table(fread(i))
        datos[,dtf:=as.POSIXct(dtf, format = "%Y-%m-%dT%H:%M:%OSZ", tz="UTC")] # %OS6Z doesn't work with as.POSIXct, just in reverse operation
      }
      proces(dat=datos)
    }
  }
  proces <- function(dat) {
    myResults <- dataFilter2.6(dat, filterthresh=FILTERTHRESH, countermax=COUNTERMAX)
    setkey(dat,dtf) # TODO 20180313: we should probably put TagID_Hex and RecSN in the key also
    setkey(myResults,dtf)
    rejecteds <- dat[!myResults]
    myResults[,tt:=strftime(dtf,tz="Etc/GMT+8",format="%Y-%m-%d %H:%M:%S")][,FracSec:=round(as.double(difftime(dtf,tt,tz="Etc/GMT+8",units="secs")),6)][,dtf:=as.character(tt)][,tt:=NULL]
    rejecteds[,tt:=strftime(dtf,tz="Etc/GMT+8",format="%Y-%m-%d %H:%M:%S")][,FracSec:=round(as.double(difftime(dtf,tt,tz="Etc/GMT+8",units="secs")),6)][,dtf:=as.character(tt)][,tt:=NULL]
    j <<- j+1
    if (myResults[,.N]>0) {
      recsn <- myResults[!is.na(RecSN)][1][,RecSN]
    } else {
      recsn <- rejecteds[!is.na(RecSN)][1][,RecSN]
    }
    fwrite(rejecteds, paste0("./rejected/", sprintf("%04d",j), "_", recsn, "_rejected.csv"))
    fwrite(myResults, paste0("./accepted/", sprintf("%04d",j), "_", recsn, "_accepted.csv"))
  }
  if (is.null(incomingData)) loopFiles()
  else proces(dat=incomingData)
}

# TODO 20180313: directly in data.table
readTags <- function(vTagFileNames=vTAGFILENAME, priColName=c('PRI_nominal','Period_Nom','nPRI','PRI_estimate','ePRI','Period','PRI'), 
                     TagColName=c('TagID_Hex','TagIDHex','TagID','TagCode_Hex','TagCode','CodeID','CodeHex','CodeID_Hex','CodeIDHex','Tag','Code','TagSN','HexCode','Tag ID (hex)','Hex'),
                     grpColName=c("Rel_Group","RelGroup","Rel_group","Release","Group","Origin","StudyID","Owner")) {
  ret <- data.frame(TagID_Hex=character(),nPRI=numeric(),rel_group=character())
  for (i in 1:nrow(vTagFileNames)) {
    fn = vTagFileNames[i,"TagFilename"]
    if (!file.exists(fn)) { next }
    pv = vTagFileNames[i, "PRI"]
    tags<- fread(fn, header=T, stringsAsFactors=FALSE) #list of known Tag IDs
    heads = names(tags)
    tcn = TagColName[which(TagColName %in% heads)[1]] # prioritize the first in priority list
    pcn = priColName[which(priColName %in% heads)[1]]
    gcn = grpColName[which(grpColName %in% heads)[1]]
    if (is.null(pcn) || is.na(pcn) || length(pcn)<1 || pcn=="NA") pcn = NULL
    if (is.null(gcn) || is.na(gcn) || length(gcn)<1 || gcn=="NA") gcn = NULL
    tags <- tags[,c(tcn,pcn,gcn),with=F]
    if (is.null(pcn)) {
      tags[,nPRI:=as.numeric(pv)]
      pcn = "nPRI"
    }
    if (is.null(gcn)) {
      fn<-as.character(basename(fn))
      tags[,rel_group:=fn]
      gcn = "rel_group"
    }
    setnames(tags,c(tcn,pcn,gcn),c("TagID_Hex","nPRI","rel_group"))
    setkey(tags,TagID_Hex)
    tags[,nPRI:=as.numeric(nPRI)]
    tags[is.na(tags)] <- as.numeric(pv)
    ret <- rbindlist(list(ret, tags),use.names=TRUE)
  }
  setDT(ret,key="TagID_Hex")
  ret[,TagID_Hex:=as.character(TagID_Hex)] # drop factors
  return(ret)
}

isDataLine <- function(x) { # non-header
  a<-as.character(x)
  if (is.null(a) || length(a)==0) return(FALSE) # NULL check
  if (nchar(a)==0) return(FALSE) # empty string check
  if (str_count(a,",")<5) return(FALSE) # are there too few fields to actually be data?
  return (!grepl("SiteName",a,fixed = T)) # is it a header line
}

elimNPCandDS <- function(x) {# NPC = nonprinting characters; DS = double-space
  return(gsub("  ", "",gsub("[^[:alnum:] :.,|?&/\\\n-]", "",x)))
}

cleanLinesATS <- function(x) {
  return(elimNPCandDS(x))
}

# timestamps given in days since midnight first day of 1900, corrected for 1900 not being leapyear
# converting a number to a POSIXct timestamp seems to assume the numbers are number of seconds from midnight GMT, regardless of specified timezone
# so, first convert the number to a date text string without timezone, then read that in as if it's PST.
lotekDateconvert <- function(x,tz="Etc/GMT+8") {
  return (
    as.POSIXct(
      as.character(
        as.POSIXct(round(x*60*60*24), origin = "1899-12-30", tz = "GMT"),
        format="%Y-%m-%dT%H:%M:%OSZ", tz="GMT" 
      ),format="%Y-%m-%dT%H:%M:%OSZ", tz=tz
  ) )
}

cleanWrapper <- function(functionCall, tags, precleanDir, filePattern, wpbTitle=NULL) { # for customized code (ATS)
  lfs<-list.files.size(precleanDir, pattern=filePattern, full.names=TRUE, include.dirs=FALSE)
  # lf<-list.files(precleanDir, pattern=filePattern, full.names=TRUE, include.dirs = FALSE)
  tf<-length(lfs[,filename]) # total files
  if (tf==0) return(F)
  tfs<-lfs[,tot][1] # total file sizes
  if (tfs==0) return(F)
  pb<-winProgressBar(title=wpbTitle, label="Setting up file cleaning...", min=0, max=tfs, initial=0)
  rt<-0 # running size total
  for(i in 1:tf){
    ts <- lfs[i,size]
    if (ts==0) next
    fn <- lfs[i,filename]
    rt <- rt+ts
    id <- as.logical(file.info(fn)["isdir"])
    if (is.null(id) || is.na(id)) id <- TRUE
    if (id==TRUE) next
    lab<-paste0(basename(fn),"\n",i,"/",tf," (",((10000*rt)%/%tfs)/100,"% by size)\n")
    setWinProgressBar(pb,rt,label=lab)
    functionCall(fn, tags)
  }
  close(pb)
  return(T)
}

cleanOuterWrapper <- function(functionCall, tags, precleanDir, filePattern, wpbTitle,
                              headerInFile, leadingBlanks, tz, dtFormat, nacols, foutPrefix,
                              inferredHeader, Rec_dtf_Hex_strings, mergeFrac) {
  if (grepl(pattern="LOTEK",precleanDir,ignore.case=TRUE)) {
    filePattern = paste0("(*.CSV)|",filePattern)
  }
  print(filePattern)
  print(precleanDir)
  print(wpbTitle)
  lfs<-list.files.size(precleanDir, pattern=filePattern, full.names=TRUE, include.dirs=FALSE)
  print(lfs)
  tf<-length(lfs[,filename]) # total files
  if (tf==0) return(F)
  tfs<-lfs[,tot][1] # total file sizes
  if (tfs==0) return(F)
  pb<-winProgressBar(title=wpbTitle, label="Setting up file cleaning...", min=0, max=tfs, initial=0)
  rt<-0 # running size total
  for(i in 1:tf){
    ts <- lfs[i,size]
    if (ts==0) next
    fn <- lfs[i,filename]
    rt <- rt+ts
    id<-as.logical(file.info(fn)["isdir"])
    if (is.null(id) || is.na(id)) id <- TRUE
    if (id==TRUE) next
    lab<-paste0(basename(fn),"\n",i,"/",tf," (",((10000*rt)%/%tfs)/100,"% by size)\n")
    setWinProgressBar(pb,rt,label=lab)
    functionCall(i=fn, tags, headerInFile, leadingBlanks, tz, dtFormat, nacols, foutPrefix,
                 inferredHeader, Rec_dtf_Hex_strings, mergeFrac)
  }
  close(pb)
  return(T)
}

cleanInnerWrap <-function(...) {
  itercount <- 0
  function(i, tags, headerInFile=T, leadingBlanks=0, tz="GMT", dtFormat="%Y-%m-%dT%H:%M:%OS", nacols=NULL, foutPrefix=".txt", inferredHeader=NULL, Rec_dtf_Hex_strings=c("RecSN","DateTime","TagID_Hex"), mergeFrac=NULL) {
    if (!headerInFile) {
      dathead <- fread(i, header=F, nrows=10, stringsAsFactors=F, skip=leadingBlanks, fill=T, na.strings=c("NA","NULL","Null","null","nan","-nan","N/A",""))
      classes<-sapply(dathead, class)
      classes[names(unlist(list(classes[which(classes %in% c("factor","numeric"))],classes[names(classes) %in% c("time","date","dtf")])))] <- "character"
      dat <- fread(i, header=F, skip=leadingBlanks, fill=T, na.strings=c("NA","NULL","Null","null","nan","-nan","N/A","","-"), colClasses=classes)
      setnames(dat,inferredHeader)
    } else {
      dat <- fread(i, header=T, skip=leadingBlanks, fill=T, na.strings=c("NA","NULL","Null","null","nan","-nan","N/A","","-")) # fread (unlike read.csv) should read dates as character automatically
    }
    if (length(nacols)>0) {
      dat <- na.omit(dat,cols=nacols)
    }
    if (nrow(dat)==0) return(F)
    if (is.na(Rec_dtf_Hex_strings[1]))  {
      SN <- extractSNfromFN(i)
      dat[,RecSN:=SN]
      Rec_dtf_Hex_strings[1]<-"RecSN"
    }
    setnames(dat,Rec_dtf_Hex_strings,c("RecSN","dtf","Hex")) 
    if (dtFormat=="EPOCH") {
      dat[,dtf:=as.character(lotekDateconvert(as.numeric(dtf),tz),format="%Y-%m-%d %H:%M:%S",tz=tz)]
      dtFormat="%Y-%m-%d %H:%M:%OS"
    }
    # combine the DT and FracSec columns into a single time column
    colnamelist<-as.data.table(names(dat))
    if (colnamelist[V1=="valid",.N] > 0) {
      if (dat[valid==0,.N] > 0) {
        dat<-dat[valid!=0]
      }
    }
    if (length(mergeFrac)>0) {
      dat[,iznumb:=ifelse(is.na(
             tryCatch(suppressWarnings(as.numeric(eval(as.name(mergeFrac)))))
                                ),FALSE,TRUE)
          ][iznumb==T         ,gt1:=(as.numeric(eval(as.name(mergeFrac)))>=1)
          ][gt1==T,fracLead0:=sprintf("%7.6f",as.numeric(eval(as.name(mergeFrac)))/1000000)
          ][iznumb==T & gt1==F,fracLead0:=sprintf("%7.6f",as.numeric(eval(as.name(mergeFrac))))
          ][iznumb==T         ,fracDot:=substring(fracLead0,2)
          ][!is.na(fracDot)   ,newDateTime:=paste0(as.character(dtf),fracDot)
          ][ is.na(fracDot)   ,newDateTime:=as.character(dtf)
        ]
      dat[,c("iznumb","gt1","fracLead0","dtf"):=NULL]
      setnames(dat, old="newDateTime", new="dtf")
      dat[,c(mergeFrac,"fracDot"):=NULL]
    }
    dat[,fullHex:=Hex]
    dat[nchar(Hex)==9,Hex:=substr(Hex,4,7)]
    setkey(dat, Hex)
    if (nrow(dat)==0) return(F)
    # convert time string into POSIXct timestamp
    dat[,dtf:=as.POSIXct(dtf, format = dtFormat, tz=tz)]
    setkey(tags,TagID_Hex)
    dat2<-dat[tags,nomatch=0] # bring in the nominal PRI (nPRI)
    if (nrow(dat2)==0) {
      print(paste0("no matching tag hits in raw file: ",i))
      print(paste0("First tags file (",as.character(tags[,rel_group][1]),"). All tags regardless of file:"))
      print(as.vector(unique(tags[,TagID_Hex]),mode="character"))
      print("Data file tags")
      print(as.vector(unique(dat[,Hex]),mode="character"))
      return(F)
    }
    setkey(dat2, RecSN, Hex, dtf)
    dat2[,tlag:=shift(.SD,n=1L,fill=NA,type="lag"), by=.(Hex,RecSN),.SDcols="dtf"]
    if (nrow(dat2)==0) return(F) # should this be <filterthresh?
    suppressWarnings(dat2[,c("SQSQueue","SQSMessageID","DLOrder","TxAmplitude","TxOffset","TxNBW"):=NULL]) # kill warnings of non-existing columns
    setkey(dat2,RecSN,Hex,dtf)
    # calculate tdiff, then remove multipath
    dat4 <- dat2[,tdiff:=difftime(dtf,tlag)][tdiff>MULTIPATHWINDOW | tdiff==0 | is.na(tdiff)]
    if (nrow(dat4)==0) return(F)
    rm(dat2)
    # dat4[dtf==tlag,tlag:=NA] # if we want to set the first lag dif to NA rather than 0 for the first detection of a tag
    setkey(dat4,RecSN,Hex,dtf)
    setkey(dat ,RecSN,Hex,dtf)
    keepcols = unlist(list(colnames(dat),"nPRI")) # use initial datafile columns plus the nPRI column from the taglist file
    dat5 <- unique(dat[dat4,keepcols,with=FALSE]) # too slow? try dat[dat4] then dat5[,(colnames(dat5)-keepcols):=NULL,with=FALSE]
    setkey(dat5,RecSN,Hex,dtf)
    rm(dat4)
    # "Crazy" in Damien's original appears to have just been a check to see if matches previous tag, if not discard result of subtraction
    # Shouldn't be needed for data.table.
    dat5[is.null(RecSN) || is.na(RecSN) || RecSN==9000 || RecSN=="" || RecSN==0,RecSN:=extractSNfromFN(i)]
    SNs<-unique(dat5[,RecSN])
    for(sn in SNs) { # don't trust the initial file to have only a single receiver in it
      itercount <<- itercount + 1
      # fwri format stores timestamps as UTC-based (yyyy-mm-ddTHH:MM:SS.microsZ)
      if (DoSaveIntermediate) fwrite(dat5[RecSN==sn], file = paste0("./cleaned/", foutPrefix, sprintf("%04d",itercount), "_", sn,  "_cleaned.fwri"))
    }
    if (!DoFilterFromSavedCleanedData) filterData(dat5)
    rm(dat5)
  }
}

cleanATSxls <- function() { # just converts an excel file to a "csv" (with a bunch of header lines)
  install.load('readxl')
  function(i, tags) {
    newfn <- paste0(i,".xtmp")
    if (!file.exists(newfn)) {
      dat <- read_excel(i)
      fwrite(dat,file=newfn)  # make sure to check for timezone shifts!
    }
  }
}

cleanATScsv <- function() { # have to figure out how to dovetail this with the other, more sane, files.
  itercount <- 0
  install.load('readr')
  install.load('stringr')
  functionCall<-cleanInnerWrap()
  function(i, tags) { # run the inner function of the enclosure
    SN<-NA
    headr <- read_lines(i,n_max=10) # find serial number somewhere in the top 10 lines
    for (rw in 1:length(headr)) {
      if (startsWith(headr[rw],"Serial Number")) {
        SN<-as.numeric(gsub("Serial Number: ([0-9]{1,8})[^\n\t]*", "\\1", headr[rw]))
        break
      }
    }
    if (is.null(SN) || is.na(SN) || SN==9000 || SN=="") SN <- extractSNfromFN(i) # 9000 is a placeholder in some files, so take from filename instead.
    rl<-read_lines(i)
    gs<-lapply(rl,cleanLinesATS)
    p<-paste(Filter(isDataLine,gs),sep="\n",collapse="\n") # Possibly gs[lapply(gs,isDataLine)] would work too
    dat<-fread(p,blank.lines.skip=TRUE,strip.white=TRUE,na.strings=c("NA","NULL","Null","null","nan","-nan","N/A","","-")) # ,skip="SiteName",
    headers <- c("Internal", "SiteName", "SiteName2", "SiteName3", "dtf", "Hex", "Tilt", "VBatt", "Temp", "Pres", "SigStr",
                 "BitPeriod", "Thresh","Detection")                        # make vector of new headers
    setnames(dat,headers)
    dat[,RecSN:=SN] # apply the value from the header to all the rows in the file
    newfn <- paste0(i,".ctmp")
    fwrite(dat,newfn)
    headerInFile = T
    leadingBlanks = 0
    tz = "Etc/GMT+8"
    dtFormat = "%m/%d/%Y %H:%M:%OS"
    nacols = NULL # if this column is null, the row gets cut from the data set. c("Detection","Pres")
    foutPrefix = "ATS"
    inferredHeader = NULL
    Rec_dtf_Hex_strings = c("RecSN","dtf","Hex")
    mergeFrac = NULL
    functionCall(i=newfn, tags=tags, headerInFile=headerInFile, leadingBlanks=leadingBlanks, tz=tz, dtFormat=dtFormat, foutPrefix=foutPrefix, inferredHeader=inferredHeader, Rec_dtf_Hex_strings=Rec_dtf_Hex_strings, mergeFrac=mergeFrac)
    file.remove(newfn)
    itercount <<- itercount + 1
  }
}

# Load Taglist
# tags<- read.csv(TAGFILENAME, header=T, colClasses="character") # single tag list file. Superseeded.
tags<-readTags(vTAGFILENAME)

# Handle all the well-structured files
# Realtime file formats
if (DoCleanPrePre) {
  headerInFile = F
  leadingBlanks = 0
  tz = "GMT"
  dtFormat = "%Y-%m-%d %H:%M:%OS"
  nacols = NULL
  foutPrefix = "RT_npp"
  inferredHeader = c("SQSQueue","SQSMessageID","RecSN","DLOrder","DateTime","microsecs","Hex","TxAmplitude","TxOffset","TxNBW","TxCRC")
  Rec_dtf_Hex_strings = c("RecSN", "DateTime", "Hex")
  mergeFrac = "microsecs"
  functionCall<-cleanInnerWrap()
  cleanOuterWrapper(functionCall, tags=tags, precleanDir = RT_Dir, filePattern = "*.CSV$", wpbTitle = "Cleaning RT files before preprocessing",
                    headerInFile=headerInFile, leadingBlanks=leadingBlanks, tz=tz, dtFormat=dtFormat, 
                    nacols=nacols, foutPrefix=foutPrefix, inferredHeader=inferredHeader, 
                    Rec_dtf_Hex_strings=Rec_dtf_Hex_strings, mergeFrac=mergeFrac)
}

if (DoCleanRT) { # preprocessed (with DBCnx.py) DataCom detection files
  headerInFile = T
  leadingBlanks = 0
  tz = "GMT"
  dtFormat = "%Y-%m-%d %H:%M:%OS"
  nacols = NULL
  foutPrefix = "RT"
  inferredHeader = NULL
  Rec_dtf_Hex_strings = c("ReceiverID","DetectionDate","TagID")
  mergeFrac = NULL
  fn<-cleanInnerWrap()
  cleanOuterWrapper(fn, tags=tags, precleanDir = RT_Dir, filePattern = RT_File_PATTERN, wpbTitle = "Cleaning Preprocessed Realtime Data",
                    headerInFile=headerInFile, leadingBlanks=leadingBlanks, tz=tz, dtFormat=dtFormat, 
                    nacols=nacols, foutPrefix=foutPrefix, inferredHeader=inferredHeader, 
                    Rec_dtf_Hex_strings=Rec_dtf_Hex_strings, mergeFrac=mergeFrac)
}

if (DoCleanShoreRT){ # ShoreStation files created with
  # cat `ls -dR */*.txt` | awk -F , 'NF == 11' > DetectionsThru2018mmdd_hhnn.csv
  headerInFile = F
  leadingBlanks = 0
  tz = "GMT"
  dtFormat = "%Y-%m-%d %H:%M:%OS"
  nacols = NULL
  foutPrefix = "SSRT"
  inferredHeader = c("RecSN","DetOrder","DetectionDate","microsecs","TagID","Amp","FreqShift","NBW","Pressure","WaterTemp","CRC")
  Rec_dtf_Hex_strings = c("RecSN","DetectionDate","TagID")
  mergeFrac = "microsecs"
  fn<-cleanInnerWrap()
  cleanOuterWrapper(fn, tags=tags, precleanDir = SSRT_Dir, filePattern = "*.csv$", wpbTitle = "Cleaning Shore Station Data",
                    headerInFile=headerInFile, leadingBlanks=leadingBlanks, tz=tz, dtFormat=dtFormat, 
                    nacols=nacols, foutPrefix=foutPrefix, inferredHeader=inferredHeader, 
                    Rec_dtf_Hex_strings=Rec_dtf_Hex_strings, mergeFrac=mergeFrac)
}

# Tekno autonomous file formats
if (DoCleanJST) {
  headerInFile = F
  leadingBlanks = 0
  tz = "Etc/GMT+8"
  dtFormat = "%m/%d/%Y %H:%M:%OS"
  nacols = NULL
  foutPrefix = "JT"
  inferredHeader = c("Filename", "RecSN", "DT", "FracSec", "Hex", "CRC", "validFlag", "TagAmp", "NBW")
  Rec_dtf_Hex_strings = c("RecSN", "DT", "Hex")
  mergeFrac = "FracSec"
  fn<-cleanInnerWrap()
  cleanOuterWrapper(fn, tags=tags, precleanDir = paste0(RAW_DATA_DIR,TEKNO_SUBDIR), filePattern = "*.JST$", wpbTitle = "Cleaning Tekno JST files",
                    headerInFile=headerInFile, leadingBlanks=leadingBlanks, tz=tz, dtFormat=dtFormat, 
                    nacols=nacols, foutPrefix=foutPrefix, inferredHeader=inferredHeader, 
                    Rec_dtf_Hex_strings=Rec_dtf_Hex_strings, mergeFrac=mergeFrac)
}

if (DoCleanSUM) {
  headerInFile = T
  leadingBlanks = 8
  tz = "Etc/GMT+8"
  dtFormat = "%m/%d/%Y %H:%M:%OS"
  nacols = c("Detection")
  foutPrefix = "SUM"
  inferredHeader = NULL
  Rec_dtf_Hex_strings = c("Serial Number","Date Time","TagCode")
  mergeFrac = NULL
  fn<-cleanInnerWrap()
  cleanOuterWrapper(fn, tags=tags, precleanDir = paste0(RAW_DATA_DIR,TEKNO_SUBDIR), filePattern = "*.SUM$", wpbTitle = "Cleaning SUM Files",
                    headerInFile=headerInFile, leadingBlanks=leadingBlanks, tz=tz, dtFormat=dtFormat, 
                    nacols=nacols, foutPrefix=foutPrefix, inferredHeader=inferredHeader, 
                    Rec_dtf_Hex_strings=Rec_dtf_Hex_strings, mergeFrac=mergeFrac)
}

# Lotek Autonomous. Files are already pre-filtered for tags from their "JST" file format
if (DoCleanLotek) {
  headerInFile = F
  leadingBlanks = 0
  tz = "Etc/GMT+8"
  dtFormat = "EPOCH"
  nacols = NULL
  foutPrefix = "LT"
  inferredHeader = c("datetime", "FracSec", "Dec", "Hex", "SigStr")
  Rec_dtf_Hex_strings = c(NA, "datetime", "Hex")
  mergeFrac = "FracSec"
  fn<-cleanInnerWrap()
  cleanOuterWrapper(fn, tags=tags, precleanDir = paste0(RAW_DATA_DIR,LOTEK_SUBDIR), filePattern = "(*.LO_CSV)|(*.TXT)$", wpbTitle = "Cleaning LoTek LO_CSV and TXT files",
                    headerInFile=headerInFile, leadingBlanks=leadingBlanks, tz=tz, dtFormat=dtFormat, 
                    nacols=nacols, foutPrefix=foutPrefix, inferredHeader=inferredHeader, 
                    Rec_dtf_Hex_strings=Rec_dtf_Hex_strings, mergeFrac=mergeFrac)
}

# Last, do the files with less structure (needing customized code)
# ATS autonomous
if (DoCleanATS) {
  fn<-cleanATSxls() # converts Excel files to a CSV-style file
  cleanWrapper(fn, tags, precleanDir = paste0(RAW_DATA_DIR,ATS_SUBDIR), filePattern = "*.XLS[X]?$", wpbTitle = "Converting ATS XLS(x) files")
  fn<-cleanATScsv() # clean ATS CSVs
  cleanWrapper(fn, tags, precleanDir = paste0(RAW_DATA_DIR,ATS_SUBDIR), filePattern = "(*.XTMP)|(*.CSV)|(*.ATS_CSV)$", wpbTitle = "Cleaning ATS CSV files")
}

###Do the filtering loop
if (DoFilterFromSavedCleanedData) {
  filterData()
}
