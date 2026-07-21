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
  links[[i]]<-html_nodes(page,".tease-press-release__link") %>%
    html_attr("href")
  
}

#create a dataframe
results_df <- data.frame(links=unlist(links),
                         stringsAsFactors = F)

#Why are the headings not included in the data frame? What is the problem here?

#also headings that do not belong to press releases are scraped, happens regularly, always be careful
headings<-data.frame(unlist(titles),stringsAsFactors = F) 


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


## define start page
# replace with your URL
startpage<-"https://theclimategroup.prod.acquia-sites.com/search?f%5B0%5D=content_type%3Anews&sort_by=created&page=44"



# generate urls of results pages
searchresults<-read_html(startpage)
# choose last page of search results

#define the main url
startpage<-("https://theclimategroup.prod.acquia-sites.com/search?f%5B0%5D=content_type%3Anews&sort_by=created&page=")


#we create a set of urls for the different sides
resultsurl<-paste0(startpage,1:44)

#we create empty lists to store the data
titles<-dates<-text<-links<-list()


# only for the first two websites, but if you change to 44 you get all
for (i in 1:2){
  page<-read_html(resultsurl[i])
  titles[[i]]<-html_nodes(page,".s-content-card__title") %>% html_text()
  links[[i]]<-html_nodes(page,".s-content-card--link") %>%
    html_attr("href")
  dates[[i]] <- html_nodes(page,".s-content-card__info p") %>% html_text()
}

results_df <- data.frame(titles=unlist(titles),
                         links=unlist(links),
                         dates=unlist(dates),
                         stringsAsFactors = F)



#need to adapt the URLs, add the first part of main website to it
results_df$links<-paste0("https://theclimategroup.prod.acquia-sites.com",results_df$links)



#testing where the text is saved
read_html(results_df$links[1]) %>% html_nodes(".article-text") %>% html_text()
html_nodes(page, "div") %>% html_text()

# However, we receive an error message when scraping the data as not all URLs seem to follow the same logic.
# Some urls have videos instead of text on their website.
# As such, we need to adapt for that:

#download statements
start <- Sys.time()


for (i in seq_along(results_df$links)) {
  link <- results_df$links[i]
  
  tryCatch({
    page <- read_html(link)
    nodes <- html_nodes(page, ".article-text div")
    
    if (length(nodes) > 0) {
      text <- html_text(nodes, trim = TRUE)
      speechtext[i] <- paste(text, collapse = " ")
    } else {
      speechtext[i] <- NA  # Or "" if you prefer empty strings
      warning(sprintf("No matching nodes for link %s", link))
    }
    
  }, error = function(e) {
    speechtext[i] <- NA
    warning(sprintf("Error while reading link %s: %s", link, e$message))
  })
}


results_df$text <- speechtext

end <- Sys.time()
end-start



