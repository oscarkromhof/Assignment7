library(text2vec)
library(tidyverse)
library(tm)

set.seed(7)

# Step 1:

# Reload movie_review dataset
IMDB <- movie_review

View(IMDB)

# split dataset into training (80%) and test (20%) sets
splits <- c(rep("train", 4000), rep("test", 1000))
IMDB_master <- IMDB %>% mutate(splits = sample(splits))
IMDB_train <- IMDB_master %>% filter(splits == "train")
IMDB_test <- IMDB_master %>% filter(splits == "test")

# Step 2:

# Convert to Corpus
corpus_train <- Corpus(VectorSource(IMDB_train$review))
corpus_test <- Corpus(VectorSource(IMDB_test$review))

#Set stopwords
ReviewStopwords <- c(stopwords(),"film","films","movie","movies")

#Set bounds

Bounds <- list(global = c(1,10)) #Here we need to find a good range

# Document-term matrices (dtms) with TF
IMDB_train_dtm_tf <- DocumentTermMatrix(corpus_train, control = list(bounds = Bounds, stopwords = ReviewStopwords, removePunctuation = T, removeNumbers = T, stemming = T))
IMDB_test_dtm_tf <- DocumentTermMatrix(corpus_test, control = list(stopwords = ReviewStopwords, removePunctuation = T, removeNumbers = T, stemming = T))


# Document-term matrices (dtms) with TF-IDF
IMDB_train_dtm_tfidf <- TermDocumentMatrix(corpus_train, control = list(weighting = weightTfIdf, stopwords = ReviewStopwords, removePunctuation = T, removeNumbers = T, stemming = T))
IMDB_test_dtm_tfidf <- TermDocumentMatrix(corpus_test, control = list(weighting = weightTfIdf, stopwords = ReviewStopwords, removePunctuation = T, removeNumbers = T, stemming = T))

#Transforming The TermDocumentMatrix back to a DATA-FRAME
df_train_tf <- data.frame(as.matrix(IMDB_train_dtm_tf))

#Adding back the given sentiment of the data as a final column.
df_train_tf <- df %>% mutate(IMDB_train$sentiment)

#Training a support vector machine on all the variables (terms) but it we get an overflow error.
model <- svm(sentiment ~., data = df)


