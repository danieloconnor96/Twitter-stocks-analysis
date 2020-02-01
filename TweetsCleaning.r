install.packages("tm")
library(tm)

#problem here is this file is only articles 1. 2 more files. These need to be concatenated
ArticlesRaw = read.csv(file.choose())

TweetsRaw = read.csv(file.choose())

#convert data frame to corpus
TweetsCorpus <- VCorpus(VectorSource(TweetsRaw$TweetContent))

############ Cleaning ############
#remove numbers from tweet content column
tm_map(TweetsCorpus, tolower)

#remove punctuation
tm_map(TweetsCorpus, removePunctuation)

#convert the corpus back to a data frame
TweetsCleaned <- data.frame(text = sapply(TweetsCorpus, as.character), stringsAsFactors = FALSE)

#######################################################################
#tested tolower function above - currently not working
# when converted back to dataframe, text still contains caps