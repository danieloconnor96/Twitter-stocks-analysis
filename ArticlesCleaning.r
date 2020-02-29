#Text Mining package for cleaning 
install.packages("tm")
library(tm)
#Package for gsub
install.packages("textreg")
library(textreg)
#Package for str_replace
install.packages("stringr")
library(stringr)
install.packages("dplyr")
library(dplyr)
#################################

ArticlesRaw3 = read.csv(file.choose(), stringsAsFactors = FALSE)

#filter by articles about Tesla/Musk
filteredArticles1 <- dplyr::filter(ArticlesRaw1, grepl('Tesla|Elon Musk', content))
filteredArticles2 <- dplyr::filter(ArticlesRaw2, grepl('Tesla|Elon Musk', content))
filteredArticles3 <- dplyr::filter(ArticlesRaw3, grepl('Tesla|Elon Musk', content))

###### before running below functions - combine the 3 article objects

#store article content column column in var
Column    <- filteredArticles1$content

#convert content column to corpus for tm use
Corpus    <- VCorpus(VectorSource(Column))

#convert upper case letters to lower
Corpus    <- tm_map(Corpus, content_transformer(tolower))
#stopwords removal 
Corpus    <- tm_map(Corpus, removeWords, stopwords(kind='en'))
#remove white space
Corpus    <- tm_map(Corpus, stripWhitespace)
#remove numbers
Corpus    <- tm_map(Corpus, content_transformer(removeNumbers))
#remove punctuation
Corpus    <- tm_map(Corpus, content_transformer(removePunctuation))

#convert the corpus back to character vector
ArticleContentVector <- convert.tm.to.character(Corpus)

#Replace TweetContent column with the clean version
filteredArticles1$content <- ArticleContentVector




############# CSV export ###############





