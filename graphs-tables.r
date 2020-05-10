library(wordcloud)
library(RColorBrewer)
library(dplyr)
library(gridExtra)

#avg wordcount comparison
wordcount(NewsArticles$ArticleContent, sep="", count.function = mean)
wordcount(TweetsClean$TweetContent, sep="", count.function = mean)

#Tweet wordcloud
wordcloud(TweetContentVector, max.words = 200, min.freq=3, random.order=FALSE, scale=c(6,.2),colors=brewer.pal(8, "Dark2"))

#News Article wordcloud
wordcloud(ArticleContentClean, max.words = 200, min.freq=3, random.order=FALSE, scale=c(6,.2),colors=brewer.pal(8, "Dark2"))

## histograms ##
qplot(sentiment$ave_sentiment, 
      geom="histogram", binwidth=0.1,main="Tweet Sentiment Scores")

qplot(sentimentArticle$ave_sentiment, 
      geom="histogram", binwidth=0.1,main="News Article Sentiment Scores")

# function to display 3 decimal places
round3 <- function(x){round(x,3)}

#set colnames for descriptive table vars
ColumnNamesT   <- colnames(TweetsClean)
ColumnNamesA   <- colnames(NewsArticles)

#descriptive/summary statistics 
DescriptivesTweets <- psych::describeBy(TweetsClean) %>% mutate(
  vars = ColumnNamesT) %>% select(-one_of("trimmed","mad")) %>%
  mutate_if(is.numeric, round3)

DescriptivesArticles <- psych::describeBy(NewsArticles) %>% mutate(
  vars = ColumnNamesA) %>% select(-one_of("trimmed","mad")) %>%
  mutate_if(is.numeric, round3)

#export summary tables asimg
png("DescriptivesTweets.png", width=1000, height=900)
p <- tableGrob(DescriptivesTweets)
grid.arrange(p)
dev.off()

png("DescriptivesArticles.png", width=1000, height=900)
p <- tableGrob(DescriptivesArticles)
grid.arrange(p)
dev.off()
