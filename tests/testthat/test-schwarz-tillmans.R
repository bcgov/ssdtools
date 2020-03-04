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

test_that("manual", {
  set.seed(10)
  dists <- ssd_fit_dists(ssdtools::boron_data, dists = c(
    "gamma", "gompertz", "lgumbel", "llogis", "lnorm", "weibull"
  ))
  expect_true(is.fitdists(dists))

  expect_equal(
    as.data.frame(ssd_gof(dists)),
    structure(list(dist = c(
      "gamma", "gompertz", "lgumbel", "llogis",
      "lnorm", "weibull"
    ), ad = c(
      0.440080783302818, 0.602165187357315,
      0.82846401226227, 0.487338850206807, 0.507033548166948, 0.434627293919434
    ), ks = c(
      0.11688217126248, 0.120189751040992, 0.15822966868497,
      0.0992853307542206, 0.106514303667428, 0.116975804418597
    ), cvm = c(
      0.0553642028346856,
      0.0822552288877461, 0.133959785380826, 0.059553716334688, 0.0703316409091878,
      0.0542672742561657
    ), aic = c(
      237.630318352347, 237.61115441186,
      244.185952678141, 241.014873786487, 239.028432979095, 237.625291133194
    ), aicc = c(
      238.110318352347, 238.09115441186, 244.665952678141,
      241.494873786487, 239.508432979095, 238.105291133194
    ), bic = c(
      240.294727372698,
      240.275563432211, 246.850361698491, 243.679282806838, 241.692841999445,
      240.289700153545
    ), delta = c(0.019, 0, 6.575, 3.404, 1.417, 0.014), weight = c(0.268, 0.271, 0.01, 0.049, 0.133, 0.269)), row.names = c(
      "gamma",
      "gompertz", "lgumbel", "llogis", "lnorm", "weibull"
    ), class = "data.frame")
  )

  expect_equal(
    ssd_hc(dists, average = FALSE)$est,
    c(
      1.07373870642628, 1.29945366523807, 1.76898186161132, 1.56257332292696,
      1.68117483775796, 1.0871695998917
    )
  )

  set.seed(99)
  expect_equal(
    as.data.frame(ssd_hc(dists, ci = TRUE, nboot = 10)),
    structure(list(
      percent = 5, est = 1.25049880604773, se = 0.631765909916202,
      lcl = 0.775280794775933, ucl = 2.60353352860508, dist = "average"
    ), row.names = c(
      NA,
      -1L
    ), class = "data.frame")
  )
})
