## ui.R ##
shinyUI(fluidPage(
  tabsetPanel(
    tabPanel("Introduction",
             verbatimTextOutput("summary"),
             imageOutput("image")),
    
    # creating interactive tab
    tabPanel("Analysis",
             # Title of Interactive Summary
             titlePanel("Meteorological Data Analysis"),
             
             # Sidebar with a checklist input to choose between weather stations
             sidebarLayout(
               sidebarPanel(
                 # Weather station input
                 selectInput("Station",
                             "Choose Weather Station:",
                             choices = c(unique(data$Source_Station),"All Stations")),
             
                 # Date range input
                 dateRangeInput("daterange1",
                                "Date Range:",
                                start = min(data$date),
                                end = max(data$date),
                                min = min(data$date),
                                max = max(data$date)),
                 
                 # Variable input
                 selectInput("Variable",
                             "Choose Variable:",
                             choices = c(colnames(data %>%
                                                    select(where(is.numeric))))),
                 # Colour input
                 selectInput("colour",
                             "Colour of Plot:",
                             list('colour' = c("blue","black","red", "green")))),
               
             
            # mainpanel for plots and summary
            mainPanel(
              plotOutput("ts_plot"),
              tableOutput("stats")
                )
              ),
            ),        
    
    # creating data tab
    tabPanel("Data",
             # Title of Data tab
             titlePanel("Met Data Table"),
             fluidRow(
               column(12,
                      dataTableOutput('table'))
             )
               
          )
       )
    )
)