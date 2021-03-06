#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(Biostrings)

    library(eisaR)

    library(GenomicFeatures)

    library(Rsamtools)
    
    rng <- getFeatureRanges(
        gtf = input$gtf,
        featureType = c("spliced", "intron"),
        intronType = "separate",
        flankLength = 90L,
        joinOverlappingIntrons = FALSE,
        verbose = TRUE
    )
    
    fas <- FaFile(input$fas)

    seq <- extractTranscriptSeqs(x = fas, transcripts = rng)

    writeXStringSet(seq, filepath = output$fas)

    exportToGtf(rng, filepath = output$gtf)

    write.table(x = metadata(rng)$corrgene, file = output$tsv[1], quote = FALSE, row.names = FALSE, col.names = TRUE, sep = "\t")

    getTx2Gene(rng, filepath = output$tsv[2])

}

main(snakemake@input, snakemake@output, snakemake@log)
