url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
dir<-"data.zip"
if(!file.exists(dir)){download.file(url,dir,"curl")}
unzip(dir,exdir = ".")

##Merges the training and the test sets to create one data set.
dirParentName<-"UCI HAR Dataset"
Xtrain<-read.table(paste(dirParentName,"train","X_train.txt",sep = "/"))
Xtest<-read.table(paste(dirParentName,"test","X_test.txt",sep = "/"))
combined<-rbind(Xtrain,Xtest)
features<-read.table(paste(dirParentName,"features.txt",sep="/"))
names(combined)<-features[,2]
##Extracts only the measurements on the mean and standard deviation for each measurement. 
selected<-combined[,grep("mean|std",names(combined),value = F)]
##Uses descriptive activity names to name the activities in the data set
ytrain<-read.table(paste(dirParentName,"train","y_train.txt",sep = "/"))
ytest<-read.table(paste(dirParentName,"test","y_test.txt",sep = "/"))
activities<-rbind(ytrain,ytest)
activities<-as.vector(activities[,1])

subTrain<-read.table(paste(dirParentName,"train","subject_train.txt",sep = "/"))
subTest<-read.table(paste(dirParentName,"test","subject_test.txt",sep = "/"))
subjects<-rbind(subTrain,subTest)

activityLabel<-read.table(paste(dirParentName,"activity_labels.txt",sep = "/"))
activities<-sapply(activities, function(x){activityLabel[match(x,activityLabel[,1]),2]})

##creates a second, independent tidy data set with the average of each variable for each activity and each subject.


clean<-cbind(Subject=subjects,Activity=activities,selected)
names(clean)[1]="Subject"

##Appropriately labels the data set with descriptive variable names. 
names(clean)<-gsub("tBodyAcc","Time Body Acceleration Signal",names(clean))
names(clean)<-gsub("tGravityAcc","Time Gravity Acceleration Signal",names(clean))
names(clean)<-gsub("tBodyAccJerk","Time Body linear acceleration",names(clean))
names(clean)<-gsub("tBodyGyroJerk","Time Body Angular Velocity",names(clean))
names(clean)<-gsub("f","Frequency",names(clean))

##write.table(clean,"cleaningData.txt",row.name = FALSE) cols not aligned 
library(gdata)
write.fwf(clean,"clData.txt",sep="\t",rownames=F)
