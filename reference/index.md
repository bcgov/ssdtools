# Package index

## Distribution Names

Functions that return character vectors of distribution names

- [`ssd_dists()`](https://bcgov.github.io/ssdtools/reference/ssd_dists.md)
  : Species Sensitivity Distributions
- [`ssd_dists_all()`](https://bcgov.github.io/ssdtools/reference/ssd_dists_all.md)
  : All Species Sensitivity Distributions
- [`ssd_dists_bcanz()`](https://bcgov.github.io/ssdtools/reference/ssd_dists_bcanz.md)
  : BCANZ Distributions
- [`ssd_dists_shiny()`](https://bcgov.github.io/ssdtools/reference/ssd_dists_shiny.md)
  : All Shiny Species Sensitivity Distributions

## Fit

Functions that fit distributions to data

- [`ssd_fit_dists()`](https://bcgov.github.io/ssdtools/reference/ssd_fit_dists.md)
  : Fit Distributions
- [`ssd_fit_bcanz()`](https://bcgov.github.io/ssdtools/reference/ssd_fit_bcanz.md)
  : Fit BCANZ Distributions
- [`ssd_fit_burrlioz()`](https://bcgov.github.io/ssdtools/reference/ssd_fit_burrlioz.md)
  : Fit Burrlioz Distributions

## Hazard Concentrations and Proportions

Functions that calculate hazard concentrations and Proportions

- [`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md) :
  Hazard Concentrations for Species Sensitivity Distributions
- [`ssd_hc_bcanz()`](https://bcgov.github.io/ssdtools/reference/ssd_hc_bcanz.md)
  : BCANZ Hazard Concentrations
- [`ssd_hp()`](https://bcgov.github.io/ssdtools/reference/ssd_hp.md) :
  Hazard Proportion
- [`ssd_hp_bcanz()`](https://bcgov.github.io/ssdtools/reference/ssd_hp_bcanz.md)
  : BCANZ Hazard Proportion

## Manipulate Data

Functions that manipulate data

- [`ssd_censor_data()`](https://bcgov.github.io/ssdtools/reference/ssd_censor_data.md)
  : Censor Data
- [`ssd_data()`](https://bcgov.github.io/ssdtools/reference/ssd_data.md)
  : Data from fitdists Object
- [`ssd_sort_data()`](https://bcgov.github.io/ssdtools/reference/ssd_sort_data.md)
  : Sort Species Sensitivity Data

## Manipulate Fits

Functions that manipulate fits of distributions

- [`augment(`*`<fitdists>`*`)`](https://bcgov.github.io/ssdtools/reference/augment.fitdists.md)
  : Augmented Data from fitdists Object
- [`coef(`*`<fitdists>`*`)`](https://bcgov.github.io/ssdtools/reference/coef.fitdists.md)
  : Turn a fitdists Object into a Tidy Tibble
- [`estimates(`*`<fitdists>`*`)`](https://bcgov.github.io/ssdtools/reference/estimates.fitdists.md)
  : Estimates for fitdists Object
- [`glance(`*`<fitdists>`*`)`](https://bcgov.github.io/ssdtools/reference/glance.fitdists.md)
  : Get a tibble summarizing each distribution
- [`predict(`*`<fitburrlioz>`*`)`](https://bcgov.github.io/ssdtools/reference/predict.fitburrlioz.md)
  : Predict Hazard Concentrations of fitburrlioz Object
- [`predict(`*`<fitdists>`*`)`](https://bcgov.github.io/ssdtools/reference/predict.fitdists.md)
  : Predict Hazard Concentrations of fitdists Object
- [`ssd_gof()`](https://bcgov.github.io/ssdtools/reference/ssd_gof.md) :
  Goodness of Fit
- [`subset(`*`<fitdists>`*`)`](https://bcgov.github.io/ssdtools/reference/subset.fitdists.md)
  : Subset fitdists Object
- [`tidy(`*`<fitdists>`*`)`](https://bcgov.github.io/ssdtools/reference/tidy.fitdists.md)
  : Turn a fitdists Object into a Tibble

## Plots

Functions to Generate Plots

- [`autoplot(`*`<fitdists>`*`)`](https://bcgov.github.io/ssdtools/reference/autoplot.fitdists.md)
  : Plot a fitdists Object

- [`geom_hcintersect()`](https://bcgov.github.io/ssdtools/reference/geom_hcintersect.md)
  : Species Sensitivity Hazard Concentration Intersection

- [`geom_ssdpoint()`](https://bcgov.github.io/ssdtools/reference/geom_ssdpoint.md)
  : Species Sensitivity Data Points

- [`geom_ssdsegment()`](https://bcgov.github.io/ssdtools/reference/geom_ssdsegment.md)
  : Species Sensitivity Censored Segments

- [`geom_xribbon()`](https://bcgov.github.io/ssdtools/reference/geom_xribbon.md)
  : Ribbon on X-Axis

- [`scale_colour_ssd()`](https://bcgov.github.io/ssdtools/reference/scale_colour_ssd.md)
  [`scale_color_ssd()`](https://bcgov.github.io/ssdtools/reference/scale_colour_ssd.md)
  [`scale_fill_ssd()`](https://bcgov.github.io/ssdtools/reference/scale_colour_ssd.md)
  : Discrete color-blind scale for SSD Plots

- [`ssd_label_comma()`](https://bcgov.github.io/ssdtools/reference/ssd_label_comma.md)
  : Label numbers with significant digits and comma

- [`ssd_label_comma_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_label_comma_hc.md)
  :

  Label numbers with significant digits and comma. If `hc_value` is
  present in breaks, put on new line and make bold.

- [`ssd_pal()`](https://bcgov.github.io/ssdtools/reference/ssd_pal.md) :
  Color-blind Palette for SSD Plots

- [`ssd_plot()`](https://bcgov.github.io/ssdtools/reference/ssd_plot.md)
  : Plot Species Sensitivity Data and Distributions

- [`ssd_plot_cdf()`](https://bcgov.github.io/ssdtools/reference/ssd_plot_cdf.md)
  : Plot Cumulative Distribution Function (CDF)

- [`ssd_plot_data()`](https://bcgov.github.io/ssdtools/reference/ssd_plot_data.md)
  : Plot Species Sensitivity Data

- [`StatSsdpoint`](https://bcgov.github.io/ssdtools/reference/ssdtools-ggproto.md)
  [`StatSsdsegment`](https://bcgov.github.io/ssdtools/reference/ssdtools-ggproto.md)
  [`GeomSsdpoint`](https://bcgov.github.io/ssdtools/reference/ssdtools-ggproto.md)
  [`GeomSsdsegment`](https://bcgov.github.io/ssdtools/reference/ssdtools-ggproto.md)
  [`GeomHcintersect`](https://bcgov.github.io/ssdtools/reference/ssdtools-ggproto.md)
  [`GeomXribbon`](https://bcgov.github.io/ssdtools/reference/ssdtools-ggproto.md)
  : ggproto Classes for Plotting Species Sensitivity Data and
  Distributions

## Distributional Functions

Distribution, quantile, random functions

- [`ssd_pburrIII3()`](https://bcgov.github.io/ssdtools/reference/ssd_p.md)
  [`ssd_pgamma()`](https://bcgov.github.io/ssdtools/reference/ssd_p.md)
  [`ssd_pgompertz()`](https://bcgov.github.io/ssdtools/reference/ssd_p.md)
  [`ssd_pinvpareto()`](https://bcgov.github.io/ssdtools/reference/ssd_p.md)
  [`ssd_plgumbel()`](https://bcgov.github.io/ssdtools/reference/ssd_p.md)
  [`ssd_pllogis_llogis()`](https://bcgov.github.io/ssdtools/reference/ssd_p.md)
  [`ssd_pllogis()`](https://bcgov.github.io/ssdtools/reference/ssd_p.md)
  [`ssd_plnorm_lnorm()`](https://bcgov.github.io/ssdtools/reference/ssd_p.md)
  [`ssd_plnorm()`](https://bcgov.github.io/ssdtools/reference/ssd_p.md)
  [`ssd_pmulti()`](https://bcgov.github.io/ssdtools/reference/ssd_p.md)
  [`ssd_pmulti_fitdists()`](https://bcgov.github.io/ssdtools/reference/ssd_p.md)
  [`ssd_pweibull()`](https://bcgov.github.io/ssdtools/reference/ssd_p.md)
  : Cumulative Distribution Function
- [`ssd_qburrIII3()`](https://bcgov.github.io/ssdtools/reference/ssd_q.md)
  [`ssd_qgamma()`](https://bcgov.github.io/ssdtools/reference/ssd_q.md)
  [`ssd_qgompertz()`](https://bcgov.github.io/ssdtools/reference/ssd_q.md)
  [`ssd_qinvpareto()`](https://bcgov.github.io/ssdtools/reference/ssd_q.md)
  [`ssd_qlgumbel()`](https://bcgov.github.io/ssdtools/reference/ssd_q.md)
  [`ssd_qllogis_llogis()`](https://bcgov.github.io/ssdtools/reference/ssd_q.md)
  [`ssd_qllogis()`](https://bcgov.github.io/ssdtools/reference/ssd_q.md)
  [`ssd_qlnorm_lnorm()`](https://bcgov.github.io/ssdtools/reference/ssd_q.md)
  [`ssd_qlnorm()`](https://bcgov.github.io/ssdtools/reference/ssd_q.md)
  [`ssd_qmulti()`](https://bcgov.github.io/ssdtools/reference/ssd_q.md)
  [`ssd_qmulti_fitdists()`](https://bcgov.github.io/ssdtools/reference/ssd_q.md)
  [`ssd_qweibull()`](https://bcgov.github.io/ssdtools/reference/ssd_q.md)
  : Quantile Function
- [`ssd_rburrIII3()`](https://bcgov.github.io/ssdtools/reference/ssd_r.md)
  [`ssd_rgamma()`](https://bcgov.github.io/ssdtools/reference/ssd_r.md)
  [`ssd_rgompertz()`](https://bcgov.github.io/ssdtools/reference/ssd_r.md)
  [`ssd_rinvpareto()`](https://bcgov.github.io/ssdtools/reference/ssd_r.md)
  [`ssd_rlgumbel()`](https://bcgov.github.io/ssdtools/reference/ssd_r.md)
  [`ssd_rllogis_llogis()`](https://bcgov.github.io/ssdtools/reference/ssd_r.md)
  [`ssd_rllogis()`](https://bcgov.github.io/ssdtools/reference/ssd_r.md)
  [`ssd_rlnorm_lnorm()`](https://bcgov.github.io/ssdtools/reference/ssd_r.md)
  [`ssd_rlnorm()`](https://bcgov.github.io/ssdtools/reference/ssd_r.md)
  [`ssd_rmulti()`](https://bcgov.github.io/ssdtools/reference/ssd_r.md)
  [`ssd_rmulti_fitdists()`](https://bcgov.github.io/ssdtools/reference/ssd_r.md)
  [`ssd_rweibull()`](https://bcgov.github.io/ssdtools/reference/ssd_r.md)
  : Random Number Generation
- [`ssd_eburrIII3()`](https://bcgov.github.io/ssdtools/reference/ssd_e.md)
  [`ssd_egamma()`](https://bcgov.github.io/ssdtools/reference/ssd_e.md)
  [`ssd_egompertz()`](https://bcgov.github.io/ssdtools/reference/ssd_e.md)
  [`ssd_einvpareto()`](https://bcgov.github.io/ssdtools/reference/ssd_e.md)
  [`ssd_elgumbel()`](https://bcgov.github.io/ssdtools/reference/ssd_e.md)
  [`ssd_ellogis_llogis()`](https://bcgov.github.io/ssdtools/reference/ssd_e.md)
  [`ssd_ellogis()`](https://bcgov.github.io/ssdtools/reference/ssd_e.md)
  [`ssd_elnorm_lnorm()`](https://bcgov.github.io/ssdtools/reference/ssd_e.md)
  [`ssd_elnorm()`](https://bcgov.github.io/ssdtools/reference/ssd_e.md)
  [`ssd_emulti()`](https://bcgov.github.io/ssdtools/reference/ssd_e.md)
  [`ssd_eweibull()`](https://bcgov.github.io/ssdtools/reference/ssd_e.md)
  : Default Parameter Estimates

## Miscellaneous

Miscellaneous functions and data

- [`boron_pred`](https://bcgov.github.io/ssdtools/reference/boron_pred.md)
  : Model Averaged Predictions for CCME Boron Data
- [`dist_data`](https://bcgov.github.io/ssdtools/reference/dist_data.md)
  : Distribution Data
- [`is.fitdists()`](https://bcgov.github.io/ssdtools/reference/is.fitdists.md)
  : Is fitdists Object
- [`ssd_licensing_md()`](https://bcgov.github.io/ssdtools/reference/ssd_licensing_md.md)
  : Licensing Markdown
- [`reexports`](https://bcgov.github.io/ssdtools/reference/reexports.md)
  [`augment`](https://bcgov.github.io/ssdtools/reference/reexports.md)
  [`autoplot`](https://bcgov.github.io/ssdtools/reference/reexports.md)
  [`coef`](https://bcgov.github.io/ssdtools/reference/reexports.md)
  [`estimates`](https://bcgov.github.io/ssdtools/reference/reexports.md)
  [`glance`](https://bcgov.github.io/ssdtools/reference/reexports.md)
  [`logLik`](https://bcgov.github.io/ssdtools/reference/reexports.md)
  [`nobs`](https://bcgov.github.io/ssdtools/reference/reexports.md)
  [`npars`](https://bcgov.github.io/ssdtools/reference/reexports.md)
  [`plot`](https://bcgov.github.io/ssdtools/reference/reexports.md)
  [`predict`](https://bcgov.github.io/ssdtools/reference/reexports.md)
  [`waiver`](https://bcgov.github.io/ssdtools/reference/reexports.md)
  [`tidy`](https://bcgov.github.io/ssdtools/reference/reexports.md) :
  Objects exported from other packages
- [`params`](https://bcgov.github.io/ssdtools/reference/params.md)
  [`parameters`](https://bcgov.github.io/ssdtools/reference/params.md)
  [`arguments`](https://bcgov.github.io/ssdtools/reference/params.md)
  [`args`](https://bcgov.github.io/ssdtools/reference/params.md) :
  Parameter Descriptions for ssdtools Functions
- [`ssd_at_boundary()`](https://bcgov.github.io/ssdtools/reference/ssd_at_boundary.md)
  : Is At Boundary
- [`ssd_ci_methods()`](https://bcgov.github.io/ssdtools/reference/ssd_ci_methods.md)
  : Confidence Interval Methods for SSDs
- [`ssd_computable()`](https://bcgov.github.io/ssdtools/reference/ssd_computable.md)
  : Is Computable Standard Errors
- [`ssd_ecd()`](https://bcgov.github.io/ssdtools/reference/ssd_ecd.md) :
  Empirical Cumulative Density
- [`ssd_ecd_data()`](https://bcgov.github.io/ssdtools/reference/ssd_ecd_data.md)
  : Empirical Cumulative Density for Species Sensitivity Data
- [`ssd_est_methods()`](https://bcgov.github.io/ssdtools/reference/ssd_est_methods.md)
  : Estimate Methods for SSDs
- [`ssd_exposure()`](https://bcgov.github.io/ssdtools/reference/ssd_exposure.md)
  : Proportion Exposure
- [`ssd_is_censored()`](https://bcgov.github.io/ssdtools/reference/ssd_is_censored.md)
  : Is Censored
- [`ssd_match_moments()`](https://bcgov.github.io/ssdtools/reference/ssd_match_moments.md)
  : Match Moments
- [`ssd_min_pmix()`](https://bcgov.github.io/ssdtools/reference/ssd_min_pmix.md)
  : Calculate Minimum Proportion in Mixture Models

## Deprecated

Deprecated functions which will become defunct in future versions

- [`comma_signif()`](https://bcgov.github.io/ssdtools/reference/comma_signif.md)
  :

  Comma and Significance Formatter **\[deprecated\]**

- [`geom_ssd()`](https://bcgov.github.io/ssdtools/reference/geom_ssd.md)
  :

  Species Sensitivity Data Points **\[deprecated\]**

- [`is_censored()`](https://bcgov.github.io/ssdtools/reference/is_censored.md)
  :

  Is Censored **\[deprecated\]**

- [`ssd_wqg_bc()`](https://bcgov.github.io/ssdtools/reference/ssd_wqg_bc.md)
  :

  Water Quality Guideline for British Columbia **\[deprecated\]**

- [`ssd_wqg_burrlioz()`](https://bcgov.github.io/ssdtools/reference/ssd_wqg_burrlioz.md)
  :

  Water Quality Guideline for Burrlioz **\[deprecated\]**

- [`ssd_hc_burrlioz()`](https://bcgov.github.io/ssdtools/reference/ssd_hc_burrlioz.md)
  :

  Hazard Concentrations for Burrlioz Fit **\[deprecated\]**

- [`ssd_plot_cf()`](https://bcgov.github.io/ssdtools/reference/ssd_plot_cf.md)
  :

  Cullen and Frey Plot **\[deprecated\]**

- [`stat_ssd()`](https://bcgov.github.io/ssdtools/reference/stat_ssd.md)
  :

  Plot Species Sensitivity Data **\[deprecated\]**

- [`dgompertz()`](https://bcgov.github.io/ssdtools/reference/dgompertz.md)
  **\[deprecated\]** :

  Gompertz Probability Density **\[deprecated\]**

- [`pgompertz()`](https://bcgov.github.io/ssdtools/reference/pgompertz.md)
  :

  Cumulative Distribution Function for Gompertz Distribution
  **\[deprecated\]**

- [`qgompertz()`](https://bcgov.github.io/ssdtools/reference/qgompertz.md)
  :

  Quantile Function for Gompertz Distribution **\[deprecated\]**

- [`rgompertz()`](https://bcgov.github.io/ssdtools/reference/rgompertz.md)
  :

  Random Generation for Gompertz Distribution **\[deprecated\]**

- [`dlgumbel()`](https://bcgov.github.io/ssdtools/reference/dlgumbel.md)
  **\[deprecated\]** :

  Log-Gumbel (Inverse Weibull) Probability Density **\[deprecated\]**

- [`plgumbel()`](https://bcgov.github.io/ssdtools/reference/plgumbel.md)
  :

  Cumulative Distribution Function for Log-Gumbel Distribution
  **\[deprecated\]**

- [`qlgumbel()`](https://bcgov.github.io/ssdtools/reference/qlgumbel.md)
  :

  Quantile Function for Log-Gumbel Distribution **\[deprecated\]**

- [`rlgumbel()`](https://bcgov.github.io/ssdtools/reference/rlgumbel.md)
  : Random Generation for log-Gumbel Distribution
