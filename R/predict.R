predict_fitdist_prob <- function(prob, boot, level) {
  quantile <- quantile(boot, prob, CI.level = level)
  est <- quantile$quantiles[1,1]
  se <- sd(quantile$bootquant[,1], 2)
  lcl <- quantile$quantCI[1,1]
  ucl <- quantile$quantCI[2,1]
  tibble::data_frame(prob = prob, est = est, se = se, lcl = lcl, ucl = ucl)
}

#' Predict fitdist
#'
#' @inheritParams predict.fitdists
#' @export
#' @examples
#' predict(boron_lnorm, probs = c(0.05, 0.5))
predict.fitdist <- function(object, probs = seq(0.01, 0.99, by = 0.01),
                            nboot = 1001, level = 0.95, ...) {
  check_vector(probs, c(0.001, 0.999), length = c(1, Inf), unique = TRUE)
  check_count(nboot, coerce = TRUE)
  check_probability(level)
  boot <- bootdist(object, niter = nboot)
  prediction <- map_df(probs, predict_fitdist_prob, boot = boot, level = level)
  prediction
}

model_average <- function(x) {
  est <- sum(x$est * x$weight)
  se <- sqrt(sum(x$weight * (x$se^2 + (x$est - est)^2)))
  lcl <- sum(x$lcl * x$weight)
  ucl <- sum(x$ucl * x$weight)
  tibble::data_frame(est = est, se = se, lcl = lcl, ucl = ucl)
}

#' Predict fitdist
#'
#' @param object The object.
#' @param probs A numeric vector of the densities to calculate the estimated concentrations for.
#' @param nboot A count of the number of bootstrap samples to use to estimate the se and confidence limits.
#' @param ic A string indicating which information-theoretic criterion ('aic', 'aicc' or 'bic') to use for model averaging or use 'no' to not model average.
#' @param average A flag indicating whether to model-average.
#' @param level A real of the confidence limit.
#' @param ... Unused
#' @export
#' @examples
#' \dontrun{
#' predict(boron_dists)
#' }
predict.fitdists <- function(object, probs = seq(0.01, 0.99, by = 0.01),
                             nboot = 1001, ic = "aic", average = TRUE, level = 0.95, ...) {
  check_vector(ic, c("aic", "aicc", "bic"), length = 1)

  ic <- ssd_gof(object)[c("dist", ic)]

  ic$delta <- ic[[2]] - min(ic[[2]])
  ic$weight <- round(exp(-ic$delta/2)/sum(exp(-ic$delta/2)), 3)

  ic %<>% split(., 1:nrow(.))

  predictions <- lapply(object, predict, probs = probs, nboot = nboot, level = level) %>%
    map2(ic, function(x, y) {x$weight <- y$weight; x}) %>%
    dplyr::bind_rows(.id = "dist")

  if(!average) return(predictions)

  predictions %<>%
    plyr::ddply("prob", model_average) %>%
    tibble::as_tibble()

  predictions
}
