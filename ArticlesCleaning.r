#Text Mining package for cleaning 
install.packages("tm")
library(tm)
#Package for gsub
install.packages("textreg")
library(textreg)
#Package for str_replace
install.packages("stringr")
library(stringr)
library(dplyr)
install.packages("plyr")
library(plyr)
#################################

ArticlesRaw3 = read.csv(file.choose(), stringsAsFactors = FALSE, encoding="UTF-8")

#filter by articles that mention Tesla/Musk
filteredArticles1 <- dplyr::filter(ArticlesRaw1, grepl('Tesla|Elon Musk', content))
filteredArticles2 <- dplyr::filter(ArticlesRaw2, grepl('Tesla|Elon Musk', content))
filteredArticles3 <- dplyr::filter(ArticlesRaw3, grepl('Tesla|Elon Musk', content))

#Bind the 3 dfs
ArticlesBinded  <- rbind.fill(filteredArticles1,filteredArticles2,filteredArticles3)

#add unique ID column
ArticlesBinded$ArticleID <- 1:nrow(ArticlesBinded)

#set df vars
ArticleID       <- ArticlesBinded$ArticleID
ArticleDate     <- ArticlesBinded$date
Title           <- ArticlesBinded$title
Publication     <- ArticlesBinded$publication
Author          <- ArticlesBinded$author
ArticleContent  <- ArticlesBinded$content

#Create DF 
NewsArticles    <- data.frame(ArticleID, ArticleDate, Title, Publication, Author, ArticleContent, stringsAsFactors=FALSE)

#store article content column column in var
Column    <- NewsArticles$ArticleContent

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
ArticleContentClean <- convert.tm.to.character(Corpus)


#Replace TweetContent column with the clean version
NewsArticles$ArticleContent <- ArticleContentClean


############# CSV export ###############
write.table(NewsArticles, file="Articles_Clean_final.csv", sep=",", row.names=FALSE)





