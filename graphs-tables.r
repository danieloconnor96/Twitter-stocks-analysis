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

# function to display 3 decimal places
round3 <- function(x){round(x,3)}

#set colnames for descriptive table vars
ColumnNames <- colnames(CorDFArticles)

#descriptive/summary statistics
DescriptiveStats <- psych::describeBy(CorDFArticles) %>% mutate(
  vars = ColumnNames) %>% select(-one_of("trimmed","mad")) %>%
  mutate_if(is.numeric, round3)

#export summary table asimg
png("DescriptivesArticles.png", width=1000, height=900)
p <- tableGrob(DescriptiveStats)
grid.arrange(p)
dev.off()
