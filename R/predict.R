predict_fitdist_prob <- function(prob, boot, level) {
  quantile <- quantile(boot, prob, CI.level = level)
  est <- quantile$quantiles[1,1]
  se <- sd(quantile$bootquant[,1], 2)
  lcl <- quantile$quantCI[1,1]
  ucl <- quantile$quantCI[2,1]
  tibble::data_frame(prob = prob, est = est, se = se, lcl = lcl, ucl = ucl)
}

#' @export
predict.fitdist <- function(object, probs = seq(0.01, 0.99, by = 0.02), level = 0.95, ...) {
  check_vector(probs, c(0.001, 0.999), length = c(1, Inf), unique = TRUE)
  check_probability(level)
  boot <- fitdistrplus::bootdist(object)
  prediction <- map_df(probs, predict_fitdist_prob, boot = boot, level = level)
  prediction
}
