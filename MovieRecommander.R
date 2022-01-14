install.packages("tidyverse")
install.packages("ggplot2")
install.packages("caret")
install.packages("data.table")
install.packages("lubridate")
install.packages("dplyr")
install.packages("ggthemes")
install.packages("scales")
install.packages("matrixStats") # used for matrix Matrix Factorization

library(dplyr) # we used for left_join
library(stringr)
library(lubridate)# we used
library(ggplot2)
library(matrixStats)
as.data.frame(trainSet)
# MovieLens small dataset:
# https://files.grouplens.org/datasets/movielens/ml-latest-small.zip

movielens <- left_join(ratings, movies, by = "movieId")

set.seed(100 , sample.kind="Rounding")
sampleIndex <- sample(1:nrow(movielens) , size = 0.9*nrow(movielens))

# %90 TrainSet  %10 TestSet
trainSet <- movielens[sampleIndex , ]
testSet <- movielens[-sampleIndex , ]

str(trainSet) # column names and classes

dim(trainSet) # 90752 row and 6 column
head(trainSet)
trainSet %>% group_by(genres) %>% summarise(n=n()) #first 6 genres

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


# most active users
trainSet %>% group_by(userId) %>%
  summarise(n=n()) %>%
  arrange(n) %>%
  head()

# frequency of ratings
hist(trainSet$rating ,
     main = "Frequancy of ratings" ,
     xlab = "Rates")


head(trainSet)
model1 <- lm(rating ~ movieId , data  = trainSet)
model1
summary(model1)

predictions <- predict(model1 , testSet)
predictions

# Difference between predictions and real values
library(caret)

R2(predictions , testSet$rating)
RMSE(predictions , testSet$rating)
MAE(predictions , testSet$rating)

summary(testSet$rating)
df_user62 <- trainSet[trainSet$userId == "62" ,]
summarise(df_user62, group_by(genres))
gentabl<- table(df_user62$genres)
popular_genre <- sort(gentabl, decreasing = T)
popular_genre #
popular_genre <- as.data.frame(popular_genre)
pop <- popular_genre[[1,1]]

pop <- movies[movies$genres == pop,]
pop[sample(nrow(pop), 5), ]
