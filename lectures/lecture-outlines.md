# Lecture Outlines: High-Dimensional Data Analysis Workshop

**Design principle**: Each lecture is a multi-part essay, not a textbook chapter. Real stories drive the statistics. The voice is engaged and first-principles — explaining the underlying logic rather than reciting results. Code appears only in speaker notes; students see figures and outputs on slides, then write code themselves in labs.

**Recurring motifs** (callbacks across all four lectures):

1. **"What does the histogram tell you?"** — p-value histogram (L1–L2), z-score distribution (L2), scree plot (L3), coefficient path (L4).
2. **"Would this replicate?"** — 5-HTTLPR didn't (L1). 64% of psychology didn't (L2). PCA artifacts replicate perfectly but mean nothing (L3). LASSO picks different genes on different bootstrap samples (L4).
3. **"What are you actually asking?"** — FWER vs. FDR (L1–L2). Visualization vs. classification (L3). Prediction vs. inference (L4).

---

## Level 1: Story Summaries

### Lecture 1: "The Gene That Wasn't There"

For fifteen years, the most-cited finding in psychiatric genetics was a serotonin transporter variant linked to depression. It had 8,000 citations. Then someone actually tested it in 38,000 people and found nothing. How does a false positive survive for fifteen years? Because the field was testing many hypotheses without accounting for how many they tested. Today, we'll see exactly how this happens — not in psychiatry, but in our own data. We'll take a leukemia dataset with 3,051 genes, test every one for a difference between cancer subtypes, and watch the false discovery problem unfold in a single histogram. That histogram will become your first diagnostic tool: it tells you whether there's signal, how much, and whether your analysis is trustworthy. By the end, you'll understand why Bonferroni controls the wrong error rate for discovery work, and why biologists needed a different framework.

### Lecture 2: "The Histogram That Was Too Wide"

Brad Efron looked at a histogram of 6,033 z-scores from a prostate cancer study and noticed something nobody else had: the middle was wider than it should have been. If no genes were differentially expressed, those z-scores should follow a standard normal curve. They didn't — the distribution was slightly inflated. This meant every p-value calculated from the theoretical null was wrong, and every FDR estimate based on those p-values was wrong too. Efron's fix was to estimate the null distribution from the data itself: most genes are null, so the bulk of the data tells you what "nothing" looks like. This idea — that ten thousand tests can teach you about the behavior of any single test — is the empirical Bayes insight, and it turns the multiple testing problem from a curse into a resource. Today we formalize what Lecture 1 showed visually: the Benjamini-Hochberg procedure, Storey's q-values, and Efron's two-groups model. The connecting thread is the histogram. It's not just a picture — it's an estimator.

### Lecture 3: "The Map That Drew Itself"

In the 1970s, Luca Cavalli-Sforza applied PCA to human gene frequencies across Europe and produced beautiful maps showing wave-like gradients radiating from the Near East. They looked exactly like what archaeologists had independently reconstructed: the spread of agriculture from the Fertile Crescent, 10,000 years ago. The biological story and the statistical story agreed. There was just one problem: in 2008, Novembre and Stephens showed that PCA produces those same wave patterns from any spatially distributed population data, whether or not any migration occurred. The maps were mathematical inevitabilities. This is the danger of dimension reduction: it always shows you structure, because that's what it does — the question is whether the structure is real. But dimension reduction can also genuinely reveal things nobody expected. When single-cell RNA sequencing produced 20,000 measurements per cell, UMAP projections showed dozens of cell types in tissues that biologists thought were uniform. The Allen Brain Cell Atlas cataloged over 5,000 transcriptionally distinct clusters. Some of those clusters are genuine discoveries; some may be artifacts of the method. This lecture is about learning to tell the difference.

### Lecture 4: "Seventy Genes and a Fraud"

Seventy percent of breast cancer patients who receive chemotherapy would have survived without it. In 2002, Laura van 't Veer used microarrays — 25,000 genes measured on 98 patients — to find a 70-gene signature that predicted which patients would develop metastases. The signature was commercialized as MammaPrint, cleared by the FDA, and validated in a 6,700-patient trial: 46% of high-risk patients were spared unnecessary chemotherapy. The data selected those 70 genes, not domain knowledge. At Duke University, Anil Potti did something similar: gene expression signatures that predicted which chemotherapy drug a tumor would respond to. Clinical trials enrolled patients based on these signatures. Two statisticians at MD Anderson spent years trying to reproduce the analysis and couldn't — mislabeled samples, systematic errors, irreproducible results. Eighteen papers were retracted. Patients had been assigned to treatments based on fraudulent models. MammaPrint and the Duke fraud are the same method applied to the same kind of data. One saved lives; the other put them at risk. The difference is validation, stability, and honesty about what a model built on 25,000 variables and 98 samples can actually tell you. Today we learn the tools — ridge, LASSO, elastic net — and the discipline required to use them responsibly.

