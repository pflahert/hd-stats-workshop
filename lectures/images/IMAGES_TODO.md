# Missing Images for Lecture 1 Slides

`lecture1-slides.qmd` references 8 image files that do not yet exist in this directory. Until they're supplied, the rendered slide deck (`_output/lectures/lecture1-slides.html` and the Beamer PDF) will display 8 broken-image placeholders.

Lectures 2–4 generate all their figures from executable Python code, so they don't depend on this directory.

## Inventory

| # | Filename | Source line | Width | What this should depict |
|---|---|---|---|---|
| 1 | `caspi-2003-title.png` | L19 | 85% | Title page / first page of Caspi et al. 2003, *Science* — "Influence of life stress on depression: moderation by a polymorphism in the 5-HTT gene." |
| 2 | `caspi-2003-fig2.png` | L29 | 80% | Caspi et al. 2003, **Figure 2** — the gene-environment interaction plot showing depression risk by 5-HTTLPR genotype × stressful life events. |
| 3 | `border-2019-title.png` | L55 | 85% | Title page of Border et al. 2019, *American Journal of Psychiatry* — "No support for historical candidate gene or candidate gene-by-interaction hypotheses for major depression across multiple large samples." |
| 4 | `border-2019-fig.png` | L67 | 80% | A figure / table from Border et al. 2019 summarizing the null results across 18 candidate genes. (The paper's Table 2 or Figure 2 are good options.) |
| 5 | `golub-1999-title.png` | L101 | 85% | Title page of Golub et al. 1999, *Science* — "Molecular classification of cancer: class discovery and class prediction by gene expression monitoring." |
| 6 | `pval-histogram-pathologies.png` | L270 | 90% | A multi-panel figure illustrating well-behaved vs. pathological *p*-value histograms (uniform, anti-conservative, U-shaped, spike at 1, etc.). Could come from Breheny's diagnostic note or be drawn yourself. |
| 7 | `dead-salmon-poster.png` | L351 | 80% | Bennett et al. 2009 — the famous "dead salmon fMRI" poster ("Neural correlates of interspecies perspective taking in the post-mortem Atlantic salmon"). Often distributed online; verify license before publishing. |
| 8 | `dead-salmon-activation.png` | L367 | 75% | The activation map showing spurious "brain activity" in the dead salmon under uncorrected statistics — the punchline figure from Bennett et al. |

## How to source

- **Title pages** (caspi-2003, border-2019, golub-1999): screenshot the journal PDF's first page, crop to title block + abstract, save as PNG.
- **Figures from papers**: screenshot directly. Most journals allow figures to be reused for educational/non-commercial purposes; check each journal's reuse policy or use figures with explicit Creative Commons licenses.
- **Dead-salmon poster**: Bennett, Baird, Miller & Wolford 2009/2010 — the poster image circulates widely; the *Journal of Serendipitous and Unexpected Results* publication is open-access.
- **P-value histogram pathologies**: easiest to **draw your own** with matplotlib (4 panels: uniform / spike-at-zero / U-shape / anti-conservative). Lower license friction than reusing a figure from a paper.

## Once you supply them

Place each PNG in this directory with the exact filename above. No code changes needed — `lecture1-slides.qmd` already references them by relative path. Re-render with `make html` (and `make pdf` for the Beamer slide deck).

If you'd rather replace a reference with a textual placeholder (e.g., for an image you can't get for licensing reasons), edit `lectures/lecture1-slides.qmd` and replace the `![](images/...)` line with prose like:

```markdown
::: {.center}
**[FIGURE: Caspi et al. 2003 — gene-environment interaction]**
:::
```
