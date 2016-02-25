#packages
if(!require(knitr)) install.packages("knitr"); library(knitr)
if(!require(shinyjs)) install.packages("shinyjs"); library(shinyjs)
if(!require(ggplot2))install.packages("ggplot2"); library(ggplot2)

source("utilities.R")

maxDemos <- 10
maxInfo <- 5

mydata <- NULL
data<- get(load("data/data.Rda"))
dontlook <- list()


#demo and info files

possible_demofiles <- paste0("demos/demo",1:maxDemos,".rmd")
possible_infofiles <- paste0("demos/info",1:maxInfo,".rmd")

ndemos <- sum(file.exists((possible_demofiles)))
ninfo <- sum(file.exists(possible_infofiles))

demofiles <- possible_demofiles[1:ndemos]
infofiles <- possible_infofiles[1:ninfo]

tmp_demos <- paste0("tmp_demo",1:ndemos,".md")
tmp_infos <- paste0("tmp_info",1:ninfo,".md")

#knit the infos
mapply(knit,infofiles,tmp_infos, MoreArgs=list(quiet=T))
