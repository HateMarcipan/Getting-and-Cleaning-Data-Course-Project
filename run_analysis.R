## LOADING REQUIRED PACKAGES
library(dplyr)
library(reshape2)
library(jsonlite)

## DOWNLOADING AND UNZIPING SOURCE DATA
# creating temporary file
tempFil <- tempfile()
# downloading source data zip file to temporary file
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",tempFil)
#creating temporary folder
tempFol<-tempdir()
# unziping data to temporary folder
unzip(tempFil, exdir = tempFol)
# creating new path which is going to be used to read files
newPath<-paste(tempFol,"\\UCI HAR Dataset\\", sep="")
# deleting temporary file
unlink(tempFil)

## READING DATA
# variable labels (variables column headers)
dLabels<- tbl_df(read.csv(paste(newPath,"features.txt", sep=""),sep = "", header = FALSE, stringsAsFactors=FALSE))

# descriptive activity names
activitynames<- tbl_df(read.csv(paste(newPath,"activity_labels.txt", sep=""),sep = "", header = FALSE, stringsAsFactors=FALSE))

# reading training data
# info on subject performing activity
subjecttrain<- tbl_df(read.csv(paste(newPath,"train\\subject_train.txt", sep=""),sep = " ", header=FALSE))
# variable values
xtrain<- tbl_df(read.csv(paste(newPath,"train\\X_train.txt", sep=""),sep = "", header=FALSE))
# activity id
ytrain<- tbl_df(read.csv(paste(newPath,"train\\y_train.txt", sep=""),sep = "", header=FALSE))

# reading test data
# info on subject performing activity
subjecttest<- tbl_df(read.csv(paste(newPath,"test\\subject_test.txt", sep=""),sep = " ", header=FALSE))
# variable values
xtest<- tbl_df(read.csv(paste(newPath,"test\\X_test.txt", sep=""),sep = "", header=FALSE))
# activity id
ytest<- tbl_df(read.csv(paste(newPath,"test\\y_test.txt", sep=""),sep = "", header=FALSE))

## Assigning headers (names)
names(xtest)<-dLabels$V2
names(xtrain)<-dLabels$V2
names(ytest)<-"activityID"
names(ytrain)<-"activityID"

names(activitynames)<-c("activityID", "activityname")
names(subjecttest)<-"subjectID"
names(subjecttrain)<-"subjectID"


# leaving only mean and standard deviation for each measurement
dLabelsMS<-dLabels$V2[grepl("mean|std",dLabels$V2,ignore.case = TRUE)]
xtest<-xtest[,dLabelsMS]
xtrain<-xtrain[,dLabelsMS]


## MERGING DATA
# test: subject + activity + data
testdata<-cbind(RowNum=c(1:nrow(ytest)),subjecttest, ytest, xtest)

# train: subject + activity + data
traindata<-cbind(RowNum=c(1:nrow(ytrain)),subjecttrain, ytrain, xtrain)


# Making structure long instead of wide as some variable names are duplicated
testdata<-melt(testdata,id=c("RowNum","subjectID","activityID"), measure.vars = dLabelsMS)
traindata<-melt(traindata,id=c("RowNum","subjectID","activityID"), measure.vars = dLabelsMS)
testdata<-tbl_df(testdata)
traindata<-tbl_df(traindata)

# specifying if data is test or train
traindata<-traindata %>% mutate(type="train")
testdata<-testdata %>% mutate(type="test")

# union of test and train data
finaldata<-rbind(testdata,traindata)

# adding activity names
finaldata<-merge(finaldata,activitynames,by.x = "activityID", by.y = "activityID")

# calculating mean of each variable on subject ID and activity level
clean_data<-finaldata%>%group_by(activityname,subjectID,variable)%>%
    summarise(mean(value))%>%print

# cleaning memory (all except clean_data)
unlink(tempFol)
rm(list = ls()[ls()!="clean_data"])

# splitting variable column and removing resulting nested data frame using function flatten of jsonlite package
clean_data<-transform(clean_data,variable=colsplit(variable, pattern ="-",names = c("signal", "calc","direction")))
clean_data<-flatten(clean_data)

# creating folder called data_qwerty in your working directiry if it doesn't exist
if(!file.exists("./data_qwerty")){dir.create("./data_qwerty")}

# outputing csv file with clean aggregated data to current working directory
write.table(clean_data,file="./data_qwerty/ActivityRecognitionTidy.csv", sep=";")

print(paste("File ActivityRecognitionTidy.csv can be found here: ",getwd(),"/data_qwerty",sep=""))










