# Klysman Rezende
# 19/02/2021
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  titlePanel(img(src="boxplot.png", height=200, width=200)),
  sidebarLayout(
    sidebarPanel(
      div(h2("My Shiny App - Klysman"), style="color:purple"),
      selectInput("dist", label = "Tipo de distribuicao", 
                  choices = list("Normal" = 1, "Exponencial" = 2), 
                  selected = 1),
      radioButtons("radio", label="Sample size",
                   choices=list("50"=50, "100"=100, "200"=200, "300"=300),
                   selected=50),
      sliderInput("Slider", label = "Largura de Banda", min = 0, 
                  max = 10, value = 0.5, step = 0.1),
      selectInput("kernel", label = "Kernel", 
                  choices = list("Gaussiann"="gaussian", "Epanechnikov"="epanechnikov",
                                 "Rectangular"="rectangular", "Triangular"="triangular",
                                 "Biweight"="biweight", "Cosine"="cosine",
                                 "Optcosine"="optcosine"), 
                  selected = 1)
      ),
    mainPanel(h3("Resultado"),
              br(),
              plotOutput("grafico"))
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  output$grafico <- renderPlot({
    if (input$dist==1){x <- rnorm(input$radio)} else {x <- rexp(input$radio)}
    hist(x, freq=F, main="Densidade ajustada", col="light blue")
    rug(x, lwd=2)
    lines(density(x, bw=input$Slider, kernel=input$kernel), lwd=2, col="red")
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

