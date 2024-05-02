---
title: 'ssdtools v2: An R package to fit Species Sensitivity Distributions'
authors:
- name: Joe Thorley
  orcid: 0000-0002-7683-4592
  corresponding: true
  affiliation: 1
- name: Rebecca Fisher
  orcid: 0000-0001-5148-6731
  affiliation: "2, 3"
- name: David Fox
  orcid: 0000-0002-3178-7243
  affiliation: "4, 5"
- name: Carl Schwarz
  affiliation: 6
affiliations:
- index: 1
  name: Poisson Consulting, Canada
- index: 2
  name: Australian Institute of Marine Science, Australia
- index: 3
  name: Oceans Institute, The University of Western Australia, Australia
- index: 4
  name: The University of Melbourne, Australia
- index: 5
  name: Environmetrics Australia, Australia
- index: 6
  name: Simon Fraser University, Canada
date: 2 May 2024
bibliography: paper.bib
tags:
  - ssdtools
  - species sensitivity distributions
  - R
  - maximum likelihood
  - model averaging
  - hazard concentration
---

# Summary

Species sensitivity distributions (SSDs) are cumulative probability distributions that are used to estimate Hazard Concentrations ($\text{HC}_x$) - the concentration of a chemical that affects a given $x$% of species.
$\text{HC}_5$ values, which protect 95% of species, are often used for the derivation of environmental quality criteria and ecological risk assessment for contaminated ecosystems [@posthuma_species_2001].
The Hazard Proportion ($\text{HP}_u$) is the proportion of species affected by a given concentration $x$.

`ssdtools` is an R package [@r] to fit SSDs using Maximum Likelihood [@millar_maximum_2011] and allow estimates of $\text{HC}_x$ and $\text{HP}_u$ values by model averaging [@schwarz_improving_2019] across multiple distribution [@thorley2018ssdtools]. 
The `shinyssdtools` R package [@dalgarno_shinyssdtools_2021] provides a Graphical User Interface to `ssdtools`.

Since the publication of @thorley2018ssdtools for v0, the `ssdtools` R package has undergone two major updates.
The first update (v1) included the addition of four new distributions (inverse Pareto, Burr Type III and the log-normal log-normal and log-logistic log-logistic mixtures) and a switch to the R package `TMB` [@tmb] for model fitting.
The second major release (v2) includes critical updates to ensure that the $\text{HC}_x$ and $\text{HP}_u$ estimates satisfy the *inversion principle* as well as bootstrap methods to obtain confidence intervals (CIs) with appropriate coverage [@fox_methodologies_2024].

# Statement of need

SSDs are a practical tool for the determination of safe threshold concentrations for toxicants in fresh and marine waters, and are implemented in some form for risk assessment and water quality criteria derivation throughout multiple jurisdictions globally [@lepper2005manual; @Warne2018; @bcmecc2019; @USEPA2020].

The selection of a suitable probability model has been identified as one of the most important and difficult choices in the use of SSDs [@chapman_2007]. 
Since the original implementation (v0), `ssdtools` [@thorley2018ssdtools] has used model averaging to allow estimation of $\text{HC}_x$ and $\text{HP}_u$ values using multiple distributions, thereby avoiding the need for selection of a single distribution [@schwarz_improving_2019]. 
The method, as applied in the SSD context is described in detail in [@fox_recent_2021], and provides a level of flexibility and parsimony that is difficult to achieve with a single distribution.

# Technical details

## Distributions

Ten distributions are currently available in `ssdtools`. 
The original version (v0) of `ssdtools` provided the two parameters log-normal (lnorm), log-logistic (llogis), log-Gumbel (lgumbel, also known as the inverse Weibull), gamma, Weibull (weibull) and Gompertz (gompertz) distributions. 
In the first major update (v1), the two parameter inverse Pareto (invpareto), three parameter Burr Type III (burrIII3) and five parameter log-normal log-normal (lnorm_lnorm) and log-logistic log-logistic (llogis_llogis) mixture distributions were added.
Together with the Burr Type III, the inverse Pareto and inverse Weibull provide the underlying distributions of the SSD fitting software `Burrlioz` [@barry2012burrlioz] while the mixture distributions were added to accommodate bimodality [@fox_recent_2021]. 
Since v1, `ssdtools` has by default fitted the lnorm, llogis, lgumbel, gamma, weibull and lnorm_lnorm distributions.

## Model Fitting

In the first major update (v1), the dependency `fitdistrplus` [@fitdistrplus] was replaced by `TMB` [@tmb] for fitting the available distributions via Maximum Likelihood [@millar_maximum_2011]. 
The move to `TMB` allowed more control over model specification, transparency regarding convergence criteria and better assessment of numerical instability issues. 

## Model Averaging

In both the original [@thorley2018ssdtools] and updated versions, the Akaike Information Criterion (AIC), AIC corrected for small sample size (AICc) and Bayesian Information Criterion (BIC) can be calculated for each distribution [@burnham_model_2002].
Information criterion based model weights have the properties $0\le w_i\le 1$ and $\sum_{i=1}^{m} w_i = 1$ where $w_i$ is the weight of the $i^{th}$ of the $m$ models [@burnham_model_2002].
Except in the case of censored data, `ssdtools` uses AICc based weights for model averaging.

The first two implementations of `ssdtools` used the weighted arithmetic mean to obtain a model-averaged estimate of $\text{HC}_x$:
$$\widetilde{\text{HC}}_x = \sum\limits_{i = 1}^m w_i \text{HC}_x^{\left\{ i \right\}}$$
where $\text{HC}_x^{\left\{ i \right\}}$ is the $\text{HC}_x$ estimate for the $i^{th}$ model.

