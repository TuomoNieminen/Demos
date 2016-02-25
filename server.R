# Introstat exercises - type 2

# Server logic
# the server handles:

# 1) execution of user inputted code

# 2016 Tuomo A Nieminen

library(shiny)

source("utilities.R")

shinyServer(function(input, output, session) {
  
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
  
  # which nav is the active one
  active <- observe({
    ex$active <- as.numeric(input$intro_nav)
  },priority=0)
  
  # filepath where to knit the active file
  filepath <- reactive({
    paste0("knitted/file",ex$active,".md")
  })
  
  # knit the active file
  knitFile <- observe({
    knit(files[ex$active], output=filepath(),quiet = T)
  },priority=1)
  
  # check if the active file is knitted
  isKnitted <- reactive({
    file.exists(filepath())
  })
  
  # render all infos
  for(i in 1:ninfo) {
    
    # render the active demo md if it is knitted
    output[[paste0("info",i)]] <- renderUI({
      if(isKnitted()) {
        withMathJax(includeMarkdown(filepath()))
      }
    })
  }
  
  # render all demos
  for(d in 1:ndemos) {
    
    # render the active demo md if it is knitted
    output[[paste0("demo",d)]] <- renderUI({
      if(isKnitted()) {
        withMathJax(includeMarkdown(filepath()))
      }
    })
  }
  
  # render welcome
  
  # output[["welcome"]] <- renderUI({
  #   welcomepath <- "knitted/welcome.md"
  #   knit("demos/welcome.rmd",output=welcomepath)
  #   if(file.exists(welcomepath)) {
  #     withMathJax(includeMarkdown(welcomepath))
  #   }
  # })

  
  
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
  
  # cleanup on exit
  
  onSessionEnded <- session$onSessionEnded(function() {
    do.call(file.remove,list(list.files("figure",full.names = T)))
    do.call(file.remove,list(list.files("knitted",full.names = T)))
  })
  
})
