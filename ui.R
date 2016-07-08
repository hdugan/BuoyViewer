library(shiny)
library(rLakeAnalyzer)

# import data
met = read.csv('./Data/Sparkling2014met_hourly.csv',stringsAsFactors = F)
met$sampledate = strptime(met$sampledate,'%Y-%m-%d %H:%M:%S')
colnames(met) = c('Date','Air Temp','Relative Humidity','Wind Speed','PAR','Water Temp','Dissolved Oxygen')
buoy = read.csv('./Data/Sparkling2014wtemp_hourly_wide.csv',stringsAsFactors = F)
buoy$datetime = as.POSIXct(strptime(buoy$datetime,'%Y-%m-%d %H:%M:%S'))



# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel('Meteorological and Buoy Data Viewer'),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(position='left',
    sidebarPanel(
      selectInput("select",
                  label = h4("Select Met variable (y-axis)"), 
                  choices = colnames(met),selected='Air Temp'),
      selectInput("select2",
                  label = h4("Select Met variable (x-axis)"),
                  choices = colnames(met),selected='Relative Humidity')
    ),
    
    
    # # Show a plot of the generated distribution
    # mainPanel(
    #     plotOutput("Plot1",height = 300,
    #           dblclick = 'Plot1_dblclick',
    #           brush = brushOpts(id="Plot1_brush",
    #            resetOnNew = TRUE))
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Met Time Series",br(),'Choose y-axis variable for time series graph',
                           br(),'Drag box and double click to zoom in on graph', 
                           plotOutput("Plot1",height = 300,
                            dblclick = 'Plot1_dblclick',
                            brush = brushOpts(id="Plot1_brush",
                            resetOnNew = TRUE))),
                  tabPanel("Met Data Comparison",br(),'Choose two meterological variables', 
                           plotOutput("Plot3",height = 300)),
                  tabPanel("Water Temp", plotOutput("Plot2",height = 500))
                  
      )
    )
  )
)
)