library("devtools")
library(tm)
library(wordcloud)

mydata<-read.csv(file="/home/dallington/Recess/vision.csv",header=TRUE)
mycorpus<-Corpus(VectorSource(mydata$Chat.content))
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
View(m)
words<-sort(rowSums(m),decreasing = TRUE)
mydf<-data.frame(Word=names(words),freq=words)
View(mydf)

wordcloud(words=mydf$Word,freq=mydf$freq,min.freq = 3,max.words = 100,random.order = FALSE,rot.per = 0.36,colors = brewer.pal(8,"Dark2"))
