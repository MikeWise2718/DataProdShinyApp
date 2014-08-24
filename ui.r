# 
# A rather silly app (ui) to fulfill the Data Products shiny app requirement
# Mike Wise - 25 Aug 2014 - dataprod-004
#
# To run ensure that a ui.r and a server.r are in the directory
# and the shiny library is installed and loaded into the session
# with "library(shiny)"
# then change to that directory in R-studio 
# and invoke the function "runApp()" or
# runGitHub("DataProdProject","MikeWise2718")
#
shinyUI(
  pageWithSidebar(
  #  
  headerPanel("Demo of Variability of Std.Dev vs. Mean"),
  sidebarPanel(
    numericInput('niter', 'Iterations', 1000, min = 10, max = 10000, step = 10),
   # selectInput("dist","Distribtion", c("Normal","Uniform","LogNormal"),multiple=F),
    sliderInput('mu', 'Mean',value = 0, min = -10, max = 10, step = 1),
    sliderInput('std', 'Std',value = 4, min = 1, max = 10, step = 0.5),
    sliderInput('nsamp', 'Samples per iteration',value = 3, min = 1, max = 30, step = 1),
    checkboxGroupInput("guides", "Checkbox",
                       c("Pop Value (red)" = "pop",
                         "Mean value (blue)" = "mean",
                         "Median value (green)" = "med"),
                       selected = c("pop","mean","med")),
   h3("Purpose"),
   p("The purpose is to demonstrate the different behaviors of the variance and mean estimates especially under low sample conditions."),
   p(" - The red line marks the actual popluation value."),
   p(" - The blue line marks the mean value."),
   p(" - The green line marks the median value."),
   p("Note how much more seperated the values tend to be for low sample sizes for the std.dev..")
  ),
  mainPanel(
    plotOutput('stdplot'),
    plotOutput('muplot')
  )
))