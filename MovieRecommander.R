install.packages("tidyverse")
install.packages("caret")
install.packages("data.table")
library(dplyr)

# MovieLens small dataset:
# https://files.grouplens.org/datasets/movielens/ml-latest-small.zip

movielens <- left_join(ratings, movies, by = "movieId")
View(movielens)

set.seed(100 , sample.kind="Rounding")
sampleIndex <- sample(1:nrow(movielens) , size = 0.9*nrow(movielens))

# %90 TrainSet  %10 TestSet
trainSet <- movielens[sampleIndex , ]
testSet <- movielens[-sampleIndex , ]

# %10 of TrainSet become validateSet 
valInde <- sample(1:nrow(testSet) , size = 0.1*nrow(trainSet))
validSet <- movielens[valInde , ]


str(trainSet) # column names and classes

dim(trainSet) # 90752 row and 6 column
