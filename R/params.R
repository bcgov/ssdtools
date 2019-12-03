#' Parameter Descriptions for ssdtools Functions
#'
#' @param x The object.
#' @param object The object.
#' @param conc A numeric vector of the concentrations.
#' @param ic A string specifying which information-theoretic criterion ('aic', 'aicc' or 'bic') to use for model averaging .
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
#' @param lower.tail	logical; if TRUE (default), probabilities are P[X <= x],otherwise, P[X > x].
#' @param location location parameter.
#' @param locationlog location parameter on the log scale.
#' @param scale scale parameter.
#' @param scalelog scale parameter on the log scale.
#' @param shape	shape parameter.
#' @param shapelog shape parameter on the log scale.
#' @param shape1log shape1 parameter on the log scale.
#' @param shape2log shape2 parameter on the log scale.
#' @keywords internal
#' @name params
NULL
