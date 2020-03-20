#Text Mining package for cleaning 
install.packages("tm")
library(tm)
#Package for gsub
install.packages("textreg")
library(textreg)
#Package for str_replace
install.packages("stringr")
library(stringr)
#################################

TweetsRaw   <- read.csv(file.choose(), stringsAsFactors = FALSE)
TweetsClean <- TweetsRaw

############ Cleaning ############
#store tweet column in var
Column    <- TweetsRaw$TweetContent
#Remove RT header
Column    <- str_replace_all(Column,"RT @[a-z,A-Z]*: ","")
#Remove @ tagging
Column    <- str_replace_all(Column,"@[a-z,A-Z]*","")   
#Remove hashtags
Column    <- str_replace_all(Column,"#[a-z,A-Z]*","")

#convert Tweet column to corpus for tm use
Corpus    <- VCorpus(VectorSource(Column))

#convert upper case letters to lower
Corpus    <- tm_map(Corpus, content_transformer(tolower))
#stopwords removal 
Corpus    <- tm_map(Corpus, removeWords, stopwords(kind='en'))
#remove url
removeURL <- function(x) gsub("http[[:alnum:][:punct:]]*", "", x)
Corpus    <- tm_map(Corpus, content_transformer(removeURL))
#remove white space
Corpus    <- tm_map(Corpus, stripWhitespace)
#remove numbers
Corpus    <- tm_map(Corpus, content_transformer(removeNumbers))
#remove punctuation
Corpus    <- tm_map(Corpus, content_transformer(removePunctuation))


#problem with above function - is when @ is removed - tagging of people on Twitter is taken as words
#Sentance makes less sense this way - need to remove words after @
#problem solved by using str_replace_all function above to remove tags - document this

#convert the corpus back to character vector
TweetContentVector <- convert.tm.to.character(Corpus)

#Replace TweetContent column with the clean version
TweetsClean$TweetContent <- TweetContentVector

#Strip hours from Tweetdate
TweetsClean$TweetDate <- format(
  as.POSIXct(TweetsClean$TweetDate,format='%Y-%m-%d %H:%M:%S'),
  format='%Y-%m-%d')


############# CSV export ###############
write.table(TweetsClean, file="R_Tweets_Clean_final.csv", sep=",", row.names=FALSE)

