
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ssdtools <img src="man/figures/logo.png" align="right" />

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/Lifecycle-Experimental-339999)](https://github.com/bcgov/repomountie/blob/master/doc/lifecycle-badges.md)
[![R-CMD-check](https://github.com/bcgov/ssdtools/workflows/R-CMD-check/badge.svg)](https://github.com/bcgov/ssdtools/actions)
[![Coverage
Status](https://img.shields.io/codecov/c/github/bcgov/ssdtools/master.svg)](https://codecov.io/github/bcgov/ssdtools?branch=master)
[![CRAN
status](https://www.r-pkg.org/badges/version/ssdtools)](https://cran.r-project.org/package=ssdtools)
![CRAN downloads](https://cranlogs.r-pkg.org/badges/ssdtools)
<!-- badges: end -->

`ssdtools` is an R package to fit and plot Species Sensitivity
Distributions (SSD).

SSDs are cumulative probability distributions which are fitted to
toxicity concentrations for different species as described by Posthuma
et al. (2001). The ssdtools package uses Maximum Likelihood to fit
distributions such as the gamma, log-logistic, log-normal and Weibull to
censored and/or weighted data. Multiple distributions can be averaged
using Akaike Information Criteria. Confidence intervals on hazard
concentrations and proportions are produced by parametric bootstrapping.

## Installation

To install the latest version from
[CRAN](https://CRAN.R-project.org/package=ssdtools)

``` r
install.packages("ssdtools")
```

To install the latest development version:

``` r
# install.packages("devtools")
devtools::install_github("bcgov/ssdtools")
```

## Introduction

`ssdtools` provides a data set for several chemicals including Boron.

``` r
library(ssdtools)
boron_data
#> # A tibble: 28 × 5
#>    Chemical Species                  Conc Group        Units
#>    <chr>    <chr>                   <dbl> <fct>        <chr>
#>  1 Boron    Oncorhynchus mykiss       2.1 Fish         mg/L 
#>  2 Boron    Ictalurus punctatus       2.4 Fish         mg/L 
#>  3 Boron    Micropterus salmoides     4.1 Fish         mg/L 
#>  4 Boron    Brachydanio rerio        10   Fish         mg/L 
#>  5 Boron    Carassius auratus        15.6 Fish         mg/L 
#>  6 Boron    Pimephales promelas      18.3 Fish         mg/L 
#>  7 Boron    Daphnia magna             6   Invertebrate mg/L 
#>  8 Boron    Opercularia bimarginata  10   Invertebrate mg/L 
#>  9 Boron    Ceriodaphnia dubia       13.4 Invertebrate mg/L 
#> 10 Boron    Entosiphon sulcatum      15   Invertebrate mg/L 
#> # … with 18 more rows
```

Distributions are fit using `ssd_fit_dists()`

``` r
boron_dists <- ssd_fit_dists(boron_data)
```

and can be quickly plotted using the `ggplot2` generic `autoplot`

``` r
library(ggplot2)

theme_set(theme_bw())

autoplot(boron_dists) + 
  scale_colour_ssd()
```

![](man/figures/README-unnamed-chunk-5-1.png)<!-- -->

The goodness of fit can be assessed using `ssd_gof`

``` r
ssd_gof(boron_dists)
#> # A tibble: 3 × 9
#>   dist      ad     ks    cvm   aic  aicc   bic delta weight
#>   <chr>  <dbl>  <dbl>  <dbl> <dbl> <dbl> <dbl> <dbl>  <dbl>
#> 1 gamma  0.440 0.117  0.0554  238.  238.  240.  0     0.595
#> 2 llogis 0.487 0.0994 0.0595  241.  241.  244.  3.38  0.11 
#> 3 lnorm  0.507 0.107  0.0703  239.  240.  242.  1.40  0.296
```

and the model-averaged 5% hazard concentration estimated using `ssd_hc`

``` r
set.seed(99)
boron_hc5 <- ssd_hc(boron_dists, ci = TRUE)
```

``` r
print(boron_hc5)
#> # A tibble: 1 × 6
#>   dist    percent   est    se   lcl   ucl
#>   <chr>     <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1 average       5  1.31 0.821 0.504  3.62
```

Model-averaged predictions complete with confidence intervals can be
produced using the `stats` generic `predict`

``` r
set.seed(99)
boron_pred <- predict(boron_dists, ci = TRUE)
```

and plotted together with the original data using `ssd_plot`.

``` r
ssd_plot(boron_data, boron_pred,
  shape = "Group", color = "Group", label = "Species",
  xlab = "Concentration (mg/L)", ribbon = TRUE
) + 
  expand_limits(x = 3000) +
  scale_colour_ssd()
#> Warning: Ignoring unknown aesthetics: shape
```

![](man/figures/README-unnamed-chunk-10-1.png)<!-- -->

## References

Posthuma, L., Suter II, G.W., and Traas, T.P. 2001. Species Sensitivity
Distributions in Ecotoxicology. CRC Press.

## Citation


    To cite ssdtools in publications use:

      Thorley, J. and Schwarz C., (2018). ssdtools An R package to fit
      Species Sensitivity Distributions. Journal of Open Source Software,
      3(31), 1082. https://doi.org/10.21105/joss.01082

    A BibTeX entry for LaTeX users is

      @Article{,
        title = {{ssdtools}: An R package to fit Species Sensitivity Distributions},
        author = {Joe Thorley and Carl Schwarz},
        journal = {Journal of Open Source Software},
        year = {2018},
        volume = {3},
        number = {31},
        pages = {1082},
        doi = {10.21105/joss.01082},
      }

## Information

Get started with ssdtools at
<https://bcgov.github.io/ssdtools/articles/ssdtools.html>.

A shiny app to allow non-R users to interface with ssdtools is available
at <https://github.com/bcgov/shinyssdtools>.

The citation for the shiny app:

*Dalgarno, S. 2021. shinyssdtools: A web application for fitting Species
Sensitivity Distributions (SSDs). JOSS 6(57): 2848.
<https://joss.theoj.org/papers/10.21105/joss.02848>.*

The ssdtools package was developed as a result of earlier drafts of:

*Schwarz, C., and Tillmanns, A. 2019. Improving Statistical Methods for
Modeling Species Sensitivity Distributions. Province of British
Columbia, Victoria, BC.*

For recent developments in SSD modeling including a review of existing
software see:

*Fox, D.R., et al. 2021. Recent Developments in Species Sensitivity
Distribution Modeling. Environ Toxicol Chem 40(2): 293–308.
<https://onlinelibrary.wiley.com/doi/10.1002/etc.4925>.*

The CCME `data.csv` data file is derived from a factsheet prepared by
the [Canadian Council of Ministers of the
Environment](http://ceqg-rcqe.ccme.ca/en/index.html). See the
[`data-raw`](https://github.com/bcgov/ssdtools/tree/master/data-raw)
folder for more information.

## Getting Help or Reporting an Issue

To report bugs/issues/feature requests, please file an
[issue](https://github.com/bcgov/ssdtools/issues/).

## How to Contribute

If you would like to contribute to the package, please see our
[CONTRIBUTING](https://github.com/bcgov/ssdtools/blob/master/.github/CONTRIBUTING.md)
guidelines.

## Code of Conduct

Please note that the ssdtools project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

## License

The code is released under the Apache License 2.0

Copyright 2015 Province of British Columbia

Licensed under the Apache License, Version 2.0 (the “License”); you may
not use this file except in compliance with the License. You may obtain
a copy of the License at

<https://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an “AS IS” BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

------------------------------------------------------------------------

<a rel="license" href="https://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons Licence"
style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/80x15.png" /></a><br /><span
xmlns:dct="http://purl.org/dc/terms/"
property="dct:title">ssdtools</span> by <span
xmlns:cc="http://creativecommons.org/ns#"
property="cc:attributionName">the Province of British Columbia </span>
is licensed under a
<a rel="license" href="https://creativecommons.org/licenses/by/4.0/">
Creative Commons Attribution 4.0 International License</a>.
