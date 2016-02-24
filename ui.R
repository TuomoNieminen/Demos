# Introstat exercises - type 2

# UI logic
# the user interface includes:

# 0) A initialization page
# 1) A wellcome tab
# 2) A playground tab where the user can 'play' with R
# 3) Exercise tabs, which include the actual exercises

# 2016 Tuomo A Nieminen

library(shiny)

shinyUI(fluidPage(
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  
  
  # initialization (student ID and theme choice)
  
  conditionalPanel(condition = "(input.start+ input.back)%2==0",
                   br(),br(),
                   
                   div(class="intro-init-wrap",
                       div(class="intro-init-content",
                           p("Please fill in the information below."),
                           p("(Leave as is for testing)"),
                           hr(),
                           numericInput("student_id",
                                        label ="Your student ID",
                                        value = 123456789),
                           br(),
                           selectInput("theme", label = "Choose your interest",
                                       choices = list("Social sciences"="Soc",
                                                      "Natural sciences"="Nat",
                                                      "Biology"="Bio",
                                                      "Medicine"="Med"),
                                       selected = "Soc"
                           ),
                           br(),
                           actionButton("start","Ok, I'm ready!"),
                           br()
                       ))
  ),
  #wrapper
  div(class="intro-wrapper",
      
      # The rest of the UI (shown only after initialization)  
      conditionalPanel(condition="(input.start + input.back)%2 != 0",
                       
                       
                       
                       
                       
                       br(),
                       div(class="intro-nav-btn",actionButton("back", "Home")),
                       br(),
                       
                       do.call(navlistPanel,
                               
                               #arguments
                               c(list(id="demonav",widths=c(3,9)),
                                      
                               #demos       
                                      list("Demos"),
                               
                                      lapply(1:ndemos, function(d) {
                                        name <- paste0("demo",d)
                                        tabPanel(name,uiOutput(name),value=d)
                                      }))),
                               #source("playground.R", local=T)$value
                               
                               
                               
                               div(id="intro-footer",
                                   p("@hy Tuomo A. Nieminen"),
                                   p("tuomo.a.nieminen (at) helsinki (dot) fi")
                               )
                               
                               
                       ))
      
      
  ))