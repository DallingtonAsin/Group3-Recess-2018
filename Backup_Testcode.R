library("devtools")
require("Rfacebook")
library("RCurl")
library("rjson")
library("tm")
library(wordcloud)

#fb_oauth <- fbOAuth(app_id="170908330266650", app_secret="b47758a6dd9697bd3b414b40437148c5",extended_permissions = TRUE)
#save(fb_oauth, file="Testcode")
#load("fb_oauth")
#getUsers(c("barackobama", "donaldtrump"), token)



#token <- 'EAACEdEose0cBALwPu2OdXMwlidVYZCOX9LrZCZC2frnTesAcRFqqRb7g14vkqsYX1YAtZAP4hNfLeyfpwo0apVcjHNQVqV9NqvtcPMagB97vDuu1GzOGVuC1esiar0LpoMaK5wPZCsZBZA8ZBZCEAZBlglVq0Rel3iaufKeMs3iwU4O2TTeMBBFR0lKZBmpzGJHAVYZD'
#me <- getUsers("me", token, private_info=TRUE)
#my_likes <- getLikes(user="me", token=token)

#p_token<-"EAACEdEose0cBAL91cG99ZAHELzyYG3AOkGBiUL7iKCYEs6bbzo3hpAcHGtXYmkILBFTrCKPZB8Uv6zlt6Vn72ZCrZBt7EPLmg4of6nxKIQmUxeqqhr74ZAk0L4gNthgxGeWOUK88ZB9cbT0W8ZCPUVXzWgcObkcrtOSVD8yagGCPbff674bXe0kc6VKPTRM2Lm1fp01RJrR2wZDZD"
#page_info<-getPage(25427813597, p_token, n = 25, since = NULL, until = NULL, feed = FALSE,comments=TRUE,
                  # reactions = FALSE, verbose = TRUE, api = NULL)

url<-"https://graph.facebook.com/v3.0/10156682750168598/comments?access_token=EAACEdEose0cBANSReZBp5DRmrCzw8q8G9wKJOE1aQRr3TeR3cFrMh0ZA4lNjf8vgkELKwXwGY3LoNfSqlvmjynuqOLEZBPCl6vnCnA2tZBNwpP2UrgVdO0D42rqBSZBDpHpX3PtqrMBGbkKQeu1WYfucYInTpCJM12ZCKA19GZANS2xWGZAOFvbRw66U4Sv0GQcZD"
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

wordcloud(words=mydf$Word,freq=mydf$freq,min.freq = 2,max.words = 100,random.order = FALSE,rot.per = 0.35,colors = brewer.pal(8,"Dark2"))









#token<-"EAACEdEose0cBAENnLkM14giELCbhkXekBZApBdZBdvfnOCi6H5P0OihrumO4bAFYkwx3pMKik2wy3fetc10ee030uSP9UMM4lcVIsINzHqF5WwFZCr3kXL9Q6M5sLqeozPZCY0xmiOgXaR4B8E7YWMJAQMQoE4wVBSLPg7hoYpsoYZBZBZAO9xYgfA40tcbWh9QUvTMU15B2gZDZD"
#sd<-getPost(post=page$id[[25427813597]], token, n = 500, comments = TRUE)

