# ECO346 Assignment 1 — Education Spending and Literacy

**Student:** Zainab Ashraf  
**Registration number:** FA24-BED-078 *(please confirm against your official university record; repository name currently uses FA24-BEDS-078)*  
**Assigned variant:** 6 — Balochistan Rural  
**Course:** ECO346 | **Assignment:** 1

> **Verification notice:** The survey-weighted figures below were supplied in the assignment discussion, not independently reproduced from the two CSV files in this README preparation. The currently shared `final_code.R` computes household totals for Balochistan without a rural filter, so its output must **not** be presented as validation of Q2. Re-run corrected R scripts and update the figures and numbers before final submission.

## Q1 — Repository, data and reproducibility

This repository contains the PSLM household and person subsets, analytical code, SVG figures and presentation. Variant 6 selects **Balochistan Rural**. Household variables (including `hhweight`, `prov_code`, and `urban_rural`) should be joined to person records using `hhid` before calculating student-level spending and weighted literacy rates.

### Files

| Location | Purpose |
|---|---|
| `data/pslm_hh_subset.csv` | Household information and survey weights |
| `data/pslm_person_subset.csv` | Individual records, education spending and literacy |
| `final_code.R` | Existing R script; **requires correction** to meet Q2–Q4 specifications |
| `scripts/q5_python.py` | Python literacy analysis; **requires weight-merge and missing-value checks** |
| `figures/` | Exported graphs |
| `FA24-BED-078.pptx` | Presentation, if this is the uploaded filename |

### Reproducing the analysis

1. Clone or download this repository, keeping the `data`, `scripts`, and `figures` folders together.
2. In RStudio, set the working directory to the repository root and load the two CSV files.
3. Verify the coding of `prov_code` and `urban_rural` in the household file; restrict to Balochistan Rural, then merge household weights by `hhid`.
4. For Q2, restrict to **person-level students with `ed_total > 0`**, use valid positive weights, and compute weighted percentiles and the specified weighted histogram.
5. For Q3, restrict to ages **10–64**, nonmissing `literate` and valid weights; calculate weighted rates for men and women in five-year age bands.
6. Save R figures as SVG, then run the Python Q5 replication and compare age-band rates with R to one decimal place.

**Status:** A complete reproducible R workflow for Q2–Q4 has not yet been verified in this repository.

## Q2 — Education spending distribution

**Reported survey-weighted results (pending verification against corrected R output):**

| Indicator | Reported value |
|---|---:|
| Valid student observations | 1,472 |
| Weighted 10th percentile (P10) | Rs. 600 |
| Weighted median (P50) | Rs. 3,500 |
| Weighted 90th percentile (P90) | Rs. 18,700 |
| P90 / weighted median | 5.34 |
| Unweighted median | **Not supplied / needs R calculation** |
| Excluded observations outside log10 range 2–6 | **Not supplied / needs R calculation** |

The reported 90th-percentile spending is about 5.34 times the median, suggesting substantial variation among students with positive education expenditure. These numbers must be checked using the required person-level sample and household survey weights.

![Q2 education spending distribution](figures/q2_distribution.svg)

**Required figure checks:** histogram density **per log10 unit**, bins of width 0.1 from log10 2 to 6, x-axis labels in rupees, and dashed weighted median/P90 lines with rupee labels. The currently stored figure may not yet satisfy all these conditions.

## Q3 — Literacy by age and sex

**Reported weighted literacy estimates (pending verification against corrected R output):**

| Age band | Male literacy | Female literacy | Male − female gap |
|---|---:|---:|---:|
| 15–19 | 63.81% | 33.25% | 30.56 percentage points |
| 40–44 | 55.42% | 7.50% | **47.92 percentage points** |
| 55–59 | 39.75% | 3.45% | 36.30 percentage points |

The **40–44** band was reported as having the largest gender gap across five-year age bands. Men have higher reported literacy than women in the displayed groups. This is a descriptive comparison; age-group differences do not establish a causal effect of age or gender.

![Q3 literacy by age and sex](figures/q3_literacy.svg)

### Full Q3 age-band table — completion required

The assignment requires **unweighted cell counts and weighted literacy rates for every five-year age band (10–14 through 60–64)**, separately for male and female respondents. Those complete results were not provided, so they cannot be filled accurately here. Add the R-generated full table after checking the correct rural filter and weights. Mark cells with fewer than 30 unweighted observations as thin in the SVG using hollow markers.

## Q4 — Default plot and redesign

**Default plot:**

![Q4 default plot](figures/default.svg)

**Redesigned plot:**

![Q4 improved literacy plot](figures/q4_improved.svg)

The redesign aims to improve comparison through (1) clearer gender distinction, (2) more informative axis and series labels, and (3) explicit emphasis on the age band with the largest gender gap. These changes support readability and visual hierarchy. A default scatterplot may show every observation directly, whereas the redesigned aggregated chart hides individual-level variation. **Verify the final redesigned file actually implements these changes.**

**Assignment-specific check:** The default plot must be created with exactly `ggplot(data, aes(x, y)) + geom_point()` and committed **before** the redesigned figure. The screenshots alone do not establish this commit sequence.

## Q5 — Python replication of Q3

![Q5 Python literacy figure](figures/q5_python.svg)

Q5 requires reproducing the **full Q3 age-band literacy table** in Python or Stata, with results agreeing with R to **one decimal place**.

| Check | R result | Python result | Status |
|---|---|---|---|
| Female literacy, 15–19 | Not verified | Not verified | **Comparison pending** |
| All age-band rates to 1 decimal | Not verified | Not verified | **Comparison pending** |

The supplied `scripts/q5_python.py` can silently substitute unit weights if it cannot find a weight column. To ensure correct replication, explicitly merge `hhweight` from the household file, filter nonmissing literacy values, confirm rural coding and compare outputs against R. The use of default `groupby` behavior and the need to specify `observed=True` is one potential cross-language setting to document, but the actual observed difference has not been demonstrated.

## Q6 — Presentation

The presentation should show the assigned variant, a comparison of the default and redesigned visualization, and a key finding. **The assignment permits at most four slides.** If the current PowerPoint has five slides (including a Thank You slide), reduce it to four before submission, for example by combining the conclusion and Thank You content on slide four.

## Reported sample and methodology

- **Reported rural Balochistan sample:** 1,505 households and 8,463 individuals. Verify these counts after applying the required filters.
- **Weighting:** Join household `hhweight` to person records on `hhid`; calculate weighted means for literacy.
- **Weighted percentiles:** Sort valid positive education spending values and choose the first value whose cumulative normalized weight reaches the target probability.
- **Missing data:** Exclude missing literacy responses and invalid weights. For education spending, follow the positive-spending student definition.

## Submission checklist

- [ ] Correct and rerun R scripts for Q2, Q3 and Q4.
- [ ] Verify all reported numbers and regenerate matching SVG figures.
- [ ] Add the full Q3 age-band table and Q2 missing statistics.
- [ ] Verify R and Python agree to one decimal place for Q5.
- [ ] Confirm meaningful Git commit history and default-before-redesign sequence.
- [ ] Confirm official registration number and consistent filenames.
- [ ] Keep the final presentation within the four-slide limit.
- [ ] Submit the public GitHub repository URL and required answers through the course form.
