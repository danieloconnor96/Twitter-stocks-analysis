#Text Mining package for cleaning 
install.packages("tm")
library(tm)
#Package for gsub
install.packages("textreg")
library(textreg)
#Package for str_replace
install.packages("stringr")
library(stringr)
#################################

#problem here is this file is only articles 1. 2 more files. These need to be concatenated
#need to decide on how much of the article data will be used
#if issue - mention to Divyaa
ArticlesRaw = read.csv(file.choose(), stringsAsFactors = FALSE)

