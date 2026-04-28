#!/usr/bin/env Rscript
# Export the ALL dataset from Bioconductor to CSV files for Python labs.
# Run once: Rscript data/export_all.R
# Requires: BiocManager::install("ALL")

library(ALL)
data(ALL)

# Expression matrix: genes (rows) x samples (columns)
expr <- as.data.frame(exprs(ALL))
write.csv(expr, "data/all_expression.csv", row.names = TRUE)

# Metadata: one row per sample
meta <- data.frame(
  sample_id = sampleNames(ALL),
  BT = ALL$BT,
  subtype = ifelse(grepl("^B", ALL$BT), "B", "T"),
  stringsAsFactors = FALSE
)
write.csv(meta, "data/all_metadata.csv", row.names = FALSE)

cat("Exported", nrow(expr), "genes x", ncol(expr), "samples\n")
cat("Metadata:", nrow(meta), "rows\n")
cat("B-cell:", sum(meta$subtype == "B"), " T-cell:", sum(meta$subtype == "T"), "\n")
