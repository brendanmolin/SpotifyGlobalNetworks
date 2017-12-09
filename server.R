server <- function(input, output, session) {
  
  # Selects track to show and play
  track <- reactive(sample_track(input$current_edge_id, g, track_country_colocation, track_country_data))
  
  # Generates Outputs
  output$network <- renderVisNetwork({
    visIgraph(g, idToLabel = TRUE) %>% 
      visEvents(selectEdge = 
                  "function(properties) {Shiny.onInputChange('current_edge_id', properties.edges);}")
  })
  
  output$shiny_return <- renderTable({
    if(!is.null(input$current_edge_id)) {
      track()[,1:3]
    } else {
      "Choose an edge to sample a song!"
    }
  })
  
  output$music <- renderUI({
    tags$audio(src = track()[,4], type = "audio/mp3", autoplay = NA, controls = NA)
  })
  
}
