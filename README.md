# Getting_and_Cleaning_Data
This is a repository for any and all code written for the Getting and Cleaning Data Coursera course through Johns Hopkins University.



The R script called "run_analysis.R" does the following:

Reads activity labels from file named "Activity_Labels.txt".
Reads column names from file named "features.txt".
Reads test data (x, y and subject) from 'test/X_test.txt', 'test/y_test.txt', "test/subject_test.txt".
Reads train data from 'train/X_train.txt', 'train/y_train.txt', "train/subject_train.txt".
Sets column names for test data and train data to what was read from "features.txt".
Removes parentheses in column names ("Something-std()-X" becomes "Something-std-X").
Selects only data where column names contain "-mean" or "-std" suffix.
Adds a new column "Activity_Label" next to activity IDs in dataset read from "Activity_Labels.txt" and fill it with those labels.
Adds new columns "subject", "Activity_ID", "Activity_Label" into our X dataset.
Merges test and train data.
Melts data putting all measurements as groups underneath one another like this:
subject Activity_ID Activity_Label variable value 1: 2 5 STANDING tBodyAcc-mean-X 0.2571778 2: 2 5 STANDING tBodyAcc-mean-X 0.2860267 3: 2 5 STANDING tBodyAcc-mean-X 0.2754848 ............................................................... n-2: 30 2 WALKING_UPSTAIRS fBodyBodyGyroJerkMag-meanFreq 0.19503401 n-1: 30 2 WALKING_UPSTAIRS fBodyBodyGyroJerkMag-meanFreq 0.01386542 n: 30 2 WALKING_UPSTAIRS fBodyBodyGyroJerkMag-meanFreq -0.05840161

Applies mean function to dataset using dcast function to calculate means by activity and subject.
subject Activity_Label tBodyAcc-mean-X tBodyAcc-mean-Y ... 1 1 LAYING 0.2215982 -0.040513953 ... 2 1 SITTING 0.2612376 -0.001308288 ... 3 1 STANDING 0.2789176 -0.016137590 ...

Stores tidy_data object in it in plain text file called "tidy_data.txt".
