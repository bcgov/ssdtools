#    Copyright 2021 Province of British Columbia
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
#'
#' @param all A flag specifying whether to also return transformed parameters.
#' @param at_boundary_ok A flag specifying whether a model with one or more
#' parameters at the boundary should be considered to have converged (default = FALSE).
#' @param x The object.
#' @param object The object.
#' @param control A list of control parameters passed to [`stats::optim()`].
#' @param chk A flag specifying whether to check the arguments.
#' @param data A data frame.
#' @param pred A data frame of the predictions.
#' @param xlab A string of the x-axis label.
#' @param ylab A string of the x-axis label.
#' @param xbreaks The x-axis breaks as one of:
#'   - `NULL` for no breaks
#'   - `waiver()` for the default breaks
#'   - A numeric vector of positions
#' @param breaks A character vector
#' @param bounds A named non-negative numeric vector of the left and right bounds for
#' uncensored missing (0 and Inf) data in terms of the orders of magnitude
#' relative to the extremes for non-missing values.
#' @param conc A numeric vector of concentrations.
#' @param digits A whole number specifying the number of significant figures
#' @param percent A numeric vector of percentages.
#' @param pvalue A flag specifying whether to return p-values or the statistics (default) for the various tests.
#' @param parametric A flag specifying whether to perform parametric as opposed to non-parametric bootstrapping.
#' @param min_pmix A number between 0 and 0.5 specifying the minimum proportion in mixture models.
#' @param delta A non-negative number specifying the maximum absolute Akaike Information-theoretic Criterion difference cutoff. Distributions with an absolute difference from the best model greater than the cutoff are excluded.
#' @param average A flag specifying whether to model average the estimates.
#' @param ci A flag specifying whether to estimate confidence intervals (by parametric bootstrapping).
#' @param nboot A count of the number of bootstrap samples to use to estimate the se and confidence limits. A value of 10000 is recommended for official guidelines.
#' @param min_pboot A number of the minimum proportion of bootstrap samples that must successfully fit
#' in the sense of returning a likelihood.
#' @param level A number between 0 and 1 of the confidence level.
#' @param ... Unused.
#' @param q	vector of quantiles.
#' @param p	vector of probabilities.
#' @param n	number of observations.
#' @param log logical; if TRUE, probabilities p are given as log(p).
#' @param log.p logical; if TRUE, probabilities p are given as log(p).
#' @param lower.tail	logical; if TRUE (default), probabilities are `P[X <= x]`,otherwise, `P[X > x]`.
#' @param location location parameter.
#' @param llocation location parameter on the log scale.
#' @param scale scale parameter.
#' @param lscale scale parameter on the log scale.
#' @param shape	shape parameter.
#' @param shape1 shape1 parameter.
#' @param shape2 shape2 parameter.
#' @param range_shape1 A numeric vector of length two of the lower and upper bounds for the shape1 parameter.
#' @param range_shape2 A numeric vector of length two of the lower and upper bounds for the shape2 parameter.
#' @param range_shape2 shape2 parameter.
#' @param locationlog1 locationlog1 parameter.
#' @param scalelog1 scalelog1 parameter.
#' @param locationlog2 locationlog2 parameter.
#' @param scalelog2 scalelog2 parameter.
#' @param pmix Proportion mixture parameter.
#' @param meanlog mean on log scale parameter.
#' @param meanlog1 mean on log scale parameter.
#' @param meanlog2 mean on log scale parameter.
#' @param locationlog location on log scale parameter.
#' @param sdlog standard deviation on log scale parameter.
#' @param sdlog1 standard deviation on log scale parameter.
#' @param sdlog2 standard deviation on log scale parameter.
#' @param scalelog scale on log scale parameter.
#' @param lshape shape parameter on the log scale.
#' @param lshape1 shape1 parameter on the log scale.
#' @param lshape2 shape2 parameter on the log scale.
#' @param xintercept The x-value for the intersect
#' @param yintercept The y-value for the intersect.
#' @param select A character vector of the distributions to select.
#' @param rescale A flag specifying whether to rescale concentration values by dividing by the largest finite value.
#' @param reweight A flag specifying whether to reweight weights by dividing by the largest weight.
#' @param left A string of the column in data with the concentrations.
#' @param right A string of the column in data with the right concentration values.
#' @param label A string of the column in data with the labels.
#' @param shape A string of the column in data for the shape aesthetic.
#' @param color A string of the column in data for the color aesthetic.
#' @param size A number for the size of the labels.
#' @param ribbon A flag indicating whether to plot the confidence interval as a grey ribbon as opposed to green solid lines.
#' @param shift_x The value to multiply the label x values by.
#' @param hc A count between 1 and 99 indicating the percent hazard concentration (or NULL).
#' @param weight A string of the numeric column in data with positive weights less than or equal to 1,000 or NULL.
#' @param dists A character vector of the distribution names.
#' @param computable A flag specifying whether to only return fits with numerically computable standard errors.
#' @param silent A flag indicating whether fits should fail silently.
#' @param na.rm A flag specifying whether to silently remove missing values or
#' remove them with a warning.
#' @param nrow A positive whole number of the minimum number of non-missing rows.
#' @param nsim A positive whole number of the number of simulations to generate.
#' @param linetype A string of the column in pred to use for the linetype.
#' @param linecolor A string of the column in pred to use for the line color.
#' @keywords internal
#' @name params
NULL
