install.packages("sentimentr")
install.packages("RCurl")
install.packages("wordcloud")
install.packages("odbc")
install.packages("sqldf")
install.packages("ggpubr")
library(sentimentr)
library(RColorBrewer)
library(RCurl)
library(wordcloud)
library(tm)
library(sqldf)
library(DBI)
library(ggpubr)

#Connect R to SQL Server
library(odbc)
con <- dbConnect(odbc(),
                 Driver = "SQL Server",
                 Server = "MOLAP",
                 Database = "StockPriceProject",
                 Trusted_Connection = "yes",
                 sep =";")

#Read fact table as DF
factStock <- dbReadTable(con, "factStock")

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
#set date vars
StockDate <- factStock$StockDate
TweetDate <- TweetsClean$TweetDate

#Join Tweets & Stocks on date
CorDF <- merge.data.frame(TweetsClean, factStock, by.x = "TweetDate", by.y = "StockDate")

ClosePrice      <- CorDF$Close
TweetSentiment  <- CorDF$ave_sentiment

cor(ClosePrice, TweetSentiment,  method = "pearson", use = "complete.obs")

#count of tweets by day??? correlation between count of tweets & stock price

#plot correlation
ggscatter(CorDF, x = "Close", y = "ave_sentiment", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "x title", ylab = "y title")





##################################### 

