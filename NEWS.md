- Added `ssd_plot_cdf()` to plot cumulative distribution function.
- Deprecated `ssd_cfplot()` for `ssd_plot_cf()`.
- Optimized `predict()` and added parallel argument.
- Fix llog distribution with small concentrations.
- Ensure concentrations below 1 have 1 significant figure in plots
- Default ssd_fit_dists distributions now ordered alphabetically

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
