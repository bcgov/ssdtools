<!-- NEWS.md is maintained by https://fledge.cynkra.com, contributors should not edit this file -->

# ssdtools 2.2.0

- Added `ssd_label_comma_hc()` function to label numbers with significant digits and comma and offset hazard concentration value if present in breaks.
- For `plot_coord_scale()` function:
  - Added `x_limits = NULL` to allow setting of x-axis limits.
  - Added `hc_value = NULL` to pass hazard concentration value.
  - Restricted `trans` argument to `"identity"`, `"log10"` or "`log`".
- For `ssd_plot()` function:
  - Added `text_size` argument.
  - Soft-deprecated `size` argument for `label_size`.

# ssdtools 2.1.0

- Added `ssd_xxmulti_fitdists()` family of functions (`ssd_rmulti_fitdists()`, `ssd_pmulti_fitdists()` and `ssd_qmulti_fitdists()`) to accept object of class `fitdists`.
- Set `lnorm.weight = 1` instead of `1` in the `ssd_xxmulti()` family of functions (`ssd_rmulti()`, `ssd_pmulti()` and `ssd_qmulti`) to avoid incorrect values with `do.call("ssd_xxmulti", c(..., estimates(fits))` if `fits` does not include the log-normal distribution.


# ssdtools 2.0.0

`ssdtools` v2.0.0, which now includes David Fox and Rebecca Fisher as co-authors, is the second major release of `ssdtools`.

## Major Changes

The following changes are major in the sense that they could alter previous hazard concentrations or break code.

### Model Fitting and Averaging

#### Modifications

The following arguments were added to `ssd_hc()` and `ssd_hp()`

- `multi_est = TRUE` to calculate model averaged estimates treating the distributions as constituting a single mixture distribution (previously it was effectively `FALSE`).
- `method_ci = "weighted_samples"` to specify whether to use `"weighted_samples"`, `"weighted_arithmetic"`, `"multi_free"` or `"multi_fixed"` methods to generate confidence intervals (previously it was effectively `"weighted_arithmetic"`).

In addition the data frame returned by `ssd_hc()` and `predict()` now includes a column `proportion` with values between 0 and 1 as opposed to a column `percentage` with between 0 and 100.

Finally, with censored data confidence intervals can now only be estimated by non-parametric bootstrapping as the methods of parametrically bootstrapping censored data require review.

## Minor Changes

The remaining changes are minor.

### Model Fitting

#### Modifications

The following arguments of `ssd_fit_dists()` were changed to reduce the chances of the `lnorm_lnorm` bimodal distribution being dropped from the default set:

- `min_pmix = ssd_min_pmix(nrow(data))` so that by default `min_pmix` is 0.1 or `3/nrow(data)` if greater.
- `at_boundary_ok = TRUE`.
- `computable = TRUE`.

These changes also allowed the `min_pboot = 0.95` argument to be changed from `0.80` for all bootstrapping functions.

It is worth noting that the second two changes also reduce the chances of the BurrIII distribution being dropped.

In addition `rescale = TRUE` now divides by the geometric mean of the minimum and maximum positive finite values as opposed to dividing by the geometric mean of the maximum finite value to improve the chances of convergence although `ssd_fit_bcanz()` no longer rescales by default.

Other minor modifications to the model fitting functions include

- `estimates.fitdists()` now includes weights in returned parameters as well as an `all_estimates = FALSE` argument to allow parameter values for all implemented distributions to be included.
- `delta = 7` instead of `delta = 9.21` to ensure weight of included models at least 0.01.
- seeds are now allocated to bootstrap samples as opposed to distributions (which results in a speed gain when there are more cores than the number of distributions). 
- `lnorm` and `gompertz` initial values are offset from their maximum likelihood estimates to avoid errors in `optim()`.

The following functions and arguments were also added:

