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

.data_fitdists <- function(fits) {
  attr(fits, "data", exact = TRUE)
}

.org_data_fitdists <- function(fits) {
  attr(fits, "org_data", exact = TRUE)
}

.rescale_fitdists <- function(fits) {
  attr(fits, "rescale", exact = TRUE)
}

.control_fitdists <- function(fits) {
  attr(fits, "control", exact = TRUE)
}

`.data_fitdists<-` <- function(fits, value) {
  attr(fits, "data") <- value
  fits
}

`.org_data_fitdists<-` <- function(fits, value) {
  attr(fits, "org_data") <- value
  fits
}

`.rescale_fitdists<-` <- function(fits, value) {
  attr(fits, "rescale") <- value
  fits
}

`.control_fitdists<-` <- function(fits, value) {
  attr(fits, "control") <- value
  fits
}

.attrs_fitdists <- function(fits) {
  attrs <- attributes(fits)
  attrs[c("control", "data", "org_data", "rescale")]
}

`.attrs_fitdists<-` <- function(fits, value) {
  .control_fitdists(fits) <- value$control
  .data_fitdists(fits) <- value$data
  .org_data_fitdists(fits) <- value$org_data
  .rescale_fitdists(fits) <- value$rescale
  fits
}

is_at_boundary <- function(fit) {
  dist <- .dist_tmbfit(fit)
  if(!is_bounds(dist)) return(FALSE)
  bounds <- bdist(dist)
  pars <- .pars_tmbfit(fit)
  
  lower <- as.numeric(bounds$lower[names(pars)])
  upper <- as.numeric(bounds$upper[names(pars)])
  
  any(pars == lower | pars == upper)
}

# required to pass dist as not available for dists that didn't fit
nullify_nonfit <- function(fit, dist, rescale, computable, silent) {
  error <- fit$error
  fit <- fit$result
  
  rescale <- if(rescale == 1) " (try rescaling data)" else NULL
  
  if (!is.null(error)) {
    if (!silent) wrn("Distribution '", dist, "' failed to fit", 
                     rescale, ": ", error)
    return(NULL)
  }
  if(is_at_boundary(fit)) {
    if (!silent) wrn("Distribution '", dist, "' failed to fit",
                     rescale, ": one or more parameters at boundary.")
    return(NULL)
  }
  if(!optimizer_converged(fit)) {
    message <- optimizer_message(fit)
    if (!silent) wrn("Distribution '", dist, "' failed to converge",
                     rescale, ": ", message)
    return(NULL)
  }
  if (computable) {
    tidy <- tidy(fit)
    if (any(is.na(tidy$se))) {
      if (!silent) wrn("Distribution '", dist, 
                       "' failed to compute standard errors", rescale, ".")
      return(NULL)
    }
  }
  fit
}

remove_nonfits <- function(fits, rescale, computable, silent) {
  fits <- mapply(nullify_nonfit, fits, names(fits),
                 MoreArgs = list(rescale = rescale, computable = computable, silent = silent), SIMPLIFY = FALSE
  )
  fits <- fits[!vapply(fits, is.null, TRUE)]
  fits
}

fit_dists <- function(data, dists, rescale, computable, control, silent) {
  safe_fit_dist <- safely(fit_tmb)
  names(dists) <- dists
  fits <- lapply(dists, safe_fit_dist, data = data, control = control)
  fits <- remove_nonfits(fits, rescale, computable, silent)
  fits
}

chk_and_process_data <- function(data, left, right, weight, nrow, rescale, silent) {  
  values <- setNames(list(c(0, Inf, NA)), left)
  if(left != right)
    values <- c(values, setNames(list(c(0, Inf, NA)), right))
  if(!is.null(weight)) {
    values <- c(values, setNames(list(c(0, Inf)), weight))
  }
  
  check_names(data, names = names(values))
  if(is.null(weight)) {
    data$weight <- 1
    weight <- "weight"
  } else if(is.integer(data[[weight]])) { # necessary to do transform before check_data
    data[[weight]] <- as.double(data[[weight]])
  }
  check_data(data, values, nrow = c(nrow, Inf))
  chk_gt(data[[left]], x_name = paste0("data$", left))
  if(any(!is.na(data[[right]]) & !is.na(data[[left]]) & data[[right]] < data[[left]])) {
    msg <- paste0("`data$", right, "` must have values greater than or equal to `data$",
                  left, "`")
    abort_chk(msg)
  }
  
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
  
  if(rescale) {
    rescale <- c(data$left, data$right)
    rescale <- max(rescale[rescale < Inf])
  } else 
    rescale <- 1
  
  list(data = data, rescale = rescale)
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
  rescale = FALSE,
  computable = TRUE,
  control = list(),
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
  chk_string(left)
  chk_string(right)
  chk_null_or(weight, chk_string)
  chk_subset(dists, ssd_dists())
  
  chk_whole_number(nrow)
  chk_gte(nrow, 4L)
  
  chk_flag(rescale)
  chk_flag(computable)
  chk_list(control)
  chk_flag(silent)
  
  x <- chk_and_process_data(data, left = left, right = right, weight = weight, 
                               nrow = nrow, rescale = rescale, silent = silent)
  
  org_data <- data
  data <- x$data
  rescale <- x$rescale
  
  fits <- fit_dists(data, dists, rescale, computable, control, silent)
  
  if (!length(fits)) err("All distributions failed to fit.")
  class(fits) <- "fitdists"
  
  attrs <- list(control = control, data = data, org_data = org_data,
                rescale = rescale)
  .attrs_fitdists(fits) <- attrs
  fits
}
