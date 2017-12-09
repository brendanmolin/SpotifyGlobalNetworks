ui <-
  fluidPage(
    headerPanel("Global Music Network"),
    tags$div(class="header", checked=NA,
             tags$p(paste0("This graphic shows the similarity in musical taste between countries.  Spotify generates playlists for many cities across the world, specifically highlighting unique songs being listened to there. We aggregated the data by country and built a network of shared songs. To learn how the analysis was done, "),
             a(href="shiny.rstudio.com/tutorial", "Click Here!"))
    ),
    mainPanel(
      visNetworkOutput("network"),
      tableOutput("shiny_return"),
      uiOutput('music'),
      tags$div(class="header", checked=NA,
               tags$a(href="shiny.rstudio.com/tutorial", "About the Author")
      )
    )
  )