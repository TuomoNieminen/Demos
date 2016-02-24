
#
maxDemos <- 10

#packages
if(!require(knitr)) install.packages("knitr"); library(knitr)
if(!require(shinyjs)) install.packages("shinyjs"); library(shinyjs)
if(!require(ggplot2))install.packages("ggplot2"); library(ggplot2)

source("demo_data.R")
mydata <- getData()
dontlook <- list()

rmdfiles <- paste0("demos/demo",1:maxDemos,".rmd")

