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
                                       choices = list("Social sciences",
                                                      "Natural sciences",
                                                      "Biology",
                                                      "Medicine"),
                                       selected = "Social sciences"
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
                       
                       div(class="intro-demo",
                           
                           div(class="intro-nav",
                               
                               br(),
                               div(class="intro-nav-btn",actionButton("back", "Home")),
                               div(class="intro-nav-btn",actionButton("prev", "Previous")),
                               div(class="intro-nav-btn",actionButton("next", "Next")),div(style="clear:both;"),
                               br()
                           ),
                           
                           uiOutput("demo"),
                           source("playground.R", local=T)$value
                           

                       ),
                       
                       div(id="intro-footer",
                           p("@hy Tuomo A. Nieminen"),
                           p("tuomo.a.nieminen (at) helsinki (dot) fi")
                       )
                       
                       
      )
  )
  
  
))