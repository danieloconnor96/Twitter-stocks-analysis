library(dplyr)
library(ngram)
library(car)
library(varImp)

#create function to display 3 decimal places
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

#avg wordcount comparison
wordcount(NewsArticles$ArticleContent, sep="", count.function = mean)
wordcount(TweetsClean$TweetContent, sep="", count.function = mean)


###################################
#Random samples to match n of articles for model
TweetSample <- sample_n(TweetsClean, 1100)
CorDFSample <- sample_n(CorDF2, 1100)

#set vars & construct DF for model
TweetSent   <- CorDFSample$ave_sentiment
PriceChange <- CorDFSample$PercentChange
ArticleSent <- NewsArticles$ave_sentiment

MergedDF <- data.frame(TweetSent, ArticleSent, PriceChange)

#Build model
Model <- lm(PriceChange ~., data=MergedDF)

#multicollinearity check
vif(Model)

#model summary
summary(Model)

#plot  model
plot(Model)

#residuals
resid(Model)

#density plot
plot(density(resid(Model)),main ="Density of Residuals")

qqnorm(resid(Model))

#variable importance
varImp(Model, scale=FALSE)

#### prediction ####
#NOT SURE ON THIS BIT - NEED TO LOOK INTO IT
#Mean values as DF
QDataMean = read.csv(file.choose(), header=TRUE ) 

# Make prediction
Prediction <- Model %>% predict(QDataMean)

####################################

#plot residuals
plot(Model)