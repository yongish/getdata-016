# Coursera "Getting and Cleaning Data" Course Project.

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","ucidata.zip")
unzip("ucidata.zip")

# 1.Merges the training and the test sets to create one data set.
data <- mapply(function (path1, path2) {rbind(read.table(path1), read.table(path2))},
               list.files("~/UCI HAR Dataset/train", recursive=TRUE,
                          pattern="\\.txt$",full.names=TRUE),
               list.files("~/UCI HAR Dataset/test", recursive=TRUE,
                          pattern="\\.txt$",full.names=TRUE))

# 4.Appropriately labels the data set with descriptive variable names. 
names(data) <- unlist(strsplit(basename(list.files("~/UCI HAR Dataset/train", recursive=TRUE, pattern="\\.txt$")),"_train.txt"))
# Read in features.txt.
# Do a string match to "mean" and "std" to extract only the mean and sd.
# Can use a pipe command, but this will be platform (e.g. *nix, Windows) dependent, and not reproducible.
# http://stackoverflow.com/questions/2193742/ways-to-read-only-select-columns-from-a-file-into-r-a-happy-medium-between-re
feature.names <- tolower(read.table("~/UCI HAR Dataset/features.txt", quote="\"", stringsAsFactors=FALSE)[,2])

# 2.Extracts only the measurements on the mean and 
#   standard deviation for each measurement.
# This means that only "subject", "X" and "y" are relevant. All other variables can be discarded.
extract.indexes <- grep("mean|std",feature.names)
data$X <- data$X[,extract.indexes]
colnames(data$X) <- feature.names[extract.indexes]

library(dplyr)
data <- tbl_df(cbind(data$subject, data$X, data$y))
colnames(data) <- paste0("average_", colnames(data))
colnames(data)[1] <- "subject"
colnames(data)[length(data)] <- "activity"

# 5.From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject.
data <- data 
  %>% group_by(activity, subject) 
  %>% summarise_each(funs(mean))

# 3.Uses descriptive activity names to name the activities in the data set.
data$activity <- factor(data$activity)
levels(data$activity) <- read.table("~/UCI HAR Dataset/activity_labels.txt")[,2]

write.table(data,"averageByActivityAndSubject.txt",row.names=FALSE)