---

## Level 2: Section-Level Outlines

### Lecture 1: "The Gene That Wasn't There"

#### 1.1 — The serotonin gene that wasn't

**Hook**: "In 2003, Avshalom Caspi published a paper in *Science* linking a serotonin transporter gene to depression under stress. It became one of the most-cited papers in psychiatry. Fifteen years later, a team tested the same hypothesis in 38,802 people and found nothing." Open from first principles: what does it mean to test a genetic hypothesis? You measure a variant, you measure an outcome, you check whether they're associated. One test, one p-value, one conclusion. Seems fine — until you realize nobody runs just one test.

**Statistical idea**: The logic of hypothesis testing — what a p-value is (and isn't), how a single test works, and why the machinery breaks when scaled up.

**Connection to next**: "But what happens when you don't test one gene — you test all of them?"

#### 1.2 — Three thousand and fifty-one tests

**Hook**: "Here's a leukemia dataset. 72 patients. Two types: ALL and AML. 3,051 genes measured per patient. You want to know which genes differ between the types. So you do what anyone would do — you test each one." Introduce the Golub dataset not as example data but as the experiment we're analyzing together for the entire workshop. Run a t-test for each gene. Get 3,051 p-values.

**Statistical idea**: The multiple testing problem from first principles. If each test has a 5% false positive rate and you run 3,051 independent tests, you expect ~153 false positives even when nothing is happening. The rate of false positives is fine; the *number* is not.

**Connection to next**: "Now let's look at what those 3,051 p-values look like."

#### 1.3 — Your first diagnostic: the p-value histogram

**Hook**: Show two histograms side by side — one from a pure-null simulation (uniform), one from the Golub data (spike near zero plus uniform bulk). "This is the single most useful plot in high-dimensional statistics." The shape tells you three things: (1) whether there's any signal at all, (2) roughly how much, and (3) whether your analysis has problems (anti-conservative = pile-up at zero beyond what's expected; conservative = dip near zero).

**Statistical idea**: Under the null, p-values are uniform. The excess near zero is signal. The height of the flat part estimates π₀, the proportion of true nulls. This is a visual introduction to the two-groups model that Lecture 2 will formalize.

**Connection to next**: "So there's signal. You want to find it. The obvious thing is to lower your threshold. That's exactly what Bonferroni does."

#### 1.4 — Bonferroni and family-wise error rate control

**Hook**: "The simplest fix: divide your significance level by the number of tests. 0.05 / 3,051 ≈ 1.6 × 10⁻⁵. Any gene with a p-value below that threshold, you call significant." Bonferroni controls the family-wise error rate — the probability of *any* false positive. In GWAS, the threshold is 5 × 10⁻⁸ because you're testing ~1 million variants.

**Statistical idea**: FWER control (Bonferroni, Šidák). The logic: if you want the probability of at least one false positive to be ≤ α, each test needs significance level α/m. Conservative because it controls the wrong thing for discovery — you don't care about "any error," you care about "what fraction of my discoveries are wrong."

**The "but" turn**: "Bonferroni controls error. But it controls the wrong error for discovery. If you're trying to find genes that differ between leukemia subtypes, you don't want zero false positives — you want a *manageable fraction* of false positives. That's a different question, and it needs a different answer."

**Connection to next**: "What does the dead salmon have to do with any of this?"

#### 1.5 — The dead salmon and the cost of not correcting

**Hook**: One slide. Craig Bennett put a dead Atlantic salmon in an fMRI scanner and asked it to determine the emotional valence of photographs. Without multiple testing correction, the salmon showed "brain activity." With correction, nothing. Published as a poster at a conference. The framing was memorable — but the underlying point was serious: 25–40% of fMRI studies at the time did not correct for multiple comparisons.

**Statistical idea**: Voxelwise testing (same problem as genewise testing, different domain). The dead salmon makes visceral what the math says abstractly. Brief mention of Bennett's survey of published fMRI work.

**Connection to next**: "The salmon is a memorable cautionary tale. Here is a case where the cost of failing to correct was substantially higher."

