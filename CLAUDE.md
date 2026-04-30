# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Two-day graduate workshop (May 2026) teaching statistical methods for high-dimensional biological data (p >> n). Covers multiple testing/FDR control, dimension reduction, and penalized regression, with AI-integrated learning and critical evaluation.

## Build Commands

```bash
make              # Full build (HTML + PDF)
make html         # Render full website
make preview      # Live preview with auto-reload

make lectures     # Render lecture notes / slide decks as HTML
make slides       # Render lecture1-slides as Reveal.js HTML
make docs         # Render syllabus, assessments, decision guide as HTML

make pdf          # Render all PDFs
make lectures-pdf # Lecture notes/decks as PDF (printable handouts)
make slides-pdf   # lecture1-slides as Beamer PDF
make docs-pdf     # Syllabus/assessments as PDF

make data         # Export Golub + ALL dataset CSVs (requires Bioconductor)

make clean        # Remove all output
make clean-pdf    # Remove PDF output only
```

Primary tool is Quarto (≥1.4). Output goes to `_output/`. PDFs go to `_pdf/`. Local Jupyter kernel for Python execution is named `hd-stats` (set via `jupyter: hd-stats` in `_quarto.yml`).

## Directory Structure

```
hd-stats-workshop/
├── _quarto.yml           # Quarto website config, navbar, project-level jupyter kernel
├── CLAUDE.md
├── README.md             # Instructor-facing teaching guide
├── Makefile
├── index.qmd             # Syllabus / landing page
├── syllabus/
│   ├── course-design.qmd # UbD framework (enduring understandings, assessment design, lecture plan)
│   └── decision-guide.qmd # Mermaid flowcharts for method selection
├── lectures/
│   ├── images/           # Slide image assets (see IMAGES_TODO.md for missing files)
│   ├── lecture-outlines.md # Master outline at three levels of detail
│   ├── lecture1.qmd      # Essay: "The Gene That Wasn't There" (HTML article + PDF)
│   ├── lecture1-slides.qmd # Reveal.js slide deck for Lecture 1 (image-driven)
│   ├── lecture2.qmd      # Essay: "The Histogram That Was Too Wide" (HTML article + PDF)
│   ├── lecture2-slides.qmd # Reveal.js slide deck for Lecture 2
│   ├── lecture3.qmd      # Essay: "The Map That Drew Itself" (HTML article + PDF)
│   ├── lecture3-slides.qmd # Reveal.js slide deck for Lecture 3
│   ├── lecture4.qmd      # Essay: "Seventy Genes and a Fraud" (HTML article + PDF)
│   └── lecture4-slides.qmd # Reveal.js slide deck for Lecture 4
├── assessments/
│   ├── pre-homework.qmd  # HTML/PDF web reference for pre-workshop assignment
│   └── homework.qmd      # HTML/PDF web reference for Day 1→Day 2 assignment
├── notebooks/
│   ├── pre-homework.ipynb # Colab assignment (Python kernel)
│   ├── homework.ipynb     # Colab assignment (R kernel — uses limma + qvalue)
│   ├── lab1.ipynb        # Lab 1: The Multiple Testing Problem
│   ├── lab2.ipynb        # Lab 2: FDR in Practice
│   ├── lab3.ipynb        # Lab 3: Dimension Reduction
│   └── lab4.ipynb        # Lab 4: Penalized Regression
└── data/
    ├── golub_expression.csv # 3,051 genes × 72 samples (Golub 1999, ALL vs. AML)
    ├── golub_metadata.csv   # 72 samples with class labels
    ├── all_expression.csv   # 12,624 genes × 128 samples (Bioconductor ALL)
    ├── all_metadata.csv     # 128 samples with B-cell / T-cell labels
    ├── export_all.R         # Exports both Golub and full ALL CSVs
    └── README.md            # Data documentation
```

## Content Architecture

Every lecture has **both** an essay and a slide deck:

- **Essays** (`lecture{1,2,3,4}.qmd`): HTML article + PDF, classic-academic prose with inline DOI links to primary sources. The essay is the readable, citable form of the lecture content. No live code in essays.
- **Slide decks** (`lecture{1,2,3,4}-slides.qmd`): Reveal.js. Lecture 1 slides are image-driven with speaker notes; lectures 2/3/4 slides combine on-slide narrative with executable Python code that generates figures live via the `hd-stats` kernel.

