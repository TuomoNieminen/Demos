
# Server logic
# the server handles:

# 1) execution of user inputted code

# 2016 Tuomo A Nieminen

library(shiny)

source("utilities.R")

shinyServer(function(input, output, session) {
  
  ex <- reactiveValues(cur=1,feedback = "",env = new.env(),results = NULL, total=0)
  util <- reactiveValues(active=1,curinfo=1)
  
  # demo data
  
  sample_data <- observe({
    # sample a personal dataset
    set.seed(input$student_id)
    sample <- data[sample(1:nrow(data),100),]
    
    # colnames based on theme choice
    colnames(sample) <- paste(input$theme,1:ncol(sample))
    mydata <<- sample
  })
  
  
  
  #  Demos
  
  # which nav is the active one and what is the current exercise
  active <- observe({
    cur_nav <- as.numeric(input$intro_nav)
    util$active <- cur_nav
    ex$cur <- cur_nav - ninfo
  },priority=0)
  
  
  
  # knit the demos
  knitDemos <- observe({
    trigger <- input$theme
    mapply(knit,demofiles,tmp_demos,MoreArgs=list(quiet=T))
  },priority=1)
  
  # check if the active demo is knitted
  demoKnitted <- reactive({
    file.exists(tmp_demos[ex$cur])
  })
  
  # render all infos
  for(i in 1:ninfo) {
    
    # render the active tmp_info
    output[[paste0("info",i)]] <- renderUI({
      withMathJax(includeMarkdown(tmp_infos[util$curinfo]))
    })
  }
  
  # render all demos
  for(d in 1:ndemos) {
    
    # render the active temp_demo if it is knitted
    output[[paste0("demo",d)]] <- renderUI({
      if(demoKnitted()) {
        withMathJax(includeMarkdown(tmp_demos[ex$cur]))
      }
    })
    
  }
  
  # code from user
  code <- reactive({
    tryCatch(parse(text=input[[paste0("code",ex$cur)]]),
             error=function(e) NULL)
  })
  
  # enviroments where to evaluate code inputs 
  envs <- lapply(1:ndemos,new.env)
  
  answer <- reactive({
    if(!is.null(code())) {
      testEval <- eval(code(),envir=envs[[ex$cur]])
      get0("ans",envir=envs[[ex$cur]],inherits=F)
    } else {NULL}
  })
  
  # user code input execution
  
  execute_code <- observeEvent(input[[paste0("execute",ex$cur)]], {
    
    type <- isolate(input[[paste0("codetype",ex$cur)]])
    code <- isolate(code())
    
    output[[paste0(type,ex$cur)]] <- switch(type,
                                            "plot" =  renderPlot({eval(code,
                                                                       envir=envs[[ex$cur]])}),
                                            "text" =  renderPrint({eval(code,
                                                                        envir=envs[[ex$cur]])})
    )
    
  })
  
  
  # give_feedback <-  observe({
  # 
  #   if(!is.null(answer())){
  #     print("found answer")
  #     correct <- do.call(dontlook[[ex$cur]],mydata)
  #     print(correct)
  #     results <-  checkAnswer(answer(), correct)
  #     ex$total <- ex$total + results$points
  #     ex$feedback <- results$feedback
  #   } else {ex$feedback <- NULL}
  # 
  # })
  # 
  # give feedback
  for(f in 1:ndemos) {
    output[[paste0("feedback",f)]] <- renderText({
      ex$feedback})
  }
  
  
  # cleanup on exit
  onSessionEnd <- session$onSessionEnded(function() {
    nfiles <- ndemos + ninfo
    do.call(file.remove,list(list.files("figure",full.names = T)))
    tryCatch(do.call(file.remove,
                     list(paste0("tmp_demo",1:ndemos,".md"))), 
             error=function(e) silent(NULL))
    tryCatch(do.call(file.remove,
                     list(paste0("tmp_info",1:ninfo,".md"))), 
             error=function(e) silent(NULL))
    
  })
  
})
