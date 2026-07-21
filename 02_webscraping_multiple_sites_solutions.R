# Scraping Multiple Webpages
# Rebecca Kittel
# 2026-07-21


# load packages (install if necessary)
library(rvest)
library(dplyr)
library(magrittr)
library(tidytext)

library(httr)

library(rstudioapi) 

# Set working directory to source file location
setwd(dirname(getActiveDocumentContext()$path)) 



rm(list = ls()) 



#------------------- EXAMPLE 1 - continued --------------------#

#         THE AMERICAN PRESIDENCY PROJECT          #


# Applying CSS Selectors
speech <- read_html("https://www.presidency.ucsb.edu/documents/statement-administration-policy-hj-res-46-terminating-the-national-emergency-declared-the")




# Using CSS Selector Gadget
#html_text to get the content
selected_nodes <- html_nodes(speech,".field-docs-content")
selected_nodes

#now we only want the text
html_text(selected_nodes)

#we can safe the speech in an object, version 1
speech_1<- selected_nodes%>% html_text()

#instead of using the .field-docs-content, we can also use p
html_nodes(speech,"#block-system-main p") %>%
  html_text()

#BUT: we have many individual p entries, we have to paste them together
speech_2 <- 
  html_nodes(speech,"#block-system-main p") %>%
  html_text()%>%paste( collapse = "")



#---------------- EXAMPLE 2: Automation ------------------#

#             White House Government Briefs               #

## define start page
# replace with your URL
startpage<-"https://www.whitehouse.gov/news/"



# generate urls of results pages
searchresults<-read_html(startpage)
# choose last page of search results

last_page<-html_nodes(searchresults,".page-numbers") %>% tail(1) %>% html_attr("href")

#some regex commands to extract last page number
library(stringr)
last_page <- str_extract(last_page,"[0-9]+")
last_page <- as.numeric(last_page)


#if you do not want to count all pages manually, just define the page count
resulturls <- paste0(startpage,"page/", 1:last_page,"/")


# Scrape links to all statements
titles <- links <- dates <- list()

# alternatively i in 1:last_page -> if you want to scrape all pages
for (i in 1:2){
  page<-read_html(resulturls[i])
  titles[[i]]<-html_nodes(page,".has-heading-3-font-size a") %>% html_text()
  links[[i]]<-html_nodes(page,".has-heading-3-font-size a") %>%
    html_attr("href")
  dates[[i]] <- html_nodes(page,"time") %>% html_text()
}

results_df <- data.frame(titles=unlist(titles),
                         links=unlist(links),
                         dates=unlist(dates),
                         stringsAsFactors = F)





#download statements
start <- Sys.time()

speechtext <- rep("",length(results_df$links))
for (i in 1:length(results_df$links)){
  speechtext[i] <- read_html(results_df$links[i]) %>%
    html_nodes(".wp-block-post-content-is-layout-constrained") %>%
    html_text()
}
results_df$text <- speechtext

end <- Sys.time()
end-start



