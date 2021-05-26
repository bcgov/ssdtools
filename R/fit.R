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

nullify_nonfits <- function(tmbfit, name, computable, silent) {
  if (!is.null(tmbfit$error)) {
    if (!silent) wrn("Distribution ", name, " failed to fit: ", tmbfit$error)
    return(NULL)
  }
  sd <- tmbfit$result$sd
  if (is.null(sd) || any(is.na(sd))) {
    if (computable) {
      if (!silent) wrn("Distribution ", name, " failed to compute standard errors (try rescaling the data or increasing the sample size).")
      return(NULL)
    }
  }
  tmbfit$result
}

remove_nonfits <- function(fit, computable, silent) {
  fit <- mapply(nullify_nonfits, fit, names(fit),
                MoreArgs = list(computable = computable, silent = silent), SIMPLIFY = FALSE
  )
  fit <- fit[!vapply(fit, is.null, TRUE)]
  fit
}

fit_dists <- function(data, dists, computable, silent) {
  safe_fit_dist <- safely(fit_tmb)
  names(dists) <- dists
  fit <- lapply(dists, safe_fit_dist, data = data)
  fit <- remove_nonfits(fit, computable, silent)
  class(fit) <- "fitdists"
  if (!length(fit)) err("All distributions failed to fit.")
  fit
}

process_data <- function(data, left, right, weight, nrow, silent) {  
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
    values <- c(values, setNames(list(c(0, Inf)), weight))
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
    if (!silent) msg("Deleting %n row%s with missing values in ", left, " and ", right, n = length(missing))
    data <- data[!missing,]
    check_dim(data, dim = nrow, values = c(nrow, Inf))
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
  
  if (sum(c("llog", "burrIII2", "llogis") %in% dists) > 1) {
    err("Distributions 'llog', 'burrIII2' and 'llogis' are identical. Please just use 'llogis'.")
  }
  
  if ("llog" %in% dists) {
    deprecate_warn("0.1.0", "dllog()", "dllogis()", id = "xllog", 
                   details = "The 'llog' distribution has been deprecated for the identical 'llogis' distribution.")
  }
  if ("burrIII2" %in% dists) {
    deprecate_warn("0.1.2", "xburrIII2()",
                   details = "The 'burrIII2' distribution has been deprecated for the identical 'llogis' distribution.", id = "xburrIII2")
  }
  chk_subset(dists, ssd_dists())
  chk_flag(computable)
  chk_flag(silent)
  
  data <- process_data(data, left = left, right = right, weight = weight, 
                       nrow = nrow, silent = silent)
  fit <- fit_dists(data, dists, computable, silent)
  fit
}
