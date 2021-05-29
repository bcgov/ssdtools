#    Copyright 2015 Province of British Columbia
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

is_at_boundary <- function(fit) {
  dist <- .dist_tmbfit(fit)
  if(!is_bounds(dist)) return(FALSE)
  bounds <- bdist(dist)
  pars <- .pars_tmbfit(fit)
  
  lower <- as.numeric(bounds$lower[names(pars)])
  upper <- as.numeric(bounds$upper[names(pars)])
  
  any(pars == lower | pars == upper)
}

nullify_nonfit <- function(fit, computable, silent) {
  error <- fit$error
  fit <- fit$result
  
  if (!is.null(error)) {
    if (!silent) wrn("Distribution ", .dist_tmbfit(fit), " failed to fit: ", error)
    return(NULL)
  }
  if(is_at_boundary(fit)) {
    if (!silent) wrn("Distribution ", .dist_tmbfit(fit), " failed to fit: one or more parameters at boundary (try rescaling the data or increasing the sample size).")
    return(NULL)
  }
  sd <- fit$sd
  if (is.null(sd) || any(is.na(sd))) {
    if (computable) {
      if (!silent) wrn("Distribution ", .dist_tmbfit(fit), " failed to compute standard errors (try rescaling the data or increasing the sample size).")
      return(NULL)
    }
  }
  fit
}

remove_nonfits <- function(fits, computable, silent) {
  fits <- mapply(nullify_nonfit, fits,
                MoreArgs = list(computable = computable, silent = silent), SIMPLIFY = FALSE
  )
  fits <- fits[!vapply(fits, is.null, TRUE)]
  fits
}

fit_dists <- function(data, dists, computable, silent) {
  safe_fit_dist <- safely(fit_tmb)
  names(dists) <- dists
  fits <- lapply(dists, safe_fit_dist, data = data)
  fits <- remove_nonfits(fits, computable, silent)
  class(fits) <- "fitdists"
  if (!length(fits)) err("All distributions failed to fit.")
  fits
}

chk_and_process_data <- function(data, left, right, weight, nrow, silent) {  
  chk_string(left)
  chk_string(right)
  chk_null_or(weight, chk_string)
  
  chk_whole_number(nrow)
  chk_gte(nrow, 4L)
  
  values <- setNames(list(c(0, Inf, NA)), left)
  if(left != right)
    values <- c(values, setNames(list(c(0, Inf, NA)), right))
  if(!is.null(weight)) {
    data[[weight]] <- as.numeric(data[[weight]])
    values <- c(values, setNames(list(c(0, 1000)), weight))
  }
  check_data(data, values, nrow = c(nrow, Inf))
  
  if(is.null(weight)) {
    data$weight <- 1
    weight <- "weight"
  }
  data <- data[c(left, right, weight)]
  colnames(data) <- c("left", "right", "weight")
  
  missing <- is.na(data$left) & is.na(data$right)
  
  if(any(missing)) {
    msg <- paste0("`data` has %n row%s with missing values in '", left, "'")
    if(right != left && any(data$left != data$right))
      msg <- paste0(msg, " and '", right, "'")
    abort_chk(msg, n = sum(missing))
  }
  zero_weight <- data$weight == 0
  if(any(zero_weight)) {
    abort_chk("`data` has %n row%s with zero weight in '", weight, "'", n = sum(zero_weight))
  }
  data$left[is.na(data$left)] <- 0
  data$right[is.na(data$right)] <- Inf
  
  data
}

#' Fit Distributions
#'
#' Fits one or more distributions to species sensitivity data.
#'
#' By default the 'llogis', 'gamma' and 'lnorm'
#' distributions are fitted to the data.
#' The ssd_fit_dists function has also been
#' tested with the 'gompertz', 'lgumbel' and 'weibull' distributions.
#'
#' If weight specifies a column in the data frame with positive numbers,
#' weighted estimation occurs.
#' However, currently only the resultant parameter estimates are available (via coef).
#'
#' If the `right` argument is different to the `left` argument then the data are considered to be censored.
#'
#' @inheritParams params
#' @return An object of class fitdists.
#'
#' @export
#' @examples
#' ssd_fit_dists(boron_data)
ssd_fit_dists <- function(
  data, left = "Conc", right = left, weight = NULL,
  dists = c("gamma", "llogis", "lnorm"),
  nrow = 6L,
  computable = FALSE,
  silent = FALSE) {
  
  chk_character_or_factor(dists)
  chk_vector(dists)
  check_dim(dists, values = TRUE)
  chk_not_any_na(dists)
  chk_unique(dists)

  if ("llog" %in% dists) {
    deprecate_stop("0.1.0", "dllog()", "dllogis()",
                   details = "The 'llog' distribution has been deprecated for the identical 'llogis' distribution.")
  }
  if ("burrIII2" %in% dists) {
    deprecate_stop("0.1.2", "xburrIII2()",
                   details = "The 'burrIII2' distribution has been deprecated for the identical 'llogis' distribution.")
  }
  chk_subset(dists, ssd_dists())
  chk_flag(computable)
  chk_flag(silent)
  
  data <- chk_and_process_data(data, left = left, right = right, weight = weight, 
                       nrow = nrow, silent = silent)
  fits <- fit_dists(data, dists, computable, silent)
  fits
}
