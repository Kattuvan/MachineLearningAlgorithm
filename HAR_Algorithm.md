# Human Activity Recognition Algorithm
### Objective:
This project involves steps taken to develop a predictive model. The training data used in this project: pml-training.csv is available [here.](https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv) and the test data: pml-testing.csv  is available [here.](https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv) The data for this project come from [this source.](http://groupware.les.inf.puc-rio.br/har)



```r
library(caret)
```

```
## Warning: package 'caret' was built under R version 3.1.3
```

```
## Loading required package: lattice
## Loading required package: ggplot2
```

```
## Warning: package 'ggplot2' was built under R version 3.1.3
```

```r
library(rpart)
```

1. We load the data from local drive.

```r
setwd("C:/Users/Ganga/Documents/Murali/GItSubmission")
wb <-"pml-training.csv"
trng_df <- read.csv(wb,sep=",",header=T,stringsAsFactors=FALSE)
```
2. Select features where values are available for all observations. 

```r
# remove all columns with 'NA'
trng_df <- trng_df[ , colSums(is.na(trng_df)) == 0]
```

3. Partition the data to train the algorithm and  then test the algorthm aginst test data.

```r
set.seed(4543)
inTrain = createDataPartition(trng_df$classe, p = 0.70, list=FALSE)
training = trng_df[ inTrain,]
testing = trng_df[-inTrain,]
```

4. Remove featues like indices,time stamp and window

```r
training <- training[,-c(1,2,3,4,5,6)]
```

5. Remove features  with near zero variance and are not good predictors.

```r
nzv<- nearZeroVar(training)

# remove those zero variance features from data frame
trainingDF  <- training[,-nzv]
```

6. Apply transformations done to Test data set which was applied to Training set

```r
testing <- testing[,-c(1,2,3,4,5,6)]

# returns near zero-freq variable features/predictors
nzv<- nearZeroVar(testing)

# remove those zero variance features from data frame
testingDF <- training[,-nzv]
```

7. trainControl function returns an object which helps to modify resampling method in train function in step-7

```r
fitControl <- trainControl(method="cv",
                           number=5,
                           repeats=1,
                           verboseIter=TRUE)
```

8. Assemble a data frame of values what control train function

```r
gbmGrid <- expand.grid(interaction.depth = 10, n.trees = 100, shrinkage = .1,n.minobsinnode =10)
```

9. tune funcrion is applied to traing data set to tune the model developed here

```r
# gbmFit <- train(classe ~ ., data=trainingDF,
#                 method="gbm", # used with weak predictors
#                 trControl=fitControl, bag.fraction = 0.5, tuneGrid = gbmGrid,
#                 verbose=FALSE)
```

10. Accuracy of the model developed here is measured by predicting values of testing data set and compared against the observed values.

```r
# gbmPred <- predict(gbmFit, testingDF)
# confusionMatrix(gbmPred, testingDF$classe)
```
Function confusionMatrix() produces the following results    
    
    Confusion Matrix and Statistics
    
              Reference
    Prediction    A    B    C    D    E
             A 3906    1    0    0    0
             B    0 2657    0    0    0
             C    0    0 2396    0    0
             D    0    0    0 2252    0
             E    0    0    0    0 2525
    
    Overall Statistics
                                         
                   Accuracy : 0.9999     
                     95% CI : (0.9996, 1)
        No Information Rate : 0.2843     
        P-Value [Acc > NIR] : < 2.2e-16  
                                         
                      Kappa : 0.9999     
     Mcnemar's Test P-Value : NA         
    
    Statistics by Class:
    
                         Class: A Class: B Class: C Class: D Class: E
    Sensitivity            1.0000   0.9996   1.0000   1.0000   1.0000
    Specificity            0.9999   1.0000   1.0000   1.0000   1.0000
    Pos Pred Value         0.9997   1.0000   1.0000   1.0000   1.0000
    Neg Pred Value         1.0000   0.9999   1.0000   1.0000   1.0000
    Prevalence             0.2843   0.1935   0.1744   0.1639   0.1838
    Detection Rate         0.2843   0.1934   0.1744   0.1639   0.1838
    Detection Prevalence   0.2844   0.1934   0.1744   0.1639   0.1838
    Balanced Accuracy      0.9999   0.9998   1.0000   1.0000   1.0000

11. Out of sample error - Error that measures percentage of time predictions deviated from observed values.

```r
# out_of_sample_error <- (sum(gbmPred != testingDF$classe)/length(testingDF$classe)) * 100
# print(out_of_sample_error)
```
Out of sample error is 0.00727961%

12. Table showing predicted values against observed values

```r
# table(gbmPred,testingDF$classe)
```

Function table() shows comprison of the results produced by the model to that observed values.

    gbmPred    A    B    C    D    E
          A 3906    1    0    0    0
          B    0 2657    0    0    0
          C    0    0 2396    0    0
          D    0    0    0 2252    0
          E    0    0    0    0 2525

13. Density plots of the 100 bootstrap estimates of Accuracy and Kappa for the final model

```r
# resampleHist(gbmFit)
```

Though correct results are produced by this model, for reasons unknown ".Rmd" file" returns error at step 9  when knitter is run.
Hence I have commented codes from step 9 to produce this HTML file. A plot for accuracy and kappa produced this model is attached as PDF file to review.
(source of data :)
