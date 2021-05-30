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

test_that("match_moments all", {
  rlang::scoped_options(lifecycle_verbosity = "quiet")
  set.seed(10)
  pars <- ssd_match_moments(dists = c(
    "gamma",
    "gompertz", "lgumbel", "llogis",
    "lnorm", "weibull"
  ))
  expect_equal(
    pars,
    list(gamma = c(shape = 1.63660278320313, scale = 2.30180053710938
    ), gompertz = c(location = 0.109304344095289, shape = 0.328852490382271),
    lgumbel = c(locationlog = 0.534375, scalelog = 0.7625), llogis = c(locationlog = 0.96875, 
                                                                          scalelog = 0.525), lnorm = c(meanlog = 0.98125, sdlog = 0.9515625
                                                                          ), weibull = c(shape = 1.26367187500001, scale = 4.325390625))
  )

  expect_s3_class(ssd_plot_cdf(pars), "ggplot")
})
