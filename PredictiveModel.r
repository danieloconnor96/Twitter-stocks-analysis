library(dplyr)
library(ngram)
library(car)
library(varImp)

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

#residuals
resid(Model)

#plot model
plot(Model)

#density plot
plot(density(resid(Model)),main ="Density of Residuals")
