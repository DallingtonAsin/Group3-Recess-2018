library("devtools")
require("Rfacebook")
library("RCurl")
library("rjson")
library("tm")
library(wordcloud)





url<-"https://graph.facebook.com/v2.6/10156682750168598/comments?access_token=EAACEdEose0cBABrlwKmKIZC1C0xY1kaamQZAECZAjhXWr5vLfTTjFB3BZASloiK8rIF4Haojbv8QS2WilE6WAfZAkZBrskafNqdHzegdBmDpOf8suaIrSeeQhUUCEruT4jPQhlP0TERSwKFpVRPhnA9xOD2juZAmUcXHzUdZBUZA2UhDq2ub49D3PMFMB9GZBswvYZD"
#url<-"https://graph.facebook.com/v3.0/10156682750168598/comments?access_token=EAACEdEose0cBAKo0qaZCW0uGx9gjywugMewJ1eTC9DcPZCK2ZBAZBK2wpqwl3lOszf3rPVTNZBA4B4m42BFd6XV3hW2dKLUuZAgBbKCalqqNb5szZATWGygm6ZB4JmHsBhVTj7f8ch14Rc9APPIHOe8459ZBoN2Xw2vZBAzW0HVbmutJZAAjRx5AEmFZCOWdRicQwAgZD"
kk<-fromJSON(getURI(url))
comments<-sapply(kk$data,function(kk) {list(comment=kk$message)})
cleanedcomments<-sapply(comments,function(x) iconv(enc2utf8(x),sub="byte"))
mycorpus<-Corpus(VectorSource(cleanedcomments))
myfunction<-content_transformer(function(x,pattern) gsub(pattern,"",x))
my_cleaned_corpus<-tm_map(mycorpus,myfunction,"/")
my_cleaned_corpus<-tm_map(my_cleaned_corpus,myfunction,"@")
my_cleaned_corpus<-tm_map(my_cleaned_corpus,myfunction,"\\|")
my_cleaned_corpus<-tm_map(my_cleaned_corpus,content_transformer(tolower))
my_cleaned_corpus<-tm_map(my_cleaned_corpus,removeWords,c(stopwords("english"),"batman","movie","superman"))
my_cleaned_corpus<-tm_map(my_cleaned_corpus,removePunctuation)
my_cleaned_corpus<-tm_map(my_cleaned_corpus,stripWhitespace)

mytdm<-TermDocumentMatrix(my_cleaned_corpus)
m<-as.matrix(mytdm)
#View(m)

words<-sort(rowSums(m),decreasing = TRUE)
mydf<-data.frame(Word=names(words),freq=words)
#View(mydf)


par(mfrow=c(3,2))
wordcloud(words=mydf$Word,freq=mydf$freq,min.freq = 1,max.words = 100,random.order = FALSE,rot.per = 0.35,colors = brewer.pal(8,"Dark2"),main="WordCloud showing frequency of words")
hist(mydf$freq,main="HISTOGRAM SHOWING FREQUENCY OF WORDS IN COMMENTS",breaks = 10,
     xlab = "Number of words",col="thistle1",freq=TRUE)
plot(mydf$freq,main = "SCATTER PLOT SHOWING FREQUENCY OF WORDS IN COMMENTS")
pie(table(mydf$freq)[order(table(mydf$freq),decreasing = TRUE)],main = "PIE CHART SHOWING FREQUENCY OF WORDS IN COMMENTS",   col = c("seashell", "cadetblue2", "lightpink",
                                                                                                       "lightcyan", "plum1", "papayawhip"))
   #init.angle = 90,clockwise = TRUE,

boxplot(mydf$freq,main = "SCATTER PLOT SHOWING FREQUENCY OF WORDS IN COMMENTS")
barplot(mydf$freq,main = "BARPLOT SHOWING FREQUENCY OF WORDS IN COMMENTS",col="red")

