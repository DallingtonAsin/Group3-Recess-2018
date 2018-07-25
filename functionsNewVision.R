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
library("stringr")

importingFile<-function(){
  #mydata<-read.csv(file.choose(), header = TRUE)
  mydata<- read.csv("~/Desktop/VisionGroupCiMJuly.csv", header = TRUE)
  
   return(mydata)
  
}
analyzingChat<-function(){
  mydata<-importingFile()
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
  docs <- tm_map(docs, removeWords, c("chat","system","https","engoru","stellamaris","eatuhaire","assistant","joseph","simon","peter","vizuri.visiongroup.co.ug","www.visiongroup.co.ug","banyu","newvision.co.ug","closed","accepted","live","elizabeth","atuhaire","support","http","paul","josephbanyu","jbanyu","ochen","nabisere","peter")) 
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
  head(d, 50)
  return(d)
}
wordCloud<-function(){
  analyzingChat()
  set.seed(1234)
  wordcloud(words = d$word, freq = d$freq, min.freq = 2, max.words=1000, random.order=FALSE, rot.per=0.2,colors=brewer.pal(8, "Dark2"))
  
}


barPlotChat<-function(){
  
  barplot(d[1:20,]$freq, las = 2, names.arg = d[1:20,]$word,col ="lightblue", main ="Most frequent words",ylab = "Word frequencies")
  
}

general_statistcs<-function(){
  
  #general statistcs and counts
  #stri_stats_general(docs)
  findAssocs(dtm, terms = "get", corlimit = 0.5)
}

#http://www.sthda.com/english/wiki/text-mining-and-word-cloud-fundamentals-in-r-5-simple-steps-you-should-know


#mm<-as.matrix(mydata$Country)
#View(mm)
#wordss<-sort(rowSums(mm),decreasing = TRUE)
#mydf<-data.frame(Word=names(wordss),freq=wordss)
#View(mydf)
barPlotCountry<-function(){
  importingFile()
  barplot(table(mydata$Country),
          main="Number of participants from different Countries",
          xlab="Country",
          ylab="Number of participates",
          border="red",
          las = 2,
          col="blue",
          density=50
          
          
  )
}

barPlotdepartment<-function(){
  importingFile()
  barplot(table(mydata$Department),
          main="Departments Selected",
          xlab="Number of participates",
          ylab="Department",
          border="red",
          las = 2,
          col="blue",
          space= 1,
          cex.lab=0.75,
          horiz = T,
          density=20
          
          
  )
}



barPlotstatus<-function(){
  importingFile()
  barplot(table(mydata$Vote.status),
          main="Number of participants who voted for Status",
          xlab="Number of participates",
          ylab="Status",
          border="red",
          las = 2,
          col="blue",
          space= 1,
          cex.lab=0.75,
          horiz = T,
          density=20
          
          
  )
}








#importingFile()
#barPlot()
#barPlotCountry()
#wordCloud()
#barPlotstatus()
#barPlotdepartment()
#general_statistcs()