The weighted arithmetic mean is conventionally used for averaging model parameters or estimates [@burnham_model_2002]. 
However, in the case of $\text{HC}_x$ and $\text{HP}_u$ values, the estimator $\widetilde{\text{HC}}_x$ fails to satisfy the *inversion principle* [@fox_methodologies_2024] which requires 
$$\left[ \text{HP}_u \right]_{x = \text{HC}_\theta } = \theta$$
This inconsistency has been rectified in `ssdtools` v2 by estimating the model-averaged $\text{HC}_x$ (denoted $\widehat{\text{HC}}_x$) directly from the model-averaged cumulative distribution function (*cdf*) 
$$G\left( u \right) = \sum\limits_{i = 1}^m w_i F_i\left( u \right)$$
where ${F_i}\left(  \cdot  \right)$ is the *cdf* for the the *i^th^* model and $w_i$ is the model weight as before. $\widehat{\text{HC}}_x$ is then obtained as the solution to
$${u:G\left( u \right) = x}$$ 
or, equivalently
$$u:G\left( u \right) - x = 0$$ 
for the proportion affected $x$. 
Finding the solution to this last equation is referred to as *finding the root(s)* of the function $G\left( u \right)-x$. 

## Confidence Intervals

`ssdtools` generates confidence intervals for $\text{HC}_x$ and $\text{HP}_u$ values via bootstrapping.
By default all versions of `ssdtools` use parametric bootstrapping as it has better coverage than the equivalent non parametric approach used in other SSD modelling software such as `Burrlioz` [see @fox_methodologies_2021].
The first two versions of `ssdtools` both calculated the model averaged CI from the weighted arithmetic mean of the CIs of the individual distributions.
Unfortunately, this approach has recently been shown to have poor coverage [@fox_methodologies_2024] and is inconsistent with the *inversion principle*.

Consequently, v2 also offers a parametric bootstrap method that uses the joint cdf to generate data before refitting the original distribution set and solving for the newly estimated joint cdf [see details in @fox_methodologies_2024].
This "multi" method can be implemented with and without re-estimation of the model weights.
However, although the "multi" method has good coverage it is computationally slow.
As a result, the default method provided by the current update is a faster heuristic based on taking bootstrap samples from the individual distributions proportional to their weights [@fox_methodologies_2024].

## Plotting 

As well as to fitting SSDs and providing methods for estimating $\text{HC}_x$ and $\text{HP}_u$ values, `ssdtools` also extends the `ggplot2` R package [@ggplot2] by defining `geom_ssdpoint()`, `geom_ssdsegment()`, `geom_hcintersect()` and `geom_xribbon()` geoms as well as a discrete color-blind scale `scale_color_sdd()` for SSD plots.

# Example of use

The following code fits the six default distributions to the boron example data set from `ssddata` [@ssddata] and prints the goodness of fit table complete with information criteria:

```r
library(ssdtools)
fits <- ssd_fit_dists(ssddata::ccme_boron)
ssd_gof(fits)
```

```r
# A tibble: 6 × 9
  dist           ad     ks    cvm   aic  aicc   bic delta weight
  <chr>       <dbl>  <dbl>  <dbl> <dbl> <dbl> <dbl> <dbl>  <dbl>
1 gamma       0.440 0.117  0.0554  238.  238.  240. 0.005  0.357
2 lgumbel     0.829 0.158  0.134   244.  245.  247. 6.56   0.013
3 llogis      0.487 0.0994 0.0595  241.  241.  244. 3.39   0.066
4 lnorm       0.507 0.107  0.0703  239.  240.  242. 1.40   0.177
5 lnorm_lnorm 0.320 0.116  0.0414  240.  243.  247. 4.98   0.03 
6 weibull     0.434 0.117  0.0542  238.  238.  240. 0      0.357
```

The model averaged $\text{HC}_5$ estimate with 95% CIs can then be obtained using:

```r
ssd_hc(fits, ci = TRUE)
```

```r
# A tibble: 1 × 11
  dist    proportion   est    se   lcl   ucl    wt method     nboot pboot samples  
  <chr>        <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <dbl> <dbl> <I<list>>
1 average       0.05  1.26 0.818 0.397  3.41     1 parametric  1000 0.999 <dbl [0]>
```

And all of the distributions plotted via:
```r
autoplot(fits)
```

![Species sensitivity distributions for the six default distributions with the Boron species concentration data.](autoplot.png){height="4in"}

The proper model averaged cdf with 95% CIs (with the model averaged $\text{HC}_5$ indicated by a dotted line) can be plotted using:

```r
predictions <- ssdtools::predict(fits, ci = TRUE)
library(ggplot2)
ssd_plot(ssddata::ccme_boron, predictions,
         shape = "Group", color = "Group", label = "Species",
         xlab = "Concentration (mg/L)"
) +
  expand_limits(x = 3000) +
  scale_color_ssd()
```

![Model averaged species sensitivity distribution with 95% CI based on the six default distributions with Boron species concentration data. The $\text{HC}_5$ value is indicated by the dotted line.](ssd_plot.png){height="4in"}

# Acknowledgements

We acknowledge contributions from Angeline Tillmanns, Seb Dalgarno, Kathleen McTavish, Heather Thompson, Doug Spry, Rick van Dam, Graham Batley, Yulia Cuthbertson, Tony Bigwood, Michael Antenucci and Ali Azizisharzi.
Development of `ssdtools` was funded by the Ministry of Environment and Climate Change Strategy, British Columbia and the Department of Climate Change, Energy, the Environment and Water, Australia.

# References
