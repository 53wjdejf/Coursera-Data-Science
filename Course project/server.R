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

s3 <- shinyServer(function(input, output) {
        output$distPlot <- renderPlot({
                x    <- na.omit(outcome[ , input$diseases])
                bins <- seq(min(x), max(x), length.out = input$bins + 1)
                hist(x, breaks = bins, col = 'darkgray', border = 'white',
                     main = paste("Hospital 30-Day Death Rates from", input$diseases,"in USA"))
                mx   <- mean(x)
                lines(c(mx, mx), c(0, 6000),col="blue",lwd=3)
                text(12, 250, paste("National mean = ", round(mx,2)))
        })

        output$distPlot2 <- renderPlot({
                local <- outcome[,2]==input$states
                x    <- na.omit(outcome[ , input$diseases])
                y    <- na.omit(outcome[local , input$diseases])
                bins <- seq(min(y), max(y), length.out = input$bins + 1)
                hist(y, breaks = bins, col = 'darkgray', border = 'white',
                     main = paste("Hospital 30-Day Death Rates from", input$diseases, "in", input$states))
                mx   <- mean(x)
                my   <- mean(y)
                lines(c(mx, mx), c(0, 200),col="blue",lwd=3)
                lines(c(my, my), c(0, 200),col="red",lwd=3)
        })
        output$dTable <- renderDataTable({
                local <- outcome[,2]==input$states
                outcome[local, ]
        })
})
