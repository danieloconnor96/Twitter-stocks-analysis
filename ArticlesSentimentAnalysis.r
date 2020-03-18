install.packages("sentimentr")
install.packages("RCurl")
install.packages("wordcloud")
library(sentimentr)
library(ggplot2)
library(RColorBrewer)
library(RCurl)
library(wordcloud)

Articles <- NewsArticles$ArticleContent

#Sentiment function
sentimentArticle <- sentiment_by(NewsArticles$ArticleContent)

#avg sentiment score - insert into DF
NewsArticles$ave_sentiment <- sentimentArticle$ave_sentiment

#summary statistics
summary(sentimentArticle$ave_sentiment)

###############################################
#group into positive, neutral or negative
NewsArticles$SentimentGroup <- NULL


#need to nest an if statement for neutral
NewsArticles$SentimentGroup <- ifelse(NewsArticles$ave_sentiment > 0, "P","N")

###############################################


########### Visualisation ########### 

#histogram - too many 0 scores?
#review code - check if further cleaning necessary
qplot(sentimentArticle$ave_sentiment, 
      geom="histogram", binwidth=0.1,main="News Article Sentiment Scores")

#wordcloud - need to go back & remove - ' , "
wordcloud(Articles, max.words=150, min.freq=10, random.order=F, colors=brewer.pal(8, "Dark2"))

##################################### 
