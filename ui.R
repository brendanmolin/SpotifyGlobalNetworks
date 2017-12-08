ui <- fluidPage(
  mainPanel(
    visNetworkOutput("network"),
    tableOutput("shiny_return")
  )#, 
#  sidebarPanel(
#     htmlOutput("inc")
#  )
)