- `ssd_hp_bcanz()` and `ssd_hp.fitburrlioz()` to get hazard proportions.
- `ssd_pmulti()`, `ssd_qmulti()` and `ssd_rmulti()` for combined mixture distributions.
- `ssd_exx()` family of functions (i.e. `ssd_elnorm()`, `ssd_egamma()` etc) to get default parameter estimates for distributions.
- `ssd_censor_data()` to censor data. 
- `npars = c(2L, 5L)` argument to `ssd_dists_bcanz()` to specify the number of parameters.
- `dists = ssd_dists_bcanz()` to `ssd_fit_bcanz()` to allow other packages to modify.
- `samples = FALSE` to `ssd_hc()` and `ssd_hp()` include bootstrap samples as list of numeric vector(s).
- `save_to = NULL` to `ssd_hc()` and `ssd_hp()` to specify a directory in which to save the bootstrap datasets as csv files and parameter estimates as .rds files. 

#### Fixes

- `ssd_hc()` and `ssd_hp()` now return data frame with `parametric` column.
- `ssd_hp()` now return data frame with `wt` column.

#### Deprecations

The following functions and arguments were deprecated:

- `ssd_wqg_bc()` and `ssd_wqg_burrlioz()` were deprecated.
- `percent = 5` in `ssd_hc()` and `predict()` was soft-deprecated for `proportion = 0.05`.
- `is_censored()` is now defunct.

### Plotting

Perhaps the biggest plotting change is that `ssd_plot_cdf()` now plots the average SSD together with the individual distributions if `average = NA`. 

In addition, the following functions and arguments were added.

- `scale_fill_ssd()` for color-blind fill scale.
- `ssd_label_comma()` for formatting of x-axis labels.
- `trans = "log10"` and `add_x = 0` to `ssd_plot()` and `ssd_plot_data()` to control x-axis scale.
- `big.mark = ","` for x-axis labels and `suffix = "%"` for y-axis labels to all plotting functions.

and the following functions deprecated

- `comma_signif()` was soft-deprecated.
- `is_censored()`, `plot.fitdists()`, `ssd_plot_cf()` `geom_ssd()` and `stat_ssd()` are now defunct.

### Data

The following data sets were removed

- `ccme_data` and `ccme_boron` (available in `ssddata` package).
- `pearson1000` data set.


# ssdtools 1.0.6

- Fix CRAN ATLAS error


# ssdtools 1.0.5

- Stopped predict and hc/hp test errors on linux.


# ssdtools 1.0.4

- Added contributors.
- Now tests table values to 6 significant figures.
- Fixed bug that was not preserving NaN (returning NA_real_) for cumulative distribution and quantile functions.


# ssdtools 1.0.3

- Replaced `size = 0.5` with `linewidth = 0.5` in `geom_hcintersect()` and `geom_xribbon()`.
- Replaced `aes_string()` with `aes()` in examples (and internally).
- Removed use of `tidyverse` package.
- Now tests values to 12 significant digits.
- Fixed description of `ssd_hp()` to be percent affected rather than percent protected.


# ssdtools 1.0.2

- Fixed bug that was producing estimates of 0 for lower HCx values for log-normal mixture model with rescaled data spanning many orders of magnitude.


# ssdtools 1.0.1

- Added `delta = 7` argument to `ssd_plot_cdf()`.


# ssdtools 1.0.0

ssdtools version 1.0.0 is the first major release of `ssdtools` with some important improvements and breaking changes.

## Fitting

An important change to the functionality of `ssd_fit_dists()` was to switch from model fitting using [`fitdistrplus`](https://github.com/lbbe-software/fitdistrplus) to [`TMB`](https://github.com/kaskr/adcomp) to allow full control over model specification as well as improved handling of censored data.
The change is internal and does not directly affect the user interface.
Although it was hoped that model fitting would be faster this is currently not the case.

As a result of the change the `fitdists` objects returned by `ssd_fit_dists()` from previous versions of `ssdtools` are not compatible with the major release and should be regenerated.

## BCANZ

As a result of an international collaboration British Columbia and Canada and Australia and New Zealand selected a set of recommended distributions for model averaging and settings when generating final guidelines.

The distributions are
```{r}
> ssd_dists_bcanz()
[1] "gamma"       "lgumbel"     "llogis"      "lnorm"       "lnorm_lnorm" "weibull" 
```

The `ssd_fit_bcanz()` and `ssd_hc_bcanz()` functions were added to the package to facilitate the fitting of these distributions and estimation of hazard concentrations using the recommended settings.

### Convergence

In the previous version of `ssdtools` a distribution was considered to have converged if the following condition was met

1) `stats::optim()` returns a code of 0 (indicating successful completion).

