# This is the server logic for a Shiny budget analysis web application.

library(shiny)
library(ggplot2)
library(DT)
library(shinyjs)
library(stringr)
library(googleVis)
library(scatterplot3d)
library(RColorBrewer)
library(plotrix)
shinyServer(function(input, output, session) {
  var<-reactive({
    switch(input$data1,
           
           "NewVision file "=names(data()),
           "full"=names(data())
    )
  })
  
  
  output$vx<-renderUI({
    selectInput("variablex","select 1st variable(x axis)",choices = var())
  })
  
  output$vy<-renderUI({
    selectInput("variabley","select 2nd Second variable(y axis)",choices = var())
  })
  # output$vz<-renderUI({
  # selectInput("variablez","select the Third variable",choices = var())
  # })
  
  output$select<-renderUI({
    selectInput(inputId="data1",label="Select dataset",choices ="NewVision file " )
  })
 
  
  output$plot1<-renderPlot({
    ggplot(data(), aes(x=get(input$variablex),y=get(input$variabley),fill = get(input$variabley)))+
      xlab(input$variablex)+
      ylab(input$variabley)+
      labs(fill=input$variabley)+
      geom_bar(stat="identity",position="dodge") 
    })
 
  output$plotdata2<-renderPlot({
    piePlotData = aggregate(formula(paste0(".~",input$variabley)), data(), sum)
    labels<-piePlotData[[input$variabley]]
    pie3D(piePlotData[[input$variablex]], labels = piePlotData[[input$variabley]],explode=0.1,theta=pi/6,mar=c(0,0,0,0))
    
    })

  
  output$plotdata3<-renderPlot({
    data <- readLines(file.choose())
    data<- sapply(data, function(row) iconv(row, from='latin1',to='ASCII', sub = ""))
    head(data, 1000)
    newCorpus <- Corpus(VectorSource(data))
    #clean the data
    #change to lower case letter
    newCorpus <- tm_map(newCorpus, content_transformer(tolower))
    #remove thr punctuation
    newCorpus <- tm_map(newCorpus, removePunctuation)
    #remove numbers
    newCorpus <- tm_map(newCorpus, removeNumbers)
    #remove the extra whitespace
    newCorpus <- tm_map(newCorpus, stripWhitespace)
    newCorpus <- tm_map(newCorpus, removeWords, stopwords("english"))
    newCorpus <- tm_map(newCorpus, stemDocument, language = 'english')
    newCorpus <- tm_map(newCorpus, removeWords, c("diana", "hello", "akurut","queri", "new vision", "accept", "system", "nssfug", "welcom", "nalwoga", "chat", "customerservicenssfugorgcustom", "customerservicenssfugorg"))
    #creating a document term frquency
    ndtm <- TermDocumentMatrix(newCorpus)
    mat <- as.matrix(ndtm)
    f <- sort(rowSums(mat), decreasing = TRUE)
    newFreq <- subset(f, f>=20)
    #create a data frame
    dframe <- data.frame(word = names(f), freq = f)
    dframe1 <- data.frame(word=names(newFreq), freq = newFreq)
    head(dframe, 200)
    
    #generate word cloud
    wordcloud(words = dframe$word, freq = dframe$freq, min.freq = 1,max.words=500, random.order=FALSE, rot.per=0.5,colors=brewer.pal(8, "Dark2"))#wordcloud2(dframe, size=0.5,fontWeight = "normal",max.words=200, minRotation = pi/6, maxRotation = pi/6,color=brewer.pal(8,"Dark2"))
    #letterCloud(dframe, word = "C",size = 2)
    #fetch the setiment words from text
    Sentiment <- get_nrc_sentiment(data)
    text <- cbind(data, Sentiment)
    #count the sentiment words by category
    TotalSentiment <- data.frame(colSums(text[, c(2:11)]))
    names(TotalSentiment) <-"count"
    TotalSentiment <- cbind("sentiment"=rownames(TotalSentiment), TotalSentiment)
    rownames(TotalSentiment) <- NULL
    #total sentiment of all graphs
    #ggplot(data=TotalSentiment, aes(x = sentiment, y = count))+geom_bar(aes(fill = sentiment), stat = "identity")+theme(legend.position = "none")+xlab("Sentiments")+ylab("Count")+ggtitle("Total Sentiment Score")
    
  })
  output$plotdata4<-renderPlot({
    data <- readLines(file.choose())
    data<- sapply(data, function(row) iconv(row, from='latin1',to='ASCII', sub = ""))
    head(data, 1000)
    newCorpus <- Corpus(VectorSource(data))
    #clean the data
    #change to lower case letter
    newCorpus <- tm_map(newCorpus, content_transformer(tolower))
    #remove thr punctuation
    newCorpus <- tm_map(newCorpus, removePunctuation)
    #remove numbers
    newCorpus <- tm_map(newCorpus, removeNumbers)
    #remove the extra whitespace
    newCorpus <- tm_map(newCorpus, stripWhitespace)
    newCorpus <- tm_map(newCorpus, removeWords, stopwords("english"))
    newCorpus <- tm_map(newCorpus, stemDocument, language = 'english')
    newCorpus <- tm_map(newCorpus, removeWords, c("diana", "hello", "akurut","queri", "nssf", "accept", "system", "nssfug", "welcom", "nalwoga", "chat", "customerservicenssfugorgcustom", "customerservicenssfugorg"))
    #creating a document term frquency
    ndtm <- TermDocumentMatrix(newCorpus)
    mat <- as.matrix(ndtm)
    f <- sort(rowSums(mat), decreasing = TRUE)
    newFreq <- subset(f, f>=20)
    #create a data frame
    dframe <- data.frame(word = names(f), freq = f)
    dframe1 <- data.frame(word=names(newFreq), freq = newFreq)
    head(dframe, 200)
    
    #generate word cloud
    wordcloud(words = dframe$word, freq = dframe$freq, min.freq = 1,max.words=500, random.order=FALSE, rot.per=0.5,colors=brewer.pal(8, "Dark2"))#wordcloud2(dframe, size=0.5,fontWeight = "normal",max.words=200, minRotation = pi/6, maxRotation = pi/6,color=brewer.pal(8,"Dark2"))
    #letterCloud(dframe, word = "C",size = 2)
    #fetch the setiment words from text
    Sentiment <- get_nrc_sentiment(data)
    text <- cbind(data, Sentiment)
    #count the sentiment words by category
    TotalSentiment <- data.frame(colSums(text[, c(2:11)]))
    names(TotalSentiment) <-"count"
    TotalSentiment <- cbind("sentiment"=rownames(TotalSentiment), TotalSentiment)
    rownames(TotalSentiment) <- NULL
    #total sentiment of all graphs
    ggplot(data=TotalSentiment, aes(x = sentiment, y = count))+geom_bar(aes(fill = sentiment), stat = "identity")+theme(legend.position = "none")+xlab("Sentiments")+ylab("Count")+ggtitle("Total Sentiment Score")
  })
  
  output$contents<-renderTable({
    data() 
    
  },height = 400,width = 1000)
  # variable to store the file data
  data <- reactive({
    file1 <- input$file
    if (is.null(file1)) {
      return()
    }
    info<-read.csv(file=file1$datapath)
    info[is.na(info)]<-0
    return(info)
  })
  # outputs summary about the file
  #output$filedf <- renderTable({
  #if (is.null(data())) {
  # return()
  #}
  #input$file
  #})
  # outputs summary about the data in the file
  output$sum <- renderTable({
    if (is.null(data())) {
      return()
    }
    summary(data())[,1:1]
  })
  
  output$downloadPlot <- downloadHandler(
    filename = "graphics.png",
    content = function(file) {
    if(input$plot=="BarGraph"){
        png(file)
        bar<-ggplot(data(),type="l", aes(x=get((input$variablex)),y=get(input$variabley) ))+
          xlab(input$variablex)+
          ylab(input$variabley)+
          geom_bar(stat="identity",position ="dodge",color ="blue")
        print(bar)
        dev.off()
     
    }
    else if(input$plot=="PieChart"){
      
        png(file)
      pie<-pie(aggregate(formula(paste0(".~",input$variabley)), data(), sum)[[input$variablex]], labels = aggregate(formula(paste0(".~",input$variabley)), data(), sum)[[input$variabley]])
      print(pie) 
      dev.off()
    }
    
    else if(input$plot=="WordCloud"){
    png(file)
    word<- wordcloud(words = dframe$word, freq = dframe$freq, min.freq = 1,max.words=500, random.order=FALSE, rot.per=0.5,colors=brewer.pal(8, "Dark2"))#wordcloud2(dframe, size=0.5,fontWeight = "normal",max.words=200, minRotation = pi/6, maxRotation = pi/6,color=brewer.pal(8,"Dark2"))
    print(word)
    dev.off()
    }
    else{
    png(file)
    sent<-ggplot(data=TotalSentiment, aes(x = sentiment, y = count))+geom_bar(aes(fill = sentiment), stat = "identity")+theme(legend.position = "none")+xlab("Sentiments")+ylab("Count")+ggtitle("Total Sentiment Score")
    print(sent)    
    dev.off()
      }
    }

  )
  output$dynamic2 <- renderUI({
    
    if (input$ds2 == "Graphics") { 
      tabsetPanel(
        id = "navbar1",
        tabPanel("Uploaded Contents",
                 tableOutput("contents")),
        tabPanel("BAR GRAPH",
                 plotOutput("plot1")),
        tabPanel("PIE CHART",
                 plotOutput("plotdata2",width="100%")),
        tabPanel("WORD CLOUD",plotOutput("plotdata3")),
        tabPanel("SENTIMENT ANALYsis",plotOutput("plotdata4"))
      )
      
    } 
  })
  
}
)