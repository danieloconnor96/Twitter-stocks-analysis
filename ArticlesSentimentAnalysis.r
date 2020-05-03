library(sentimentr)
library(ggplot2)
library(RColorBrewer)
library(RCurl)
library(wordcloud)
library(dyplr)

Articles <- NewsArticles$ArticleContent

#Sentiment function
sentimentArticle <- sentiment_by(NewsArticles$ArticleContent)

#avg sentiment score - insert into DF
NewsArticles$ave_sentiment <- sentimentArticle$ave_sentiment

ArticleScore <- sentimentArticle$ave_sentiment

#summary statistics
summary(sentimentArticle$ave_sentiment)

###############################################
#group into positive, neutral or negative
NewsArticles$SentimentGroup <- NULL
NewsArticles$SentimentGroup <- ifelse(ArticleScore > 0, "Positive",ifelse(ArticleScore == 0, "Neutral", "Negative"))


###############################################


########### Visualisation ########### 
qplot(sentimentArticle$ave_sentiment, 
      geom="histogram", binwidth=0.1,main="News Article Sentiment Scores")

#wordcloud - need to go back & remove - ' , "
wordcloud(Articles, max.words=150, min.freq=10, random.order=F, colors=brewer.pal(8, "Dark2"))

###############################################
## Pearson's correlation coefficient ##

### Hypotheseis ###
### H1: There is no linear relationship between News Articles & Stocks ###
### H0: There is a linear relationship between News Articles & Stocks ###

#set article date var
ArticleDate <- NewsArticles$ArticleDate
ArticleSentScore <- NewsArticles$ave_sentiment

#aggregate dates by mean sentiment score
Agg <- aggregate(cbind(AvgSent=NewsArticles$ave_sentiment),
                 by = list(Date = NewsArticles$ArticleDate),
                 FUN = mean)

#aggregate dates by max sentiment score
AggMax <- aggregate(cbind(MaxSent=NewsArticles$ave_sentiment),
                 by = list(Date = NewsArticles$ArticleDate),
                 FUN = max)

#calculate daily stock price change percentage
factStock['PercentChange'] = (factStock['Close']-factStock['Open'])/factStock['Open']*100

#Join Articles & Stocks on date
CorDFArticles <- merge.data.frame(Agg, StocksDistinct, by.x = "Date", by.y = "StockDate")
CorDFArticlesMax <- merge.data.frame(AggMax, StocksDistinct, by.x = "Date", by.y = "StockDate")

#set vars 
PriceChange       <- CorDFArticles$PercentChange
ArticleSentiment  <- CorDFArticles$AvgSent
PriceChange2      <- CorDFArticlesMax$PercentChange
ArticleMaxSent    <- CorDFArticlesMax$MaxSent

#Pearson correlation
cor(PriceChange, ArticleSentiment,  method = "pearson", use = "complete.obs")
cor(PriceChange2, ArticleMaxSent,  method = "pearson", use = "complete.obs")


#plot correlation
#Between Daily price percentage change & sentiment score
ggscatter(CorDFArticles, x = "PercentChange", y = "AvgSent", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "Daily Price Change %", ylab = "Article Sentiment Score",
          add.params = list(color="red", fill="lightgray"))


##################################### 
