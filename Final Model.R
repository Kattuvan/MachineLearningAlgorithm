rm(list=ls())
library(caret)
library(rpart)

# load the data
wb <-"pml-training.csv"
trng_df <- read.csv(wb,sep=",",header=T)

set.seed(4543)
# remove all columns with 'NA'
trng_df <- trng_df[ , colSums(is.na(trng_df)) == 0]

inTrain = createDataPartition(trng_df$classe, p = 0.70, list=FALSE)
training = trng_df[ inTrain,]
testing = trng_df[-inTrain,]

## training dataset
training <- training[,-c(1,2,3,4,5,6)]
nzvidentify <- nearZeroVar(training, saveMetrics = TRUE)

# returns near zero-freq variable features/predictors
nzv<- nearZeroVar(training)
# remove those zero variance features from data frame
trainingDF  <- training[,-nzv]

## Read Test  data set and apply the t]Transformations done to Training set
## ************************************************************************
testing <- testing[,-c(1,2,3,4,5,6)]

# returns near zero-freq variable features/predictors
nzv<- nearZeroVar(testing)
# remove those zero variance features from data frame
testingDF <- training[,-nzv]

# To use three repeats of 10–fold cross–validation, we would use
fitControl <- trainControl(method="cv",
                           number=5,
                           repeats=1,
                           verboseIter=TRUE)

gbmGrid <- expand.grid( n.trees = 100, interaction.depth = 10, shrinkage = .1)  

gbmFit <- caret::train(classe ~ ., data=trainingDF,
                        method="gbm", # used with weak predictors
                        trControl=fitControl,bag.fraction = 0.5,
                        tuneGrid = gbmGrid,
                        verbose=FALSE)

gbmPred <- predict(gbmFit, testingDF)
confusionMatrix(gbmPred, testingDF$classe)

out_of_sample_error <- sum(gbmPred != testingDF$classe)/length(testingDF$classe)
# 0.1530

table(gbmPred,testingDF$classe)
########### Plotting
# A plot of the classification accuracy versus the tuning factors
plot(gbmFit)

# a plot of the Kappastatistic profiles 
plot(gbmFit, metric = "Kappa")

# A level plot of the accuracy values
plot(gbmFit, plotType = "level")

# Density plots of the 200 bootstrap estimates of Accuracy and Kappa for the final model 
resampleHist(gbmFit)


##### pml -test data #####
##########################

wb <-"pml-testing.csv"
pml_testing <- read.csv(wb,sep=",",header=T)

# remove all columns with 'NA'
pml_testing_lessNA <- pml_testing[ , colSums(is.na(pml_testing)) == 0]

# returns near zero-freq variable features/predictors
nzv<- nearZeroVar(pml_testing_lessNA)
# remove those zero variance features from data frame
filtered_pml_testing <- pml_testing_lessNA[,-nzv]

## pml test data set
pml_testing_df <- filtered_pml_testing[,-c(1:5)]

pml_Pred <- predict(gbmFit, pml_testing_df)

# Write up the predicted character to the “.txt” files for submission
pml_write_files = function(x) {
  n = length(x)
  for (i in 1:n) {
    filename = paste0("problem_id_", i, ".txt")
    write.table(x[i], file = filename, quote = FALSE, row.names = FALSE, 
                col.names = FALSE)
  }
}

pml_write_files(pml_Pred)
