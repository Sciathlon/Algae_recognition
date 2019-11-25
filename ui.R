
##############################################################
#
# Load libraries
#
##############################################################

library(shiny)
library(shinyjs)

##############################################################
#
# Initialize variables and load game parameters
#
##############################################################

number_of_tries <<- 0
number_succeeded <<- 0
macroalgae <- c("Himanthalia elongata", "Pelvetia canaliculata", "Fucus serratus", "Fucus vesicolusus", 
                "Bryopsis plumosa", "Bryopsis hypnoides")
list_algae_names <<- macroalgae

success_messages <<- c("Congrats, you did it!", "Good job=)", "Nice!", "Right on!", "You got it!", "Success=)")
failure_messages <<- c("Wrong one, sorry!", "Well, you tried^^", "Woops! Not that one!", "Try again=p")

##############################################################
#
# Functions
#
##############################################################



##############################################################

shinyUI(fluidPage(
  
  ##############################################################
  #
  # Image side
  #
  ##############################################################
  
  pageWithSidebar(
    headerPanel("Can you recognize your algae? 
                Let's find out!"),
    sidebarPanel(
      imageOutput("myImage"),
      tags$div(id = 'placeholder3'),
      tags$div(id = 'placeholder2'),
      tags$div(id = 'placeholder1'),
      actionButton("start_button", "Start"),
      actionButton("end_button", "End")
    ),
    mainPanel(
      verbatimTextOutput("check_result"),
      verbatimTextOutput("stat_text"),
      verbatimTextOutput("bidule"),
      verbatimTextOutput("example")
    )
    )
)
)