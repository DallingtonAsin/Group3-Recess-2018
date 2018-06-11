library("devtools")
require("Rfacebook")
library("RCurl")
library("rjson")
library("tm")
library(wordcloud)





#url<-"https://graph.facebook.com/v2.6/10156682750168598/comments?access_token=EAACEdEose0cBAAp20IdsijqSyAtQaankZCRqOZAdeuDBWbxplrF26h5J0pUS8uuai68lO0ZCs95joVGARpcY8nkjkCUZBCVKEnCGzDW6e33sdZC52dQpRn33diS3fRaa4Ip6zMFokttzhTi8LuEKWwNY0UBW1aflKhZCBsU7mHp9PiMVyZCN9odTuv75Aw2IowYyrzZCVHPbVQZDZD"

url<-"https://graph.facebook.com/v2.6/10156682750168598/comments?access_token=EAACEdEose0cBAMdn1oDx3yUkekAQayZAlpCQ0CAO4eRLO7R08P3kEltXvkpTblwrOaZBVc5FC3PUwZCpjvGSTnXtH2AxcQaJYDNoIAD64hZAZBYgVs45k77UVSGcmH5klG51ZCtmZAnV7aNwfW2gd7zoBKZCviyYZBPRgbgmUeFbfAPkVKsF86fMvEqMvZA1Vyt10ZD"

#url<-"https://graph.facebook.com/v2.6/10156682750168598/comments?access_token=EAACEdEose0cBAGShgeCwT5W9LSZA4OHzqxZBhtAV2wJS1gZBLKjAnQsdyqhlDa2hGKrSBAFT4wn1r4ZC0QBvlpKw8LctSk3MZCmkMMHxneYAjdbmnsYZAnxRIDuAfF4tQBChNam5xOdPi0MAt2LhO8QZCEIJPFgvUUlPOZAUDtIzZALbfDbJdgyKpX9t9VVko6xLZAn7lIB8wCUgZDZD"


#url<-"https://graph.facebook.com/v3.0/10156682750168598/comments?access_token=EAACEdEose0cBABZAqBvhX3TXf1DZBGuLLcfBFNcwjOboCt5Hj9vO4eKgR7XnfMUgTfaIqrf42Mt5Iqtj0FJAoJjIWU0wTWuv0VdYFw2c91f8w2RStbMsXmuijgVNZCLghQlTU4KZC5WopD2QJ3rM0ZA6vR4LljdZBISOAZCE2OAyL1Qj1AAPZBfMtaogJO4l9ZAGZCcqqhLILfzwZDZD"
kk<-fromJSON(getURL(url))
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
View(m)
words<-sort(rowSums(m),decreasing = TRUE)
mydf<-data.frame(Word=names(words),freq=words)
View(mydf)

wordcloud(words=mydf$Word,freq=mydf$freq,min.freq = 2,max.words = 100,random.order = FALSE,rot.per = 0.36,colors = brewer.pal(8,"Dark2"))
#hist(mydf$freq,main = "HISTOGRAM SHOWING FREQUENCY OF WORDS USED IN THE POST")
