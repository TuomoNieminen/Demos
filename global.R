#packages
if(!require(knitr)) install.packages("knitr"); library(knitr)
if(!require(shinyjs)) install.packages("shinyjs"); library(shinyjs)
if(!require(ggplot2))install.packages("ggplot2"); library(ggplot2)

maxDemos <- 10
maxInfo <- 5

mydata <- NULL
data<- get(load("data/data.Rda"))
dontlook <- list()

demofiles <- paste0("demos/demo",1:maxDemos,".rmd")
ndemos <- sum(file.exists((demofiles)))

infofiles <- paste0("demos/info",1:maxInfo,".rmd")
ninfo <- sum(file.exists(infofiles))
files <- c(infofiles[1:ninfo],demofiles[1:ndemos])