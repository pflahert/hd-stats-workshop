# Golub Leukemia Dataset

Gene expression data from the landmark Golub et al. (1999) study on molecular classification of cancer. Used in workshop labs to teach multiple testing, FDR, dimension reduction, and penalized regression.

## Files

- **golub_expression.csv** — 3,051 genes (rows) x 72 samples (columns). Preprocessed microarray expression values.
- **golub_metadata.csv** — 72 rows with columns: `sample_id`, `subtype` (ALL or AML).

## Provenance

- **Source**: Zenodo ([DOI: 10.5281/zenodo.8123245](https://zenodo.org/records/8123245)), preprocessed version of Golub et al. (1999)
- **Original study**: Golub, T.R. et al. (1999). Molecular Classification of Cancer: Class Discovery and Class Prediction by Gene Expression Monitoring. *Science*, 286(5439), 531-537.
- **Platform**: Affymetrix HG-U6800 microarray
- **Samples**: 72 patients (47 ALL, 25 AML); original train/test split combined

## Usage (Python, Colab)

```python
# Install pyreadr for reading R data files
!pip install -q pyreadr

import pyreadr, urllib.request, pandas as pd, os

url = "https://zenodo.org/records/8123245/files/leukemia_data_Golub99_3051.rda?download=1"
if not os.path.exists("golub.rda"):
    urllib.request.urlretrieve(url, "golub.rda")

rda = pyreadr.read_r("golub.rda")
expr = pd.concat([rda['golub_train_3051'], rda['golub_test_3051']]).reset_index(drop=True)
labels = pd.concat([rda['golub_train_response'].iloc[:, 0],
                     rda['golub_test_response'].iloc[:, 0]]).reset_index(drop=True)
```
