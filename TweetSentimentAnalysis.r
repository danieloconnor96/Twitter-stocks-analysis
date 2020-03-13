install.packages("sentimentr")
library(sentimentr)
library(ggplot2)

#Sentiment function
sentiment <- sentiment_by(TweetsClean$TweetContent)

#avg sentiment score - insert into DF
TweetsClean$ave_sentiment <- sentiment$ave_sentiment

  
#histogram - too many 0 scores
#review code - check if further cleaning necessary
qplot(sentiment$ave_sentiment, 
      geom="histogram", binwidth=0.1,main="Tweet Sentiment Scores")

#summary statistics
summary(sentiment$ave_sentiment)

#group into positive, neutral or negative
