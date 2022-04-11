rm(list=ls())

library(data.table)
library(dplyr)

setwd("C:/Users/uocou/OneDrive - IRI/Desktop/Coursera/")

#Read datasets
features <- read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)

#Training datasets
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
X_train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)

#Test datasets
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
X_test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)


###################### PART 1 ######################

subject <- rbind(subject_train, subject_test)
y <- rbind(y_train, y_test)
X <- rbind(X_train, X_test)

colnames(X) <- t(features[2])

# Final merged dataset
colnames(y) <- "Activity"
colnames(subject) <- "Subject"
finaldata <- cbind(X,y,subject)

###################### PART 2 ######################

#Check which columns have mean and sd
col_with_mean_sd <- grep(".*Mean.*|.*Std.*", names(finaldata), ignore.case=TRUE)
finalcol <- c(col_with_mean_sd, 562, 563)

#Final data whose columns have mean and sd
data <- finaldata[,finalcol]

###################### PART 3 ######################

data$Activity <- as.character(data$Activity)

for (i in 1:6){
  data$Activity[data$Activity == i] <- as.character(activity_labels[i,2])
}

data$Activity <- as.factor(data$Activity)


###################### PART 4 ######################
names(data)

#Replace some colnames in more to be more clear
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("^t", "Time", names(data))
names(data)<-gsub("^f", "Frequency", names(data))
names(data)<-gsub("tBody", "TimeBody", names(data))
names(data)<-gsub("-mean()", "Mean", names(data), ignore.case = TRUE)
names(data)<-gsub("-std()", "STD", names(data), ignore.case = TRUE)
names(data)<-gsub("-freq()", "Frequency", names(data), ignore.case = TRUE)
names(data)<-gsub("angle", "Angle", names(data))
names(data)<-gsub("gravity", "Gravity", names(data))

###################### PART 5 ######################

data$Subject <- as.factor(data$Subject)
data <- data.table(data)

new_data <- aggregate(. ~Subject + Activity, data, mean)
new_data <- new_data[order(new_data$Subject,new_data$Activity),]

write.table(new_data, file = "New_data.txt", row.names = FALSE)
