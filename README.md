## DESCRIPTORS AND MEASUREMENTS of the data collected from the accelerometers from the Samsung Galaxy S smartphone. 

This file explains wich transformations does the script "run_analysis.R" to convert the input dataset of 10299 rows and 563 columns into a new dataset of 180 rows and 68 columns.

The generated dataset follows the principles of "tidy data" described in http://www.jstatsoft.org/v59/i10/paper and can also be found in the file "tidyDataset.txt". A coodebook is also provided in this folder, to describe the meaning of each column.  


## Description of the script

The script generates a tidy dataset where for each of the 180 samples, the following information is provided:
- Measurements on the Mean and the Standard deviation of 33 different domain variables. 
- Its observed activity (with a descriptive value)
- An identifier of the subject representing the sample.

## Script's data input

The samples of the input dataset are divided into 2 datasets, each of them located in a separate directory: "train and "test". Each dataset is provided as a set of files containing the inputs (for dataset train: "X_train.txt" and "subject_train.txt"; for dataset test: "X_test.txt" and "subject_test.txt") and the observed output (for dataset train: "y_train.txt; for dataset test: "y_test.txt"). The diagramm provided by David Hood in the Coursera forum explains the relation between the files.

The headers of the dataset comes from the file "features.txt". For information about how the data has been collected and all the columns contained in the original dataset, see file "features_info.txt"

##Script's data processing

The script reads datasets from several files and joins them. After that, the dataset is filtered so that it only includes measurements on the Mean and the Standard deviation, the observed activity (with a descriptive value). Finally, some processing is done to get a tidy dataset where:
- The variable with name "activity_label" has descriptive values, instead of numbers, provided in a separate dictionary.
- All the variable names are descriptive using the list "meanAndStdColNames" created previously

Finally, it create a new dataset with the average for each combination of subject, activity, and variable


## Script's data output

The script requires the library "sqldf" to be installed

It generates a dataset of 180 rows and 68 columns.

To read in R the dataset returned by the script, you can use the following lines which directly download the dataset from the submission site and read it as a table into R

address = "https://s3.amazonaws.com/coursera-uploads/user-4c6850571373ef7d2ee52e56/973502/asst-3/7d2163b0186211e5ac5251108ea066d7.txt"
address = sub("^https", "http", address)
data = read.table(url(address), header = TRUE)
View(data)