# R v. 3.3.3  RStudio v. 1.0.136  MacOS 10.12.4

# set the working directory
setwd("~/Documents/Coursera_courses/R/Mod3/Final_project")
getwd()

# packages used
library(dplyr)

# download files for the assessment
urlfiles <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(urlfiles, destfile='./Datasets.zip', method='curl')
unzip('./Datasets.zip')

# exploring the content of the downloaded folders
dir()
dir("UCI HAR Dataset")
dir("UCI HAR Dataset/test")

# reading the tables needed for the assessment
activity_lbl <- read.table('./UCI HAR Dataset/activity_labels.txt')
features <- read.table('./UCI HAR Dataset/features.txt')

test_partic <- read.table('./UCI HAR Dataset/test/subject_test.txt')
test_set <- read.table('./UCI HAR Dataset/test/X_test.txt')
test_activity <- read.table('./UCI HAR Dataset/test/y_test.txt')

train_partic <- read.table('./UCI HAR Dataset/train/subject_train.txt')
train_set <- read.table('./UCI HAR Dataset/train/X_train.txt')
train_activity <- read.table('./UCI HAR Dataset/train/y_train.txt')

# setting column names
colnames(activity_lbl) <- c('activityId', 'activityName')

colnames(test_partic) <- 'participantId'
colnames(test_set) <- features[,2]
colnames(test_activity) <- 'activityId'

colnames(train_partic) <- 'participantId'
colnames(train_set) <- features[,2]
colnames(train_activity) <- 'activityId'

# merging test datasets
test_merge <- bind_cols(test_partic, test_activity, test_set)

# merging train datasets
train_merge <- bind_cols(train_partic, train_activity, train_set)

# merging test and train data frames into one df (Q1)
train_test_df <- rbind(train_merge, test_merge)

# extracting mean and SD (Q2), together with the participantId and activityId columns
train_test_meanSD <- train_test_df[grep('participantId|activityId|mean|std', names(train_test_df), ignore.case=TRUE)]
names(train_test_meanSD) #check that the columns are correct. Realized that I have unnecessary columns that
# include the word mean in the name, but they are not the data that I need
length(select(train_test_meanSD, contains('angle'), contains('meanFreq'))) # verify the number of columns with meanFreq in the name
train_test_meanSD <- select(train_test_meanSD, -contains('meanFreq'), -contains('angle')) # removing the unnecessary columns 
# 68 columns remaining out of 88 before removal

# adding explanatory activity names (Q3) contained in the activity_lbl table
train_test_meanSD <- inner_join(train_test_meanSD, activity_lbl, by='activityId')

# cleaning the names of columns, removing parenthesis and transforming dashes into undescores
# this is necessary for the next transformation because the select command generated errors with
# dashes and parentheses in the names. Moreover, parenthesis are not needed in variable names.
names(train_test_meanSD) <- gsub('-', '_', names(train_test_meanSD))
names(train_test_meanSD) <- gsub('[()]', '', names(train_test_meanSD)) 
names(train_test_meanSD) <- sub("^t", "time", names(train_test_meanSD))
names(train_test_meanSD) <- sub("^f", "frequency", names(train_test_meanSD))
names(train_test_meanSD) <- sub("Acc", "Accelerometer", names(train_test_meanSD))
names(train_test_meanSD) <- sub("Gyro", "Gyroscope", names(train_test_meanSD))
names(train_test_meanSD) <- sub("Mag", "Magnitude", names(train_test_meanSD))

# removing the activityId column and reordering the columns to have the activityName column in second position
train_test_meanSD <- select(train_test_meanSD, participantId, activityName, 
                            timeBodyAccelerometer_mean_X:frequencyBodyBodyGyroscopeJerkMagnitude_std)

# second tidy set (Q5) with the average of each variable for each activity and each participant
summary_set <- train_test_meanSD %>% group_by(activityName, participantId) %>% summarise_each(funs(mean))

# writing the second dataset
write.table(summary_set, 'summary_set.txt', row.name=FALSE)
