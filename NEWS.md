<!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->

- Added wt (Akaike weight) column to data frame returned by `predict()`, `ssd_hc()` and `ssd_hp()`.
- Allow mixture distribution functions to work with reversed modes.
- Now estimate bias corrected order statistic for each bootstrap sample.
- Correct bias in inverse Pareto scale order statistic.
- No longer correct for order statistic in invpareto.
- Added `method` column to HC and HP values to indicate whether CIs calculated using parametric or non-parametric bootstrap.
- Added `ssd_wqg_burrlioz()`.
- Added `ssd_hc_burrlioz()` to get hazard concentration for burrlioz approach.
- ssd_fit_burrlioz() now fits llogis if less than 8 samples.
- Added option for non-parametric bootstrap.
- Back to glm to get gompertz starting values
- gompertz now tries and then switches to default starting values.
- Added `ssd_plot_data()` to just plot data.
- Switching boron_data to ssddata::ccme_boron and switching to ssddata::ccme_data.
- hc5 to wqg
- Rename pxx() to ssd_pxx().
- qxx() to ssd_qxx().
- Added paralellization using futures.
- Added min_pboot to ssd_hc() and predict.fitdists().
- Added min_pboot to ssd_hc() to check for minimum proportion of bootstraps fitted.
- Added `ssd_hc5_bc()`.
- Added nboot and pboot to ssd_hp().
- Added nboot and pboot to hazard concentration to give proportion of boot strap samples that fitted.
- Added `ssd_fit_burrlioz()` to provide burrlioz functionality.
- Added at_boundary_ok to specifying whether a distribution with one or more parameters at a boundary has converged (by default FALSE).
- Used AIC for weights with censored data and same number of parameters.
- Added `min_pmix` argument to `ssd_fit_dists()`.
- Added delta to subset and implemented for ssd_hc, ssd_hp and predict.fitdist.
- Remove ic argument and add delta_aic argument.
- Removed demo, boron_lnorm, boron_dists data object and boron_data.csv.
- Add pvalue argument to get pvalue instead of statistics for ssd_gof().
- Added gof ad, cvm and ks p.values.
- Implement invpareto distribution.
- Removed invweibull distribution as identical to log-Gumbel.
- Switch shape to 3
- Added invweibull distribution.
- Added inverse pareto
- Added lnorm_lnorm mixture distribution.
- Fully implemented `llogis_llogis` distribution.
- Renamed mx_llogis_llogis to llogis_llogis.
- Implementing llogis_llogis.
- Update so not calculate CIs with unequally weighted data.
- Not calculate CIs with unequally weighted data.
- Distributions cannot currently be fitted to right censored data.
- Not calculate CIs if inconsistently censored data.
- Change `ssd_plot()` ylab from "Percent of Species Affected" to just "Species Affected".
- Added `ssd_data()` to extract data from fitdists object.
- Switch rescale = FALSE by default.
- Added `ssd_ecd_data()` to get empirical cumulative density for data.
- Added `ssd_sort_data()`.
- Added `orders = c(left = 1, right = 1)` argument to `ssd_plot()` to control order of magnitude above and below minimum recorded value.
- Added `scale_colour_ssd()` 8 color-blind scale.
- Added `ssd_pal()` 8 color-blind palette.
- `ssd_plot()` now plots all data using combination of two calls to `geom_ssdpoint()` for left and right and geom_ssdsegment() to allow for censoring. Alpha needs to be adjusted according.
- Soft deprecated `geom_ssd()` for `geom_ssdpoint()`.
- Soft deprecated `stat_ssd()`.
- Rename StatSsd to StatSsdpoint and GeomSsd to GeomSsdpoint.
- Rename GeomSSdcens to GeomSSdsegment and add arrows args.
- Rename stat_ssdcens() and geom_ssdcens() to stat_ssdsegment() and geom_ssdsegment().
- Added `stat_ssdcens()` and `geom_ssdcens()`.
- Deprecated `plot.fitdists()` for `autoplot.fitdists()`.
- Added type argument to `ssd_dists()`.
- Added summary for fitdists and tmbfit classes.
- Removed fluazinam.
- Added augment() function to get original data plus.
- data now attribute of fitdists.
- Added control list to `ssd_fit_dists()` and hc and hp.
- Added rescale argument to `ssd_fit_dists()`.
- Switched computable function to TRUE by default.
- Now checks that right is not less than left.
- Now ensures data left are no positive.
- Allow Inf weight but expect all models to fail to fit.
- 0 < weight <= 1000
- Checks for zero weight.
- Removed llog and burrII2 distributions as identical to llogis.
- ssd_fit_dists() errors if has one or more uninformative rows.
- Switched to optim with TMB.
- Make hc argument to `ssd_hc()` defunct.
- Remove warning about ci being switched from TRUE to FALSE.
- Made ssd_plot_cf() defunct and moved fitdistrplus to suggests.
- Made pareto distributional functions defunct.
- Added `ssd_dists()` which specifies permitted distributions.
- All soft-deprecated functions and arguments pre v0.3.0 now warn unconditionally.
- Soft-deprecate `ssd_plot_cf()` for `fitdistrplus::descdist()`.
- No longer export lnorm and weibull distributional functions.
- No longer export burrII2, burrIII3 and gamma distribution functions.
- Switched from fitdistrplus to TMB.
- Print tidy not glance.
- Print log_lik, aic etc instead of parameter values.
- readded burrIII3
- gompertz llocation and lshape to location and shape
- Switched gompertz from llocation and lshape to location and shape.
- added gamma
- move dist to first from last column for `sd_hc()` and `predict()`.
- Added glance() and logLik()
- Added logLik()
- npars() now orders by distribution name.


# ssdtools 0.3.4.9000

- Internal changes only.


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