#### 1.6 — What a field-wide false positive looks like

**Hook**: Return to 5-HTTLPR. The Caspi 2003 paper spawned hundreds of replication attempts. Meta-analyses disagreed. In 2019, Border et al. tested 18 candidate gene hypotheses for depression in datasets of 62,000–443,000 people. None replicated. "The entire candidate gene literature for depression was, in effect, noise." Meanwhile, GWAS with proper multiple testing correction was finding real signals — hundreds of loci for depression at genome-wide significance. The fix was known the whole time; the field just didn't use it.

**Statistical idea**: Publication bias, winner's curse, the garden of forking paths. How false positives survive: selective reporting, underpowered replications, meta-analyses that aggregate biased estimates. Contrast with GWAS: same biology, different statistical framework, different results.

**End on the observation** (no summary slide): "The 5-HTTLPR story isn't a story about bad scientists. It's a story about what happens when a field's statistical framework doesn't match the scale of its questions. The framework exists. That's what we'll build in Lecture 2."

---

### Lecture 2: "The Histogram That Was Too Wide"

#### 2.1 — Benjamini and Hochberg ask the right question

**Hook**: "In 1995, Yoav Benjamini and Yosef Hochberg wrote a two-page paper that would eventually become one of the most cited papers in statistics. They asked a question nobody had formalized before: *of all the hypotheses I declare significant, what fraction are wrong?*" This is the false discovery rate. Lecture 1 showed why FWER is the wrong criterion for discovery. FDR is the criterion that matches the question.

**Statistical idea**: FDR definition — E[V/R] where V is false discoveries and R is total discoveries. The BH procedure: rank p-values, find the largest k where p_(k) ≤ (k/m)α. It controls FDR at level α under independence (and positive dependence). Walk through the procedure on the Golub dataset.

**The "but" turn**: "BH controls FDR. But it relies on knowing what the null looks like — specifically, that null p-values are uniform. What if they're not?"

**Connection to next**: "Which brings us to Brad Efron, looking at a histogram and noticing something everyone else missed."

#### 2.2 — Efron notices the null is wrong

**Hook**: "Brad Efron looked at a histogram of 6,033 z-scores from a prostate cancer microarray study and noticed something. The center of the distribution — the part that should be standard normal if the null hypothesis is true — was too wide." Show the histogram. Show N(0,1) overlaid. Show the discrepancy. "The theoretical null was wrong. Slightly, but wrong. And when you're making 6,000 decisions based on that null, 'slightly wrong' becomes 'substantially wrong.'"

**Statistical idea**: Theoretical vs. empirical null. Sources of null inflation: unmodeled correlations among genes, batch effects, subtle population structure. If the null z-scores are actually N(0, 1.2²) instead of N(0, 1), then the tails are heavier than expected, and you get too many small p-values — false signal.

**Connection to next**: "So the null is wrong. How do you fix it? You let the data tell you what the null looks like."

#### 2.3 — The two-groups model: let the data be its own control

**Hook**: "Here's Efron's insight. Most genes are null — they don't differ between conditions. So the bulk of the z-score distribution *is* the null. You don't need to assume N(0,1); you can estimate the null from the data." The mixture model: f(z) = π₀f₀(z) + (1-π₀)f₁(z). The null proportion π₀ and the null density f₀ are estimable from the center of the histogram.

**Statistical idea**: Two-groups model. Local false discovery rate: fdr(z) = π₀f₀(z)/f(z) — the probability that a specific gene is null, given its z-score. This is the Bayesian turn: from "procedure controls a rate" to "each gene has a probability of being null." Estimation: central matching (fit a Gaussian to the middle of the histogram) or MLE on the mixture.

**Connection to next**: "This idea — that thousands of tests teach you about the null — has a name. It's empirical Bayes."

#### 2.4 — Empirical Bayes: ten thousand tests inform one

**Hook**: "In 1977, Efron and Carl Morris wrote a paper about baseball. Predicting a player's end-of-season batting average from their first 45 at-bats. The best predictor wasn't the player's own average — it was a shrinkage estimate that pulled everyone toward the league mean. Every player's estimate got better by borrowing information from every other player." This is Stein's paradox applied. In genomics: every gene's test statistic gets better when you use information from all the other genes.

**Statistical idea**: Shrinkage and the James-Stein estimator. The connection to the two-groups model: estimating π₀ and f₀ from all genes is empirical Bayes — the "prior" comes from the data. Storey's q-value: the minimum FDR at which a gene would be declared significant. Relationship between BH procedure, q-values, and local fdr.

