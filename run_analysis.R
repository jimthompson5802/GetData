#
# Download data and extract out
#
file.url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(file.url,"./getdata_projectfiles_UCI_HAR_Dataset.zip")
unzip("./getdata_projectfiles_UCI_HAR_Dataset.zip")

#
# read in activity labels
#
activity <- read.table("./UCI HAR Dataset/activity_labels.txt")
names(activity) <- c("activity.code","activity.label")

#
# create feature names
#
fname.df <- read.table("./UCI HAR Dataset/features.txt")

# show sample of original feature names
head(fname.df)
tail(fname.df)

#
# make the feature names legal for R 
# using Google's R style guide as basis for naming standard 
# https://google-styleguide.googlecode.com/svn/trunk/Rguide.xml#identifiers
#
features <- gsub("\\.\\.\\.","\\.",make.names(fname.df[,2]))
features <- gsub("\\.\\.$","",features)
features <- gsub("\\.$","",features)
features <- tolower(features)

# show sample of feature names after standardization
head(features)
tail(features)

#
# Construct train data set
#
train.X <- read.table("./UCI HAR Dataset/train/X_train.txt")
names(train.X) <- features

train.y <- read.table("./UCI HAR Dataset/train/y_train.txt")
names(train.y) <- "activity.code"


train.id <- read.table("./UCI HAR Dataset/train/subject_train.txt")
names(train.id) <- "subject.id"

# combined parts of the training data

train.df <- cbind(data.source=rep("train", nrow(train.id)), 
                  train.id, train.y, train.X)


#
# Construct test data set
#
test.X <- read.table("./UCI HAR Dataset/test/X_test.txt")
names(test.X) <- features

test.y <- read.table("./UCI HAR Dataset/test/y_test.txt")
names(test.y) <- "activity.code"


test.id <- read.table("./UCI HAR Dataset/test/subject_test.txt")
names(test.id) <- "subject.id"

#combine parts of the test 
test.df <- cbind(data.source=rep("test", nrow(test.id)), 
                 test.id, test.y, test.X)

#
#combine train and test sets
#
all.df <- rbind(train.df, test.df)

# show sample of data
head(all.df[, 1:6])
tail(all.df[, 1:6])

#
# create first data set with just mean and standard deviation measurements
#

#get column index for feature names containing mean or standard deviaion measures
mean.idx <- grepl("mean", names(all.df), ignore.case=TRUE)  # features with mean
std.idx <- grepl("std", names(all.df), ignore.case=TRUE)  # features with standard deviaion 

# extract out attributes for mean and standard deviation
data.set.one <- cbind(all.df[, 1:3], all.df[, mean.idx | std.idx])

# resulted attributes for data.set.one
names(data.set.one)

# add activity label
data.set.one <- merge(data.set.one,activity)


# create second tidy data set

library(plyr)
# function to calculate means of all columns except those used for idendification
# assumes the identifier columns are the first 4 columns
# used in conjunction with ddply() function.
CalcMeans <- function(df) {
    colMeans(df[, 4:(ncol(df)-1)])
}

# calculate mean of each numeric feature by subject and activity label
data.set.two <- ddply(data.set.one, .(subject.id,activity.label), CalcMeans)

#
# clean up unneeded data frames
#
rm(activity, train.X, train.y, train.id, test.X, test.y, test.id,
   train.df, test.df, all.df, fname.df, features, mean.idx, std.idx)

#
# Write out second tidy data set
#
write.csv(data.set.two, "./accelerometer_summary_data.csv",row.names=FALSE)
