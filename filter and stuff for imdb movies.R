library(dplyr)

names(data$titleType)
types <- data$titleType
types
group_by(data$titleType)
data.class(types)

types<- as.factor(types)
levels(types)

data <- filter(data, titleType == "movie" | titleType == "tvMovie" )

subset(data, select = )

data<- data %>% group_by(titleType) %>%  select(tconst, titleType, primaryTitle, startYear, runtimeMinutes, genres)
filter(data$startYear < 2010 & data$startYear > 1960 )

data$startYear <- as.integer(data$startYear)
class(data$startYear)

df <- data[data$startYear >= 1960 & data$startYear <= 2010, ]
View(df)

na <- is.na(df$tconst)
df[titleType]
filter(df$tconst !na)

new_df<- df %>% filter(tconst != "na")

write.csv(new_df,"C:\\Users\\Muzaffer\\Desktop\\new_df.csv", row.names = FALSE)
