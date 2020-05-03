library(sentimentr)
library(RColorBrewer)
library(RCurl)
library(wordcloud)
library(tm)
library(sqldf)
library(DBI)
library(ggpubr)
library(TextBlob)
library(lubridate)
library(dplyr)

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

TweetScore <- sentiment$ave_sentiment

#summary statistics
summary(sentiment$ave_sentiment)

###############################################
#group into positive, neutral or negative
TweetsClean$SentimentGroup <- NULL
TweetsClean$SentimentGroup <- ifelse(TweetScore > 0, "Positive",ifelse(TweetScore == 0, "Neutral", "Negative"))


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

### Hypotheseis ###
### H1: There is no linear relationship between Tweets & Stocks ###
### H0: There is a linear relationship between Tweets & Stocks ###

#set date vars
StockDate <- factStock$StockDate
TweetDate <- TweetsClean$TweetDate

#Join Tweets & Stocks on date
CorDF <- merge.data.frame(TweetsClean, factStock, by.x = "TweetDate", by.y = "StockDate")

PercentChange   <- CorDF2$PercentChange
TweetSentiment  <- CorDF2$ave_sentiment

#######
#remove unneeded column
Stocks <- Stocks[,-3]

#calculate daily stock price change percentage
factStock['PercentChange'] = (factStock['Close']-factStock['Open'])/factStock['Open']*100


#distinct rows because using daily percentage change - each price change not needed
StocksDistinct <- distinct(Stocks,StockID, .keep_all= TRUE)

#merge data frames for correlation test
CorDFTweets <- merge.data.frame(TweetsClean, StocksDistinct, by.x = "TweetDate", by.y = "StockDate")

cor(ClosePrice, TweetSentiment,  method = "pearson", use = "complete.obs")


#plot correlation
#Between Daily price percentage change & sentiment score
ggscatter(CorDFTweets, x = "PercentChange", y = "ave_sentiment", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "Daily Price Change %", ylab = "Tweet Sentiment Score",
          add.params = list(color="red", fill="lightgray"))


##################################### 


#export tweets with sentiment column for input to DW
write.table(TweetsClean, file="Tweets_Clean_final.csv", sep=",", row.names=FALSE)

