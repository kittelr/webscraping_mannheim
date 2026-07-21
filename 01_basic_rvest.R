# Basic Rvest Commands
# Rebecca Kittel
# 2026-07-21



# load packages (install if necessary)
library(rvest) # for scraping HTML content
library(dplyr)
library(tidyverse)

library(rstudioapi) 

# Set working directory to source file location
setwd(dirname(getActiveDocumentContext()$path)) 



rm(list = ls()) 




#------------------- EXAMPLE 1 --------------------#

#         THE AMERICAN PRESIDENCY PROJECT          #

#open webpage in browser
browseURL("https://www.presidency.ucsb.edu/")


#define url
#administation policy statements
url<-"https://www.presidency.ucsb.edu/documents/presidential-documents-archive-guidebook/statements-administration-policy-reagan-1985"


#read html page
searchresults <- read_html(url)

#inspect object
searchresults

#convert table into list object, option 1
html_table(searchresults)


#convert table into list object, option 2
tables <- html_table(searchresults)

tables [[1]]


library(magrittr)
extract2(tables, 1)




# Looking up a website
speech <- read_html("https://www.presidency.ucsb.edu/documents/statement-administration-policy-h-con-res-86-directing-the-removal-united-states-armed-0")







# Applying tags to identify elements
html_nodes(speech,"h1")
html_nodes(speech,"h2")
html_nodes(speech,"h3")
html_nodes(speech,"h4")

html_nodes(speech,"*")





# or with extracting text

html_nodes(speech,"h1") %>% html_text()
html_nodes(speech,"h2") %>% html_text()
html_nodes(speech,"h3") %>% html_text()
html_nodes(speech,"h4") %>% html_text()

html_nodes(speech,"*") %>% html_text()


# Wikipedia


## html_table(): Extracting tables ####


# Try out yourself!

# Go to https://en.wikipedia.org/wiki/List_of_elected_and_appointed_female_heads_of_state_and_government

# And  scrape the table :)




