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

quantile_data <- function(boot, percent, level) {
  quantile <- quantile(boot, percent / 100, CI.level = level)
  ci <- t(as.matrix(quantile$quantCI))
  est <- t(as.matrix(quantile$quantiles))
  se <- as.matrix(quantile$bootquant)
  se <- apply(as.matrix(quantile$bootquant), 2, sd)
  
  data <- data.frame(percent = percent, est = est[,1], se = se, 
                     lcl = ci[,1], ucl = ci[,2])
  as_tibble(data)
}

empty_quantile_data <- function(percent) {
  stopifnot(!length(percent))
  as_tibble(data.frame(percent = percent, est = numeric(0), se = numeric(0), 
                       lcl = numeric(0), ucl = numeric(0)))
}

model_average <- function(x) {
  est <- sum(x$est * x$weight)
  se <- sqrt(sum(x$weight * (x$se^2 + (x$est - est)^2)))
  lcl <- sum(x$lcl * x$weight)
  ucl <- sum(x$ucl * x$weight)
  data.frame(
    percent = x$percent[1], est = est, se = se, lcl = lcl, ucl = ucl,
    stringsAsFactors = FALSE
  )
}

#' Predict fitdist
#'
#' @inheritParams fitdistrplus::bootdist
#' @inheritParams predict.fitdists
#' @export
#' @examples
#' predict(boron_lnorm, percent = c(5L, 50L))
predict.fitdist <- function(object, percent = 1:99,
                            nboot = 1000, level = 0.95, 
                            parallel = "no", ncpus = 1L, ...) {
  chk_numeric(percent)
  chk_range(percent, c(1, 99))
  chk_not_any_na(percent)
  chk_unique(percent)
  chk_whole_number(nboot)
  chk_gt(nboot)
  chk_number(level)
  chk_range(level)
  chk_unused(...)
  
  if(!length(percent)) return(empty_quantile_data(percent))
  
  boot <- boot(object, nboot = nboot, parallel = parallel, ncpus  = ncpus)
  quantile_data(boot, percent, level)
}

#' Predict censored fitdist
#'
#' @inheritParams predict.fitdists
#' @inheritParams fitdistrplus::bootdistcens
#' @export
#' @examples
#' \dontrun{
#' predict(fluazinam_lnorm, percent = c(5L, 50L))
#' }
predict.fitdistcens <- function(object, percent = 1:99,
                                nboot = 1000, level = 0.95, 
                                parallel = "no", ncpus = 1L, ...) {
  chk_numeric(percent)
  chk_range(percent, c(1, 99))
  chk_not_any_na(percent)
  chk_unique(percent)
  
  chk_whole_number(nboot)
  chk_number(level)
  chk_range(level)
  chk_unused(...)
  
  if(!length(percent)) return(empty_quantile_data(percent))
  
  boot <- boot(object, nboot = nboot, parallel = parallel, ncpus = ncpus)
  quantile_data(boot, percent, level)
}

#' Predict fitdists
#'
#' @inheritParams fitdistrplus::bootdist
#' @param object The object.
#' @param percent A numeric vector of the densities to calculate the estimated concentrations for.
#' @param nboot A count of the number of bootstrap samples to use to estimate the se and confidence limits.
#' @param ic A string indicating which information-theoretic criterion ('aic', 'aicc' or 'bic') to use for model averaging.
#' @param average A flag indicating whether to model-average.
#' @param level The confidence level.
#' @param ... Unused
#' @export
#' @examples
#' \dontrun{
#' predict(boron_dists)
#' }
predict.fitdists <- function(object, percent = 1:99,
                             nboot = 1000, ic = "aicc", average = TRUE, 
                             level = 0.95, parallel = "no", ncpus = 1L, ...) {
  chk_string(ic)
  chk_subset(ic, c("aic", "aicc", "bic"))
  chk_unused(...)
  
  ic <- ssd_gof(object)[c("dist", ic)]
  
  ic$delta <- ic[[2]] - min(ic[[2]])
  ic$weight <- round(exp(-ic$delta / 2) / sum(exp(-ic$delta / 2)), 3)
  
  ic <- split(ic, 1:nrow(ic))
  
  predictions <- lapply(object, predict, percent = percent, nboot = nboot, 
                        level = level, parallel = parallel, ncpus = ncpus)
  predictions <- mapply(function(x, y) {
    x$weight <- y$weight
    x
  }, predictions, ic,
  SIMPLIFY = FALSE
  )
  predictions <- mapply(function(x, y) {
    x$dist <- y
    x
  }, predictions, names(predictions),
  SIMPLIFY = FALSE
  )
  predictions$stringsAsFactors <- FALSE
  predictions <- do.call("rbind", predictions)
  predictions <- predictions[c("dist", "percent", "est", "se", "lcl", "ucl", "weight")]
  
  if (!average) {
    return(predictions)
  }
  
  predictions <- split(predictions, predictions$percent)
  predictions <- lapply(predictions, model_average)
  predictions$stringsAsFactors <- FALSE
  predictions <- do.call("rbind", predictions)
  as_tibble(predictions)
}

#' Predict Censored fitdists
#'
#' @inheritParams predict.fitdists
#' @inheritParams fitdistrplus::bootdistcens
#' @export
#' @examples
#' \dontrun{
#' predict(fluazinam_dists)
#' }
predict.fitdistscens <- function(object, percent = 1:99,
                                 nboot = 1000, ic = "aic", average = TRUE, 
                                 level = 0.95, parallel = "no", ncpus = 1L, ...) {
  chk_string(ic)
  chk_subset(ic, c("aic", "bic"))
  
  NextMethod(
    object = object, percent = percent, nboot = nboot, ic = ic, average = average,
    level = level, parallel = parallel, ncpus = ncpus, ...
  )
}
