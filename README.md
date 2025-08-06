# PCR Primer Tm Calculator with Mutagenesis Option

This is my first publicly shared project on GitHub: a simple Shiny web application for calculating the melting temperature (Tm) of DNA primer sequences. The application includes an optional correction for site-directed mutagenesis by allowing users to enter the number of mismatched nucleotides.

The idea for this project emerged while I was working on a previous research project that involved designing mutagenic primers for a QuikChange mutagenesis experiment. To simplify the process of calculating GC content and Tm for the primers I designed, I initially wrote a few basic R scripts. Later, I decided to turn those scripts into a user-friendly Shiny web application. This tool now supports both standard and mutagenic primers, offering a flexible interface for Tm calculation that accounts for the application of mutagenesis.

You can try the app here:  
👉 [PrimerTmApp on shinyapps.io](https://rumeysaaksu.shinyapps.io/primertmapp/)

## Tm Formula Used

```
Tm = 81.5 + 0.41(%GC) - 675/N - (% mismatch)
```

- **%GC**: Percentage of G and C bases in the primer  
- **N**: Total length of the primer  
- **% mismatch**: (Number of mismatches / N) * 100 (only applied if mutagenesis is selected)

## Features

- Input primer sequence (5' → 3')
- See calculated GC content and primer length
- Optional checkbox for site-directed mutagenesis
- Enter the number of mismatched nucleotides
- Final Tm value calculated and displayed based on selected parameters


## Author

Created by Rümeysa Aksu  
MSc in Bioinformatics and Systems Biology


