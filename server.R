library(shiny)
library(rLakeAnalyzer)

# import data
met = read.csv('./Data/Sparkling2014met_hourly.csv',stringsAsFactors = F)
met$sampledate = strptime(met$sampledate,'%Y-%m-%d %H:%M:%S')
colnames(met) = c('Date','Air Temp','Relative Humidity','Wind Speed','PAR','Water Temp','Dissolved Oxygen')
buoy = read.csv('./Data/Sparkling2014wtemp_hourly_wide.csv',stringsAsFactors = F)
buoy$datetime = as.POSIXct(strptime(buoy$datetime,'%Y-%m-%d %H:%M:%S'))


# Define server logic required to draw a histogram
shinyServer(function(input,output) {
  # Single zoomable plot (on left)
  ranges <- reactiveValues(x = NULL, y = NULL)
  
  # The expression is wrapped in a call to renderPlot to indicate that:
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  output$Plot1 <- renderPlot({
    #selected y axis variable
    var1 = met[,which(names(met)==input$select)]
    par(mar=c(2.5,2.5,1,1),mgp=c(1.5,0.5,0),tck=-0.02)
    plot(met$Date,var1,type='l',xlim = ranges$x, ylim = ranges$y,
         ylab=input$select,xlab='Date',col='red3',xaxt='n')
    axis(1,pretty(c(par('usr')[1:2])),format(as.POSIXct(pretty(par('usr')[1:2]),
              origin = '1970-01-01 00:00:00 UTC'),'%b-%d'))
  })
  
  output$Plot3 <- renderPlot({
    #selected y axis variable
    var1 = met[,which(names(met)==input$select)]
    var2 = met[,which(names(met)==input$select2)]
    par(mar=c(2.5,2.5,1,1),mgp=c(1.5,0.5,0),tck=-0.02)
    plot(var2,var1,type='p',
         ylab=input$select,xlab=input$select2,col='red3')
    })
  
  output$Plot2 <- renderPlot({
    wtr.heat.map(buoy) 
  })
  
  # When a double-click happens, check if there's a brush on the plot.
  # If so, zoom to the brush bounds; if not, reset the zoom.
  observeEvent(input$Plot1_dblclick, {
    brush <- input$Plot1_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })

})