# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Two-day graduate workshop (May 2026) teaching statistical methods for high-dimensional biological data (p >> n). Covers multiple testing/FDR control, dimension reduction, and penalized regression, with AI-integrated learning and critical evaluation.

## Build Commands

```bash
make              # Full build (HTML + PDF)
make html         # Render full website
make preview      # Live preview with auto-reload

make lectures     # Render lecture notes (essays) as HTML
make slides       # Render slide decks (Reveal.js) as HTML
make docs         # Render syllabus, assessments, decision guide as HTML

make pdf          # Render all PDFs
make lectures-pdf # Lecture notes as PDF (for printing/reading)
make slides-pdf   # Slide decks as Beamer PDF
make docs-pdf     # Syllabus/assessments as PDF

make data         # Export ALL dataset CSVs (requires Bioconductor)

make clean        # Remove all output
make clean-pdf    # Remove PDF output only
```

Primary tool is Quarto (≥1.4). Output goes to `_output/`. PDFs go to `_pdf/`.

## Directory Structure

```
hd-stats-workshop/
├── _quarto.yml           # Quarto website config, navbar
├── CLAUDE.md
├── Makefile
├── index.qmd             # Syllabus / landing page
├── syllabus/
│   ├── course-design.qmd # UbD framework (enduring understandings, assessment design, lecture plan)
│   └── decision-guide.qmd # Mermaid flowcharts for method selection
├── lectures/
│   ├── images/           # Slide image assets
│   ├── lecture-outlines.md # Master outline at three levels of detail
│   ├── lecture1.qmd      # Essay: "The Gene That Wasn't There"
│   ├── lecture1-slides.qmd # Reveal.js slides for Lecture 1
│   ├── lecture2.qmd      # Slides: "The Histogram That Was Too Wide"
│   ├── lecture3.qmd      # Slides: "The Map That Drew Itself"
│   └── lecture4.qmd      # Slides: "Seventy Genes and a Fraud"
├── assessments/
│   ├── pre-homework.qmd  # Pre-workshop review & software check
│   └── homework.qmd      # Day 1 → Day 2 homework
├── notebooks/
│   ├── lab1.ipynb        # Lab 1: The Multiple Testing Problem (Colab)
│   ├── lab2.ipynb        # Lab 2: FDR in Practice (Colab)
│   ├── lab3.ipynb        # Lab 3: Dimension Reduction (Colab)
│   └── lab4.ipynb        # Lab 4: Penalized Regression (Colab)
└── data/
    ├── all_expression.csv # 12,625 genes × 128 samples
    ├── all_metadata.csv   # 128 samples with subtype labels
    ├── export_all.R       # Bioconductor export script
    └── README.md          # Data documentation
```

## Content Architecture

Each lecture exists as **two Quarto files** plus a **Colab notebook**:

- **Lecture notes** (`lectures/lecture1.qmd`): The primary artifact. Essay-style prose written in a story-driven, first-principles voice (Matt Levine style). These are the speaking notes — the instructor reads/delivers the essay while the slides provide visual support. Rendered as HTML articles.
- **Slides** (`lectures/lecture1-slides.qmd`): Visual scaffold for the lecture. Mostly images (paper titles, key figures, data visualizations) with sparse text. The full essay text lives in Reveal.js speaker notes (`::: {.notes}`). Code is `echo: false`; students see figures, not code.
- **Labs** (`notebooks/lab1.ipynb`): Python Colab notebooks. The primary lab format — zero-install, runs in browser. Follow structure: setup → write code → use AI → critique checklist.

### Learning Outcomes

- **LO1**: Multiple testing, FDR control, empirical Bayes
- **LO2**: Dimension reduction (PCA/UMAP), penalized regression (ridge/LASSO/elastic net)
- **LO3**: Critical evaluation of analysis code and AI-generated output

## Code Conventions

- Lecture notes and slides use R code blocks with Quarto syntax: `#| label:`, `#| fig-height:`, etc.
- Lecture notes: no executable code (pure prose)
- Slides: `echo: false` — students see figures and outputs, not code. Code in speaker notes for instructor reference.
- Labs (Python notebooks): `numpy.random.seed(2026)` for reproducibility. `plt.style.use('seaborn-v0_8-whitegrid')` for consistent plots.
- Labs follow structure: setup → write code → use AI → critique checklist

## Key Datasets and Packages

- **ALL dataset**: 12,625 genes × 128 samples, B-cell vs. T-cell leukemia
  - Source: Bioconductor `ALL` package (exported to `data/all_expression.csv` and `data/all_metadata.csv`)
  - Labs load from GitHub raw URL: `https://raw.githubusercontent.com/pflahert/hd-stats-workshop/main/data/`
- **Python** (labs): scipy, statsmodels, scikit-learn, umap-learn, matplotlib, seaborn, pandas, numpy
- **R** (slides only): limma, qvalue, glmnet, tidyverse, ggplot2, pheatmap, Rtsne, uwot

## AI Integration Philosophy

Every lab uses AI explicitly. Students prompt AI, evaluate output, and catch errors. Labs include deliberately subtle errors for students to identify. Assessment focuses on understanding what AI produces, not just using it.

## Editing Guidelines

- The essay (lecture notes) is the source of truth. Modify the essay first, then update slides and lab notebook to match.
- Preserve narrative flow — each lecture tells a story with an anchor paper/finding
- Keep visual emphasis (p-value histograms, scree plots, biplots)
- Slide image placeholders use `lectures/images/` directory — see `lecture1-slides.qmd` for the pattern
- Update `_quarto.yml` navbar if adding new documents
- Decision guide uses Mermaid flowcharts — test rendering after edits
- Slides have speaker notes accessible via Reveal.js speaker view (press 'S')
- Do not commit `_output/`, `.quarto/`, or `_pdf/` directories