**The "but" turn**: "Shrinkage makes your estimates better on average. But 'on average' hides something — the genes with the strongest effects get shrunk toward the null too. The most interesting findings are the ones most affected by the correction."

**Connection to next**: "Let's see what happens when the entire framework breaks down."

#### 2.5 — When it breaks: the replication crisis as a calibration failure

**Hook**: "In 2015, 270 researchers replicated 100 psychology experiments. 97% of the originals were statistically significant. 36% of the replications were." The Reproducibility Project quantified what the 5-HTTLPR story illustrated: systematic over-optimism at scale. Connect to Lecture 1's ending — it's the same problem, across an entire discipline.

**Statistical idea**: Why replication rates are low even without fraud: publication bias inflates effect sizes (winner's curse), flexible analysis inflates significance (garden of forking paths), and theoretical nulls are wrong (Efron's observation). The FDR framework predicts this: if π₀ is high and power is low, most discoveries will be false even at α = 0.05.

**Connection to next**: "The tools we've built — BH, q-values, the two-groups model — don't prevent bad science by themselves. They're diagnostic instruments. They tell you what your data can and can't support. The histogram from Lecture 1 is the first check. The empirical null is the second. The discipline is in actually looking."

**End on the observation**: "The histogram isn't just a picture. It's an estimator. And now you know how to read it."

---

### Lecture 3: "The Map That Drew Itself"

#### 3.1 — Cavalli-Sforza's beautiful mistake

**Hook**: "In 1978, Luca Cavalli-Sforza did something that seemed brilliant. He took gene frequency data from populations across Europe, ran PCA, and plotted the first principal component on a map. The result was striking: a smooth gradient radiating from the Near East — exactly matching the archaeological record of farming spreading from the Fertile Crescent." Show the map. It's gorgeous. It confirmed decades of archaeological theory with independent genetic evidence. "In 2008, John Novembre showed it was an artifact."

**Statistical idea**: What PCA does — finds orthogonal directions of maximum variance. The eigenvalue decomposition of the covariance matrix. When applied to spatially structured data, the leading PCs *always* produce sinusoidal gradients, regardless of the underlying process. This is a mathematical property of eigenvectors on spatial grids, not a biological signal. Show Novembre's simulation: isolation by distance with no migration produces the same maps.

**The "but" turn**: "The bittersweet part: the underlying biology was probably right — farmers did spread from the Near East. But PCA maps couldn't be the evidence, because PCA maps can't distinguish migration from no migration. The method answered a question it wasn't asked."

**Connection to next**: "So PCA can fool you. But it can also be genuinely useful — if you know what you're looking at."

#### 3.2 — What PCA actually finds (and the scree plot as diagnostic)

**Hook**: Return to the Golub dataset. "72 patients, 3,051 genes. Can PCA show us the difference between ALL and AML without being told the labels?" Run PCA. Plot PC1 vs. PC2. The types separate. "Now — how do you know this isn't another Cavalli-Sforza?" Answer: the scree plot and the loadings. The scree plot tells you how many dimensions matter. The loadings tell you which genes drive the separation.

**Statistical idea**: Eigenvalues as variance explained. The scree plot — what it looks like when there's signal vs. noise. The elbow and the Marchenko-Pastur law (eigenvalue distribution under pure noise). Loadings and biplots: interpreting what the components mean biologically. Variance explained vs. structure explained (a component can explain little variance but capture real biology).

**Connection to next**: "PCA finds linear structure. But biological data often isn't linear."

#### 3.3 — The Netflix Prize and latent factors

**Hook**: "In 2006, Netflix offered a million dollars to anyone who could improve their recommendation algorithm by 10%. The key insight of the winning approaches was matrix factorization — the same math as PCA. Every movie can be described by ~50 latent numbers. Every user can be described by ~50 numbers. Your predicted rating is the dot product." The latent factors turned out to have human-interpretable meaning: genre, tone, era. Cruel coda: Netflix never deployed the winning algorithm because they'd shifted to streaming, where the recommendations problem was different.

**Statistical idea**: Low-rank matrix approximation. SVD: X ≈ UΣV'. The connection to PCA (PCA is SVD of the centered matrix). Rank as a parameter — choosing how many components to keep. The bias-variance tradeoff in dimensionality: too few dimensions and you miss structure; too many and you fit noise.

**Connection to next**: "Linear methods find linear structure. But cell types don't live on lines."

