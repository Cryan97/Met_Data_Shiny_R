## server.r 
shinyServer(function(input,output) {

##### Outputs
# summary text for Introduction tab
output$summary <- renderText({paste("This app is based on daily Met Data collected",
                                    "from 3 weather stations in Ireland for.",
                                    "the years 2021 and 2022. There are two tabs",
                                    "which can be accessed through the app.","\n",
                                    "Firstly, an interactive analysis tab which can be used to",
                                    "produce time-series plots of a chosen meteorological",
                                    "variable of interest for chosen location and daterange.",
                                    "High level descriptive statistics are shown for the chosen",
                                    "variable, location and date-range below the plot.","\n",
                                    "Secondly, there is a data tab which displays the underlying",
                                    "data corresponding to the various filters chosen.",
                                    "The Met Eireann image is not mine",sep = "\n")})

# image for Introduction tab
output$image <- renderImage({
  list(src = './OG-icon.jpg',width = "50%", height = "50%")},
  deleteFile = FALSE)

# output data table
# data is filtered for location and date-range
output$table <- renderDataTable({
    if (input$Station == "All Stations") {
      data %>% filter(date >= input$daterange1[1],
                      date <= input$daterange1[2])
    } else {
      data %>% filter(Source_Station == input$Station,
                      date >= input$daterange1[1],
                      date <= input$daterange1[2])
    }
  })

# output time-series plot of variable of choice
# data is filtered for location and date-range
output$ts_plot <- renderPlot({
  if (input$Station == "All Stations") {
    plot_data <- data %>% filter(date >= input$daterange1[1],
                    date <= input$daterange1[2]) %>% 
                  select(date,input$Variable)%>% 
                  rename(y = input$Variable)
                  
  } else {
    plot_data <- data %>% filter(Source_Station == input$Station,
                  date >= input$daterange1[1],
                  date <= input$daterange1[2]) %>% 
                  select(date,input$Variable) %>% 
                  rename(y = input$Variable)
  }
  ggplot(plot_data,aes(x = date,y = y)) +
    geom_line(col = input$colour, size = 1) +
    scale_x_date(limits = c(input$daterange1[1],input$daterange1[2])) +
    ggtitle(label = str_to_title(paste0(input$Variable," - ",input$Station))) +
    xlab("Date") +
    ylab(str_to_title(input$Variable)) +
    theme(plot.title = element_text(hjust = 0.5,
                                    size = 20,
                                    vjust = 0.5),
          axis.title = element_text(size = 15))
})

# output descriptive stats for variable of choice
# data is filtered for location and date-range
output$stats <- renderTable({
              tibble::enframe(
                      if (input$Station == "All Stations") {
                        summary(data %>%
                          filter(date >= input$daterange1[1],
                                 date <= input$daterange1[2]) %>%
                          select(input$Variable))
                      } else {
                        summary(data %>%
                          filter(Source_Station == input$Station, 
                                 date >= input$daterange1[1],
                                 date <= input$daterange1[2]) %>%
                          select(input$Variable))
                      },
                      name = str_to_title(paste0(input$Variable,
                                                 " - Summary")),
                      value = "Statistic")
  })
})
