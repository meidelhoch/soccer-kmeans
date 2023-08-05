




knitr::opts_chunk$set(echo = TRUE, 
                      size = "small", 
                      collapse = TRUE, 
                      comment = NA, 
                      warning = FALSE, 
                      message = FALSE,
                      error = TRUE,
                      eval = TRUE) # change it to TRUE

# Install necessary packages
# install.packages(c("shiny", "shinythemes", "shinyWidgets", "leaflet", "tidyverse", "janitor", "DT", "maps", "maptools", "sp"))

library(shiny)
library(shinythemes)
library(shinyWidgets)
library(leaflet)
library(tidyverse)
library(janitor)
library(DT)
library(maps)
library(maptools)
library(sp)
library(tidyverse)
library(purrr)
library(rvest)
library(polite)
library(readr)
library(plotly)
library(fmsb)
library(purrr)
library(broom)
library(factoextra)
library(ggthemes)
library(ragg)
library(plotly)
library(ggradar)
library(scales)



#Read in data
player_data <- read_csv("final_data.csv")
gk_data <- read_csv("gk_data_qualified.csv")
fw_kmeans <- read_csv("fw_for_kmeans.csv")
mf_kmeans <- read_csv("mf_for_kmeans.csv")
df_kmeans <- read_csv("df_for_kmeans.csv")

#filter data as needed for graph
graph_data_selected <- player_data %>% select(c(1:6, 9, 11, 12, 19, 30, 51, 61, 53, 54, 55, 39:42))
standardize <- function(x, na.rm = FALSE) {
  (x - mean(x, na.rm = na.rm)) / sd(x, na.rm = na.rm)
}


# creating our app below

