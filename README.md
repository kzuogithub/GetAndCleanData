# Getting-and-Cleaning-Data

## Project Name: Human Activity Recognition Using Smartphones Dataset

**For each record it is provided**    

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration 
- Triaxial Angular velocity from the gyroscope                                                     
- A 561-feature vector with time and frequency domain variables

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