In the new version an additional two conditions must also be met

2) Bounded parameters are not at a boundary (this condition can be turned off by setting `at_boundary_ok = TRUE` or the user can specify different boundary values - see below)
3) Standard errors are computable for all the parameter values (this condition can be turned off by setting `computable = FALSE`)

### Censored Data

Censoring can now be specified by providing a data set with one or more rows that have

- a finite value for the left column that is smaller than the finite value in the right column (interval censored)
- a zero or missing value for the left column and a finite value for the right column (left censored)

It is currently not possible to fit distributions to data sets that have

- a infinite or missing value for the right column and a finite value for the left column (right censored)

Rows that have a zero or missing value for the left column and an infinite or missing value for the right column (fully censored) are uninformative and will result in an error.

#### Akaike Weights

For uncensored data, Akaike Weights are calculated using AICc (which corrects for small sample size).
In the case of censored data, Akaike Weights are calculated using AIC (as the sample size cannot be estimated) but only if all the distributions have the same number of parameters (to ensure the weights are valid).

### Weighted Data

Weighting must be positive with values <= 1000.

### Distributions
  
Previously the density functions for the available distributions were exported as R functions to make them accessible to `fitdistrplus`. 
This meant that `ssdtools` had to be loaded to fit distributions.
The density functions are now defined in C++ as TMB templates and are no longer exported.

The distribution, quantile and random generation functions are more generally useful and are still exported but are now prefixed by `ssd_` to prevent clashes with existing functions in other packages.
Thus for example `plnorm()`, `qlnorm()` and `rlnorm()` have been renamed `ssd_plnorm()`, `ssd_qlnorm()` and `ssd_rlnorm()`.

The following distributions were added (or in the case of `burrIII3` readded) to the new version

  - `burrIII3` - burrIII three parameter distribution
  - `invpareto` - inverse pareto (with bias correction in scale order statistic)
  - `lnorm_lnorm` log-normal/log-normal mixture distribution
  - `llogis_llogis` log-logistic/log-logistic mixture distribution
  
The following arguments were added to `ssd_fit_dists()`

  - `rescale` (by default `FALSE`) to specify whether to rescale concentrations values by dividing by the largest (finite) value. This alters the parameter estimates, which can help some distributions converge, but not the estimates of the hazard concentrations/protections.
  - `reweight` (by default `FALSE`) to specify whether to reweight data points by dividing by the largest weight.
  - `at_boundary_ok` (by default `FALSE`) to specifying whether a distribution with one or more parameters at a boundary has converged.
  - `min_pmix` (by default 0) to specify the boundary for the minimum proportion for a mixture distribution.
  - `range_shape1` (by default `c(0.05, 20)`) to specify the lower and upper boundaries for the shape1 parameter of the burrIII3 distribution.
  - `range_shape2` (by default the same as `range_shape2`) to specify the lower and upper boundaries for the shape2 parameter of the burrIII3 distribution.
  - `control` (by default an empty list) to pass a list of control parameters to `stats::optim()`.

It also worth noting that the default value of 

  - `computable` argument was switched from `FALSE` to `TRUE` to enforce stricter requirements on convergence (see above).

#### Subsets of Distributions

The following were added to handle multiple distributions

  - `ssd_dists()` to specify subsets of the available distributions.
  - `delta` argument (by default 7) to the `subset()` generic to only keep those distributions within the specified AIC(c) difference of the best supported distribution.

### Burrlioz

