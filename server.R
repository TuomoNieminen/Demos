# Introstat exercises - type 2

# Server logic
# the server handles:

# 1) execution of user inputted code

# 2016 Tuomo A Nieminen

library(shiny)

source("utilities.R")

shinyServer(function(input, output,session) {
  
  ex <- reactiveValues(results = NULL, cur = 1, total=0)
  
  # demo data  
  
  demo_data <- reactive({
    data <- getData(input$theme,input$student_id)
    mydata <<- data
    data
  })
  
  # ei toimi
  observeEvent(input[["start"]], {
    attach(mydata, pos=2, warn.conflicts = F)
    })
  
  # navigation
  
  observeEvent(input[["next"]], {
    cur <- ex$cur +1
    ex$cur <- min(length(rmdfiles), cur)
  })
  
  observeEvent(input[["prev"]],{
    cur <- ex$cur -1
    ex$cur <- max(1, cur)
  })
  
  # single demo
  # move to ui and use sapply + do.call
  demoUI <- reactive({
    trigger <- demo_data()
    knit(rmdfiles[[ex$cur]], quiet = T)
    withMathJax(includeMarkdown(paste0("demo",ex$cur,".md")))
  })
  output$demo <- renderUI({
    demoUI()
  })
  
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
                             "table" = renderTable({eval(code,envir=.GlobalEnv)}),
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
