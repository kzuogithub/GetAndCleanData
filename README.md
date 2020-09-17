# Getting-and-Cleaning-Data
Getting and Cleaning Data Course Project
==================================================================
Human Activity Recognition Using Smartphones Dataset   
Version 1.0
==================================================================
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws
==================================================================
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:
======================================

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The dataset includes the following files:
=========================================
- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

The following is how the script in run_analysis.R works:
========================================================
**Part1: Load library and create data directory**

library(dplyr)

if(!file.exists("data")){dir.create("data")}

list.files("./data")

**Part2: Read in and work on variable names**

varName0 <- readLines("C:\\Users\\kaili\\OneDrive\\Documents\\Data Science\\Getting and Cleaning Data\\data\\features.txt")

***remove - and () from variable names***

library(stringr)

varName1 <- str_replace_all(string = varName0, pattern = "\\-",replacement ="")

varName <- str_replace_all(string = varName1, pattern = "\\(\\)",replacement ="")

str(varName)

**Part3: Read in Training dataset**

***read in X- train text file***

trainData0 <- read.table("C:\\Users\\kaili\\OneDrive\\Documents\\Data Science\\Getting and Cleaning Data\\data\\train\\X_train.txt", header=F, col.names = varName)

dim(trainData0)

***read in Y_train text file: label of six different activity***

yTrain <- read.table("C:\\Users\\kaili\\OneDrive\\Documents\\Data Science\\Getting and Cleaning Data\\data\\train\\Y_train.txt", header=F, col.names="acType")

head(yTrain)

***read in subject_train text file: differnt subject***

subTrain <- read.table("C:\\Users\\kaili\\OneDrive\\Documents\\Data Science\\Getting and Cleaning Data\\data\\train\\subject_train.txt", header=F, col.names="subjectInd")
                      
***add subject and activity type to training data***

trainData <- cbind(subTrain, yTrain, trainData0)

dim(trainData)

**Part4: read in Test data set**

***read in X - test text file***

testData0 <- read.table("C:\\Users\\kaili\\OneDrive\\Documents\\Data Science\\Getting and Cleaning Data\\data\\test\\X_test.txt",header=F, col.names = varName)

dim(testData0)

***read in Y_test text file: label of six different activity***

yTest <- read.table("C:\\Users\\kaili\\OneDrive\\Documents\\Data Science\\Getting and Cleaning Data\\data\\test\\Y_test.txt",header=F, col.names="acType")

***read in subject_train text file: different subject***

subTest <- read.table("C:\\Users\\kaili\\OneDrive\\Documents\\Data Science\\Getting and Cleaning Data\\data\\test\\subject_test.txt",header=F, col.names="subjectInd")

***add subject and activity type to training data***

testData <- cbind(subTest, yTest, testData0)

dim(testData)

**Part5: Merge the training and the test sets to create one data set**

totalData <- rbind(trainData,testData)

dim(totalData)

str(totalData)

**Part6: Extract only measurements on the mean and standard deviation for each measurement**

***extract only measurement on the mean***

onlyMean = select(totalData,contains("mean"))

dim(onlyMean)

str(onlyMean)

***extract only measurement on the standard deviation***

onlyStd = select(totalData,contains("std")) 

dim(onlyStd)

str(onlyStd)

***combine measurements on the mean and on the standard deviation***

onlyMeanStd <- cbind(onlyMean,onlyStd)

dim(onlyMeanStd)

str(onlyMeanStd)

**Part7: Uses descriptive activity names to name the activities in the data set**

totalData$acType[totalData$acType == "1"] <- "WALKING"

totalData$acType[totalData$acType == "2"] <- "WALKING-UPSTAIRS"

totalData$acType[totalData$acType == "3"] <- "WALKING-DOWNSTAIRS"

totalData$acType[totalData$acType == "4"] <- "SITTING"

totalData$acType[totalData$acType == "5"] <- "STANDING"

totalData$acType[totalData$acType == "6"] <- "LAYING"

str(totalData)

**Part8: Appropriately labels the data set with descriptive variable names**

totalDatanew <- rename(totalData, c(Subject = subjectInd, Activity = acType))

**Part9: From the data set in step4, create a second, independent tidy data set**
**with the average of each variable for each activity and each subject**

secondData <- aggregate(. ~ Activity + Subject, totalDatanew, mean)

dim(secondData)

**Datasets produced: totalData and secondData**

totalData with 10299 rows and 563 columns

secondData with 180 rows and 563 columns

**The End**

