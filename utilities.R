
checkAnswer <- function(ans, correct_ans) {
  correct <- tryCatch(isTRUE(all.equal(ans,correct_ans)) | all(ans == correct_ans),
                      error=function(e) FALSE)
  feedback <-   ifelse(correct,
                       correctFeedback(),
                       incorrectFeedback()
  )
  return(list(points = correct, feedback = feedback))  
}

correctFeedback <- function() {
  paste0("<div class = 'intro-feedback correct'>",
         sample(correct_msg,1),
         "</div>")
}

incorrectFeedback <- function(answer) {
  paste("<div class = 'intro-feedback incorrect'>",
        sample(incorrect_msg,1),
        "</div>"
  )
}

correct_msg<-c("Correct! Good job. :)",
               "That's correct, well played! :)",
               "Well done, nice! :)")

incorrect_msg <- c("Sorry, that's not it. :(",
                   "Sorry, not quite what was asked. :(",
                   "Sorry, not exactly what we were after. :(")