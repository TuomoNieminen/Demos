# 2016 Tuomo A Nieminen

# UI for The Playground
# the playground user interface includes:

# 1) text area for inputting code
# 2) radio buttons to choose the type of output
# 3) output as text, plot or table


get_playGround <- function(i) {
  div(class="intro-playground",
      
      # code input
      div(tags$textarea(id=paste0("code",i),
                        rows=5, cols=90,
                        "# write any (R) code here \n \n")),
      
      # code type choice, execution btn, feedback
      
      fluidRow(
        column(2,          
               # code execution
               actionButton(paste0("execute",i),"Go!")
        ),
        column(4,
               # code type
               radioButtons(paste0("codetype",i),
                            label = "Choose output type",
                            choices = list("basic" = "text",
                                           "plot" = "plot"),
                            selected = "text")
        ),
        
        column(6,
               br(),
               htmlOutput(paste0("feedback",i))
        )
      ),
      
      # output
      
      conditionalPanel(
        condition=paste0("input.codetype",i,"=='text'"),
        verbatimTextOutput(paste0("text",i))
      ),
      conditionalPanel(
        condition=paste0("input.codetype",i,"=='plot'"),
        plotOutput(paste0("plot",i))
      )
      
  )
}


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