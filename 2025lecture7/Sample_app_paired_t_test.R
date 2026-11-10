#
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

    # Application title
    titlePanel("Paired t-test 解熱剤シミュレーション"),

    # Sidebar with a slider input  
    sidebarLayout(
        sidebarPanel(
            sliderInput("SampleSize",
                        "個体数:",
                        min = 3,
                        max = 100,
                        value = 10),
            sliderInput("maemean",
                        "投与前の値℃:",
                        min = 30,
                        max = 50,
                        value = 39),
            sliderInput("atomean",
                        "投与後の値℃:",
                        min = 37.0,
                        max = 39.0,
                        value = 38,step=0.1),
            sliderInput("mysd",
                        "標準偏差:",
                        min = 0.1,
                        max = 2,
                        value = 1,step=0.1)
        ),
        # Sidebar with a slider input  
               
        # Show a plot of the generated 
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate simulated data based on input$* from ui.R
        pvalues<-vector() #  a vector to store p values
        for (i in 1:10000){
            mae<-rnorm(input$SampleSize,mean=input$maemean,sd=input$mysd) # 
            ato<-rnorm(input$SampleSize,mean=input$atomean,sd=input$mysd) #
            pvalues<-c(pvalues,t.test(ato,mae,paired=T,alternative = "less")$p.value)
        }
        # draw the histogram with the specified number of bins
        par(family = "UD デジタル 教科書体 NK-B")
        hist(pvalues, breaks = 100, col = 'darkgray', border = 'white',xlim=c(0,1),main="p値の分布")
        text(x=0.8,y=200,paste("0.05以下の数: ",sum(pvalues<0.05)))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
