library(shiny)
library(markdown)

outcome <- read.csv("data/outcome.csv", colClasses = "character")
outcome <- as.data.frame(outcome[,c(2,7,11,17,23)])
colnames(outcome) <- c("hospital.Name", "states", "Heart Attack", "Heart Failure", "Pneumonia")
for(i in 3:5){
        outcome[,i] <- as.numeric(outcome[,i])
}
#Hospital 30-Day Death (Mortality) Rates from Heart Attack, Heart Failure, Pneumonia

states <- unique(outcome[,2])

i3 <- shinyUI(
        navbarPage("The hospital quality of USA",
                   tabPanel("Datasets",
                            sidebarPanel(
                                    sliderInput("bins",
                                                "Number of bins:",
                                                min = 1,
                                                max = 50,
                                                value = 30),
                                    selectInput("states", "States:", list(states=states)),
                                    radioButtons("diseases", "Diseases:",
                                                 c("Heart Attack" = "Heart Attack",
                                                   "Heart Failure" = "Heart Failure",
                                                   "Pneumonia" = "Pneumonia"))
                            ),
                            mainPanel(
                                    tabsetPanel(
                                            tabPanel(p(icon("bar-chart"), "Graph"),
                                                     plotOutput("distPlot"),
                                                     plotOutput("distPlot2")
                                            ),
                                            tabPanel(p(icon("table"), "Table"),
                                                     dataTableOutput(outputId="dTable")
                                            )
                                    ))),
                   tabPanel("About",
                            mainPanel(
                                    includeMarkdown("README.md")
                            )
                   )))
