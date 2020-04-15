# ssdtools 0.2.0.9000

- Internal changes only.


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
