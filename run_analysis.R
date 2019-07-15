install.packages('dplyr')
library(dplyr)

## 1.Merges the training and the test sets to create one data set.

## Reading training data
x_train <- read.table('.UCI HAR Dataset\\train\\X_train.txt')
y_train <- read.table('.UCI HAR Dataset\\train\\Y_train.txt')
subject_train <-  read.table('.UCI HAR Dataset\\train\\subject_train.txt')

## Reading test data 
x_test <- read.table('.UCI HAR Dataset\\test\\X_test.txt')
y_test <- read.table('.UCI HAR Dataset\\test\\y_test.txt')
subject_test <-  read.table('.UCI HAR Dataset\\test\\subject_test.txt')

## Reading features
features <-read.table('.UCI HAR Dataset\\features.txt')

## Reading activity labels
activity_labels <- read.table('.UCI HAR Dataset\\activity_labels.txt')

## xData
x_Data <- rbind(x_train, x_test)

## yData
y_Data <- rbind(y_train, y_test)

## subject data 
subject_Data <- rbind(subject_train, subject_test)


## 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
selected_features <- features[grep('mean|std', features[,2]),]
x_Data <- x_Data[selected_features[,1]]


## 3.Uses descriptive activity names to name the activities in the data set
colnames(y_Data) <- 'ActivityID'

y_Data$activity_labels <- factor(y_Data$ActivityID, labels = as.character(activity_labels[,2]))
activity_labels <- y_Data[,-1]

## 4.Appropriately labels the data set with descriptive variable names. 
colnames(x_Data) <- features[selected_features[,1],2]

## 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
colnames(subject_Data) <- 'subjectID'


Total <- cbind(subject_Data, activity_labels, x_Data) 
Mean <- Total %>% group_by(activity_labels, subjectID) %>%  summarise_all(funs(mean))


## Export
write.table(Mean, file = '.tidydata.txt', row.names = FALSE, col.names = FALSE)

