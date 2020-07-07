#    Copyright 2015 Province of British Columbia
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

#' Parameter Descriptions for ssdtools Functions
#'
#' @param x The object.
#' @param object The object.
#' @param data A data frame.
#' @param pred A data frame of the predictions.
#' @param xlab A string of the x-axis label.
#' @param ylab A string of the x-axis label.
#' @param conc A numeric vector of concentrations.
#' @param percent A numeric vector of percentages.
#' @param ic A string specifying which information-theoretic criterion ('aic', 'aicc' or 'bic') to use for model averaging .
#' @param average A flag specifying whether to model average the estimates.
#' @param ci A flag specifying whether to estimate confidence intervals (by parametric bootstrapping).
#' @param nboot A count of the number of bootstrap samples to use to estimate the se and confidence limits.
#' @param level A number between 0 and 1 of the confidence level.
#' @param parallel A string specifying the type of parallel operation to be used ('no', 'snow' or 'multicore').
#' @param ncpus A count of the number of parallel processes to use.
#' @param ... Unused.
#' @param q	vector of quantiles.
#' @param p	vector of probabilities.
#' @param n	number of observations.
#' @param log,log.p logical; if TRUE, probabilities p are given as log(p).
#' @param lower.tail	logical; if TRUE (default), probabilities are `P[X <= x]`,otherwise, `P[X > x]`.
#' @param location location parameter.
#' @param llocation location parameter on the log scale.
#' @param scale scale parameter.
#' @param lscale scale parameter on the log scale.
#' @param shape	shape parameter.
#' @param meanlog mean on log scale parameter.
#' @param locationlog location on log scale parameter.
#' @param sdlog standard deviation on log scale parameter.
#' @param scalelog scale on log scale parameter.
#' @param lshape shape parameter on the log scale.
#' @param lshape1 shape1 parameter on the log scale.
#' @param lshape2 shape2 parameter on the log scale.
#' @param xintercept The x-value for the intersect
#' @param yintercept The y-value for the intersect.
#' @param select A character vector of the distributions to select.
#' @param left A string of the column in data with the concentrations.
#' @param right A string of the column in data with the right concentration values.
#' @param label A string of the column in data with the labels.
#' @param shape A string of the column in data for the shape aesthetic.
#' @param color A string of the column in data for the color aesthetic.
#' @param size A number for the size of the labels.
#' @param ribbon A flag indicating whether to plot the confidence interval as a grey ribbon as opposed to green solid lines.
#' @param shift_x The value to multiply the label x values by.
#' @param hc A count between 1 and 99 indicating the percent hazard concentration (or NULL).
#' @param weight A string of the column in data with the weightings (or NULL)
#' @param dists A character vector of the distribution names.
#' @param computable A flag specifying whether to only return fits with numerically computable standard errors.
#' @param silent A flag indicating whether fits should fail silently.
#' @param na.rm A flag specifying whether to silently remove missing values or
#' remove them with a warning.
#' @param nsim A positive whole number of the number of simulations to generate.
#' @keywords internal
#' @name params
NULL
