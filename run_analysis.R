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
names(activity) <- c("Activity.Code","Activity.Label")

#
# create feature names
#
fname.df <- read.table("./UCI HAR Dataset/features.txt")
head(fname.df)
tail(fname.df)

# make the feature names legal for R
features <- gsub("\\.\\.\\.","\\.",make.names(fname.df[,2]))
features <- sub("\\.\\.$","",features)
head(features)
tail(features)

#
# Construct train data set
#
train.X <- read.table("./UCI HAR Dataset/train/X_train.txt")
names(train.X) <- features

train.y <- read.table("./UCI HAR Dataset/train/y_train.txt")
names(train.y) <- "Activity.Code"
train.y <- merge(train.y,activity)

train.id <- read.table("./UCI HAR Dataset/train/subject_train.txt")
names(train.id) <- "Subject.Id"

# combined parts of the training data

train.df <- cbind(Data.Source=rep("train",nrow(train.id)),train.id,train.y,train.X)


#
# Construct test data set
#
test.X <- read.table("./UCI HAR Dataset/test/X_test.txt")
names(test.X) <- features

test.y <- read.table("./UCI HAR Dataset/test/y_test.txt")
names(test.y) <- "Activity.Code"
test.y <- merge(test.y,activity)

test.id <- read.table("./UCI HAR Dataset/test/subject_test.txt")
names(test.id) <- "Subject.Id"

#combine parts of the test 
test.df <- cbind(Data.Source=rep("test",nrow(test.id)),test.id,test.y,test.X)

#
#combine train and test sets
#
all.df <- rbind(train.df,test.df)
head(all.df[,1:6])
tail(all.df[,1:6])

#
# create first data set with just mean and standard deviation measurements
#

#get index for features with mean or standard deviaion measures
mean.idx <- grepl("mean",names(all.df),ignore.case=TRUE)
std.idx <- grepl("std",names(all.df),ignore.case=TRUE)

# extract out identifier attributes and mean and standard deviation
data.set.one <- cbind(all.df[,1:4],all.df[,mean.idx | std.idx])

#resulted attributes for data.set.one
names(data.set.one)

#
# create second data set
#


