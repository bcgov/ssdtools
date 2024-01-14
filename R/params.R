# Copyright 2023 Province of British Columbia
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       https://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

#' Parameter Descriptions for ssdtools Functions
#' @param all A flag specifying whether to also return transformed parameters.
#' @param all_dists A flag specifying whether all the named distributions must fit successfully.
#' @param at_boundary_ok A flag specifying whether a model with one or more
#' parameters at the boundary should be considered to have converged (default = FALSE).
#' @param average A flag specifying whether to provide model averaged values as opposed to a value for each distribution.
#' @param breaks A character vector
#' @param bounds A named non-negative numeric vector of the left and right bounds for
#' uncensored missing (0 and Inf) data in terms of the orders of magnitude
#' relative to the extremes for non-missing values.
#' @param chk A flag specifying whether to check the arguments.
#' @param ci A flag specifying whether to estimate confidence intervals (by bootstrapping).
#' @param color A string of the column in data for the color aesthetic.
#' @param computable A flag specifying whether to only return fits with numerically computable standard errors.
#' @param conc A numeric vector of concentrations to calculate the hazard proportions for.
#' @param control A list of control parameters passed to [`stats::optim()`].
#' @param data A data frame.
#' @param delta A non-negative number specifying the maximum absolute AIC difference cutoff.
#' Distributions with an absolute AIC difference greater than delta are excluded from the calculations.
#' @param digits A whole number specifying the number of significant figures.
#' @param dists A character vector of the distribution names.
#' @param hc A value between 0 and 1 indicating the proportion hazard concentration (or NULL).
#' @param label A string of the column in data with the labels.
#' @param left A string of the column in data with the concentrations.
#' @param level A number between 0 and 1 of the confidence level of the interval.
#' @param linecolor A string of the column in pred to use for the line color.
#' @param linetype A string of the column in pred to use for the linetype.
#' @param llocation location parameter on the log scale.
#' @param location location parameter.
#' @param locationlog location on the log scale parameter.
#' @param locationlog1 locationlog1 parameter.
#' @param locationlog2 locationlog2 parameter.
#' @param log logical; if TRUE, probabilities p are given as log(p).
#' @param log.p logical; if TRUE, probabilities p are given as log(p).
#' @param lscale scale parameter on the log scale.
#' @param lshape shape parameter on the log scale.
#' @param lshape1 shape1 parameter on the log scale.
#' @param lshape2 shape2 parameter on the log scale.
#' @param lower.tail logical; if TRUE (default), probabilities are `P[X <= x]`, otherwise, `P[X > x]`.
#' @param meanlog mean on log scale parameter.
#' @param meanlog1 mean on log scale parameter.
#' @param meanlog2 mean on log scale parameter.
#' @param min_pboot A number between 0 and 1 of the minimum 
#' proportion of bootstrap samples that must successfully fit (return a likelihood) 
#' to report the confidence intervals.
#' @param min_pmix A number between 0 and 0.5 specifying the minimum proportion in mixture models.
#' @param all_estimates A flag specifying whether to calculate estimates for all implemented distributions.
#' @param multi_ci A flag specifying whether to treat the distributions as constituting a single distribution which is now the recommended approach (as opposed to taking the mean) when calculating model averaged confidence intervals.
#' @param multi_est A flag specifying whether to treat the distributions as constituting a single distribution (as opposed to taking the mean) when calculating model averaged estimates.
#' @param na.rm A flag specifying whether to silently remove missing values or 
#' remove them with a warning.
#' @param n positive number of observations.
#' @param nboot A count of the number of bootstrap samples to use to estimate the confidence limits. A value of 10,000 is recommended for official guidelines.
#' @param nrow A positive whole number of the minimum number of non-missing rows.
#' @param nsim A positive whole number of the number of simulations to generate.
#' @param object The object.
#' @param parametric A flag specifying whether to perform parametric bootstrapping as opposed to non-parametrically resampling the original data with replacement.
#' @param p vector of probabilities.
#' @param percent A numeric vector of percent values to estimate hazard concentrations for. Soft-deprecated for `proportion = 0.05`.
#' @param pmix Proportion mixture parameter.
#' @param proportion A numeric vector of proportion values to estimate hazard concentrations for.
#' @param pvalue A flag specifying whether to return p-values or the statistics (default) for the various tests.
#' @param pred A data frame of the predictions.
#' @param q	vector of quantiles.
#' @param range_shape1 A numeric vector of length two of the lower and upper bounds for the shape1 parameter.
#' @param range_shape2 A numeric vector of length two of the lower and upper bounds for the shape2 parameter.
#' @param range_shape2 shape2 parameter.
#' @param reweight A flag specifying whether to reweight weights by dividing by the largest weight.
#' @param rescale A flag specifying whether to rescale concentration values by dividing by the geometric mean of the minimum and maximum positive finite values.
#' @param ribbon A flag indicating whether to plot the confidence interval as a grey ribbon as opposed to green solid lines.
#' @param right A string of the column in data with the right concentration values.
#' @param save_to NULL or a string specifying a directory to save where the bootstrap datasets and parameter estimates (when successfully converged) to.
#' @param samples A flag specfying whether to include a numeric vector of the bootstrap samples as a list column in the output. 
#' @param scale scale parameter.
#' @param scalelog1 scalelog1 parameter.
#' @param scalelog2 scalelog2 parameter.
#' @param scalelog scale on log scale parameter.
#' @param sdlog standard deviation on log scale parameter.
#' @param sdlog1 standard deviation on log scale parameter.
#' @param sdlog2 standard deviation on log scale parameter.
#' @param select A character vector of the distributions to select.
#' @param shape	shape parameter.
#' @param shape1 shape1 parameter.
#' @param shape2 shape2 parameter.
#' @param shift_x The value to multiply the label x values by.
#' @param silent A flag indicating whether fits should fail silently.
#' @param size A number for the size of the labels.
#' @param weight A string of the numeric column in data with positive weights less than or equal to 1,000 or NULL.
#' @param weighted A flag which specifies whether to use the original model weights (as opposed to re-estimating for each bootstrap sample) unless `multi_ci = FALSE` in which case it specifies
#' whether to take bootstrap samples from each distribution proportional to 
#' its weight versus calculating the weighted arithmetic means of the lower 
#' and upper confidence limits.
#' @param x The object.
#' @param xbreaks The x-axis breaks as one of:
#'   - `NULL` for no breaks
#'   - `waiver()` for the default breaks
#'   - A numeric vector of positions
#' @param xintercept The x-value for the intersect
#' @param xlab A string of the x-axis label.
#' @param yintercept The y-value for the intersect.
#' @param ylab A string of the x-axis label.
#' @param burrIII3.weight weight parameter for the Burr III distribution.
#' @param burrIII3.shape1 shape1 parameter for the Burr III distribution.
#' @param burrIII3.shape2 shape2 parameter for the Burr III distribution.
#' @param burrIII3.scale scale parameter for the Burr III distribution.
#' @param gamma.weight weight parameter for the gamma distribution.
#' @param gamma.shape shape parameter for the gamma distribution.
#' @param gamma.scale scale parameter for the gamma distribution.
#' @param gompertz.weight weight parameter for the Gompertz distribution.
#' @param gompertz.location location parameter for the Gompertz distribution.
#' @param gompertz.shape shape parameter for the Gompertz distribution.
#' @param invpareto.weight weight parameter for the inverse Pareto distribution.
#' @param invpareto.shape shape parameter for the inverse Pareto distribution.
#' @param invpareto.scale scale parameter for the inverse Pareto distribution.
#' @param lgumbel.weight weight parameter for the log-Gumbel distribution.
#' @param lgumbel.locationlog location parameter for the log-Gumbel distribution.
#' @param lgumbel.scalelog scale parameter for the log-Gumbel distribution.
#' @param llogis.weight weight parameter for the log-logistic distribution.
#' @param llogis.locationlog location parameter for the log-logistic distribution.
#' @param llogis.scalelog scale parameter for the log-logistic distribution.
#' @param llogis_llogis.weight weight parameter for the log-logistic log-logistic mixture distribution.
#' @param llogis_llogis.locationlog1 locationlog1 parameter for the log-logistic log-logistic mixture distribution.
#' @param llogis_llogis.scalelog1 scalelog1 parameter for the log-logistic log-logistic mixture distribution.
#' @param llogis_llogis.locationlog2 locationlog2 parameter for the log-logistic log-logistic mixture distribution.
#' @param llogis_llogis.scalelog2 scalelog2 parameter for the log-logistic log-logistic mixture distribution.
#' @param llogis_llogis.pmix pmix parameter for the log-logistic log-logistic mixture distribution.
#' @param lnorm.weight weight parameter for the log-normal distribution.
#' @param lnorm.meanlog meanlog parameter for the log-normal distribution.
#' @param lnorm.sdlog sdlog parameter for the log-normal distribution.
#' @param lnorm_lnorm.weight weight parameter for the log-normal log-normal mixture distribution.
#' @param lnorm_lnorm.meanlog1 meanlog1 parameter for the log-normal log-normal mixture distribution.
#' @param lnorm_lnorm.sdlog1 sdlog1 parameter for the log-normal log-normal mixture distribution.
#' @param lnorm_lnorm.meanlog2 meanlog2 parameter for the log-normal log-normal mixture distribution.
#' @param lnorm_lnorm.sdlog2 sdlog2 parameter for the log-normal log-normal mixture distribution.
#' @param lnorm_lnorm.pmix pmix parameter for the log-normal log-normal mixture distribution.
#' @param weibull.weight weight parameter for the Weibull distribution.
#' @param weibull.shape shape parameter for the Weibull distribution.
#' @param weibull.scale scale parameter for the Weibull distribution.
#' @param ... Unused.
#' @keywords internal
#' @name params
NULL
