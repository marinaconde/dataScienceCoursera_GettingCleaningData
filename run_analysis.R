#It joins the training and test datasets located in the subfolders "train" and "test"
#and returns a tidy version of the it, according to the principles described in http://www.jstatsoft.org/v59/i10/paper. 

# 1- Merge train and test

#Read TRAIN and TEST inputs
train_X = read.table("./train/X_train.txt");
test_X = read.table("./test/X_test.txt");

#get other features for both
train_subject = read.table("./train/subject_train.txt");
train_activity  = read.table("./train/y_train.txt");
train = cbind(train_X, train_subject, train_activity);
test_subject = read.table("./test/subject_test.txt");
test_activity  = read.table("./test/y_test.txt");
test = cbind(test_X, test_subject, test_activity);

#In both datasets, rename with descriptive name ("V1", "V2"), the last 2 columns
names(train)[562] = "subject"
names(test)[562] = "subject"
names(train)[563] = "activity_id"
names(test)[563] = "activity_id"


#number of samples to join: 10299
#number of features? 563 = 561 + subject + activity
#dim(test) 
#dim(train)

#join
all = rbind(train, test);

# 2 - Extract only the measurements on the mean and standard deviation for each measurement.
#Considering the file "features_info.txt", I suppose that mean is not the same than meanFreq, 
#thus the measurements to be included in the final dataset correspond to the columns with
#a header name containing the substring "mean" (but not "meanFreq") or "std"

#To do this, get the header names of the columns from the dataset "features" 
features = read.table("./features.txt");
names(features)[1] = "columnId";
names(features)[2] = "columnName";

#Extract only the 66 columns with a header name containing the substring "mean" (but not "meanFreq") or "std"
meanAndStdColIds = which(apply(features, 1, function (x) (
  (any(grepl("mean", x)) ||  any(grepl("std", x))) & !any(grepl("meanFreq", x)))
));
 
meanAndStd = all[,c(meanAndStdColIds, 562,563)]

#Subset in the same way the list of column names which will be added to the dataset of samples afterwards
colNames = features[meanAndStdColIds,]$columnName;

#Add the 2 new columns that have been added in step 1 (subject and activity_id)
meanAndStdColNames = append(as.character(colNames),c("subject", "activity_id"))
names(meanAndStd) = meanAndStdColNames

#Store the names of the selected features in a file to be used in the generation of the codebook

# 3 - Use descriptive activity names to name the activities in the data set
#Replace activity numbers in the data by descriptive terms such as "Walking"
#As this is achieved by merging with the dictionary of activity labels, it should be done once the train and test datasets have been merged 


#Get the dictionary with activity labels
activity_labels = read.table("./activity_labels.txt");
names(activity_labels) = c("activity_id", "activity_label")

#Join with the dataset of means and stds by the column with the same name
library(sqldf);
meanAndStdWithActivityLabel = sqldf("select * from meanAndStd join activity_labels ON activity_labels.activity_id = meanAndStd.activity_id");

#Remove the 2 columns used to join the datasets (named "activity_id")
meanAndStdWithActivityLabel$activity_id = NULL;
meanAndStdWithActivityLabel$activity_id = NULL;

#Update the list of column names with the change of columns: "activity_id" replaced by "activity_label" 
meanAndStdColNames[68] = "activity_label"

# 4 - Label the data set with descriptive variable names
names(meanAndStdWithActivityLabel) = meanAndStdColNames

# 5 - Create a new dataset with the average for each combination of subject, activity, and variable of the output of step 4
tidyDataset = aggregate(meanAndStdWithActivityLabel, by=list(meanAndStdWithActivityLabel$subject, meanAndStdWithActivityLabel$activity_label), FUN=mean)

# Remove the columns us and subject columns and rename aggregated columns
tidyDataset$subject = NULL
tidyDataset$activity_label = NULL
names(tidyDataset)[names(tidyDataset) == 'Group.1'] = 'subject'
names(tidyDataset)[names(tidyDataset) == 'Group.2'] = 'activity_label'

write.table(tidyDataset, file = "./tidyDataset.txt", row.names=FALSE)
