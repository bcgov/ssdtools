predict_fitdist_prob <- function(prob, boot, level) {
  quantile <- quantile(boot, prob, CI.level = level)
  est <- quantile$quantiles[1,1]
  se <- sd(quantile$bootquant[,1], 2)
  lcl <- quantile$quantCI[1,1]
  ucl <- quantile$quantCI[2,1]
  tibble::data_frame(prob = prob, est = est, se = se, lcl = lcl, ucl = ucl)
}

#' @export
predict.fitdist <- function(object, probs = seq(0.01, 0.99, by = 0.02),
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

#' @export
predict.fitdists <- function(object, probs = seq(0.01, 0.99, by = 0.02),
                             nboot = 1001, IC = AIC, level = 0.95, ...) {
  ic <- IC(object)

  if(!(is.data.frame(ic) && ncol(ic) == 2 && row.names(ic) == names(object)))
    stop("IC must return a data frame with two columns and one named row for each object")

  ic$delta <- ic[[2]] - min(ic[[2]])
  ic$weight <- round(exp(-ic$delta/2)/sum(exp(-ic$delta/2)), 3)

  ic %<>% split(., 1:nrow(.))

  predictions <- lapply(object, predict, probs = probs, nboot = nboot, level = level) %>%
    map2(ic, function(x, y) {x$weight <- y$weight; x}) %>%
    dplyr::bind_cols() %>%
    plyr::ddply("prob", model_average) %>%
    tibble::as_tibble()

  predictions
}
