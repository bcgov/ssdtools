# Changelog

## ssdtools 2.5.0

CRAN release: 2025-12-01

- Added the following confidence interval methods to
  [`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md),
  [`ssd_hp()`](https://bcgov.github.io/ssdtools/reference/ssd_hp.md) and
  [`predict()`](https://rdrr.io/r/stats/predict.html):
  - `"GMACL"`: weighted geometric mean of the confidence limits.
  - `"arithmetic_samples"`: takes weighted arithmetic mean of the values
    for each bootstrap iteration across all the distributions and then
    calculates the confidence limits from the single set of samples.
  - `"geometric_samples"`: takes weighted geometric mean of the values
    for each bootstrap iteration across all the distributions and then
    calculates the confidence limits from the single set of samples. The
    new confidence interval methods were added for research or
    completeness and the default recommended method is still
    `ci_method = "weighted_samples"`.
- Added `decimal.mark = getOption("OutDec", ".")` argument to plotting
  functions. ([\#135](https://github.com/bcgov/ssdtools/issues/135)).
- Allowed
  [`ssd_plot()`](https://bcgov.github.io/ssdtools/reference/ssd_plot.md)
  to use concentration as labels for shinyssdtools.
- Fixed documentation to indicate that default value of
  `at_boundary_ok = TRUE`.

## ssdtools 2.4.0

CRAN release: 2025-09-12

### Features

- Added right censoring for all distributions (by
  [@eduardszoecs](https://github.com/eduardszoecs)).
- Added `rescale = "odds"` option to
  [`ssd_fit_dists()`](https://bcgov.github.io/ssdtools/reference/ssd_fit_dists.md)
  to allow fitting to dilution data including `odds_max = 0.999`
  argument to handle values of 1.

### Functions

- Added
  [`ssd_ci_methods()`](https://bcgov.github.io/ssdtools/reference/ssd_ci_methods.md)
  and
  [`ssd_est_methods()`](https://bcgov.github.io/ssdtools/reference/ssd_est_methods.md)
  to get character vector of methods.
- Added
  [`ssd_at_boundary()`](https://bcgov.github.io/ssdtools/reference/ssd_at_boundary.md)
  and
  [`ssd_computable()`](https://bcgov.github.io/ssdtools/reference/ssd_computable.md).
- Added class and attribute preserving `[[` and `[` operators.

### Arguments

- Added `strict = TRUE` argument to
  [`subset()`](https://rdrr.io/r/base/subset.html) to allow subsetting
  when distributions missing (with `strict = FALSE`).

### Output Columns

- Added column `"dists"` to
  [`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md),
  [`ssd_hp()`](https://bcgov.github.io/ssdtools/reference/ssd_hp.md) and
  [`predict()`](https://rdrr.io/r/stats/predict.html) which is a list of
  the distributions.
- Added `"est_method"` and `"ci_method"` columns to tibble output by
  [`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md),
  [`ssd_hp()`](https://bcgov.github.io/ssdtools/reference/ssd_hp.md) and
  [`predict()`](https://rdrr.io/r/stats/predict.html).
- Added `"level"` column to tibble output by
  [`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md),
  [`ssd_hp()`](https://bcgov.github.io/ssdtools/reference/ssd_hp.md) and
  [`predict()`](https://rdrr.io/r/stats/predict.html).
- Added `"at_bound"` and `"computable"` columns to tibble output by
  [`ssd_gof()`](https://bcgov.github.io/ssdtools/reference/ssd_gof.md).
- Renamed `"method"` column to `"boot_method"` in tibble output by
  [`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md),
  [`ssd_hp()`](https://bcgov.github.io/ssdtools/reference/ssd_hp.md) and
  [`predict()`](https://rdrr.io/r/stats/predict.html).
- [`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md),
  [`ssd_hp()`](https://bcgov.github.io/ssdtools/reference/ssd_hp.md) and
  [`predict()`](https://rdrr.io/r/stats/predict.html) now only return
  missing values for `se`, `lcl` and `ucl` when `nboot = 0`.

### Error Checking

- Added … and check unused to ensure matching names of subsequent
  arguments.
- Fixed error message when Inf weights.
- [`ssd_fit_bcanz()`](https://bcgov.github.io/ssdtools/reference/ssd_fit_bcanz.md)
  now checks all dists are subset of
  [`ssd_dists_bcanz()`](https://bcgov.github.io/ssdtools/reference/ssd_dists_bcanz.md).

### Modifications

- Modified method to calculate
  [`ssd_ecd()`](https://bcgov.github.io/ssdtools/reference/ssd_ecd.md)
  to use [`stats::ppoints()`](https://rdrr.io/r/stats/ppoints.html).
- Ensures `weighted_samples` sum to nboot.

### Deprecated

- Deprecated
  [`ssd_dists_shiny()`](https://bcgov.github.io/ssdtools/reference/ssd_dists_shiny.md).

- Deprecated `ties.method = "first"` argument in
  [`ssd_ecd()`](https://bcgov.github.io/ssdtools/reference/ssd_ecd.md).

- Soft-deprecated `est_method = "multi"` argument to `multi_est = TRUE`
  for
  [`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md),
  [`ssd_hp()`](https://bcgov.github.io/ssdtools/reference/ssd_hp.md) and
  [`predict()`](https://rdrr.io/r/stats/predict.html).

- Soft-deprecated `proportion = FALSE` to `proportion = TRUE` argument
  to [`ssd_hp()`](https://bcgov.github.io/ssdtools/reference/ssd_hp.md)
  which switches output from percentages to proportions.

- Soft-deprecated `wt = FALSE` for `wt = TRUE` argument to
  [`ssd_gof()`](https://bcgov.github.io/ssdtools/reference/ssd_gof.md)
  and [`glance()`](https://generics.r-lib.org/reference/glance.html)
  which replaces column `"weight"` with `"wt"` in output.

- Soft-deprecated `ci_method = "weighted_arithmetic"` for
  `ci_method = "MACL"`.

## ssdtools 2.3.0

CRAN release: 2025-02-20

- Added valid column to dist_data to indicate the “invpareto” has
  invalid likelihood.
- Modified
  [`ssd_fit_dists()`](https://bcgov.github.io/ssdtools/reference/ssd_fit_dists.md)
  so fits distributions with invalid likelihoods in isolation.
- Modified
  [`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md) and
  [`ssd_hp()`](https://bcgov.github.io/ssdtools/reference/ssd_hp.md) so
  does not average if just one distribution.
- Updated citations to Thorley et al. (2025).

## ssdtools 2.2.0

CRAN release: 2025-01-14

- Added
  [`ssd_label_comma_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_label_comma_hc.md)
  function to label numbers with significant digits and comma and offset
  hazard concentration value if present in breaks.
- Added
  [`ssd_dists_shiny()`](https://bcgov.github.io/ssdtools/reference/ssd_dists_shiny.md)
  to define distributions for use in shiny app.
- For `plot_coord_scale()` function:
  - Added `x_limits = NULL` to allow setting of x-axis limits.
  - Added `hc_value = NULL` to pass hazard concentration value.
  - Restricted `trans` argument to `"identity"`, `"log10"` or “`log`”.
- For
  [`ssd_plot()`](https://bcgov.github.io/ssdtools/reference/ssd_plot.md)
  function:
  - Added `text_size` argument.
  - Added `theme_classic = FALSE` argument to switch classic theme.
  - Soft-deprecated `size` argument for `label_size`.
- Turned off x-axis minor breaks for all plots (for consistency) as HC
  major break causing multiple minor breaks in
  [`ssd_plot()`](https://bcgov.github.io/ssdtools/reference/ssd_plot.md).

## ssdtools 2.1.0

CRAN release: 2024-10-21

- Added `ssd_xxmulti_fitdists()` family of functions
  ([`ssd_rmulti_fitdists()`](https://bcgov.github.io/ssdtools/reference/ssd_r.md),
  [`ssd_pmulti_fitdists()`](https://bcgov.github.io/ssdtools/reference/ssd_p.md)
  and
  [`ssd_qmulti_fitdists()`](https://bcgov.github.io/ssdtools/reference/ssd_q.md))
  to accept object of class `fitdists`.
- Set `lnorm.weight = 1` instead of `1` in the `ssd_xxmulti()` family of
  functions
  ([`ssd_rmulti()`](https://bcgov.github.io/ssdtools/reference/ssd_r.md),
  [`ssd_pmulti()`](https://bcgov.github.io/ssdtools/reference/ssd_p.md)
  and `ssd_qmulti`) to avoid incorrect values with
  `do.call("ssd_xxmulti", c(..., estimates(fits))` if `fits` does not
  include the log-normal distribution.

## ssdtools 2.0.0

CRAN release: 2024-10-09

`ssdtools` v2.0.0, which now includes David Fox and Rebecca Fisher as
co-authors, is the second major release of `ssdtools`.

### Major Changes

The following changes are major in the sense that they could alter
previous hazard concentrations or break code.

#### Model Fitting and Averaging

##### Modifications

The following arguments were added to
[`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md) and
[`ssd_hp()`](https://bcgov.github.io/ssdtools/reference/ssd_hp.md)

- `multi_est = TRUE` to calculate model averaged estimates treating the
  distributions as constituting a single mixture distribution
  (previously it was effectively `FALSE`).
- `method_ci = "weighted_samples"` to specify whether to use
  `"weighted_samples"`, `"weighted_arithmetic"`, `"multi_free"` or
  `"multi_fixed"` methods to generate confidence intervals (previously
  it was effectively `"weighted_arithmetic"`).

In addition the data frame returned by
[`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md) and
[`predict()`](https://rdrr.io/r/stats/predict.html) now includes a
column `proportion` with values between 0 and 1 as opposed to a column
`percentage` with between 0 and 100.

Finally, with censored data confidence intervals can now only be
estimated by non-parametric bootstrapping as the methods of
parametrically bootstrapping censored data require review.

### Minor Changes

The remaining changes are minor.

#### Model Fitting

##### Modifications

The following arguments of
[`ssd_fit_dists()`](https://bcgov.github.io/ssdtools/reference/ssd_fit_dists.md)
were changed to reduce the chances of the `lnorm_lnorm` bimodal
distribution being dropped from the default set:

- `min_pmix = ssd_min_pmix(nrow(data))` so that by default `min_pmix` is
  0.1 or `3/nrow(data)` if greater.
- `at_boundary_ok = TRUE`.
- `computable = TRUE`.

These changes also allowed the `min_pboot = 0.95` argument to be changed
from `0.80` for all bootstrapping functions.

It is worth noting that the second two changes also reduce the chances
of the BurrIII distribution being dropped.

In addition `rescale = TRUE` now divides by the geometric mean of the
minimum and maximum positive finite values as opposed to dividing by the
geometric mean of the maximum finite value to improve the chances of
convergence although
[`ssd_fit_bcanz()`](https://bcgov.github.io/ssdtools/reference/ssd_fit_bcanz.md)
no longer rescales by default.

Other minor modifications to the model fitting functions include

- [`estimates.fitdists()`](https://bcgov.github.io/ssdtools/reference/estimates.fitdists.md)
  now includes weights in returned parameters as well as an
  `all_estimates = FALSE` argument to allow parameter values for all
  implemented distributions to be included.
- `delta = 7` instead of `delta = 9.21` to ensure weight of included
  models at least 0.01.
- seeds are now allocated to bootstrap samples as opposed to
  distributions (which results in a speed gain when there are more cores
  than the number of distributions).
- `lnorm` and `gompertz` initial values are offset from their maximum
  likelihood estimates to avoid errors in
  [`optim()`](https://rdrr.io/r/stats/optim.html).

The following functions and arguments were also added:

- [`ssd_hp_bcanz()`](https://bcgov.github.io/ssdtools/reference/ssd_hp_bcanz.md)
  and
  [`ssd_hp.fitburrlioz()`](https://bcgov.github.io/ssdtools/reference/ssd_hp.md)
  to get hazard proportions.
- [`ssd_pmulti()`](https://bcgov.github.io/ssdtools/reference/ssd_p.md),
  [`ssd_qmulti()`](https://bcgov.github.io/ssdtools/reference/ssd_q.md)
  and
  [`ssd_rmulti()`](https://bcgov.github.io/ssdtools/reference/ssd_r.md)
  for combined mixture distributions.
- `ssd_exx()` family of functions
  (i.e. [`ssd_elnorm()`](https://bcgov.github.io/ssdtools/reference/ssd_e.md),
  [`ssd_egamma()`](https://bcgov.github.io/ssdtools/reference/ssd_e.md)
  etc) to get default parameter estimates for distributions.
- [`ssd_censor_data()`](https://bcgov.github.io/ssdtools/reference/ssd_censor_data.md)
  to censor data.
- `npars = c(2L, 5L)` argument to
  [`ssd_dists_bcanz()`](https://bcgov.github.io/ssdtools/reference/ssd_dists_bcanz.md)
  to specify the number of parameters.
- `dists = ssd_dists_bcanz()` to
  [`ssd_fit_bcanz()`](https://bcgov.github.io/ssdtools/reference/ssd_fit_bcanz.md)
  to allow other packages to modify.
- `samples = FALSE` to
  [`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md) and
  [`ssd_hp()`](https://bcgov.github.io/ssdtools/reference/ssd_hp.md)
  include bootstrap samples as list of numeric vector(s).
- `save_to = NULL` to
  [`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md) and
  [`ssd_hp()`](https://bcgov.github.io/ssdtools/reference/ssd_hp.md) to
  specify a directory in which to save the bootstrap datasets as csv
  files and parameter estimates as .rds files.

##### Fixes

- [`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md) and
  [`ssd_hp()`](https://bcgov.github.io/ssdtools/reference/ssd_hp.md) now
  return data frame with `parametric` column.
- [`ssd_hp()`](https://bcgov.github.io/ssdtools/reference/ssd_hp.md) now
  return data frame with `wt` column.

##### Deprecations

The following functions and arguments were deprecated:

- [`ssd_wqg_bc()`](https://bcgov.github.io/ssdtools/reference/ssd_wqg_bc.md)
  and
  [`ssd_wqg_burrlioz()`](https://bcgov.github.io/ssdtools/reference/ssd_wqg_burrlioz.md)
  were deprecated.
- `percent = 5` in
  [`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md) and
  [`predict()`](https://rdrr.io/r/stats/predict.html) was
  soft-deprecated for `proportion = 0.05`.
- [`is_censored()`](https://bcgov.github.io/ssdtools/reference/is_censored.md)
  is now defunct.

#### Plotting

Perhaps the biggest plotting change is that
[`ssd_plot_cdf()`](https://bcgov.github.io/ssdtools/reference/ssd_plot_cdf.md)
now plots the average SSD together with the individual distributions if
`average = NA`.

In addition, the following functions and arguments were added.

- [`scale_fill_ssd()`](https://bcgov.github.io/ssdtools/reference/scale_colour_ssd.md)
  for color-blind fill scale.
- [`ssd_label_comma()`](https://bcgov.github.io/ssdtools/reference/ssd_label_comma.md)
  for formatting of x-axis labels.
- `trans = "log10"` and `add_x = 0` to
  [`ssd_plot()`](https://bcgov.github.io/ssdtools/reference/ssd_plot.md)
  and
  [`ssd_plot_data()`](https://bcgov.github.io/ssdtools/reference/ssd_plot_data.md)
  to control x-axis scale.
- `big.mark = ","` for x-axis labels and `suffix = "%"` for y-axis
  labels to all plotting functions.

and the following functions deprecated

- [`comma_signif()`](https://bcgov.github.io/ssdtools/reference/comma_signif.md)
  was soft-deprecated.
- [`is_censored()`](https://bcgov.github.io/ssdtools/reference/is_censored.md),
  `plot.fitdists()`,
  [`ssd_plot_cf()`](https://bcgov.github.io/ssdtools/reference/ssd_plot_cf.md)
  [`geom_ssd()`](https://bcgov.github.io/ssdtools/reference/geom_ssd.md)
  and
  [`stat_ssd()`](https://bcgov.github.io/ssdtools/reference/stat_ssd.md)
  are now defunct.

#### Data

The following data sets were removed

- `ccme_data` and `ccme_boron` (available in `ssddata` package).
- `pearson1000` data set.

## ssdtools 1.0.6

CRAN release: 2023-09-07

- Fix CRAN ATLAS error

## ssdtools 1.0.5

CRAN release: 2023-08-29

- Stopped predict and hc/hp test errors on linux.

## ssdtools 1.0.4

CRAN release: 2023-05-17

- Added contributors.
- Now tests table values to 6 significant figures.
- Fixed bug that was not preserving NaN (returning NA_real\_) for
  cumulative distribution and quantile functions.

## ssdtools 1.0.3

CRAN release: 2023-04-12

- Replaced `size = 0.5` with `linewidth = 0.5` in
  [`geom_hcintersect()`](https://bcgov.github.io/ssdtools/reference/geom_hcintersect.md)
  and
  [`geom_xribbon()`](https://bcgov.github.io/ssdtools/reference/geom_xribbon.md).
- Replaced
  [`aes_string()`](https://ggplot2.tidyverse.org/reference/aes_.html)
  with [`aes()`](https://ggplot2.tidyverse.org/reference/aes.html) in
  examples (and internally).
- Removed use of `tidyverse` package.
- Now tests values to 12 significant digits.
- Fixed description of
  [`ssd_hp()`](https://bcgov.github.io/ssdtools/reference/ssd_hp.md) to
  be percent affected rather than percent protected.

## ssdtools 1.0.2

CRAN release: 2022-05-14

- Fixed bug that was producing estimates of 0 for lower HCx values for
  log-normal mixture model with rescaled data spanning many orders of
  magnitude.

## ssdtools 1.0.1

CRAN release: 2022-04-10

- Added `delta = 7` argument to
  [`ssd_plot_cdf()`](https://bcgov.github.io/ssdtools/reference/ssd_plot_cdf.md).

## ssdtools 1.0.0

CRAN release: 2022-04-01

ssdtools version 1.0.0 is the first major release of `ssdtools` with
some important improvements and breaking changes.

### Fitting

An important change to the functionality of
[`ssd_fit_dists()`](https://bcgov.github.io/ssdtools/reference/ssd_fit_dists.md)
was to switch from model fitting using
[`fitdistrplus`](https://github.com/lbbe-software/fitdistrplus) to
[`TMB`](https://github.com/kaskr/adcomp) to allow full control over
model specification as well as improved handling of censored data. The
change is internal and does not directly affect the user interface.
Although it was hoped that model fitting would be faster this is
currently not the case.

As a result of the change the `fitdists` objects returned by
[`ssd_fit_dists()`](https://bcgov.github.io/ssdtools/reference/ssd_fit_dists.md)
from previous versions of `ssdtools` are not compatible with the major
release and should be regenerated.

### BCANZ

As a result of an international collaboration British Columbia and
Canada and Australia and New Zealand selected a set of recommended
distributions for model averaging and settings when generating final
guidelines.

The distributions are
`{r} > ssd_dists_bcanz() [1] "gamma" "lgumbel" "llogis" "lnorm" "lnorm_lnorm" "weibull"`

The
[`ssd_fit_bcanz()`](https://bcgov.github.io/ssdtools/reference/ssd_fit_bcanz.md)
and
[`ssd_hc_bcanz()`](https://bcgov.github.io/ssdtools/reference/ssd_hc_bcanz.md)
functions were added to the package to facilitate the fitting of these
distributions and estimation of hazard concentrations using the
recommended settings.

#### Convergence

In the previous version of `ssdtools` a distribution was considered to
have converged if the following condition was met

1.  [`stats::optim()`](https://rdrr.io/r/stats/optim.html) returns a
    code of 0 (indicating successful completion).

In the new version an additional two conditions must also be met

2.  Bounded parameters are not at a boundary (this condition can be
    turned off by setting `at_boundary_ok = TRUE` or the user can
    specify different boundary values - see below)
3.  Standard errors are computable for all the parameter values (this
    condition can be turned off by setting `computable = FALSE`)

#### Censored Data

Censoring can now be specified by providing a data set with one or more
rows that have

- a finite value for the left column that is smaller than the finite
  value in the right column (interval censored)
- a zero or missing value for the left column and a finite value for the
  right column (left censored)

It is currently not possible to fit distributions to data sets that have

- a infinite or missing value for the right column and a finite value
  for the left column (right censored)

Rows that have a zero or missing value for the left column and an
infinite or missing value for the right column (fully censored) are
uninformative and will result in an error.

##### Akaike Weights

For uncensored data, Akaike Weights are calculated using AICc (which
corrects for small sample size). In the case of censored data, Akaike
Weights are calculated using AIC (as the sample size cannot be
estimated) but only if all the distributions have the same number of
parameters (to ensure the weights are valid).

#### Weighted Data

Weighting must be positive with values \<= 1000.

#### Distributions

Previously the density functions for the available distributions were
exported as R functions to make them accessible to `fitdistrplus`. This
meant that `ssdtools` had to be loaded to fit distributions. The density
functions are now defined in C++ as TMB templates and are no longer
exported.

The distribution, quantile and random generation functions are more
generally useful and are still exported but are now prefixed by `ssd_`
to prevent clashes with existing functions in other packages. Thus for
example [`plnorm()`](https://rdrr.io/r/stats/Lognormal.html),
[`qlnorm()`](https://rdrr.io/r/stats/Lognormal.html) and
[`rlnorm()`](https://rdrr.io/r/stats/Lognormal.html) have been renamed
[`ssd_plnorm()`](https://bcgov.github.io/ssdtools/reference/ssd_p.md),
[`ssd_qlnorm()`](https://bcgov.github.io/ssdtools/reference/ssd_q.md)
and
[`ssd_rlnorm()`](https://bcgov.github.io/ssdtools/reference/ssd_r.md).

The following distributions were added (or in the case of `burrIII3`
readded) to the new version

- `burrIII3` - burrIII three parameter distribution
- `invpareto` - inverse pareto (with bias correction in scale order
  statistic)
- `lnorm_lnorm` log-normal/log-normal mixture distribution
- `llogis_llogis` log-logistic/log-logistic mixture distribution

The following arguments were added to
[`ssd_fit_dists()`](https://bcgov.github.io/ssdtools/reference/ssd_fit_dists.md)

- `rescale` (by default `FALSE`) to specify whether to rescale
  concentrations values by dividing by the largest (finite) value. This
  alters the parameter estimates, which can help some distributions
  converge, but not the estimates of the hazard
  concentrations/protections.
- `reweight` (by default `FALSE`) to specify whether to reweight data
  points by dividing by the largest weight.
- `at_boundary_ok` (by default `FALSE`) to specifying whether a
  distribution with one or more parameters at a boundary has converged.
- `min_pmix` (by default 0) to specify the boundary for the minimum
  proportion for a mixture distribution.
- `range_shape1` (by default `c(0.05, 20)`) to specify the lower and
  upper boundaries for the shape1 parameter of the burrIII3
  distribution.
- `range_shape2` (by default the same as `range_shape2`) to specify the
  lower and upper boundaries for the shape2 parameter of the burrIII3
  distribution.
- `control` (by default an empty list) to pass a list of control
  parameters to [`stats::optim()`](https://rdrr.io/r/stats/optim.html).

It also worth noting that the default value of

- `computable` argument was switched from `FALSE` to `TRUE` to enforce
  stricter requirements on convergence (see above).

##### Subsets of Distributions

The following were added to handle multiple distributions

- [`ssd_dists()`](https://bcgov.github.io/ssdtools/reference/ssd_dists.md)
  to specify subsets of the available distributions.
- `delta` argument (by default 7) to the
  [`subset()`](https://rdrr.io/r/base/subset.html) generic to only keep
  those distributions within the specified AIC(c) difference of the best
  supported distribution.

#### Burrlioz

The function
[`ssd_fit_burrlioz()`](https://bcgov.github.io/ssdtools/reference/ssd_fit_burrlioz.md)
was added to approximate the behaviour of
[Burrlioz](https://research.csiro.au/software/burrlioz/).

### Hazard Concentration/Protection Estimation

Hazard concentration estimation is performed by
[`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md)
(which is wrapped by
[`predict()`](https://rdrr.io/r/stats/predict.html)) and hazard
protection estimation by
[`ssd_hp()`](https://bcgov.github.io/ssdtools/reference/ssd_hp.md). By
default confidence intervals are estimated by parametric bootstrapping.

To reduce the time required for bootstrapping, parallelization was
implemented using the [future](https://github.com/futureverse/future)
package.

The following arguments were added to
[`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md) and
[`ssd_hp()`](https://bcgov.github.io/ssdtools/reference/ssd_hp.md)

- `delta` (by default 7) to only keep those distributions within the
  specified AIC difference of the best supported distribution.
- `min_pboot` (by default 0.90) to specify minimum proportion of
  bootstrap samples that must successfully fit.
- `parametric` (by default `TRUE`) to allow non-parametric
  bootstrapping.
- `control` (by default an empty list) to pass a list of control
  parameters to [`stats::optim()`](https://rdrr.io/r/stats/optim.html).

and the following columns were added to the output data frame

- `wt` to specify the Akaike weight.
- `method` to indicate whether parametric or non-parametric bootstrap
  was used.
- `nboot` to indicate how many bootstrap samples were used.
- `pboot` to indicate the proportion of bootstrap samples which fitted.

It also worth noting that the

- `dist` column was moved from the last to the first position in the
  output data frame.

#### Censored Data

Confidence intervals cannot be estimated for interval censored data.

#### Weighted Data

Confidence intervals cannot be estimated for unequally weighted data.

### Goodness of Fit

The `pvalue` argument (by default `FALSE`) was added to
[`ssd_gof()`](https://bcgov.github.io/ssdtools/reference/ssd_gof.md) to
specify whether to return p-values for the test statistics as opposed to
the test statistics themselves.

### Plotting

There have also been some substantive changes to the plotting
functionality.

Added following functions

- [`ssd_plot_data()`](https://bcgov.github.io/ssdtools/reference/ssd_plot_data.md)
  to plot censored and uncensored data by calling
  [`geom_ssdpoint()`](https://bcgov.github.io/ssdtools/reference/geom_ssdpoint.md)
  for the left and for the right column (alpha parameter values should
  be adjusted accordingly)
- [`geom_ssdsegment()`](https://bcgov.github.io/ssdtools/reference/geom_ssdsegment.md)
  to allow plotting of the range of a censored data points using
  segments.
- [`scale_colour_ssd()`](https://bcgov.github.io/ssdtools/reference/scale_colour_ssd.md)
  (and
  [`scale_color_ssd()`](https://bcgov.github.io/ssdtools/reference/scale_colour_ssd.md))
  to provide an 8 color-blind scale.

Made the following changes to
[`ssd_plot()`](https://bcgov.github.io/ssdtools/reference/ssd_plot.md)

- added `bounds` (by default `c(left = 1, right = 1)`) argument specify
  how many orders of magnitude to extend the plot beyond the minimum and
  maximum (non-missing) values.
- added `linetype` (by default `NULL`) argument to specify line type.
- added `linecolor` (by default `NULL`) argument to specify line color.
- changed default value of `ylab` from “Percent of Species Affected” to
  “Species Affected”.

Renamed - `GeomSsd` to `GeomSsdpoint`. - `StatSsd` to `StatSsdpoint`

Soft-deprecated -
[`geom_ssd()`](https://bcgov.github.io/ssdtools/reference/geom_ssd.md)
for
[`geom_ssdpoint()`](https://bcgov.github.io/ssdtools/reference/geom_ssdpoint.md). -
[`stat_ssd()`](https://bcgov.github.io/ssdtools/reference/stat_ssd.md). -
[`ssd_plot_cf()`](https://bcgov.github.io/ssdtools/reference/ssd_plot_cf.md)
for
[`fitdistrplus::descdist()`](https://lbbe-software.github.io/fitdistrplus/reference/descdist.html).

### Data

#### `ssddata`

The dataset `boron_data` was renamed `ccme_boron` and moved to the
[`ssddata`](https://github.com/open-AIMS/ssddata) R package together
with the other CCME datasets.

The `ssddata` package provides a suite of datasets for testing and
comparing species sensitivity distribution fitting software.

#### Data Handling Functions

Added

- [`ssd_data()`](https://bcgov.github.io/ssdtools/reference/ssd_data.md)
  to return original data for a `fitdists` object.
- [`ssd_ecd_data()`](https://bcgov.github.io/ssdtools/reference/ssd_ecd_data.md)
  to get empirical cumulative density for data.
- [`ssd_sort_data()`](https://bcgov.github.io/ssdtools/reference/ssd_sort_data.md)
  to sort data by empirical cumulative density.

### Miscellaneous

- [`npars()`](https://poissonconsulting.github.io/universals/reference/npars.html)
  now orders by distribution name.
- All functions and arguments that were soft-deprecated prior to v0.3.0
  now warn unconditionally.

#### Generics

- Implemented the following generics for `fitdists` objects

  - [`glance()`](https://generics.r-lib.org/reference/glance.html) to
    get the model likelihoods, information-theoretic criteria etc.
  - [`augment()`](https://generics.r-lib.org/reference/augment.html) to
    return original data set.
  - [`logLik()`](https://rdrr.io/r/stats/logLik.html) to return the
    log-likelihood.
  - `summary.fitdists()` to summarize.

## ssdtools 0.3.7.9000

- Same as previous version.

## ssdtools 0.3.7

CRAN release: 2021-10-27

- fix unequal indentation of Rmd \`\`\`

## ssdtools 0.3.6

CRAN release: 2021-09-22

- Added `wt` (Akaike weight) column to
  [`predict()`](https://rdrr.io/r/stats/predict.html),
  [`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md) and
  [`ssd_hp()`](https://bcgov.github.io/ssdtools/reference/ssd_hp.md)
- Deprecated argument `ic` to
  [`predict()`](https://rdrr.io/r/stats/predict.html),
  [`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md) and
  [`ssd_hp()`](https://bcgov.github.io/ssdtools/reference/ssd_hp.md)
  because unused.
- Silenced output from
  [`ssd_fit_dists()`](https://bcgov.github.io/ssdtools/reference/ssd_fit_dists.md).

## ssdtools 0.3.5

CRAN release: 2021-09-03

- Bump requirement to R \>= 4.1 because of `actuar` package.

## ssdtools 0.3.4

CRAN release: 2021-05-14

- Update Apache License url to https.

## ssdtools 0.3.3

CRAN release: 2021-02-19

- Increased requirement that R \>= 3.5 due to VGAM.
- Modified
  [`comma_signif()`](https://bcgov.github.io/ssdtools/reference/comma_signif.md)
  so that now rounds to 3 significant digits by default and only applies
  [`scales::comma()`](https://scales.r-lib.org/reference/comma.html) to
  values \>= 1000.
- Soft-deprecated the `...` argument to
  [`comma_signif()`](https://bcgov.github.io/ssdtools/reference/comma_signif.md).

## ssdtools 0.3.2

CRAN release: 2020-09-02

- Fix moved URLs.

## ssdtools 0.3.1

CRAN release: 2020-09-01

- Internal changes only.

## ssdtools 0.3.0

CRAN release: 2020-07-09

### Breaking Changes

- Soft-deprecated ‘burrIII3’ distribution as poorly defined.
- Soft-deprecated ‘pareto’ distribution as poor fit on SSD data.

### Major Changes

- Reparameterized ‘llogis’ distribution in terms of locationlog and
  scalelog.
- Reparameterized ‘burrIII3’ distribution in terms of lshape1, lshape2
  and lscale.
- Reparamaterized ‘burrIII2’ distribution in terms of locationlog and
  scalelog.
- Reparamaterized ‘lgumbel’ distribution in terms of locationlog and
  scalelog.
- Reparamaterized ‘gompertz’ distribution in terms of llocation and
  lshape.
- Standardized handling of arguments for d,p,q,r and s functions for
  distributions.

### Minor Changes

- `rdist()` functions now use length of n if `length(n) > 1`.
- Added `slnorm()` to get starting values for ‘dlnorm’ distribution.

### Internal Changes

- Switch to C++ implementation for distributions.

## ssdtools 0.2.0

CRAN release: 2020-04-15

### Breaking Changes

- Changed computable (whether standard errors must be computable to be
  considered to have converged) to FALSE by default.
- Enforces only one of ‘llogis’, ‘llog’ or ‘burrIII2’ in all sets (as
  identical).

### Major Changes

- Deprecated ‘burrIII2’ for ‘llogis’ as identical.
- Replaced ‘burrIII2’ for (identical) ‘llogis’ in default set.
- Fixed bug in `rllog()` that was causing error.
- Fixed parameterisation of ‘lgumbel’ that was causing it to fail to fit
  with some data.

### Minor Changes

- Provides warning message about change in default for ci argument in
  predict function.
- Only gives warning about standard errors not being computable if
  computable = TRUE.
- Uses tibble package to create tibbles.
- Removed dependency on checkr.

## ssdtools 0.1.1

CRAN release: 2020-01-24

- Fix test for CRAN R 3.5

## ssdtools 0.1.0

CRAN release: 2020-01-13

### Breaking Changes

- Default distributions changed to ‘burrIII2’, ‘gamma’ and ‘lnorm’ from
  ‘gamma’, ‘gompertz’, ‘lgumbel’, ‘llog’, ‘lnorm’ and ‘weibull’.
- Changed implicit behaviour of
  [`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md) and
  [`predict()`](https://rdrr.io/r/stats/predict.html) where `ci = TRUE`
  to explicit `ssd_hc(ci = FALSE)` and `predict(ci = FALSE)`.
- Replaced `shape` and `scale` arguments to `llog()` with `lshape` and
  `lscale`.
- Replaced `location` and `scale` arguments to `lgumbel()` with
  `llocation` and `lscale`.

### Major Features

- Added Burr Type-III Two-Parameter Distribution (`burrIII2`).
- Added
  [`ssd_hp()`](https://bcgov.github.io/ssdtools/reference/ssd_hp.md) to
  calculate hazard percent at specific concentrations.
- Added
  [`ssd_exposure()`](https://bcgov.github.io/ssdtools/reference/ssd_exposure.md)
  to calculate proportion exposed based on distribution of
  concentrations.
- Optimized [`predict()`](https://rdrr.io/r/stats/predict.html) and
  added parallel argument.
- Tidyverse style error and warning messages.

### Minor Features

- [`ssd_fit_dists()`](https://bcgov.github.io/ssdtools/reference/ssd_fit_dists.md)
  now checks if standard errors computable.
- Added Burr Type-III Three-Parameter Distribution (`burrIII3`).
- Added `sdist(x)` functionality to set starting values for
  distributions.
- Added
  [`ssd_plot_cdf()`](https://bcgov.github.io/ssdtools/reference/ssd_plot_cdf.md)
  to plot cumulative distribution function (equivalent to
  [`autoplot()`](https://ggplot2.tidyverse.org/reference/autoplot.html))
- [`nobs()`](https://rdrr.io/r/stats/nobs.html) for censored data now
  returns a missing value.
- Default
  [`ssd_fit_dists()`](https://bcgov.github.io/ssdtools/reference/ssd_fit_dists.md)
  distributions now ordered alphabetically.

### Deprecated

- Deprecated
  [`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md)
  argument `hc = 5L` for `percent = 5L`.
- Deprecated `dllog()` etc for `dllogis()`.
- Deprecated `ssd_cfplot()` for
  [`ssd_plot_cf()`](https://bcgov.github.io/ssdtools/reference/ssd_plot_cf.md).

### Bug Fixes

- Fixed `llog` distribution with small concentrations.
- Ensured concentrations below 1 have 1 significant figure in plots.

## ssdtools 0.0.3

CRAN release: 2018-11-25

- added citation
- Added ssdtools-manual vignette
- Changed predict() and ssd_hc() nboot argument from 1001 to 1000
- Added hc5_boron data object
- No longer export ssd_fit_dist() as ssd_fit_dists() renders redundant
- geom_hcintersect() now takes multiple values
- More information in DESCRIPTION
- Added CRAN badge
- Removed dependencies: dplyr, magrittr, plyr, purrr
- Moved from depends to imports: VGAM, fitdistrplus, graphics, ggplot,
  stats
- Moved from imports to suggests: tibble

## ssdtools 0.0.2

CRAN release: 2018-10-14

- Added contributors
- Added hex

## ssdtools 0.0.1

- Initial Release
