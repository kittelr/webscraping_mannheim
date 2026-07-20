# Web-scraping Press Releases: Example
# Rebecca Kittel
# 2026-07-21


# load packages
library(rvest)
library(dplyr)
library(tidytext)

#clear your environment
rm(list = ls()) 


#set wd

library(rstudioapi) 
# Set working directory to source file location
setwd(dirname(getActiveDocumentContext()$path)) 
getwd()


#                    EXAMPLE 3                  #

#        Press Releases Extinction Rebellion     #


#define the main url
startpage<-("https://extinctionrebellion.uk/press/page/")

#we create a set of urls for the different sides
resultsurl<-paste0(startpage,1:5,"/")

#we create empty lists to store the data
titles<-dates<-text<-links<-list()

titles<-list()
dates<-list()
text<-list()


#for loop for scraping main page
for (i in 1:5){
  page<-read_html(resultsurl[i])
  titles[[i]]<-html_nodes(page,"h2") %>% html_text()
  dates[[i]]<-html_nodes(page,".tease-press-release__meta") %>% 
    html_text()
  #please fill in the css selctor to scrape the link
  links[[i]]<-html_nodes(page,"") %>%
    html_attr("href")
  
}

#create a dataframe
results_df <- data.frame(links=unlist(links),
                         dates =unlist(dates),
                         stringsAsFactors = F)

#Why are the headings not included in the data frame? What is the problem here?



#download statements
start <- Sys.time()

speechtext <- rep("",length(results_df$links))
dates<-rep("",length(results_df$links))
titles<-rep("",length(results_df$links))


for (i in 1:length(results_df$links)){
  speechtext[i] <- read_html(results_df$links[i]) %>%
    html_nodes(".type") %>%
    html_text()
  dates[i] <- read_html(results_df$links[i]) %>%
    html_nodes(".post_date") %>%
    html_text()  
  titles[i] <- read_html(results_df$links[i]) %>%
    html_nodes(".page-title") %>%
    html_text()  
  
  
}


results_df$text <- speechtext
results_df$dates <- dates
results_df$titles <- titles


end <- Sys.time()
end-start






# EXAMPLE : Press Releases - DO-IT-YOURSELF EXAMPLE #



# 1. Go to https://www.theclimategroup.org/
# 2. Collect all press releases they have published on their website
# 3. Use a for loop to collect the date, link and headline information
# 4. Use a second for loop to collect the text
# Hint: When you run into a problem by collecting the text information, 
#       try to figure out what the error message is, also ChatGPT or another AI can be of help!


# 5. Additional Task: Clean the date variable



