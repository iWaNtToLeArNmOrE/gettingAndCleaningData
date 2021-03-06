# Getting and cleaning data: course project 
    
## Reading data


#Read the training dataset
train <- read.table("./train//X_train.txt")

#Read the test dataset
test <- test <- read.table("./test//X_test.txt")

#Read the list of features that will be sued as variable names
features <- read.table("./features.txt")
features[,2] <- gsub("()-", ".", tolower(as.character(features[,2])), fixed =TRUE)
features[,2] <- gsub("()", ".", tolower(as.character(features[,2])), fixed =TRUE)
features[,2] <- gsub("-", ".", tolower(as.character(features[,2])), fixed =TRUE)
features[,2] <- gsub(",", ".", as.character(features[,2]), fixed =TRUE)
features[,2] <- gsub("(", ".", as.character(features[,2]), fixed =TRUE)
features[,2] <- gsub(")", ".", as.character(features[,2]), fixed =TRUE)

#Read the list of training subjects
trainingSub <- read.table("./train//subject_train.txt")

#Read the list of test subjects
testSub <- read.table("./test//subject_test.txt")

#Read the training labels
labelTrain <- read.table("./train//y_train.txt")

#Read the test labels
labelTest <- read.table("./test//y_test.txt")

#Read activity names and the activity labels
activityNames <- read.table("./activity_labels.txt")


## Codes for merging data


#Add a column containing the subject ID to training dataset
trainWithSub <- cbind(train, trainingSub)

#Add a column containing the subject ID to test dataset
testWithSub <- cbind(test, testSub)

#Add activity labels to training dataset
trainWithSubAndAct <- cbind(trainWithSub, labelTrain)

#Add activity labels to test dataset
testWithSubAndAct <- cbind(testWithSub, labelTest)

#Merge the training and activity datasets
mergedTrainAndTest <- rbind(trainWithSubAndAct, testWithSubAndAct)

#Add variable names to the merged dataset
colnames(mergedTrainAndTest) <- c(features[,2], "Subject.ID", "activityLabel")


## Code for adding a column of activity names and extracting only the mean and standard deviation

#Convert activity label to activity name
numObs <- length(mergedTrainAndTest$activityLabel)
counter = 1
tempVect <- rep(0, times = numObs)
rownames(activityNames) <- activityNames[,1]

while (counter <= numObs){
    tempVect[counter] <- as.character(activityNames[mergedTrainAndTest$activityLabel[counter], 2])
    counter = counter + 1
}

#Finalized merged dataset
finalizedMerged <- cbind(mergedTrainAndTest, tempVect)

#Renaming the columns in the merged dataset
colnames(finalizedMerged) <- c(as.character(features[,2]), "Subject.ID", "activityLabel", 
                               "activityName")

#A list of all variable names extracted from the file features.txt
varList <- as.character(features[,2])

#A list of variable names containing ".mean". These variable names correspond to the mean of the measurements
meanVarList <- varList[grep(".mean", varList, fixed = TRUE)]

#A list of variable names containing ".mean". These variable names correspond to the standard deviation of the measurements
stdVarList <- varList[grep(".std", varList, fixed = TRUE)]

#A vector containing the column indices of mean variables
meanVarLoc <- which(varList %in% meanVarList)

#A vector containing the column indices of standard deviation variables
stdVarLoc <- which(varList %in% stdVarList)

#Initiates a data frame for storing the extracted means
onlyMeans <- data.frame(finalizedMerged$Subject.ID, finalizedMerged$activityName)

#Creates a dataframe that contains only the extracted means
onlyMeans <- cbind(onlyMeans, finalizedMerged[,meanVarLoc])

#Creates a dataframe that contains only the extracted means and standard deviations
meansAndStd <- cbind(onlyMeans, finalizedMerged[,stdVarLoc])

## The code for creating the tidy dataset

#Splits the means and standard deviation data according the activity names
subSplit <- split(meansAndStd, as.factor(meansAndStd$finalizedMerged.activityName))

#initiates a dataframe to store the average means and standard deviations of every subject corresponding to the activity named "LAYING"
layingTidyData <- data.frame(matrix(data = NA, nrow = 30, ncol = 81))

#initiates a dataframe to store the average means and standard deviations of every subject corresponding to the activity named "SITTING"
sitTidyData <- data.frame(matrix(data = NA, nrow = 30, ncol = 81))

#initiates a dataframe to store the average means and standard deviations of every subject corresponding to the activity named "STANDING"
standTidyData <- data.frame(matrix(data = NA, nrow = 30, ncol = 81))

#initiates a dataframe to store the average means and standard deviations of every subject corresponding to the activity named "WALKING"
walkTidyData <- data.frame(matrix(data = NA, nrow = 30, ncol = 81))

#initiates a dataframe to store the average means and standard deviations of every subject corresponding to the activity named "WALKING_DOWNSTAIRS"
downTidyData <- data.frame(matrix(data = NA, nrow = 30, ncol = 81))

#initiates a dataframe to store the average means and standard deviations of every subject corresponding to the activity named "WALKING_UPSTAIRS"
upTidyData <- data.frame(matrix(data = NA, nrow = 30, ncol = 81))