The function `ssd_fit_burrlioz()` was added to approximate the behaviour of [Burrlioz](https://research.csiro.au/software/burrlioz/).

## Hazard Concentration/Protection Estimation

Hazard concentration estimation is performed by `ssd_hc()` (which is wrapped by `predict()`) and hazard protection estimation by `ssd_hp()`.
By default confidence intervals are estimated by parametric bootstrapping.

To reduce the time required for bootstrapping, parallelization was implemented using the [future](https://github.com/HenrikBengtsson/future) package.

The following arguments were added to `ssd_hc()` and `ssd_hp()`

  - `delta` (by default 7) to only keep those distributions within the specified AIC difference of the best supported distribution.
  - `min_pboot` (by default 0.90) to specify minimum proportion of bootstrap samples that must successfully fit.
  - `parametric` (by default `TRUE`) to allow non-parametric bootstrapping.
  - `control` (by default an empty list) to pass a list of control parameters to `stats::optim()`.

and the following columns were added to the output data frame

  - `wt` to specify the Akaike weight.
  - `method` to indicate whether parametric or non-parametric bootstrap was used.
  - `nboot` to indicate how many bootstrap samples were used.
  - `pboot` to indicate the proportion of bootstrap samples which fitted.
  
It also worth noting that the 

  - `dist` column was moved from the last to the first position in the output data frame.
  
### Censored Data

Confidence intervals cannot be estimated for interval censored data.

### Weighted Data

Confidence intervals cannot be estimated for unequally weighted data.

## Goodness of Fit

The `pvalue` argument (by default `FALSE`) was added to `ssd_gof()` to specify whether to return p-values for the test statistics as opposed to the test statistics themselves.

## Plotting

There have also been some substantive changes to the plotting functionality.

Added following functions

  - `ssd_plot_data()` to plot censored and uncensored data by calling `geom_ssdpoint()` for the left and for the right column (alpha parameter values should be adjusted accordingly)
  - `geom_ssdsegment()` to allow plotting of the range of a censored data points using segments.
  - `scale_colour_ssd()` (and `scale_color_ssd()`) to provide an 8 color-blind scale.
  
Made the following changes to `ssd_plot()`

  - added `bounds` (by default `c(left = 1, right = 1)`) argument specify how many orders of magnitude to extend the plot beyond the minimum and maximum (non-missing) values.
  - added `linetype` (by default `NULL`) argument to specify line type.
  - added `linecolor` (by default `NULL`) argument to specify line color.
  - changed default value of `ylab` from "Percent of Species Affected" to "Species Affected".

Renamed 
  - `GeomSsd` to `GeomSsdpoint`.
  - `StatSsd` to `StatSsdpoint`

Soft-deprecated
  - `geom_ssd()` for `geom_ssdpoint()`.
  - `stat_ssd()`.
  - `ssd_plot_cf()` for `fitdistrplus::descdist()`.

## Data

### `ssddata`

The dataset `boron_data` was renamed `ccme_boron` and moved to the [`ssddata`](https://github.com/open-AIMS/ssddata) R package together with the other CCME datasets.

The `ssddata` package provides a suite of datasets for testing and comparing species sensitivity distribution fitting software.

### Data Handling Functions

Added 

- `ssd_data()` to return original data for a `fitdists` object.
- `ssd_ecd_data()` to get empirical cumulative density for data.
- `ssd_sort_data()` to sort data by empirical cumulative density.

## Miscellaneous

- `npars()` now orders by distribution name.
- All functions and arguments that were soft-deprecated prior to v0.3.0 now warn unconditionally.

### Generics

- Implemented the following generics for `fitdists` objects

  - `glance()` to get the model likelihoods, information-theoretic criteria etc.
  - `augment()` to return original data set.
  - `logLik()` to return the log-likelihood.
  - `summary.fitdists()` to summarize.
  

# ssdtools 0.3.7.9000

- Same as previous version.


# ssdtools 0.3.7

- fix unequal indentation of Rmd ```


# ssdtools 0.3.6

- Added `wt` (Akaike weight) column to `predict()`, `ssd_hc()` and `ssd_hp()`
- Deprecated argument `ic` to `predict()`, `ssd_hc()` and `ssd_hp()` because unused.
- Silenced output from `ssd_fit_dists()`.


# ssdtools 0.3.5

- Bump requirement to R >= 4.1 because of `actuar` package.


# ssdtools 0.3.4

- Update Apache License url to https.

# ssdtools 0.3.3

- Increased requirement that R >= 3.5 due to VGAM.
- Modified `comma_signif()` so that now rounds to 3 significant digits by default and only applies `scales::comma()` to values >= 1000.
- Soft-deprecated the `...` argument to `comma_signif()`.

# ssdtools 0.3.2

- Fix moved URLs.

# ssdtools 0.3.1

- Internal changes only.

# ssdtools 0.3.0

## Breaking Changes

- Soft-deprecated 'burrIII3' distribution as poorly defined.
- Soft-deprecated 'pareto' distribution as poor fit on SSD data.

## Major Changes

- Reparameterized 'llogis' distribution in terms of locationlog and scalelog.
- Reparameterized 'burrIII3' distribution in terms of lshape1, lshape2 and lscale.
- Reparamaterized 'burrIII2' distribution in terms of locationlog and scalelog.
- Reparamaterized 'lgumbel' distribution in terms of locationlog and scalelog.
- Reparamaterized 'gompertz' distribution in terms of llocation and lshape.
- Standardized handling of arguments for d,p,q,r and s functions for distributions.

## Minor Changes

- `rdist()` functions now use length of n if `length(n) > 1`.
- Added `slnorm()` to get starting values for 'dlnorm' distribution.

## Internal Changes

- Switch to C++ implementation for distributions.

# ssdtools 0.2.0

## Breaking Changes

- Changed computable (whether standard errors must be computable to be considered to have converged) to FALSE by default.
- Enforces only one of 'llogis', 'llog' or 'burrIII2' in all sets (as identical).

## Major Changes

- Deprecated 'burrIII2' for 'llogis' as identical.
- Replaced 'burrIII2' for (identical) 'llogis' in default set.
- Fixed bug in `rllog()` that was causing error.
- Fixed parameterisation of 'lgumbel' that was causing it to fail to fit with some data.

## Minor Changes

- Provides warning message about change in default for ci argument in predict function.
- Only gives warning about standard errors not being computable if computable = TRUE.
- Uses tibble package to create tibbles.
- Removed dependency on checkr.

# ssdtools 0.1.1

- Fix test for CRAN R 3.5

# ssdtools 0.1.0

## Breaking Changes

- Default distributions changed to 'burrIII2', 'gamma' and 'lnorm' from
'gamma', 'gompertz', 'lgumbel', 'llog', 'lnorm' and 'weibull'.
- Changed implicit behaviour of `ssd_hc()` and `predict()` where `ci = TRUE` to explicit `ssd_hc(ci = FALSE)` and `predict(ci = FALSE)`.
- Replaced `shape` and `scale` arguments to `llog()` with `lshape` and `lscale`.
- Replaced `location` and `scale` arguments to `lgumbel()` with `llocation` and `lscale`.

## Major Features

- Added Burr Type-III Two-Parameter Distribution (`burrIII2`).
- Added `ssd_hp()` to calculate hazard percent at specific concentrations.
- Added `ssd_exposure()` to calculate proportion exposed based on distribution of concentrations.
- Optimized `predict()` and added parallel argument.
- Tidyverse style error and warning messages.

## Minor Features

- `ssd_fit_dists()` now checks if standard errors computable.
- Added Burr Type-III Three-Parameter Distribution (`burrIII3`).
- Added `sdist(x)` functionality to set starting values for distributions.
- Added `ssd_plot_cdf()` to plot cumulative distribution function (equivalent to `autoplot()`)
- `nobs()` for censored data now returns a missing value.
- Default `ssd_fit_dists()` distributions now ordered alphabetically.

## Deprecated

- Deprecated `ssd_hc()` argument `hc = 5L` for `percent = 5L`.
- Deprecated `dllog()` etc for `dllogis()`.
- Deprecated `ssd_cfplot()` for `ssd_plot_cf()`.

## Bug Fixes

- Fixed `llog` distribution with small concentrations.
- Ensured concentrations below 1 have 1 significant figure in plots.

# ssdtools 0.0.3

- added citation
- Added ssdtools-manual vignette
- Changed predict() and ssd_hc() nboot argument from 1001 to 1000
- Added hc5_boron data object
- No longer export ssd_fit_dist() as ssd_fit_dists() renders redundant
- geom_hcintersect() now takes multiple values
- More information in DESCRIPTION
- Added CRAN badge
- Removed dependencies: dplyr, magrittr, plyr, purrr
- Moved from depends to imports: VGAM, fitdistrplus, graphics, ggplot, stats
- Moved from imports to suggests: tibble

# ssdtools 0.0.2

- Added contributors
- Added hex

# ssdtools 0.0.1

- Initial Release
