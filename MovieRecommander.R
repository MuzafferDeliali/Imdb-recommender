install.packages("tidyverse")
install.packages("ggplot2")
install.packages("caret")
install.packages("data.table")
install.packages("lubridate")
install.packages("dplyr")
install.packages("ggthemes")
install.packages("scales")

library(dplyr)
library(stringr)
library(lubridate)# we used
library(ggplot2)

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
head(trainSet)
trainSet %>% group_by(genres) %>% summarise(n=n()) %>% head() #first 6 genres

# movies classified in more than one genre
tibble(count = str_count(trainSet$genres, fixed("|")), genres = trainSet$genres) %>% 
  group_by(count, genres) %>%
  summarise(n = n()) %>%
  arrange(-count) %>% 
  head()

# Rating period almost 22 and half year
tibble(`Initial Date` = date(as_datetime(min(trainSet$timestamp), origin="1970-01-01")),
       `Final Date` = date(as_datetime(max(trainSet$timestamp), origin="1970-01-01"))) %>%
  mutate(Period = duration(max(trainSet$timestamp)-min(trainSet$timestamp)))

visual<- trainSet %>% mutate(year = year(as_datetime(timestamp, origin="1970-01-01")))
hist(visual$year ,
     main = "Rating Distribution Per Year" ,
     xlab = "Year" ,
     ylab = "Number of ratings")


trainSet %>% group_by(rating) %>% summarize(n=n())

# most active users
trainSet %>% group_by(userId) %>%
  summarise(n=n()) %>%
  arrange(n) %>%
  head()

# frequancy of ratings
hist(trainSet$rating ,
     main = "Frequancy of ratings" ,
     xlab = "Rates")

#cleaning some values
trainSet <- trainSet %>% select(userId, movieId, rating, title)
testSet  <- testSet  %>% select(userId, movieId, rating, title)


#select user id 1 and coralation between genres and rating