#### 3.4 — The single-cell revolution: UMAP as discovery

**Hook**: "When single-cell RNA-seq became feasible around 2015, biologists thought they knew what cell types existed in, say, the brain. Neurons, glia, a few subtypes. Then they measured 20,000 genes per cell in thousands of cells and ran UMAP. The plots showed dozens of clusters nobody had names for." The Allen Brain Cell Atlas: 5,000+ transcriptionally distinct cell populations. "Dimension reduction wasn't just visualizing known structure — it was revealing structure nobody had imagined."

**Statistical idea**: t-SNE and UMAP — nonlinear dimension reduction. The basic idea: preserve local neighborhoods, allow global distances to distort. How UMAP works intuitively: build a neighborhood graph in high-dimensional space, then optimize a low-dimensional layout that preserves the graph. Key parameters: n_neighbors (controls local vs. global), min_dist (controls clumping). What UMAP preserves (local clusters) and what it doesn't (distances between clusters, global geometry).

**The "but" turn**: "UMAP showed real cell types nobody expected. But it also shows clusters in pure noise. And the distances between clusters on a UMAP plot are meaningless. If you see two clusters far apart, that doesn't mean they're more different than two clusters close together."

**Connection to next**: "So we have a method that genuinely discovers cell types but also hallucinates structure. How do you tell which is which?"

#### 3.5 — Artifacts, overclustering, and the discipline of validation

**Hook**: "Here's a UMAP of the Golub dataset. The types separate cleanly. Now here's a UMAP of the same data with permuted labels — the genes have no relationship to the types. There are still clusters." The visual lesson: clusters on a UMAP plot are necessary but not sufficient evidence of real structure. Validation strategies: (1) do the clusters correspond to known biology? (2) are they stable across parameter choices? (3) do they replicate in independent data?

**Statistical idea**: Stability analysis — bootstrap or subsample the data, rerun the projection, see which clusters persist. Silhouette scores and cluster validation metrics (briefly). The distinction between visualization (explore) and inference (conclude). PCA corrections in GWAS (Price et al. 2006): PCA went from visualization tool to causal-inference correction — top PCs summarize ancestry and remove confounding when included as covariates. This is dimension reduction doing something PCA maps couldn't: solving a real statistical problem.

**End on the observation**: "Dimension reduction always shows you structure. The discipline is in asking: structure in the data, or structure in the method?"

---

### Lecture 4: "Seventy Genes and a Fraud"

#### 4.1 — The p >> n problem: why ordinary regression fails

**Hook**: "You have 98 patients and 25,000 genes. You want to predict who will develop metastases. The obvious approach is regression — but you can't run a regression with more predictors than observations." Explain mechanically why OLS fails: the system is underdetermined, X'X is singular, there are infinitely many solutions. "The geometry is revealing: in 25,000 dimensions with 98 points, you can always find a hyperplane that perfectly separates any two groups. Perfect fit, zero information."

**Statistical idea**: The rank deficiency of X when p > n. Why overfitting is guaranteed: with p >> n, the training error can always be driven to zero while the model learns nothing generalizable. The bias-variance tradeoff at its extreme — zero bias, infinite variance.

**Connection to next**: "You need to give something up. Ridge regression gives up unbiasedness."

#### 4.2 — Ridge regression: the counterintuitive fix

**Hook**: "In 1970, two engineers named Hoerl and Kennard noticed something disturbing: regression coefficients could be negative for variables that were obviously positively related to the outcome. The estimates were technically unbiased but wildly unstable. Their fix was deliberately counterintuitive: add a penalty that makes the estimates *biased* toward zero. The biased estimates predicted better." This is the bias-variance tradeoff made concrete.

