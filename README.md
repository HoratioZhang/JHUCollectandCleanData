# README FILE 

This is the read me file to describe how the code run_analysis.R works and what are the data contained in file analysis_results.

<h1>How the script works</h1>

Firstly, please change the route in line 2
```
setwd('.../UCIHARDataset')
```
to the route on your computer to run the code successfully.

Then in my code I read the training and testing set. Also the training and testing subjects. Same to the training and testing activities file. 
```
trainingDataframe #All training Data
trainingLables #All training Lables
trainingSubjects #All training Subjects
trainingDataframe['TrainingLabel'] = trainingLables #Set labels and subjects to dataset
trainingDataframe['TrainingSubject'] = trainingSubjects

testingDataframe #All training Data
testingLables #All training Lables
testingSubjects #All training Subjects
testingDataframe['TestingLabel'] = testingLables #Set labels and subjects to dataset
testingDataframe['TestingSubject'] = testingSubjects
```

According to the length of activiteis, we could conclude that there are 7351 training observations and 2946 testing observations. Each of the observation contains a vector with 561 elements. 

I read the sets ad dataframes, I added the subjects and activity types as new two columns of the two dataframes then merge the two dataframes by column name 'TrainingSubject' aka the subjectID.

By the new big dataframe, we could calculate the means and standard deviations of the variables. 
```
library(dplyr)

mergedDataFrame <- full_join(trainingDataframe, testingDataframe, by = 'TrainingSubject')


totalMeans <- colMeans(mergedDataFrame, na.rm = TRUE) # The means 

totalSTD <- sapply(mergedDataFrame, sd, na.rm = TRUE) # The STD
```
The means vector contains 1122 columns - the means of 561 training data elements and 561 testing data elements. 
Same to the standard deviation vector.


As the second tidy data set, I firstly picked all data by activity type and grouped them. Then I calculate the means of the 561 elements in each group of different activity types.

```
#Calculate average of each activity
averageOfActivitiesTraining = aggregate(trainingDataframe[, c(1:561)], list(trainingDataframe$TrainingLabel), mean, na.action = na.omit)
averageOfActivitiesTesting = aggregate(testingDataframe[, c(1:561)], list(testingDataframe$TestingLabel), mean, na.action = na.omit)
```

Same to the subjects. I calculated the means in each of the subject groups.

```
#Calculate average of each subject
averageOfSubjectsTraining = aggregate(trainingDataframe[, c(1:561)], list(trainingDataframe$TrainingSubject), mean, na.action = na.omit)
averageOfSubjectsTesting = aggregate(testingDataframe[, c(1:561)], list(testingDataframe$TrainingSubject), mean, na.action = na.omit)
```

<h1>Codebook</h1>

In file analysis_results.txt, there is a dataframe of 561 columns and 36 rows. Each line stands for a type of activity or subject. 

For example, the first row, contains all the means of 561 elements of all observations with Walking type.

The 561 columns are the 561 elements of the data vectors.

First 6 rows refers the means in 6 activity types. 1 to 6 are WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING.

The 7th to 28th rows refers to the subjects of training. 2, 4,...42.

The 29th to 36th rows refers to the sujbects of testing. 1,3...17.

