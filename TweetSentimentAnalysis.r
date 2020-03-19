install.packages("sentimentr")
install.packages("RCurl")
install.packages("wordcloud")
install.packages("odbc")
install.packages("sqldf")
library(sentimentr)
library(ggplot2)
library(RColorBrewer)
library(RCurl)
library(wordcloud)
library(tm)
library(sqldf)

#Connect R to SQL Server
library(odbc)
con <- dbConnect(odbc(),
                 Driver = "SQL Server",
                 Server = "MOLAP",
                 Database = "StockPriceProject",
                 Trusted_Connection = "yes",
                 sep =";")

#Sentiment function
sentiment <- sentiment_by(TweetsClean$TweetContent)

#avg sentiment score - insert into DF
TweetsClean$ave_sentiment <- sentiment$ave_sentiment

#summary statistics
summary(sentiment$ave_sentiment)

###############################################
#group into positive, neutral or negative
TweetsClean$SentimentGroup <- NULL

#below doesn't work - if statement doesn't work on vectors
if(TweetsClean$ave_sentiment > 0.1){
  TweetsClean$SentimentGroup <- "Positive"
} else if (TweetsClean$ave_sentiment < 0){
  TweetsClean$SentimentGroup <- "Negative"
} else {
  TweetsClean$SentimentGroup <- "Neutral"
}


#below works - need to nest an if statement for neutral
TweetsClean$SentimentGroup <- ifelse(TweetsClean$ave_sentiment > 0, "P","N")

###############################################


########### Visualisation & Tests ########### 

## histogram ##
qplot(sentiment$ave_sentiment, 
      geom="histogram", binwidth=0.1,main="Tweet Sentiment Scores")

## wordcloud ##
#Remove unwanted words first
TweetsCorpus  <- Corpus(VectorSource(Tweets))
TweetsCorpus  <- tm_map(TweetsCorpus, removeWords, c("elon","musk", "tesla"))
wordcloud(TweetsCorpus, max.words=150, min.freq=10, random.order=F, colors=brewer.pal(8, "Dark2"))

## Pearson's correlation coefficient ##
#Create df by merging stocks & Tweets on date


CorDF <- merge.data.frame()
cor(x, y,  method = "pearson", use = "complete.obs")

##################################### 

