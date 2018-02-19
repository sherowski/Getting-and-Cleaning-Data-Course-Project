#download data source
#unzip data source
#setwd where data source was saved
getwd()
setwd("./UCI HAR Dataset")


feat<-read.table("./features.txt")
act_lab<-read.table("./activity_labels.txt")

colnames(act_lab)<-c('activityId','activityType')

subject_test<-read.table("./test/subject_test.txt", col.names = "subject")
#head(subject_test, 5)
x_test<-read.table("./test/X_test.txt",col.names = feat[,2])
y_test<-read.table("./test/y_test.txt",col.names = "activityId")

subject_train<-read.table("./train/subject_train.txt",col.names = "subject")
x_train<-read.table("./train/X_train.txt",col.names = feat[,2])
y_train<-read.table("./train/y_train.txt",col.names = "activityId")

#use descriptive activity name
y_test_act <- left_join(y_test, act_lab, by ="activityId")
y_train_act <- left_join(y_train, act_lab, by ="activityId")

#merge training and test sets to create one data set
merge_train<- cbind(subject_train, y_train_act, x_train)
merge_test<- cbind(subject_test, y_test_act, x_test)
comb_all<-rbind(merge_train,merge_test)
comb_all_tidy<- select(comb_all, -activityId) 

#extract only measrurments on the mean and std for each measurement
comb_mean_sd<-select(comb_all_tidy, contains("mean"),contains("std"))

#appropriately labels the data set with descriptive variable name
comb_mean_sd$subject<-as.factor(comb_all$subject)
comb_mean_sd$activity<-as.factor(comb_all$activityType)

#create a second, independent tidy data set with average of each variable for each activity and each subject
all_tidyData_avg <- comb_mean_sd %>%
        group_by(subject, activity) %>%
                summarise_all(funs(mean))
write.table(all_tidyData_avg, file="./tidydataset.txt", row.names=FALSE, col.names= TRUE)