**Assessments and labs** follow a dual-form pattern:
- `assessments/*.qmd` — readable HTML/PDF web reference.
- `notebooks/*.ipynb` — interactive Colab version where students actually do the work. Linked from the navbar with a "(Colab)" suffix and from the top of each `.qmd` via a callout box.

**Labs** (`notebooks/lab1.ipynb`–`lab4.ipynb`): Python Colab notebooks; zero-install for students; structure: setup → write code → use AI → critique checklist.

### Learning Outcomes

- **LO1**: Multiple testing, FDR control, empirical Bayes
- **LO2**: Dimension reduction (PCA/UMAP), penalized regression (ridge/LASSO/elastic net)
- **LO3**: Critical evaluation of analysis code and AI-generated output

## Code Conventions

- **Lecture essays** (`lecture{1,2,3,4}.qmd`): pure prose, no executable code; cite primary sources inline as `[Author (year)](https://doi.org/...)`.
- **Lecture 1 slides** (`lecture1-slides.qmd`): image-driven; `code-fold: true` in Reveal.js settings. No live code execution.
- **Lectures 2–4 slides** (`lecture{2,3,4}-slides.qmd`): mix of on-slide narrative + executable Python (`{python}` blocks with `echo: true`). Figures render live during build via the `hd-stats` Jupyter kernel.
- **Labs** (Python notebooks): `numpy.random.seed(2026)` for reproducibility; `plt.style.use('seaborn-v0_8-whitegrid')` for plots; data loaded from Zenodo or GitHub raw URLs.
- **Homework notebook** (R kernel): uses `limma` + `qvalue` (Bioconductor); data loaded from GitHub raw URLs.

## Key Datasets and Packages

- **Golub dataset**: 3,051 genes × 72 samples, ALL vs. AML leukemia.
  - Source: Golub et al. (1999), *Science*; archived on Zenodo (DOI: 10.5281/zenodo.8123245).
  - Local exports: `data/golub_expression.csv`, `data/golub_metadata.csv`.
  - Loaded by labs from GitHub raw URLs: `https://raw.githubusercontent.com/pflahert/hd-stats-workshop/main/data/`.
- **ALL dataset**: 12,624 genes × 128 samples, B-cell vs. T-cell ALL.
  - Source: Bioconductor `ALL` package.
  - Local exports: `data/all_expression.csv`, `data/all_metadata.csv`.
- Both produced by `data/export_all.R` (run via `make data`; requires Bioconductor `ALL` + `multtest`).
- **Python** (labs, lectures 2–4): scipy, statsmodels, scikit-learn, umap-learn, matplotlib, seaborn, pandas, numpy.
- **R** (homework, optional local): limma, qvalue, glmnet, tidyverse, ggplot2, pheatmap, Rtsne, uwot.

## AI Integration Philosophy

Every lab uses AI explicitly. Students prompt AI, evaluate output, and catch errors. Labs include deliberately subtle errors for students to identify. Assessment focuses on understanding what AI produces, not just using it.

## Editing Guidelines

- For every lecture: the essay (`lecture{N}.qmd`) is the canonical text and cites primary sources. The slide deck (`lecture{N}-slides.qmd`) is the in-class delivery form. When the science changes, update the essay first; sync the slides afterwards.
- For assessments: edit the `.qmd` and the corresponding `.ipynb` in lockstep — they should stay in sync.
- Preserve narrative flow — each lecture tells a story with an anchor paper/finding.
- Keep visual emphasis (p-value histograms, scree plots, biplots).
- Slide image placeholders use `lectures/images/` — see `IMAGES_TODO.md` for the current list of missing files.
- Update `_quarto.yml` navbar if adding new documents (and add a Colab link if the new doc has a paired `.ipynb`).
- Decision guide uses Mermaid flowcharts — test rendering after edits.
- Slides have speaker notes accessible via Reveal.js speaker view (press 'S').
- Do not commit `_output/`, `.quarto/`, `_pdf/`, or `*.quarto_ipynb*` artifacts.

## Distribution model

- **Source on GitHub**: `pflahert/hd-stats-workshop`.
- **Website**: served from GitHub Pages via `quarto publish gh-pages`.
- **Labs and assessments**: distributed as `.ipynb` opened by students directly in **Google Colab** (URLs of the form `colab.research.google.com/github/pflahert/hd-stats-workshop/blob/main/notebooks/<file>.ipynb`).
- **Alternative**: students may upload the same `.ipynb` files to UMass Harmony or any other Jupyter-capable platform.
