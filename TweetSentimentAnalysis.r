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

#Sentiment score - insert into DF
TweetsClean$ave_sentiment <- sentiment$ave_sentiment

TweetScore <- sentiment$ave_sentiment

#summary statistics
summary(sentiment$ave_sentiment)

###############################################
#group into positive, neutral or negative
TweetsClean$SentimentGroup <- NULL
TweetsClean$SentimentGroup <- ifelse(TweetScore > 0,"Positive",
                                     ifelse(TweetScore == 0, "Neutral", "Negative"))


###############################################


############# Statistical Tests ############# 

#shapiro-wilk test for normality - Tweet sentiment
shapiro.test(TweetsClean$ave_sentiment)

## Spearman's correlation coefficient ##

### Hypotheseis ###
### H1: There is no linear relationship between Tweets & Stocks ###
### H0: There is a linear relationship between Tweets & Stocks ###

#set date vars
StockDate <- factStock$StockDate
TweetDate <- TweetsClean$TweetDate

#Join Tweets & Stocks on date
CorDF <- merge.data.frame(TweetsClean, factStock, by.x = "TweetDate", by.y = "StockDate")

PercentChange   <- CorDFTweets$PercentChange
TweetSentiment  <- CorDFTweets$ave_sentiment

#######
#remove unneeded column
Stocks <- Stocks[,-3]

#calculate daily stock price change percentage
factStock['PercentChange'] = (factStock['Close']-factStock['Open'])/factStock['Open']*100


#distinct rows because using daily percentage change - each price change not needed
StocksDistinct <- distinct(Stocks,StockID, .keep_all= TRUE)

#merge data frames for correlation test
CorDFTweets <- merge.data.frame(TweetsClean, StocksDistinct, by.x = "TweetDate", by.y = "StockDate")

#Set neutrals as NA & remove NAs
CorDFTweets[CorDFTweets == 0] <- NA
CorDFTweets <- na.omit(CorDFTweets)

cor(ClosePrice, TweetSentiment,  method = "spearman", use = "complete.obs")


#plot correlation
#Between Daily price percentage change & sentiment score
ggscatter(CorDFTweets, x = "PercentChange", y = "ave_sentiment", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "spearman",
          xlab = "Daily Price Change %", ylab = "Tweet Sentiment Score",
          add.params = list(color="red", fill="lightgray"))

##################################### 


#export tweets with sentiment column for input to DW
write.table(TweetsClean, file="Tweets_Clean_final.csv", sep=",", row.names=FALSE)

