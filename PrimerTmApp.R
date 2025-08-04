# Install required packages in R:

install.packages("shiny")
install.packages("shinythemes")
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("Biostrings")

library(shiny)
library(Biostrings)
library(shinythemes)

ui <- fluidPage(
  theme = shinytheme("cerulean"),
  
  tags$head(
    tags$style(HTML("      
      #main_title {
        background-color: #e3f2fd;
        padding: 15px;
        border-radius: 10px;
        text-align: center;
        font-weight: bold;
        font-size: 28px;
        margin-bottom: 20px;
      }
      #sub_title {
        font-size: 20px;
        font-weight: bold;
        margin-top: 20px;
        margin-bottom: 10px;
      }
      .form-control {
        font-family: monospace;
      }
    "))
  ),
  
  div(id = "main_title", "PCR Primer Tm Calculator with Mutagenesis Option"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("primer", "Primer sequence (5'→3'):", value = "GACTTGCTTAGACATAGGTATATAGTAAGT"),
      numericInput("mismatches", "Number of mismatched nucleotides:", value = 0, min = 0),
      checkboxInput("mutagenesis", "Is this for site-directed mutagenesis?", value = FALSE),
      helpText("Note: Only A, T, G, and C characters are allowed. Tm is adjusted if mutagenesis is selected.")
    ),
    
    mainPanel(
      div(id = "sub_title", "Sequence Properties"),
      verbatimTextOutput("seq_info"),
      tags$hr(),
      div(id = "sub_title", "Melting Temperature (Tm)"),
      p("Tm = 81.5 + 0.41(%GC) - 675/N - % mismatch"),
      verbatimTextOutput("tm_result")
    )
  )
)

server <- function(input, output) {
  
  calc_seq_info <- reactive({
    seq <- toupper(input$primer)
    if (!all(strsplit(seq, "")[[1]] %in% c("A", "T", "G", "C"))) {
      return(list(error = TRUE, msg = "ERROR: Primer must contain only A, T, G, or C."))
    }
    
    myseq <- DNAString(seq)
    N <- length(myseq)
    GC <- sum(letterFrequency(myseq, letters = c("G", "C")))
    return(list(error = FALSE, sequence = seq, length = N, gc = GC))
  })
  
  output$seq_info <- renderText({
    info <- calc_seq_info()
    if (info$error) return(info$msg)
    paste0("Sequence: ", info$sequence, "\nLength (N): ", info$length, "\nGC Count: ", info$gc)
  })
  
  output$tm_result <- renderText({
    info <- calc_seq_info()
    if (info$error) return("")
    
    N <- info$length
    GC <- info$gc
    mismatch_correction <- if (input$mutagenesis) (input$mismatches / N) * 100 else 0
    
    Tm <- 81.5 + 0.41 * ((GC / N) * 100) - (675 / N) - mismatch_correction
    paste0("Calculated Tm: ", round(Tm, 2), " °C")
  })
}

shinyApp(ui = ui, server = server)
