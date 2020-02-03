install.packages("tm")
library(tm)

#problem here is this file is only articles 1. 2 more files. These need to be concatenated
ArticlesRaw = read.csv(file.choose())

TweetsRaw = read.csv(file.choose())

#convert data frame to corpus
Corpus <- VCorpus(VectorSource(TweetsRaw$TweetContent))

############ Cleaning ############
#convert upper case letters to lower
CleanCorpus <- tm_map(Corpus, content_transformer(tolower))

#remove punctuation
CleanCorpus <- tm_map(CleanCorpus, content_transformer(removePunctuation))

#convert the corpus back to a data frame
CleanDF <- data.frame(text=unlist(sapply(CleanCorpus, `[`, "content")), stringsAsFactors=F)



#rm("TweetsCorpusCleaned", "TweetsCorpus", "ArticlesRaw")