
library(shiny)
library(shinyjs)

shinyServer(function(input, output, session) {
  
  ##############################################################
  #
  # new_answer function
  #
  # no input
  # output : a list of three algae
  ##############################################################
  
  new_answer <- function(){
    
    #select a new algae
    answer <<- sample(list_algae_names, 1, replace = TRUE)
    
    #Generate other answers
    other_answers <<- sample(list_algae_names[!list_algae_names %in% answer], 2)
    
    #randomize the answers including the right one and 2 random ones
    all_possibilities <<- sample(c(answer, other_answers), 3)
    
  }
  
  ##############################################################
  #
  # start the game
  #
  ##############################################################
  
  show_example <- eventReactive(input$start_button, {
    "To play the game, identify the algae in the photo on
    the left and pick the right answer underneath. 
    
    For example here, the answer is 'Bryopsis hypnoides' 
    Then click 'Check your answer' to see if you've got 
    it right! 
    
    Click 'Next' to got to the next one. 
    
    Have fun!"
  })
  
  
  start_game <- observeEvent(input$start_button, {
    
    removeUI(selector = '#start_button')
    example <- c("Bryopsis hypnoides", "Fucus vesicolusus", "Himanthalia elongata")
    answer <<- "Bryopsis hypnoides"
    insertUI(selector = '#placeholder3', ui = radioButtons("reponse",
                                                           "Select the correct answer", 
                                                           choices = example, 
                                                           selected = NULL,
                                                           inline = FALSE, 
                                                           width = NULL))
    insertUI(selector = '#placeholder1', ui = actionButton('next_button', "Next"))
    insertUI(selector = '#placeholder2', ui = actionButton("check_button", "Check your answer"))
    
    #Generate the image
    output$myImage <- renderImage({
      
      list(src = paste("./www/Bryopsis hypnoides.gif", sep = ""), contentType = 'image/gif',
           width = 200,
           height = 200,
           alt = "This is alternate text")
      
    }, deleteFile = FALSE)
    
  })
  
  
  ##############################################################
  #
  # End the game and display results
  #
  ##############################################################
  
  display_stats <- eventReactive(input$end_button, {
    paste("Thanks for playing! 
          You recognized", number_succeeded, "algae out of", number_of_tries, "! =)=)
          Awesome job!
          Play again soon!
          
          Snowalker")
  })
  
  ##############################################################
  #
  # check if the answer is correct
  #
  ##############################################################
  
  display_result <- eventReactive(input$check_button, {
    print("displayres")
    if(input$reponse == answer){
      
      #increment number of succeeded attempts
      number_succeeded <<- number_succeeded + 1
      
      #set the text to display
      text_to_display <<- sample(success_messages, 1)
      
    }else{
      
      #set the text to display
      text_to_display <<- sample(failure_messages, 1)
    }
    text_to_display
  })
  
  
  ##############################################################
  #
  # Display the image to identify
  #
  ##############################################################
  
  
  generate_question <- function(){
    
    if(number_of_tries == 0){
      removeUI(selector = '#example')
    }
    
    print("generate_question")
    new_answer()
    
    #increment the number of tries
    number_of_tries <<- number_of_tries + 1
    
    #update the radiobutton
    updateRadioButtons(session, "reponse",
                       choices = all_possibilities
    )
    
    #Generate the image
    output$myImage <- renderImage({
      
      list(src = paste("./www/", answer, ".gif", sep = ""), contentType = 'image/gif',
           width = 200,
           height = 200,
           alt = "This is alternate text")
      
    }, deleteFile = FALSE)
    
  }
  
  ##############################################################
  #
  # Load next question
  #
  ##############################################################
  
  nextquestion <- observeEvent(input$next_button, {
    print("nextquestion")
    generate_question()
    
  })
  
  ##############################################################
  #
  # Outputs
  #
  ##############################################################
  
  
  #Generate the logo image
  output$myImage <- renderImage({
    
    list(src = paste("./www/startlogo.gif", sep = ""), contentType = 'image/gif',
         width = 200,
         height = 200,
         alt = "This is alternate text")
    
  }, deleteFile = FALSE)
  print("imageok")
  
  #start a game
  output$reponse <- renderUI({
    start_game()
  })
  print("start_game")
  
  #Show the example
  output$example <- renderText({
    show_example()
  })
  
  #Display the result
  output$check_result <- renderText({
    display_result()
  })
  
  print("displayresok")
  
  #show the stats of the player
  output$stat_text <- renderText({
    display_stats()
  })
  print("statsok")
  })