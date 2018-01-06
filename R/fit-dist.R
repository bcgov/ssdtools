#' Fit Distribution
#'
#' @param x A numeric vector of the data.
#' @param dist A string of the distribution to fit.
#'
#' @return An object of class fitdist.
fit_dist_internal <- function(x, dist = "lnorm") {
  check_vector(x, 1)
  check_string(dist)

  dist %<>% list(data = x, distr = ., method = "mle")

  if(dist$distr == "burr"){
    dist$start <- list(shape1 = 4, shape2 = 1, rate = 1)
    dist$method <- "mme"
    dist$order <- 1:3
    dist$memp  <- function (x, order){ sum(x^order) }
  } else if(dist$dist == "gamma"){
    dist$start <- list(scale = var(x) / mean(x),
                       shape = mean(x)^2 / var(x)^2)
  } else if(dist$distr == "gompertz"){
    fit <- vglm(x~1, gompertz)
    dist$start <- list(shape = exp(unname(coef(fit)[2])),
                       scale = exp(unname(coef(fit)[1])) )
  } else if(dist$distr == "lgumbel"){
    dist$start <- list(location = mean(log(x)),
                       scale = pi*sd(log(x))/sqrt(6))
  } else if(dist$distr == "llog" ){
    dist$start <- list(shape = mean(log(x)), scale = pi*sd(log(x))/sqrt(3))
  } else if(dist$distr == "pareto"){
    fit <- vglm(x~1, paretoff)
    dist$start  <- list(shape = exp(unname(coef(fit))))
    dist$fix.arg<- list(scale = fit@extra$scale)
  } else if(dist$distr %in% c("lnorm", "weibull")){
  } else
    stop("distribution '", dist$distr, "' unrecognised", call. = FALSE)

  fit <- do.call(fitdistrplus::fitdist, dist)
  fit
}

#' Fit Distribution
#'
#' @param x A numeric vector of the data.
#' @param dist A string of the distribution to fit.
#'
#' @return An object of class fitdist.
#' @export
#'
#' @examples
#' ssd_fit_dist(ccme_data$Conc[ccme_data$Chemical == "Boron"])
ssd_fit_dist <- function(x, dist = "lnorm") {
  fit_dist_internal(x, dist)
}
