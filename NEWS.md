<!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->

# ssdtools 1.0.0

ssdtools is the first major release of ssdtools with some big improvements and breaking changes.

## Fitting

A major change to the functionality of `ssd_fit_dists()` was to switch from model fitting using [`fitdistrplus`](https://github.com/aursiber/fitdistrplus) to [`TMB`](https://github.com/kaskr/adcomp) for increased control.

As a result the `fitdists` objects returned by `ssd_fit_dists()` from previous versions of `ssdtools` are not compatible with the major release and should be regenerated.

### Distributions
  
Previously the density functions for the available distributions were exported as R functions to make them accessible to `fitdistrplus`. 
This meant that `ssdtools` had to be loaded to fit distributions (or estimate uncertainty in hazard concentrations/protections).
The density functions are now defined in C++ as TMB templates and no longer exported.

The distribution, quantile and random generation functions are still exported but are now prefixed by `ssd_` to prevent clashes with existing functions in other packages.
Thus for example `plnorm()`, `qlnorm()` and `rlnorm()` have been renamed `ssd_plnorm()`, `ssd_qlnorm()` and `ssd_rlnorm()`.

The following distributions were added (or in the case of `burrIII3` readded)

  - `burrIII3` - burrIII three parameter distribution
  - `invpareto` - inverse pareto (with bias correction in scale order statistic)
  - `lnorm_lnorm` log-normal/log-normal mixture distribution
  - `llogis_llogis` log-logistic/log-logistic mixture distribution
  
The following arguments were added to `ssd_fit_dists()`
  - `rescale` (by default `FALSE`) to specify whether to rescale concentrations values by dividing by the largest finite value.
  - `min_pmix` (by default 0.2) to specify the minimum proportion for a mixture distribution xx is it a bound.
  - `at_boundary_ok` (by default `FALSE`) to specifying whether a distribution with one or more parameters at a boundary has converged.
  - `range_shape1` (by default `c(0.05, 20)`) to specify the lower and uppper bounds for the shape1 parameter of the burrIII3 distribution.
  - `range_shape2` (by default the same as `range_shape2`) to specify the lower and uppper bounds for the shape2 parameter of the burrIII3 distribution.
  - `control` (by default an empty list) to pass a list of control parameters to `stats::optim()`.

And

  - the default value of the `computable` argument was switched from `FALSE` to `TRUE` to enforce stricter requirements on convergence.
  
In addition

  - `ssd_dists()` was added to specify subsets of the available distributions using `type` argument.
  - the `delta` argument (by default 7) was added to the `subset()` generic to only keep those distributions within the specified AIC difference of the best supported distribution.

#### Burrlioz

The function `ssd_fit_burrlioz()` (and `ssd_hc_burrlioz()`) was added to imitate the behavior of (Burrlioz)[https://research.csiro.au/software/burrlioz/].

## Hazard Concentration/Protection Estimation

Hazard concentration estimation is performed by `ssd_hc()` (which is called by `predict()`) and hazard protection estimation by `ssd_hp()`.
Confidence intervals are estimated by parametric bootstrapping.

To reduce the time required for bootstrapping, paralellization was implemented using the [future](https://github.com/HenrikBengtsson/future) package.

- Added the following arguments
  - `delta` (by default 7) to only keep those distributions within the specified AIC difference of the best supported distribution.
  - `min_pboot` (by default 0.99) to specify minimum proportion of bootstrap samples that must successfully fit.
  - `parametric` (by default `TRUE`) to allow non-parametric bootstrapping.
  - `control` (by default an empty list) to pass a list of control parameters to `stats::optim()`.

- Added following columns to output tibbles (and moved the `dist` column to the first position)
  - `wt` to specify the Akaike weight.
  - `method` to indicate whether parametric or non-parametric bootstrap was used.
  - `nboot` to indicate how many bootstrap samples were used.
  - `pboot` to indicate the proportion of bootstrap samples which fitted.
  
## Plotting

- Added `scale_colour_ssd()` (and `scale_color_ssd()`) 8 color-blind scale.
- Added `ssd_plot_data()` to just plot data.

- Soft-deprecated `ssd_plot_cf()` for `fitdistrplus::descdist()`.
- Deprecated `plot.fitdists()` for `autoplot.fitdists()`.
- Soft deprecated `geom_ssd()` for `geom_ssdpoint()`.
- Soft deprecated `stat_ssd()`.
- Added `orders = c(left = 1, right = 1)` argument to `ssd_plot()` to control order of magnitude above and below minimum recorded value.
- `ssd_plot()` now plots all data using combination of two calls to `geom_ssdpoint()` for left and right and `geom_ssdsegment()` to allow for censoring. Alpha needs to be adjusted according.
- Rename StatSsd to StatSsdpoint and GeomSsd to GeomSsdpoint.
- Rename GeomSSdcens to GeomSSdsegment and add arrows args.
- Rename stat_ssdcens() and geom_ssdcens() to stat_ssdsegment() and geom_ssdsegment().
- Added `stat_ssdcens()` and `geom_ssdcens()`.
- Change `ssd_plot()` ylab from "Percent of Species Affected" to just "Species Affected".
- Added `ssd_data()` to extract data from fitdists object.

## Goodness of Fit

Added `pvalue` argument (by default `FALSE`) to `ssd_gof()` to specify whether to return p-values for the test statistics as opposed to the test statistics themselves.

## Data

The dataset `boron_data` was renamed `ccme_boron` and moved to the [ssddata](https://github.com/open-AIMS/ssddata) R package together with the other CCME datasets.

## Miscellaneous

- Implemented the following generics
  - `glance()` to xx
  - `augment()` to return original data set.
  - `logLik()` to return the log-likelihood.
  - `summary.fitdists()` to summarise fitdists objects.
  
- `npars()` now orders by distribution name.


- All soft-deprecated functions and arguments pre v0.3.0 now warn unconditionally.

- Used AIC for weights with censored data and same number of parameters.
- Switch shape to 3
- Update so not calculate CIs with unequally weighted data.
- Not calculate CIs with unequally weighted data.
- Distributions cannot currently be fitted to right censored data.
- Not calculate CIs if inconsistently censored data.

- Added `ssd_ecd_data()` to get empirical cumulative density for data.
- Added `ssd_sort_data()`.

- 0 < weight <= 1000
- Checks for zero weight.
- ssd_fit_dists() errors if has one or more uninformative rows.

# ssdtools 0.3.4

- Update Apache Licence url to https.

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
