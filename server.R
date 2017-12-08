server <- function(input, output, session) {
  output$network <- renderVisNetwork({
    visIgraph(g, idToLabel = TRUE) %>% 
#      visOptions(highlightNearest = TRUE) %>%
      visEvents(selectEdge = 
"function(properties) {Shiny.onInputChange('current_edge_id', properties.edges);}")
  })
  
  output$shiny_return <- renderTable({
    if(!is.null(input$current_edge_id)) {
      sample_track(input$current_edge_id)
    } else {
      "Choose an edge to sample a song!"
    }
  })
}
