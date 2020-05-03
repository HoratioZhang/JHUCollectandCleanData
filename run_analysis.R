getwd()
setwd('.../UCIHARDataset')

trainingLables<-read.table("train/y_train.txt",header=FALSE,sep=" ")
#trainingSet<-read.table("train/X_train.txt",header=FALSE,sep=" ")

mat2 <- scan("train/X_train.txt")

trainingDataframe <- data.frame(matrix(ncol = 561, nrow = 0))

for (i in seq(1:561)) {
  names(trainingDataframe)[i] <- paste('training Item', i)  
}

d<- seq(0,7351)

for (variable in d) {
  print(variable)
  startIndex <- variable*561 + 1
  endIndex <- startIndex + 560
  oneRow = mat[startIndex:endIndex]
  trainingDataframe[nrow(trainingDataframe) + 1, ] = oneRow
}

trainingDataframe['TrainingLabel'] = trainingLables

trainingSubjects<-read.table("train/subject_train.txt",header=FALSE,sep=" ")

trainingDataframe['TrainingSubject'] = trainingSubjects




testingLables<-read.table("test/y_test.txt",header=FALSE,sep=" ")
#trainingSet<-read.table("train/X_train.txt",header=FALSE,sep=" ")

mat3 <- scan("test/X_test.txt")

testingDataframe <- data.frame(matrix(ncol = 561, nrow = 0))

for (i in seq(1:561)) {
  names(testingDataframe)[i] <- paste('testingItem', i)  
}

d2<- seq(0,2946)

for (variable in d2) {
  print(variable)
  startIndex <- variable*561 + 1
  endIndex <- startIndex + 560
  oneRow = mat[startIndex:endIndex]
  testingDataframe[nrow(testingDataframe) + 1, ] = oneRow
}

testingDataframe['TestingLabel'] = testingLables

testSubjects<-read.table("test/subject_test.txt",header=FALSE,sep=" ")

testingDataframe['TrainingSubject'] = testSubjects



library(dplyr)

mergedDataFrame <- full_join(trainingDataframe, testingDataframe, by = 'TrainingSubject')


totalMeans <- colMeans(mergedDataFrame, na.rm = TRUE) # The means 

totalSTD <- sapply(mergedDataFrame, sd, na.rm = TRUE) # The STD

#Uses descriptive activity names to name the activities in the data set
index <- mergedDataFrame$TrainingLabel == 1
mergedDataFrame$TrainingLabel[index] <- 'WALKING' 
index <- mergedDataFrame$TrainingLabel == 2
mergedDataFrame$TrainingLabel[index] <- 'WALKING_UPSTAIRS' 
index <- mergedDataFrame$TrainingLabel == 3
mergedDataFrame$TrainingLabel[index] <- 'WALKING_DOWNSTAIRS' 
index <- mergedDataFrame$TrainingLabel == 4
mergedDataFrame$TrainingLabel[index] <- 'SITTING' 
index <- mergedDataFrame$TrainingLabel == 5
mergedDataFrame$TrainingLabel[index] <- 'STANDING' 
index <- mergedDataFrame$TrainingLabel == 6
mergedDataFrame$TrainingLabel[index] <- 'LAYING' 

index <- mergedDataFrame$TestingLabel == 1
mergedDataFrame$TestingLabel[index] <- 'WALKING' 
index <- mergedDataFrame$TestingLabel == 2
mergedDataFrame$TestingLabel[index] <- 'WALKING_UPSTAIRS' 
index <- mergedDataFrame$TestingLabel == 3
mergedDataFrame$TestingLabel[index] <- 'WALKING_DOWNSTAIRS' 
index <- mergedDataFrame$TestingLabel == 4
mergedDataFrame$TestingLabel[index] <- 'SITTING' 
index <- mergedDataFrame$TestingLabel == 5
mergedDataFrame$TestingLabel[index] <- 'STANDING' 
index <- mergedDataFrame$TestingLabel == 6
mergedDataFrame$TestingLabel[index] <- 'LAYING' 

#Calculate average of each activity
averageOfActivitiesTraining = aggregate(trainingDataframe[, c(1:561)], list(trainingDataframe$TrainingLabel), mean, na.action = na.omit)
averageOfActivitiesTesting = aggregate(testingDataframe[, c(1:561)], list(testingDataframe$TestingLabel), mean, na.action = na.omit)

averageOfAllActivities = (averageOfActivitiesTraining * 7352.0 + averageOfActivitiesTesting * 2947.0) / (7352.0 + 2947.0)


averageOfWalking <- averageOfAllActivities[1, 2:562]
averageOfWalking_Upstairs <- averageOfAllActivities[2, 2:562]
averageOfWalking_Downstairs <- averageOfAllActivities[3, 2:562]
averageOfSitting <- averageOfAllActivities[4, 2:562]
averageOfStanding <- averageOfAllActivities[5, 2:562]
averageOfLaying <- averageOfAllActivities[6, 2:562]

#Calculate average of each subject
averageOfSubjectsTraining = aggregate(trainingDataframe[, c(1:561)], list(trainingDataframe$TrainingSubject), mean, na.action = na.omit)
averageOfSubjectsTesting = aggregate(testingDataframe[, c(1:561)], list(testingDataframe$TrainingSubject), mean, na.action = na.omit)


#Second Data set
SecondDF <- data.frame(matrix(ncol = 561, nrow = 0))
SecondDF[nrow(SecondDF) + 1, ] <- averageOfWalking
SecondDF[nrow(SecondDF) + 1, ] <- averageOfWalking_Upstairs
SecondDF[nrow(SecondDF) + 1, ] <- averageOfWalking_Downstairs
SecondDF[nrow(SecondDF) + 1, ] <- averageOfSitting
SecondDF[nrow(SecondDF) + 1, ] <- averageOfStanding
SecondDF[nrow(SecondDF) + 1, ] <- averageOfLaying

for (variable in seq(1:21)) {
 OneSubject <- averageOfSubjectsTraining[variable, 1:561]
 SecondDF[nrow(SecondDF) + 1, ] <- OneSubject
}

for (variable in seq(1:9)) {
  OneSubject <- averageOfSubjectsTesting[variable, 1:561]
  SecondDF[nrow(SecondDF) + 1, ] <- OneSubject
}

for (variable in seq(1:561)) {
  names(SecondDF)[variable] <- paste('item', variable)
}

row.names(SecondDF)[1] <- 'averageOfWalking'
row.names(SecondDF)[2] <- 'averageOfWalking_Upstairs'
row.names(SecondDF)[3] <- 'averageOfWalking_Downstairs'
row.names(SecondDF)[4] <- 'averageOfSitting'
row.names(SecondDF)[5] <- 'averageOfStanding'
row.names(SecondDF)[6] <- 'averageOfLaying'



for (variable in seq(0:20)) {
  indix = variable * 2 + 1
  row.names(SecondDF)[7 + variable] = paste('subject', indix)
}

for (variable in seq(1:9)) {
  indix = variable * 2
  row.names(SecondDF)[27 + variable] = paste('subject', indix)
}

write.table(SecondDF, file = "analysis_results.txt", sep = ",", row.names=FALSE)


