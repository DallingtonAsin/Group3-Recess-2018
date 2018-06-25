#install.packages("tm")  # for text mining
#install.packages("SnowballC") # for text stemming
#install.packages("wordcloud") # word-cloud generator 
#install.packages("RColorBrewer") # color palettes
# Load
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")
library("ggplot2")


#mydata<-read.csv(file.choose(), header = TRUE)
mydata <- read.csv("~/Desktop/VisionGroupCiMJuly.csv", header = TRUE)
docs <- Corpus(VectorSource(mydata$Chat.content))
inspect(docs)
toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")
# Convert the text to lower case
docs <- tm_map(docs, content_transformer(tolower))
# Remove numbers
docs <- tm_map(docs, removeNumbers)
# Remove english common stopwords
#View(stopwords("english")) 
docs <- tm_map(docs, removeWords, stopwords("english"))
# Remove your own stop word
# specify your stopwords as a character vector
docs <- tm_map(docs, removeWords, c("chat","system","https","stellamaris","eatuhaire","assistant","joseph","simon","www.visiongroup.co.ug","banyu","newvision.co.ug","closed","accepted","live","elizabeth","atuhaire","support","http","paul","josephbanyu","jbanyu","ochen","nabisere")) 
# Remove punctuations
docs <- tm_map(docs, removePunctuation)
# Eliminate extra white spaces
docs <- tm_map(docs, stripWhitespace)
# Text stemming
# docs <- tm_map(docs, stemDocument)
dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
#View(m)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
#View(d)
head(d, 20)

set.seed(1234)
wordcloud(words = d$word, freq = d$freq, min.freq = 1, max.words=1000, random.order=FALSE, rot.per=0.35,colors=brewer.pal(8, "Dark2"))


#barplot(d[1:20,]$freq, las = 2, names.arg = d[1:20,]$word,col ="lightblue", main ="Most frequent words",ylab = "Word frequencies")
# general statistcs and counts
#stri_stats_general(docs)
findAssocs(dtm, terms = "get", corlimit = 0.5)










