---
title: 'ssdtools: An R package to fit Species Sensitivity Distributions'
authors:
- affiliation: 1
  name: Joe Thorley
  orcid: 0000-0002-7683-4592
- affiliation: 2
  name: Carl Schwarz
date: '2018-11-23'
bibliography: paper.bib
tags:
- ssd
- R
- maximum likelihood
- hazard concentration
affiliations:
- index: 1
  name: Poisson Consulting Ltd., British Columbia
- index: 2
  name: Simon Fraser University, British Columbia
---

# Summary

Species sensitivity distributions (SSDs) are cumulative probability distributions that are used to estimate the percent of species that are affected by a given concentration of a chemical. 
The concentration that affects 5% of the species is referred to as the 5% Hazard Concentration (HC).
Hazard concentrations are used for the derivation of environmental quality criteria and ecological risk assessment for contaminated ecosystems [@posthuma_species_2001].

`ssdtools` is an R package [@r] to fit SSDs using Maximum Likelihood [@millar_maximum_2011]. 
The available distributions include the log-normal (lnorm), log-logistic (llog), Gompertz, log-Gumbel (lgumbel), gamma and Weibull distributions.
Model selection or model averaging can be performed using Akaike Information Criterion (AIC), AIC corrected for small sample size (AICc) and Bayesian Information Criterion (BIC) [@burnham_model_2002].
Confidence intervals can be calculated for the cumulative distribution or specific hazard concentrations (percentiles) using parametric bootstrap resampling.

`ssdtools` uses the `fitdistrplus` R package [@fitdistrplus] for model fitting, calculation of information criteria and bootstrapping.
`ssdtools` extends the `ggplot2` R package [@ggplot2] by defining `ssdfit`, `xribbon` and `hcintersect` geometries to allow the user to produce custom SSD plots.

The following code fits the default distributions to the data set for boron and plots the results with the model averaged 5% HC as a dotted intersection (Figure 1).

```r
# install.packages("ssdtools")
library(ssdtools)
library(ggplot2)

dists <- ssd_fit_dists(boron_data)
hc <- ssd_hc(dists)

gp <- autoplot(dists) +
  geom_hcintersect(data = hc, aes(xintercept = est, yintercept = percent/100))

print(gp)
```

![Species sensitivity distributions for sample species concentration values](dists.png)


# Acknowledgements

We acknowledge contributions from Ali Azizishirazi, Angeline Tillmanns, Stephanie Hazlitt, Kathleen McTavish, Emilie Doussantousse, Heather Thompson and Andy Teucher.
Development of `ssdtools` was funded by the Ministry of Environment and Climate Change Strategy, British Columbia.

# References

