setwd("/Users/Sivaneri/Documents/Nithya/Education/Coursera_Dta_Science/Assignments/Getting and cleaning data")
if(!file.exists("./data"))
  {dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Samsung_Dataset.zip",method="curl")
#Unzipping the file
unzip(zipfile="./data/Samsung_Dataset.zip",exdir="./data")
#Getting the list of filesunder UCI HAR Dataset
path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
files
#Reading the activity files
data_ActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
data_ActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)
#Reading the Subject files
data_SubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
data_SubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
#Reading Features file
data_FeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
data_FeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)
#Properties of the above variable
str(data_ActivityTest)
str(data_ActivityTrain)
str(data_SubjectTrain)
str(data_SubjectTest)
str(data_FeaturesTest)
str(data_FeaturesTrain)
#Merging the test and training data
#By rows
data_Subject <- rbind(data_SubjectTrain, data_SubjectTest)
data_Activity<- rbind(data_ActivityTrain, data_ActivityTest)
data_Features<- rbind(data_FeaturesTrain, data_FeaturesTest)
#Assigning new meaningfull variable names
names(data_Subject)<-c("Subject")
names(data_Activity)<- c("Activity")
data_FeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(data_Features)<- data_FeaturesNames$V2
#Merging by columns
data_Combine <- cbind(data_Subject, data_Activity)
Data <- cbind(data_Features, data_Combine)
#Extracting the mean and sd of each measurement
subdata_FeaturesNames<-data_FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", data_FeaturesNames$V2)]
#Subsetting the data frame
selected_Names<-c(as.character(subdata_FeaturesNames), "Subject", "Activity" )
Data<-subset(Data,select=selected_Names)
str(Data)
#Descriptine names 
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)
head(Data$Activity,30)
#Labelling variable with descripting names
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
names(Data)
#Tidy data set and output
library(plyr);
Data2<-aggregate(. ~Subject + Activity, Data, mean)
Data2<-Data2[order(Data2$Subject,Data2$Activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)
