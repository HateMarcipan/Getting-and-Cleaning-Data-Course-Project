## The Code Book
File that "describes the variables, the data, and any transformations or work performed to clean up the data".



### The Data
ActivityRecognitionTidy.txt file is a result of manipulations described bellow.

It has 15480 rows (30 subjects x 6 activities x 86 variables) and 6 columns, delimited by ";".

Column names: "activityname", "subjectID", "mean.value.", "variable.signal", "variable.calc", "variable.direction"

Source data for ActivityRecognitionTidy.csv is downloaded using following link:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Full description of the source data is available here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#


For our purposes we do not need raw data under folders 'train/Inertial Signals' or 'test/Inertial Signals', so run_analysis.R script will read only following files:
- 'features.txt': contains list of columns/variable names (561 names);
- 'activity_labels.txt': list of activity IDs and descriptive names (6 names) that will be later merged with 'train/y_train.txt' and 'test/y_test.txt'
- 'train/X_train.txt': values of each observation for train data (2947 rows, 561 columns)
- 'train/y_train.txt': activity ID performed by subject (2947 rows, 1 column)
- 'train/subject_train.txt': 2971 rows identifying the subject who performed the train activity for each window sample. Its range is from 1 to 30. 
- 'test/X_test.txt': values of each observation for test data (7325 rows, 561 columns)
- 'test/y_test.txt': activity ID performed by subject (7325 rows, 1 column)
- 'test/subject_test.txt': 7325 rows identifying the subject who performed the test activity for each window sample. Its range is from 1 to 30. 


### Data merging and transformations

#### Assigning labels
1. Column/Variable names for both x_train and x_test data sets were assigned from 2nd column of the features file using names();
2. Single columns from y and subject files for test and training were called "activityID" and "subjectID" accordingly;
3. Descriptive activity names are added using merge() function on common field in both activity_labels and subject files - activityID.

#### Extracting only the measurements on the mean and standard deviation for each measurement:
1. Selecting of required variable names is performed using grepl() functions with case-insensitive search for "mean|std" (resulting into 86 selected columns).


#### Transforming, merging the training and the test sets to create one data set followed by aggregation on required level.
1. Subject, activity and observation values were merged using cbind() function on train and test data sets separately - additionally each of the 2 resulting data frames had RowNum column as row identifier for future data transformation;
2. Feature names mainly consisted of 3 parts which could potentially be useful to split into 3 different columns for future analysis, in which case data set has to be transformed from "wide" to "long" structure. This was done using melt() function leaving RowNum, subjectID and activityID as labels and all variable names as measure variables;
3. Before performing union of train and test data frames (using rbind()) column 'type' was added to identify whether activity is training or test;
4. Merged data set was aggregated using mean() on activity and subject level - 'mean.value' column;
5. As mentioned previously feature names mainly consist of 3 parts "signal"-"calculation"-"direction" which got split into 3 different columns using function transform() and colsplit():  "variable.signal", "variable.calc", "variable.direction".
	
	
	
### References

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.