# Define the UI
ui <- navbarPage(
  theme = shinytheme("flatly"),
  "Final",
  windowTitle = "Final",
  tabPanel(
    "Description",
    fluidRow(
      column(12, align = "center", uiOutput('markdown'), mainPanel(h1("A Mapping Guide to International Soccer"), h4("Marc Eidelhoch and Piper Dean"), p("Across the world, there are five major soccer leagues that dominate international soccer. The Premier League in England, La Liga in Spain, Ligue 1 in France, Serie A in Italy and Bundesliga in Germany are the leagues that are comprised of the top international soccer players and amass a large share of the revenue in professional soccer. In order to make it in these leagues, players must continue to improve throughout their careers. Every game, statistics are taken on all aspect of a player's performance. Goals, assists, pass percentages, tackles and more are then used to analyze which players should play. For this data exploration, all the data is scraped from the website FBREF.com and contains statistics on every player from the 2022-2023 season. The data was cleaned to 75 variables and filtered to include players that played in at least 8 games this past season. Throughout the tabs of this app, the user can compare their favorite players, leagues and teams through an analytical lens.")))
    )
  ),
  tabPanel(
    "Graph",
    fluidRow(
      column(
        2,
        wellPanel(
          selectInput(
            "x_variable",
            label = "Select X Variable",
            choices = colnames(graph_data_selected),
            selected = colnames(graph_data_selected)[1]
          ),
          selectInput(
            "y_variable",
            label = "Select Y Variable",
            choices = colnames(graph_data_selected),
            selected = colnames(graph_data_selected)[2]
          ), 
          radioButtons(
            "team",
            "Choose League to project:",
            choices = c("La Liga", "Premier League", "Serie A", "Bundesliga", "Ligue 1")
          ),
          checkboxInput("color","Check to see Position Break Down")
        )
      ),
      column(
        10,
        plotlyOutput(outputId = "graph", height = "600px")
      )
    )
  ),
  tabPanel(
    "Radar",
    fluidRow(
      column(
        2,
        wellPanel(
          selectInput(
            "player1_radar",
            label = "Select Player 1:",
            choices = player_data$name
          ),
          selectInput(
            "player2_radar",
            label = "Select Player 2:",
            choices = player_data$name
          )
        )
      ),
      column(
        10,
        plotOutput(outputId = "radar", height = "600px")
      )
    )
  ),
  tabPanel(
    "K Means Forwards",
    fluidRow(
      column(
        2,
        wellPanel(
          selectInput(inputId = "player", label = "Select a player: ", choices = fw_kmeans$name)
        )
      ),
      column(
        10,
        DTOutput(outputId = "kmeans_fw")
      )
    )
  ), 
  
  tabPanel(
    "K Means Midfielders",
    fluidRow(
      column(
        2,
        wellPanel(
          selectInput(inputId = "player2", label = "Select a player: ", choices = mf_kmeans$name)
        )
      ),
      column(
        10,
        DTOutput(outputId = "kmeans_mf")
      )
    )
  ),
  
  tabPanel(
    "K Means Defenders",
    fluidRow(
      column(
        2,
        wellPanel(
          selectInput(inputId = "player3", label = "Select a player: ", choices = df_kmeans$name)
        )
      ),
      column(
        10,
        DTOutput(outputId = "kmeans_df")
      )
    )
  )
)
# Define the server logic
server <- function(input, output) {
  #creat reactive data
  graph_data1 <- reactive({
    graph_data_selected %>% filter(league == input$team)
  })
  #create graph output
  output$graph <- renderPlotly({
    if (input$color) {
      p <- ggplot(graph_data1(), aes(x = !!sym(input$x_variable), y = !!sym(input$y_variable), color = position, label = name, text = paste("Position", position, "\n", "Age", age, "\n", "Nationality", nation, "\n"))) +
        geom_point()
      p
    } else {
      q <- ggplot(graph_data1(), aes(x = !!sym(input$x_variable), y = !!sym(input$y_variable), label = name, text = paste("Position", position, "\n", "Age", age, "\n", "Nationality", nation, "\n"))) +
        geom_point()
      q
    }
      
    
  })
  
  #Create radar graphs
  output$radar <- renderPlot({
    
    rescaled_data <- player_data %>% mutate(across(where(is.numeric), rescale))
    
    ggradar(rescaled_data %>% filter(name == input$player1_radar | name == input$player2_radar) %>% 
              select(c(1, 24,25,38,54,58,61)), 
              grid.max = 1, centre.y = 0, fill = TRUE, fill.alpha = .5,
              group.point.size = 3, label.centre.y = FALSE, label.gridline.min = FALSE, 
              label.gridline.mid = FALSE, label.gridline.max = FALSE, plot.legend = TRUE, 
              gridline.min.linetype = "dashed", gridline.mid.linetype = "dashed", 
              gridline.max.linetype = "dashed", gridline.min.colour = "grey", 
              gridline.mid.colour = "grey", gridline.max.colour = "grey", axis.label.offset = 1,
              axis.label.size = 4)
      
  })
  
  #create Kmeans table for forwards 
  output$kmeans_fw <- renderDataTable({
    player_1 <- fw_kmeans %>% filter(name == input$player)
    grouped1 <- fw_kmeans %>% filter(fwd_group == player_1$fwd_group[[1]])
    datatable(grouped1 %>% select(c(1:6, ncol(grouped1))))
  })
  #create Kmeans table for midfielders
  output$kmeans_mf <- renderDataTable({
    player_2 <- mf_kmeans %>% filter(name == input$player2)
    grouped2 <- mf_kmeans %>% filter(mf_group == player_2$mf_group[[1]])
    datatable(grouped2 %>% select(c(1:6, ncol(grouped2))))
  })
  #create Kmeans table for defenders
  output$kmeans_df <- renderDataTable({
    player_3 <- df_kmeans %>% filter(name == input$player3)
    grouped3 <- df_kmeans %>% filter(df_group == player_3$df_group[[1]])
    datatable(grouped3 %>% select(c(1:6, ncol(grouped3))))
  })
  
  
}
#run app.
app <-shinyApp(ui = ui, server = server)
app