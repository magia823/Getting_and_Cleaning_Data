## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#filesPath <- "C:/Users/mkocic/Desktop/Coursera/Getting and Cleaning Data/data/UCI HAR Dataset"

###set working directory
setwd("C:/Users/mkocic/Desktop/Coursera/Getting and Cleaning Data/data")


#### install pakages
if (!require("data.table")) {
  install.packages("data.table")
}
#### install package
if (!require("reshape2")) {
  install.packages("reshape2")
}

#require("data.table")
#require("reshape2")
library(data.table)
library(reshape2)
#LOAD DATA
##############################################################################
# Load: activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

# Load: data column names
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

##############################################################################
# Load and process data X_test & y_test data.
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")

# Load and process X_train & y_train data.
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

### load subject test data
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
### load subject train data
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
#############################################################################

###CHANGE COLOUMN NAMES  in cxtrain and xtest with feature names
names(X_train) = features
#change the cloumn name in dataset xtest
names(X_test) = features

###### change subject test and train column  name into subject
names(subject_test) = "subject"
names(subject_train) = "subject"


# remove parentheses in column names
features <- gsub('[()]', '', features)

#############################################################################

# Extract only  the mean and standard deviation for each measurement 
extract_features <- grepl("mean|std", features)

#############################################################################

# X_TEST
# Extract only the measurements on the mean and standard deviation for each measurement.
X_test = X_test[,extract_features]
#X TRAIN
# Extract only the measurements on the mean and standard deviation for each measurement.
X_train = X_train[,extract_features]

#############################################################################
#3. Uses descriptive activity names to name the activities in the data set.
#Y_TEST
# Load activity labels, add second column  with corresponding activity labels with 1st column in y_test
y_test[,2] = activity_labels[y_test[,1]]
### givee newm column names to frst and second column
names(y_test) = c("Activity_ID", "Activity_Label")

#############################################################################
#3. Uses descriptive activity names to name the activities in the data set.
#Y TRAIN
# create second column in y_train dataset. with activity lebels corresponding to 1st column from y-train
y_train[,2] = activity_labels[y_train[,1]]
#change column names
names(y_train) = c("Activity_ID", "Activity_Label")

###############################################################################
# 1. Merges the training and the test sets to create one data set.
#MERGE
# bind data TEST  column bind (subject test, y-test and x test)
test_data <- cbind(as.data.table(subject_test), y_test, X_test)
# bind  data TRAIN; column bind subject train, y train and x train
train_data <- cbind(as.data.table(subject_train), y_train, X_train)
# Merge test and train data; row bind test data and train data
all_data = rbind(test_data, train_data)

###############################################################################
# 4. Appropriately labels the data set with descriptive activity names
# vector with column names for melt id 
id_labels   = c("subject", "Activity_ID", "Activity_Label")
### 
data_labels = setdiff(colnames(all_data), id_labels)
##############################################################################
#MELT
melt_data = melt(all_data, id = id_labels, measure.vars = data_labels)

#it looks like this
#subject Activity_ID   Activity_Label                        variable       value
#1:       2           5         STANDING               tBodyAcc-mean()-X  0.25717778
#2:       2           5         STANDING               tBodyAcc-mean()-X  0.28602671
#3:       2           5         STANDING               tBodyAcc-mean()-X  0.27548482
#4:       2           5         STANDING               tBodyAcc-mean()-X  0.27029822
#5:       2           5         STANDING               tBodyAcc-mean()-X  0.27483295
#---                                                                                 
#813617:      30           2 WALKING_UPSTAIRS fBodyBodyGyroJerkMag-meanFreq() -0.07015670
#813618:      30           2 WALKING_UPSTAIRS fBodyBodyGyroJerkMag-meanFreq()  0.16525919
#813619:      30           2 WALKING_UPSTAIRS fBodyBodyGyroJerkMag-meanFreq()  0.19503401
#813620:      30           2 WALKING_UPSTAIRS fBodyBodyGyroJerkMag-meanFreq()  0.01386542
#813621:      30           2 WALKING_UPSTAIRS fBodyBodyGyroJerkMag-meanFreq() -0.05840

################################################################################
# 5. Creates a 2nd, independent tidy data set with the average of each variable for each activity and each subject.
#DCAST (mean function)
# Apply mean function to dataset using dcast function
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

# Our tidy data now looks like this:
# 
# subject activity_label tBodyAcc-mean-X tBodyAcc-mean-Y     ...
# 1       1         LAYING       0.2215982    -0.040513953   ...
# 2       1        SITTING       0.2612376    -0.001308288   ...
# 3       1       STANDING       0.2789176    -0.016137590   ...

# where in rows we have means of measurements grouped by subject and activity.

##############################################################################
#WRITE DATA

#save as plain text file
write.table(tidy_data, file = "./tidy_data.txt",  row.name=FALSE)


