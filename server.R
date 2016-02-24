# Introstat exercises - type 2

# Server logic
# the server handles:

# 1) execution of user inputted code

# 2016 Tuomo A Nieminen

library(shiny)

source("utilities.R")

shinyServer(function(input, output,session) {
  
  ex <- reactiveValues(active=1,results = NULL, total=0)
  
  # demo data
  
  # set seed
  seed <- observe({
    set.seed(input$student_id)
  })
  
  # sample a personal dataset
  sampled_data <- reactive({
    mydata <<- data[sample(1:nrow(data),100),]
    mydata
  })
  
  # set colnames based on theme choice
  col_names <- observe({
    names <- paste(input$theme,1:ncol(sampled_data()))
    colnames(mydata) <- names
    colnames(data) <- names
  })
  
  
  #  Demos
  
  # active demo
  active <- observe({
    ex$active <- as.numeric(input$demonav)
  })
  
  # filepath to knit the active demo to
  demofilepath <- reactive({
    paste0("knitted/demo",ex$active,".md")
  })
  
  # knit the active demo
  knitDemo <- observe({
    knit(rmdfiles[ex$active], output=demofilepath(),quiet = T)
  })
  
  # render all demos
  
  for(d in 1:ndemos) {
    
    output[[paste0("demo",d)]] <- renderUI({
      if(file.exists(demofilepath())) {
      withMathJax(includeMarkdown(demofilepath()))
      }
    })
  }
  
  
  # React to the code inputs
  
  code <- reactive({
    tryCatch(parse(text=input$code),error=function(e) NULL)
  })
  
  answer <- reactive({
    testEnv <- new.env()
    testEval <- eval(code(),env=testEnv)
    get0("ans",testEnv,inherits=F)
  })
  
  observeEvent(input$execute, {
    
    # execute the code
    type <- isolate(input$codetype)
    code <- isolate(code())
    output[[type]] <- switch(type,
                             "plot" =  renderPlot({eval(code,envir=.GlobalEnv)}),
                             "text" =  renderPrint({eval(code,envir=.GlobalEnv)})
    )  
  })
  
  # check answer
  answer_feedback <- eventReactive(input$execute,{
    
    if(!is.null(answer())){
      results <-  checkAnswer(answer(), dontlook[[ex$cur]])
      ex$total <- ex$total + results$points
      feedback <- results$feedback
    } else {
      feedback <- ""
    }  
    feedback
  })
  
  # give feedback
  output$feedback <- renderText({answer_feedback()})
  
})
