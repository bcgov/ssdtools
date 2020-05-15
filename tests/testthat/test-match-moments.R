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

test_that("match_moments default", {
  set.seed(10)
  pars <- ssd_match_moments()
  expect_equal(pars, list(llogis = c(lshape = 0.6, lscale = 0.975000000000001), gamma = c(
    shape = 1.4796875,
    scale = 2.5890625
  ), lnorm = c(meanlog = 0.98125, sdlog = 0.9515625)))
  expect_is(ssd_plot_cdf(pars), "ggplot")
})

test_that("match_moments all", {
  rlang::scoped_options(lifecycle_verbosity = "quiet")
  set.seed(10)
  pars <- ssd_match_moments(dists = c(
    "burrIII2", "burrIII3", "gamma",
    "gompertz", "lgumbel", "llogis",
    "lnorm", "pareto", "weibull"
  ))
  expect_equal(
    pars,
    list(burrIII2 = c(lshape = 0.399359130859376, lscale = -0.602319335937502), burrIII3 = c(
      lshape1 = 0.707510288065844, lshape2 = 0.348559670781893,
      lscale = -0.215226337448561
    ), gamma = c(shape = 1.4796875, scale = 2.5890625), gompertz = c(lscale = -1.12955560684204, lshape = -2.17702827453613), lgumbel = c(llocation = 0.534375, lscale = 0.7625), llogis = c(
      lshape = 0.6,
      lscale = 0.975000000000001
    ), lnorm = c(meanlog = 0.98125, sdlog = 0.9515625), pareto = c(scale = 1, shape = 1), weibull = c(
      shape = 1.35231933593751,
      scale = 4.5020751953125
    ))
  )

  expect_is(ssd_plot_cdf(pars), "ggplot")
})

test_that("match_moments all", {
  rlang::scoped_options(lifecycle_verbosity = "quiet")
  set.seed(10)
  pars <- ssd_match_moments(dists = c(
    "burrIII2", "burrIII3", "gamma",
    "gompertz", "lgumbel", "llogis",
    "lnorm", "weibull"
  ))
  expect_equal(
    pars,
    list(burrIII2 = c(lshape = 0.399359130859376, lscale = -0.602319335937502), burrIII3 = c(
      lshape1 = 0.707510288065844, lshape2 = 0.348559670781893,
      lscale = -0.215226337448561
    ), gamma = c(shape = 1.4796875, scale = 2.5890625), gompertz = c(lscale = -1.12955560684204, lshape = -2.17702827453613), lgumbel = c(llocation = 0.534375, lscale = 0.7625), llogis = c(
      lshape = 0.6,
      lscale = 0.975000000000001
    ), lnorm = c(meanlog = 0.98125, sdlog = 0.9515625), weibull = c(shape = 1.35231933593751, scale = 4.5020751953125))
  )

  expect_is(ssd_plot_cdf(pars), "ggplot")
})
