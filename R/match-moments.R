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

discrepancy <- function(pars, fun, meanlog, sdlog, nsim) {
  args <- as.list(pars)
  args$n <- nsim
  sims <- do.call(fun, args)
  smeanlog <- mean(log(sims))
  ssdlog <- sd(log(sims))
  (meanlog - smeanlog)^2 + (sdlog - ssdlog)^2
}

min_discrepancy <- function(dist, meanlog, sdlog, nsim) {
  fun <- paste0("r", dist)
  pars <- formals(fun)
  pars <- pars[names(pars) != "n"]

  pars <- unlist(pars)
  optim(pars, discrepancy,
    fun = fun, meanlog = meanlog, sdlog = sdlog,
    nsim = nsim, control = list(abstol = 0.01)
  )
}

#' Match Moments
#'
#' @inheritParams params
#' @param meanlog A number of the mean on the log scale.
#' @param sdlog A number of the standard deviation on the log scale.
#'
#' @return A named list of the parameter values that produce a distribution
#' with moments closest to the meanlog and sdlog.
#' @seealso [ssd_plot_cdf()].
#' @export
#'
#' @examples
#' ssd_match_moments()
ssd_match_moments <- function(dists = c("llogis", "gamma", "lnorm"), meanlog = 1, sdlog = 1,
                              nsim = 1e+05) {
  chk_vector(dists)
  chk_s3_class(dists, "character")

  pars <- lapply(dists, min_discrepancy, meanlog = meanlog, sdlog = sdlog, nsim = nsim)
  pars <- lapply(pars, function(x) x$par)
  names(pars) <- dists
  pars
}
