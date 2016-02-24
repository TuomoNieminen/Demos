

getData <- function(theme = "Social sciences", student_id = 123456) {
  set.seed(student_id)
  
  n <- 100
  
  X <- round(abs(rnorm(n=n,mean=5,sd=2)),2)
  Y <- sample(1:5, n,replace = TRUE,
              prob=c(0.15,0.2,0.3,0.2,0.15))
  Y <- factor(Y,labels = c("very_low","low","medium","high","very_high"))
  
  l <- 1 + 2*X - as.numeric(Y) + rnorm(n)
  l <- abs(l)
  Z <- rpois(n,l)
  
  G <- sample(c(0,1),n,replace=TRUE)
  
  data <- data.frame(X,Y,Z,G)
  nc <- ncol(data)
  col_names <- switch(theme,
                      "Social sciences" = paste0("soc",1:nc),
                      "Biology" = paste0("bio",1:nc),
                      "Natural sciences" = paste0("natur",1:nc),
                      "Medicine" = paste0("med",1:nc)
  )
  colnames(data) <- col_names
  
  data
}