# Parameter Descriptions for ssdtools Functions

Parameter Descriptions for ssdtools Functions

## Arguments

- ...:

  Unused.

- add_x:

  The value to add to the label x values (before multiplying by
  `shift_x`).

- all:

  A flag specifying whether to also return transformed parameters.

- all_dists:

  A flag specifying whether all the named distributions must fit
  successfully.

- all_estimates:

  A flag specifying whether to calculate estimates for all implemented
  distributions.

- at_boundary_ok:

  A flag specifying whether a model with one or more parameters at the
  boundary should be considered to have converged (default = TRUE).

- average:

  A flag specifying whether to provide model averaged values as opposed
  to a value for each distribution.

- bcanz:

  A flag or NULL specifying whether to only include distributions in the
  set that is approved by BC, Canada, Australia and New Zealand for
  official guidelines.

- big.mark:

  A string specifying the thousands separator.

- breaks:

  A character vector

- bounds:

  A named non-negative numeric vector of the left and right bounds for
  uncensored missing (0 and Inf) data in terms of the orders of
  magnitude relative to the extremes for non-missing values.

- chk:

  A flag specifying whether to check the arguments.

- ci:

  A flag specifying whether to estimate confidence intervals (by
  bootstrapping).

- ci_method:

  A string specifying which method to use for estimating the standard
  error and confidence limits from the bootstrap samples. The default
  and recommended value is still `ci_method = "weighted_samples"` which
  takes bootstrap samples from each distribution proportional to its
  AICc based weights and calculates the confidence limits (and SE) from
  this single set. `ci_method = "multi_fixed"` and
  `ci_method = "multi_free"` generate the bootstrap samples using the
  model-averaged cumulative distribution function but differ in whether
  the model weights are fixed at the values for the original dataset or
  re-estimated for each bootstrap sample dataset. The value
  `ci_method = "MACL"` (was `ci_method = "weighted_arithmetic"`), which
  is only included for historical reasons, takes the weighted arithmetic
  mean of the confidence limits while `ci_method = GMACL` which takes
  the weighted geometric mean of the confidence limits was added for
  completeness but is also not recommended. Finally
  `ci_method = "arithmetic_samples"` and
  `ci_method = "geometric_samples"` take the weighted arithmetic or
  geometric mean of the values for each bootstrap iteration across all
  the distributions and then calculate the confidence limits (and SE)
  from the single set of samples.

- censoring:

  A numeric vector of the left and right censoring values.

- color:

  A string of the column in data for the color aesthetic.

- computable:

  A flag specifying whether to only return fits with numerically
  computable standard errors.

- conc:

  A numeric vector of concentrations to calculate the hazard proportions
  for.