**Statistical idea**: Ridge regression: minimize ||y - Xβ||² + λ||β||². The penalty shrinks all coefficients toward zero but never to exactly zero. The solution: β̂_ridge = (X'X + λI)⁻¹X'y — the λI term makes the matrix invertible. Geometric interpretation: the L2 ball. The regularization path — plot coefficients as a function of λ. Cross-validation to choose λ.

**The "but" turn**: "Ridge gives you stable predictions. But with 3,051 genes, every single one gets a nonzero coefficient. If you want to know *which* genes matter — which genes a clinician should look at — ridge doesn't help."

**Connection to next**: "You want a model that selects genes. That's what LASSO does."

#### 4.3 — LASSO: the geometry of sparsity

**Hook**: "In 1996, Robert Tibshirani proposed replacing the squared penalty with an absolute-value penalty. The change seems minor — L2 norm to L1 norm — but the geometry is completely different." Show the diamond (L1 ball) vs. the circle (L2 ball). The constraint contours have corners on the axes. The regression solution hits a corner, and at a corner, some coefficients are exactly zero. "LASSO doesn't just shrink — it selects."

**Statistical idea**: LASSO: minimize ||y - Xβ||² + λ||β||₁. The geometry of why L1 produces sparsity. The regularization path — coefficients enter the model one at a time as λ decreases. Cross-validation for λ. Applied to the Golub dataset: at the optimal λ, maybe 30–50 genes have nonzero coefficients out of 3,051.

**The "but" turn**: "LASSO gives you a gene list. But here's the problem: run it again on a bootstrap sample and you get a *different* gene list. The identity of the selected genes is unstable, even when the prediction accuracy is stable. Which 70 genes depends on the random seed."

**Connection to next**: "The instability is worst when genes are correlated — and in biology, genes are always correlated."

#### 4.4 — Elastic net and correlated genes

**Hook**: "Genes work in pathways. If three genes in a pathway are all relevant, LASSO picks one and discards the other two — which one depends on noise in the data. This looks like precision but it's luck." Zou and Hastie (2005) combined L1 and L2 penalties. The L1 part provides sparsity. The L2 part provides the "grouping effect" — correlated predictors get similar coefficients instead of one winning and the others being zeroed out.

**Statistical idea**: Elastic net: minimize ||y - Xβ||² + λ₁||β||₁ + λ₂||β||². The mixing parameter α controls the balance (α = 1 is LASSO, α = 0 is ridge). Cross-validation over both λ and α. The grouping property theorem: if two predictors are highly correlated, elastic net gives them similar coefficients. Comparison: ridge (stable, no selection), LASSO (sparse, unstable groups), elastic net (sparse, stable groups).

**Connection to next**: "Now we have the tools. The question is whether we use them honestly."

#### 4.5 — MammaPrint: when regularization saves lives

**Hook**: "In 2002, Laura van 't Veer measured 25,000 genes on 98 breast cancer patients and used a regularized method to find a 70-gene signature predicting metastasis. The signature was commercialized as MammaPrint." Walk through the MINDACT trial (2016): 6,693 patients. Women classified as high clinical risk but low genomic risk were randomized to chemotherapy vs. no chemotherapy. Five-year survival: 94.7% without chemo. "46% of women who would have received chemotherapy based on clinical criteria alone were spared — because a model built on 25,000 variables and 98 patients turned out to be right."

**Statistical idea**: External validation — the MINDACT trial as the gold standard. Why the signature worked: biological signal was strong (metastasis has a clear transcriptomic signature), the method was appropriate (penalized regression for p >> n), and the validation was rigorous (prospective randomized trial, not retrospective reanalysis).

**The "but" turn**: "The same method, the same kind of data, the same kind of problem. But at Duke, it went very differently."

**Connection to next**: Direct pivot to Duke.

#### 4.6 — The Duke fraud: when the same method destroys trust

**Hook**: "Anil Potti at Duke used gene expression signatures to predict which chemotherapy drug a tumor would respond to. Patients were enrolled in clinical trials based on these signatures. Two statisticians at MD Anderson — Keith Baggerly and Kevin Coombes — spent years trying to reproduce the analysis." They found mislabeled samples, off-by-one errors in gene indices, results that were literally the opposite of what was claimed. Eighteen papers retracted. Potti's medical license revoked.

**Statistical idea**: Reproducibility as a statistical practice, not just an ethical one. The specific errors Baggerly and Coombes found — and why they were invisible without access to the code and data. Cross-validation done correctly vs. incorrectly (the Duke group leaked information between training and test sets). The lesson: regularization is a tool, not a guarantee. The model is only as good as the analysis pipeline.

**End on the observation**: "MammaPrint and the Duke fraud are the same method, the same data type, the same question. The difference isn't statistical — it's disciplinary. Validation, reproducibility, and honesty about uncertainty aren't add-ons to the analysis. They're the analysis."

---

## Level 3: Slide-Level Detail

*To be developed one lecture at a time, after Level 2 approval.*

Each Level 3 entry will include:
- **Opening line** (what the speaker says first)
- **Key visual** (the figure or output on the slide)
- **Speaker notes** (casual voice, audience prompts, code for generating the visual)
- **Transition** (one sentence connecting to the next slide)
