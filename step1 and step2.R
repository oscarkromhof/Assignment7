library(text2vec)
library(tidyverse)
library(tm)
set.seed(7)

# Step 1 :  
# Reload movie_review dataset
IMDB <- movie_review

View(IMDB)

# split dataset into training (80%) and test (20%) sets
splits <- c(rep("train", 4000), rep("test", 1000))
IMDB_master <- IMDB %>% mutate(splits = sample(splits))
IMDB_train <- IMDB_master %>% filter(splits == "train")
IMDB_test <- IMDB_master %>% filter(splits == "test")

# Step 2
# Convert to Corpus
corpus_train <- Corpus(VectorSource(IMDB_train$review))
corpus_test <- Corpus(VectorSource(IMDB_test$review))

#Set stopwords
ReviewStopwords <- c(stopwords(),"film","films","movie","movies")

# Document-term matrices (dtms) with TF
IMDB_train_dtm_tf <- DocumentTermMatrix(corpus_train, control = list(stopwords = ReviewStopwords, removePunctuation = T, removeNumbers = T, stemming = T))
IMDB_test_dtm_tf <- DocumentTermMatrix(corpus_test, control = list(stopwords = ReviewStopwords, removePunctuation = T, removeNumbers = T, stemming = T))


# Document-term matrices (dtms) with TF-IDF
IMDB_train_dtm_tfidf <- TermDocumentMatrix(corpus_train, control = list(weighting = weightTfIdf, stopwords = ReviewStopwords, removePunctuation = T, removeNumbers = T, stemming = T))
IMDB_test_dtm_tfidf <- TermDocumentMatrix(corpus_test, control = list(weighting = weightTfIdf, stopwords = ReviewStopwords, removePunctuation = T, removeNumbers = T, stemming = T))
inspect(IMDB_test_dtm_tf[1:10,1:10])