- control:

  A list of control parameters passed to
  [`stats::optim()`](https://rdrr.io/r/stats/optim.html).

- data:

  A data frame.

- decimal.mark:

  A string specifying the numeric decimal point.

- delta:

  A non-negative number specifying the maximum absolute AIC difference
  cutoff. Distributions with an absolute AIC difference greater than
  delta are excluded from the calculations.

- digits:

  A whole number specifying the number of significant figures.

- dists:

  A character vector of the distribution names.

- est_method:

  A string specifying whether to estimate directly from the
  model-averaged cumulative distribution function
  (`est_method = 'multi'`) or to take the arithmetic mean of the
  estimates from the individual cumulative distribution functions
  weighted by the AICc derived weights (`est_method = 'arithmetic'`) or
  or to use the geometric mean instead (`est_method = 'geometric'`).

- fitdists:

  An object of class fitdists.

- hc:

  A value between 0 and 1 indicating the proportion hazard concentration
  (or NULL).

- hc_value:

  A number of the hazard concentration value to offset.

- label:

  A string of the column in data with the labels.

- label_size:

  A number for the size of the labels.

- left:

  A string of the column in data with the concentrations.

- level:

  A number between 0 and 1 of the confidence level of the interval.

- linecolor:

  A string of the column in pred to use for the line color.

- linetype:

  A string of the column in pred to use for the linetype.

- llocation:

  location parameter on the log scale.

- location:

  location parameter.

- locationlog:

  location on the log scale parameter.

- locationlog1:

  locationlog1 parameter.

- locationlog2:

  locationlog2 parameter.

- log:

  logical; if TRUE, probabilities p are given as log(p).

- log.p:

  logical; if TRUE, probabilities p are given as log(p).

- lscale:

  scale parameter on the log scale.

- lshape:

  shape parameter on the log scale.

- lshape1:

  shape1 parameter on the log scale.

- lshape2:

  shape2 parameter on the log scale.

- lower.tail:

  logical; if TRUE (default), probabilities are `P[X <= x]`, otherwise,
  `P[X > x]`.

- meanlog:

  mean on log scale parameter.

- meanlog1:

  mean on log scale parameter.

- meanlog2:

  mean on log scale parameter.

- min_pboot:

  A number between 0 and 1 of the minimum proportion of bootstrap
  samples that must successfully fit (return a likelihood) to report the
  confidence intervals.

- min_pmix:

  A number between 0 and 0.5 specifying the minimum proportion in
  mixture models.

- npars:

  A whole numeric vector specifying which distributions to include based
  on the number of parameters.

- multi_est:

  A flag specifying whether to estimate directly from the model-averaged
  cumulative distribution function (`multi_est = TRUE`) or to take the
  arithmetic mean of the estimates from the individual cumulative
  distribution functions weighted by the AICc derived weights
  (`multi_est = FALSE`).

- na.rm:

  A flag specifying whether to silently remove missing values or remove
  them with a warning.

- n:

  positive number of observations.

- nboot:

  A count of the number of bootstrap samples to use to estimate the
  confidence limits. A value of 10,000 is recommended for official
  guidelines.

- nrow:

  A positive whole number of the minimum number of non-missing rows.

- nsim:

  A positive whole number of the number of simulations to generate.

- object:

  The object.

- parametric:

  A flag specifying whether to perform parametric bootstrapping as
  opposed to non-parametrically resampling the original data with
  replacement.

- p:

  vector of probabilities.

- percent:

  A numeric vector of percent values to estimate hazard concentrations
  for. Deprecated for `proportion = 0.05`. **\[deprecated\]**

- pmix:

  Proportion mixture parameter.

- proportion:

  A numeric vector of proportion values to estimate hazard
  concentrations for.

- pvalue:

  A flag specifying whether to return p-values or the statistics
  (default) for the various tests.

- pred:

  A data frame of the predictions.

- q:

  vector of quantiles.

- range_shape1:

  A numeric vector of length two of the lower and upper bounds for the
  shape1 parameter.

- range_shape2:

  shape2 parameter.

- reweight:

  A flag specifying whether to reweight weights by dividing by the
  largest weight.

- rescale:

  A flag specifying whether to leave the values unchanged (FALSE) or to
  rescale concentration values by dividing by the geometric mean of the
  minimum and maximum positive finite values (TRUE) or a string
  specifying whether to leave the values unchanged ("no") or to rescale
  concentration values by dividing by the geometric mean of the minimum
  and maximum positive finite values ("geomean") or to logistically
  transform ("odds").

- ribbon:

  A flag indicating whether to plot the confidence interval as a grey
  ribbon as opposed to green solid lines.

- right:

  A string of the column in data with the right concentration values.

- save_to:

  NULL or a string specifying a directory to save where the bootstrap
  datasets and parameter estimates (when successfully converged) to.

- samples:

  A flag specfying whether to include a numeric vector of the bootstrap
  samples as a list column in the output.

- scale:

  scale parameter.

- scalelog1:

  scalelog1 parameter.

- scalelog2:

  scalelog2 parameter.

- scalelog:

  scale on log scale parameter.

- sdlog:

  standard deviation on log scale parameter.

- sdlog1:

  standard deviation on log scale parameter.

- sdlog2:

  standard deviation on log scale parameter.

- select:

  A character vector of the distributions to select.

- shape:

  shape parameter.

- shape1:

  shape1 parameter.

- shape2:

  shape2 parameter.

- shift_x:

  The value to multiply the label x values by (after adding `add_x`).

- silent:

  A flag indicating whether fits should fail silently.

- size:

  A number for the size of the labels. Deprecated for `label_size`. \#'
  **\[deprecated\]**

- strict:

  A flag indicating whether all elements of select must be present.

- suffix:

  Additional text to display after the number on the y-axis.

- tails:

  A flag or NULL specifying whether to only include distributions with
  both tails.

- text_size:

  A number for the text size.

- theme_classic:

  A flag specifying whether to use the classic theme or the default.

- trans:

  A string of which transformation to use. Accepted values include
  `"log10"`, `"log"`, and `"identity"` (`"log10"` by default).

- valid:

  A flag or NULL specifying whether to include distributions with valid
  likelihoods that allows them to be fit with other distributions for
  modeling averaging.

- weight:

  A string of the numeric column in data with positive weights less than
  or equal to 1,000 or NULL.

- odds_max:

  A number specifying the upper left value when `rescale = "odds"`. By
  default left values cannot exceed 0.999.

- wt:

  A flag specifying whether to return the Akaike weight as "wt" instead
  of "weight".

- x:

  The object.

- xbreaks:

  The x-axis breaks as one of:

  - `NULL` for no breaks

  - [`waiver()`](https://ggplot2.tidyverse.org/reference/waiver.html)
    for the default breaks

  - A numeric vector of positions

- xlimits:

  The x-axis limits as one of:

  - `NULL` to use the default scale range

  - A numeric vector of length two providing the limits. Use NA to refer
    to the existing minimum or maximum limits.

- xintercept:

  The x-value for the intersect.

- xlab:

  A string of the x-axis label.

- yintercept:

  The y-value for the intersect.

- ylab:

  A string of the x-axis label.

- burrIII3.weight:

  weight parameter for the Burr III distribution.

- burrIII3.shape1:

  shape1 parameter for the Burr III distribution.

- burrIII3.shape2:

  shape2 parameter for the Burr III distribution.

- burrIII3.scale:

  scale parameter for the Burr III distribution.

- gamma.weight:

  weight parameter for the gamma distribution.

- gamma.shape:

  shape parameter for the gamma distribution.

- gamma.scale:

  scale parameter for the gamma distribution.

- gompertz.weight:

  weight parameter for the Gompertz distribution.

- gompertz.location:

  location parameter for the Gompertz distribution.

- gompertz.shape:

  shape parameter for the Gompertz distribution.

- invpareto.weight:

  weight parameter for the inverse Pareto distribution.

- invpareto.shape:

  shape parameter for the inverse Pareto distribution.

- invpareto.scale:

  scale parameter for the inverse Pareto distribution.

- lgumbel.weight:

  weight parameter for the log-Gumbel distribution.

- lgumbel.locationlog:

  location parameter for the log-Gumbel distribution.

- lgumbel.scalelog:

  scale parameter for the log-Gumbel distribution.

- llogis.weight:

  weight parameter for the log-logistic distribution.

- llogis.locationlog:

  location parameter for the log-logistic distribution.

- llogis.scalelog:

  scale parameter for the log-logistic distribution.

- llogis_llogis.weight:

  weight parameter for the log-logistic log-logistic mixture
  distribution.

- llogis_llogis.locationlog1:

  locationlog1 parameter for the log-logistic log-logistic mixture
  distribution.

- llogis_llogis.scalelog1:

  scalelog1 parameter for the log-logistic log-logistic mixture
  distribution.

- llogis_llogis.locationlog2:

  locationlog2 parameter for the log-logistic log-logistic mixture
  distribution.

- llogis_llogis.scalelog2:

  scalelog2 parameter for the log-logistic log-logistic mixture
  distribution.

- llogis_llogis.pmix:

  pmix parameter for the log-logistic log-logistic mixture distribution.

- lnorm.weight:

  weight parameter for the log-normal distribution.

- lnorm.meanlog:

  meanlog parameter for the log-normal distribution.

- lnorm.sdlog:

  sdlog parameter for the log-normal distribution.

- lnorm_lnorm.weight:

  weight parameter for the log-normal log-normal mixture distribution.

- lnorm_lnorm.meanlog1:

  meanlog1 parameter for the log-normal log-normal mixture distribution.

- lnorm_lnorm.sdlog1:

  sdlog1 parameter for the log-normal log-normal mixture distribution.

- lnorm_lnorm.meanlog2:

  meanlog2 parameter for the log-normal log-normal mixture distribution.

- lnorm_lnorm.sdlog2:

  sdlog2 parameter for the log-normal log-normal mixture distribution.

- lnorm_lnorm.pmix:

  pmix parameter for the log-normal log-normal mixture distribution.

- weibull.weight:

  weight parameter for the Weibull distribution.

- weibull.shape:

  shape parameter for the Weibull distribution.

- weibull.scale:

  scale parameter for the Weibull distribution.
