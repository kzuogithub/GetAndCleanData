################################ Getting and Cleaning Data week4 Course Project  ############################## 
# Project Name: Human Activity Recognition Using Smartphones Dataset                                          # 
###############################################################################################################
# The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years.   #
# Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING,     #
# LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and       #
# gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. #
# The experiments have been video-recorded to label the data manually.                                        #
# The obtained dataset randomly partitioned into two sets, where 70% of the volunteers selected for           #
# generating the training data and 30% the test data.                                                         #
#                                                                                                             #
# For each record it is provided:                                                                             #
# - Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.    #
# - Triaxial Angular velocity from the gyroscope.                                                             #
# - A 561-feature vector with time and frequency domain variables.                                            #
# - Its activity label.                                                                                       #
# - An identifier of the subject who carried out the experiment.                                              #
###############################################################################################################
library(dplyr)

if(!file.exists("data")){dir.create("data")}
list.files("./data")

#read in file features (all 561 variable names) as a vector
varName0 <- readLines("C:\\Users\\kaili\\OneDrive\\Documents\\Data Science\\Getting and Cleaning Data\\data\\features.txt")
library(stringr)
head(varName0)
#remove - and () from variable names
varName1 <- str_replace_all(string = varName0, pattern = "\\-",replacement ="")
varName <- str_replace_all(string = varName1, pattern = "\\(\\)",replacement ="")
head(varName)

####### read in Training data set ########
#read in X- train text file
trainData0 <- read.table("C:\\Users\\kaili\\OneDrive\\Documents\\Data Science\\Getting and Cleaning Data\\data\\train\\X_train.txt", 
                         header=F, col.names = varName)
head(trainData0)
#read in Y_train text file: label of six different activity
yTrain <- read.table("C:\\Users\\kaili\\OneDrive\\Documents\\Data Science\\Getting and Cleaning Data\\data\\train\\Y_train.txt", 
                     header=F, col.names="acType")

#read in subject_train text file: differnt subject
subTrain <- read.table("C:\\Users\\kaili\\OneDrive\\Documents\\Data Science\\Getting and Cleaning Data\\data\\train\\subject_train.txt", 
                       header=F, col.names="subjectInd")

#add subject and activity type to training data
trainData <- cbind(subTrain, yTrain, trainData0)
dim(trainData)
head(trainData,n=3)
str(trainData)

####### read in testing data set #######
#read in X - test text file
testData0 <- read.table("C:\\Users\\kaili\\OneDrive\\Documents\\Data Science\\Getting and Cleaning Data\\data\\test\\X_test.txt", 
                        header=F, col.names = varName)

#read in Y_test text file: label of six different activity
yTest <- read.table("C:\\Users\\kaili\\OneDrive\\Documents\\Data Science\\Getting and Cleaning Data\\data\\test\\Y_test.txt", 
                    header=F, col.names="acType")

#read in subject_train text file: differnt subject
subTest <- read.table("C:\\Users\\kaili\\OneDrive\\Documents\\Data Science\\Getting and Cleaning Data\\data\\test\\subject_test.txt", 
                      header=F, col.names="subjectInd")

#add subject and activity type to training data
testData <- cbind(subTest, yTest, testData0)
dim(testData)

#1. Merge the training and the test sets to create one data set
totalData <- rbind(trainData,testData)
dim(totalData)
str(totalData)

#2. Extract only the measurements on the mean and standard deviation for each measurement
# Select on columns names of the dataframe which contains mean 
onlyMean = select(totalData,contains("mean")); dim(onlyMean)
str(onlyMean)
# Select on columns names of the dataframe which contains std (standard deviation)
onlyStd = select(totalData,contains("std")); dim(onlyStd)
str(onlyStd)
# Data set only contains the measurements on the mean and standard deviation fro each measurement
onlyMeanStd <- cbind(onlyMean,onlyStd); dim(onlyMeanStd)
str(onlyMeanStd)

#3. Uses descriptive activity names to name the activities in the data set
str(totalData)
totalData$acType[totalData$acType == "1"] <- "WALKING"
totalData$acType[totalData$acType == "2"] <- "WALKING-UPSTAIRS"
totalData$acType[totalData$acType == "3"] <- "WALKING-DOWNSTAIRS"
totalData$acType[totalData$acType == "4"] <- "SITTING"
totalData$acType[totalData$acType == "5"] <- "STANDING"
totalData$acType[totalData$acType == "6"] <- "LAYING"

#4. Appropriately labels the data set with descriptive variable names
# Rename multiple columns of the dataframe at once
totalDatanew <- rename(totalData, c(Subject = subjectInd, Activity = acType))
str(totalDatanew)

#5.From the data set in step4, create a second, independent tidy data set with the average
# of each variable for each activity and each subject
secondData <- aggregate(. ~ Activity + Subject, totalDatanew, mean)
dim(secondData)
head(secondData, n=10)
