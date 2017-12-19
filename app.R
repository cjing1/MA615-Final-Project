# Game Market Analysis R shiny 
# Chen Jing

# !!! set work directory 
setwd('/Users/JingC/Desktop/MA 615/Final project/')

library(xlsx)
library(dplyr)
library(ggplot2)
library(knitr)
require(reshape2)
library(treemap)
library(wordcloud2)
library(stringr)
library(RColorBrewer)
library(tidytext)
library(tidyverse)
library(janeaustenr)
library(scales)
library(shiny)

#Game <- read.xlsx("Video_Games_Sales_as_at_22_Dec_2016.xlsx", sheetName = "GameSales")
#NintendoData <- read.xlsx('NintendoData.xlsx', sheetName = "NintendoData", stringsAsFactors=FALSE)


NintendoData <- read.csv('NintendoData.csv', stringsAsFactors=FALSE)
Game <- read.csv('Video_Games_Sales_as_at_22_Dec_2016.csv')


Game<-Game[-c(which(Game$Year_of_Release=='2017'),which(Game$Year_of_Release=='2020'),which(Game$Year_of_Release=='N/A')),]
Game$Year_of_Release<-as.numeric(as.character(Game$Year_of_Release))



# Define UI for application that draws a histogram
ui <- navbarPage("Game Market Analysis",
   
   # Application title
   titlePanel("Game Data"),
   
   tabPanel("Time Change Influence",
   sidebarLayout(
      sidebarPanel(
         sliderInput("time",
                     "Year:",
                     min = 1980,
                     max = 2016,
                     value = 2000)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
        tabsetPanel(
          tabPanel('Platform', plotOutput("tree1")),
          tabPanel('Genre',plotOutput("tree2")),
          tabPanel('Publisher',plotOutput("tree3"))
      )
      )
   )
   ),
   tabPanel("Word Cloud",
            sidebarLayout(
              # Sidebar with a slider and selection inputs
              sidebarPanel(
                selectInput("selection", "Tweet Topic:", 
                            choices=levels(as.factor(NintendoData$tweets)))),
              
              # Show Word Cloud
              mainPanel(
                wordcloud2Output("cloud")
              )
            )
   )
)


server <- function(input, output) {
   
   output$tree1 <- renderPlot({
      data<-Game[c(which(Game$Year_of_Release==input$time)),]
      treemap(data,
              index="Platform",
              vSize="Global_Sales",
              type="index",
              title="Video Games Global Sales for various Platform", 
              fontsize.title = 14 
      )
   })
   
   output$tree2 <- renderPlot({
     data<-Game[c(which(Game$Year_of_Release==input$time)),]
     treemap(data,
             index="Genre",
             vSize="Global_Sales",
             type="index",
             title="Video Games Global Sales for various Genre", 
             fontsize.title = 14 
     )
   })
   
   output$tree3 <- renderPlot({
     data<-Game[c(which(Game$Year_of_Release==input$time)),]
     treemap(data,
             index="Publisher",
             vSize="Global_Sales",
             type="index",
             title="Video Games Global Sales for various Publisher", 
             fontsize.title = 14 
     )
   })
   
   output$cloud <- renderWordcloud2({
     
     NS<-NintendoData[c(which(NintendoData$tweets==as.character(input$selection))),]
     switchtweet <- sapply(as.vector(data.frame(NS[[3]])), function(row) iconv(row, "latin1", "ASCII", sub=""))
     switchreview_text <- paste(switchtweet,collapse = "")
     
     # Clean text
     clean_tweet = gsub("&amp", "", switchreview_text)
     clean_tweet1 = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", clean_tweet)
     clean_tweet2 = gsub("@\\w+", "", clean_tweet1)
     clean_tweet3 = gsub("[[:punct:]]", "", clean_tweet2)
     clean_tweet4 = gsub("[[:digit:]]", "", clean_tweet3)
     clean_tweet5 = gsub("http\\w+", "", clean_tweet4)
     clean_tweet6 = gsub("[ \t]{2,}", "", clean_tweet5)
     clean_tweet7 = gsub("^\\s+|\\s+$", "", clean_tweet6) 
     clean_tweet8 <- str_replace_all(clean_tweet7," "," ")#get rid of unnecessary spaces
     clean_tweet9 <- str_replace(clean_tweet8,"RT @[a-z,A-Z]*: ","") # Take out retweet header
     clean_tweet10 <- str_replace_all(clean_tweet9,"#[a-z,A-Z]*","") # Get rid of hashtags
     clean_tweet11 <- str_replace_all(clean_tweet10,"@[a-z,A-Z]*","")# Get rid of references to other screennames 
     
     text_df <- data_frame(text = clean_tweet11)
     NS_df <- text_df %>% unnest_tokens(word, text) %>%  anti_join(stop_words)
     
     result <- NS_df %>%
       count(word, sort=TRUE) 
     
     wordcloud2(result)
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