#Creates a new dataframe containg all the mean and standard deviation readings corresponding to the activity named "LAYING"
laying <- subSplit$LAYING

#Splits the above dataframe according to the subject id
layingSplit <- split(laying, laying$finalizedMerged.Subject.ID)

#In the following for loop, 'i' corresponds to subject id and 'j' corresponds to the column index of the variable whose average needs to be calculated
for (i in 1:30) {
    for (j in 3:81){
        
        #assigns the subject id to first column
        layingTidyData[i,1] <- as.character(i)
        #Assigns the activity name to the second column
        layingTidyData[i,2] <- as.character("LAYING")
        #Calculates and assigns the average ith row and jth column
        layingTidyData[i,j] <- mean(data.matrix(layingSplit[[i]][j]))
    }
}

#Creates a new dataframe containg all the mean and standard deviation readings corresponding to the activity named "SITTING"
sitting <- subSplit$SITTING

#Splits the above dataframe according to the subject id
sitSplit <- split(sitting, sitting$finalizedMerged.Subject.ID)

#In the following for loop, 'i' corresponds to subject id and 'j' corresponds to the column index of the variable whose average needs to be calculated
for (i in 1:30) {
    for (j in 3:81){
        
        #assigns the subject id to first column
        sitTidyData[i,1] <- as.character(i)
        #Assigns the activity name to the second column
        sitTidyData[i,2] <- as.character("SITTING")
        #Calculates and assigns the average ith row and jth column
        sitTidyData[i,j] <- mean(data.matrix(sitSplit[[i]][j]))
    }
}

#Creates a new dataframe containg all the mean and standard deviation readings corresponding to the activity named "STANDING"
stand <- subSplit$STANDING

#Splits the above dataframe according to the subject id
standSplit <- split(stand, stand$finalizedMerged.Subject.ID)

#In the following for loop, 'i' corresponds to subject id and 'j' corresponds to the column index of the variable whose average needs to be calculated
for (i in 1:30) {
    for (j in 3:81){
        
        #assigns the subject id to first column
        standTidyData[i,1] <- as.character(i)
        #Assigns the activity name to the second column
        standTidyData[i,2] <- as.character("STANDING")
        #Calculates and assigns the average to ith row and jth column
        standTidyData[i,j] <- mean(data.matrix(standSplit[[i]][j]))
    }
}

#Creates a new dataframe containg all the mean and standard deviation readings corresponding to the activity named "WALKING"
walk <- subSplit$WALKING

#Splits the above dataframe according to the subject id
walkSplit <- split(walk, walk$finalizedMerged.Subject.ID)

#In the following for loop, 'i' corresponds to subject id and 'j' corresponds to the column index of the variable whose average needs to be calculated
for (i in 1:30) {
    for (j in 3:81){
        
        #assigns the subject id to first column
        walkTidyData[i,1] <- as.character(i)
        #Assigns the activity name to the second column
        walkTidyData[i,2] <- as.character("WALKING")
        #Calculates and assigns the average to ith row and jth column
        walkTidyData[i,j] <- mean(data.matrix(walkSplit[[i]][j]))
    }
}

#Creates a new dataframe containg all the mean and standard deviation readings corresponding to the activity named "WALIKING_DOWNSTAIRS"
down <- subSplit$WALKING_DOWNSTAIRS

#Splits the above dataframe according to the subject id
downSplit <- split(down, down$finalizedMerged.Subject.ID)

#In the following for loop, 'i' corresponds to subject id and 'j' corresponds to the column index of the variable whose average needs to be calculated
for (i in 1:30) {
    for (j in 3:81){
        
        #assigns the subject id to first column
        downTidyData[i,1] <- as.character(i)
        #Assigns the activity name to the second column
        downTidyData[i,2] <- as.character("WALKING_DOWNSTAIRS")
        #Calculates and assigns the average to ith row and jth column
        downTidyData[i,j] <- mean(data.matrix(downSplit[[i]][j]))
    }
}

#Creates a new dataframe containg all the mean and standard deviation readings corresponding to the activity named "WALKING_UPSTAIRS"
up <- subSplit$WALKING_UPSTAIRS

#Splits the above dataframe according to the subject id
upSplit <- split(up, up$finalizedMerged.Subject.ID)

#In the following for loop, 'i' corresponds to subject id and 'j' corresponds to the column index of the variable whose average needs to be calculated
for (i in 1:30) {
    for (j in 3:81){
        
        #assigns the subject id to first column
        upTidyData[i,1] <- as.character(i)
        #Assigns the activity name to the second column
        upTidyData[i,2] <- as.character("WALKING_UPSTAIRS")
        #Calculates and assigns the average to ith row and jth column
        upTidyData[i,j] <- mean(data.matrix(upSplit[[i]][j]))
    }
}

#Combines the calculated averages into one file for submission
tidyData <- rbind(layingTidyData, sitTidyData, standTidyData, walkTidyData, downTidyData, upTidyData)

#Provides the column names to the tidy data
colnames(tidyData) <- as.character(colnames(meansAndStd))

#str(tidyData)

## Writing tidy data to a file

#Use write.table function to write the tidy data to hard disk
write.table(tidyData, file ="tidyData.txt", row.names= FALSE)
