
# app.R
library(shiny)
library(tidyverse)
library(lubridate)

ui <- fluidPage(
  titlePanel(div(
    img(src = "logo.png", height = "80px"), br(),
    "Tableau de bord – Collecte de données à Lomé"
  )),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Suivi quotidien de la collecte."),
      dateRangeInput("dateRange", "Plage de dates", 
                     start = as.Date("2025-04-10"), end = as.Date("2025-04-20")),
      selectInput("quartier", "Choisir un quartier", 
                  choices = c("Tous", "Tokoin", "Bè-Kpota", "Adidogomé"), selected = "Tous")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Vue d’ensemble", verbatimTextOutput("resume")),
        tabPanel("Taux de réponse", plotOutput("plot1")),
        tabPanel("Ménages enquêtés", plotOutput("plot2")),
        tabPanel("Femmes et enfants", plotOutput("plot3")),
        tabPanel("Détail quotidien", tableOutput("tableau"))
      )
    )
  )
)

server <- function(input, output) {
  data_file <- "data_collecte_vierge.csv"
  if (file.exists(data_file)) {
    raw_data <- read_csv(data_file, show_col_types = FALSE) %>%
      mutate(
        date = as.Date(date),
        menages_enquetes = as.numeric(menages_enquetes),
        menages_visites = as.numeric(menages_visites),
        taux_reponse = round(100 * menages_enquetes / menages_visites, 1)
      )
  } else {
    raw_data <- tibble(
      date = seq(from = as.Date("2025-04-10"), to = as.Date("2025-04-20"), by = "day"),
      equipe = rep(c("Équipe A", "Équipe B", "Équipe C"), length.out = 11),
      quartier = rep(c("Tokoin", "Bè-Kpota", "Adidogomé"), length.out = 11),
      grappe = sample(1:10, 11, replace = TRUE),
      menages_cibles = 30,
      menages_visites = sample(25:30, 11, replace = TRUE),
      menages_enquetes = sample(20:30, 11, replace = TRUE),
      femmes_enqu = sample(15:28, 11, replace = TRUE),
      enfants_enqu = sample(5:15, 11, replace = TRUE)
    ) %>%
    mutate(taux_reponse = round(100 * menages_enquetes / menages_visites, 1))
  }

  data_collecte <- reactive({
    req(input$dateRange, input$quartier)
    raw_data %>%
      filter(date >= input$dateRange[1], date <= input$dateRange[2]) %>%
      filter(quartier == input$quartier | input$quartier == "Tous")
  })
  
  output$resume <- renderPrint({
    req(data_collecte())
    data_collecte() %>%
      summarise(
        total_menages = sum(menages_enquetes),
        total_femmes = sum(femmes_enqu),
        total_enfants = sum(enfants_enqu),
        taux_moyen_reponse = mean(taux_reponse)
      )
  })
  
  output$plot1 <- renderPlot({
    req(data_collecte())
    data_collecte() %>%
      group_by(quartier) %>%
      summarise(taux_moyen = mean(taux_reponse)) %>%
      ggplot(aes(x = quartier, y = taux_moyen)) +
      geom_col() +
      labs(title = "Taux moyen de réponse par quartier", y = "Taux (%)", x = "") +
      ylim(0, 100)
  })
  
  output$plot2 <- renderPlot({
    req(data_collecte())
    ggplot(data_collecte(), aes(x = date, y = menages_enquetes, fill = equipe)) +
      geom_col() +
      labs(title = "Nombre de ménages enquêtés par jour", y = "Ménages enquêtés", x = "Date")
  })
  
  output$plot3 <- renderPlot({
    req(data_collecte())
    collecte_long <- data_collecte() %>%
      pivot_longer(cols = c(femmes_enqu, enfants_enqu), names_to = "groupe", values_to = "n")
    
    ggplot(collecte_long, aes(x = date, y = n, fill = groupe)) +
      geom_col(position = "dodge") +
      labs(title = "Nombre de femmes et enfants enquêtés", y = "Nombre", x = "Date")
  })
  
  output$tableau <- renderTable({
    req(data_collecte())
    data_collecte()
  })
}

shinyApp(ui = ui, server = server)
