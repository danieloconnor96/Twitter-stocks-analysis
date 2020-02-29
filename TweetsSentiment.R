install.packages("sentimentr")
library(sentimentr)

TweetText <- (TweetsClean$TweetContent)

sentiment <- sentiment_by(TweetText)


