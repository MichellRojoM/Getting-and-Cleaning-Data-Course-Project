# Upload and store training data and validation#
###Train data ####
train_data <- read.csv("UCI HAR Dataset/train/X_train.txt",sep="",header=FALSE)
Y_train_data<- read.csv("UCI HAR Dataset/train/Y_train.txt",sep="",header=FALSE)
subject_train_data<- read.csv("UCI HAR Dataset/train/subject_train.txt",sep="",header=FALSE)

###Validate data ####
test_data <- read.csv("UCI HAR Dataset/test/X_test.txt",sep="",header=FALSE)
Y_test_data<- read.csv("UCI HAR Dataset/test/Y_test.txt",sep="",header=FALSE)
subject_test_data<- read.csv("UCI HAR Dataset/test/subject_test.txt",sep="",header=FALSE)

#### Upload and store name of columns and activity labels ### 
#Activity labels 
act_labels<-read.csv("UCI HAR Dataset/activity_labels.txt",sep="",header=FALSE)
act_labels[,2]<-as.character(act_labels[,2])
act_labels

# Columns #
features <- read.table("UCI HAR Dataset/features.txt")
features[,2]<-as.character(features[,2])
features 

#Extract only the data on mean and standard deviation and rename name of columns#

cols<- grep(".*mean.*|.*std.*", features[,2])
cols_names <- features[cols,2]
cols_names <-gsub('-mean', 'Mean', cols_names)
cols_names <- gsub('-std', 'Std', cols_names)
cols_names <- gsub('[-()]', '', cols_names)
head(cols_names)


#Merge training and test data#
# Merge training data ###
train_data<-train_data[cols]
D_train <-cbind(train_data,subject_train_data,Y_train_data)
# Merge Validate data #
test_data<-test_data[cols]
D_test<-cbind(test_data,subject_test_data,Y_test_data)
data<-rbind(D_train, D_test)

#Rename the columns of data#
colnames(data)<-c(cols_names,"Subject","Activity")

# Write Tidy Data #
data$Activity <- as.factor(data$Activity )
data$Subject <- as.factor(data$Subject)
tidydata<-aggregate(data, by=list(activity = data$Activity, subject=data$Subject), mean)
dim(tidydata)
tidydata<-tidydata[,1:81] 
write.table(tidydata, "tidydata.txt", sep="\t",row.name=FALSE)
