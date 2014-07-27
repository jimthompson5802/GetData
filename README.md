README
========================================================

For the Coursera (Johns Hopkins) course "Getting and Cleaning Data", this repository contains the class project data.

The created class data is contained in the data set **accelerometer_summary_data.csv**.

The features of the data set are described in the following file: **features_info.txt**

Code to prepare the data set is contained in **run_analysis.R**.  The steps
taken to prepare the data set are as follows:

* Download data and extract out the original accelerometer data
* Extract the activity labels to allow translation from numeric code to
activity label string
* Extract the original feature names in the data set. Make the to  create feature names legal for R. Feature name creation is based on [Google's 
R style guide found at this web site](https://google-styleguide.googlecode.com/svn/trunk/Rguide.xml#identifiers)
* Extract the training data set and merge with activity label data
* Extract the test data set and merge with activity label data
* Combine train and test sets together to create one single data set for
the class project
* Create first data set with just mean and standard deviation attributes. 
These attributes are determined if they contain the string "mean" or "std" in
the attribute name
* From the first data set create second tidy data set
* For the second tidy data set calculate mean of each numeric feature extracted
by subject and activity label
* Write out second tidy data set for class project submission



