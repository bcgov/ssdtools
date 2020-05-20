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
    ssd_hc(dists, average = FALSE)$est,
    c(1.07373870642628, 1.29945366523807, 1.76891782851293, 1.56256632555312, 
      1.68066107721146, 1.0871695998917)
  )

  set.seed(99)
  expect_equal(
    as.data.frame(ssd_hc(dists, ci = TRUE, nboot = 10)),
    structure(list(percent = 5, est = 1.2504293469908, se = 0.631776851773594, 
                   lcl = 0.775249435219941, ucl = 2.60353105288968, dist = "average"), row.names = c(NA, 
                                                                                                     -1L), class = "data.frame")
  )

  dists <- ssd_gof(dists)
  expect_is(dists, "tbl_df")
  expect_identical(
    colnames(dists),
    c("dist", "ad", "ks", "cvm", "aic", "aicc", "bic", "delta", "weight")
  )
  expect_identical(dists$dist, c(
    "gamma", "gompertz", "lgumbel", "llogis",
    "lnorm", "weibull"
  ))
  expect_equal(dists$ad, c(0.440080783302818, 0.602165187357315, 0.828638954899656, 0.487268240754265, 
                           0.506765995104718, 0.434627293919434))
  expect_equal(dists$ks, c(0.11688217126248, 0.120189751040992, 0.158266487930008, 0.0993097760964311, 
                           0.106478603062667, 0.116975804418597))
  expect_equal(dists$cvm, c(0.0553642028346856, 0.0822552288877461, 0.134017999007959, 
                            0.0595308368054581, 0.0702966462329144, 0.0542672742561657))
  expect_equal(dists$aic, c(
    237.630318352347, 237.61115441186,
    244.185952512763, 241.014872096207, 239.028432979095, 237.625291133194
  ))
  expect_equal(dists$aicc, c(
    238.110318352347, 238.09115441186, 244.665952512763,
    241.494872096207, 239.508432979095, 238.105291133194
  ), bic = c(
    240.294727372698,
    240.275563432211, 246.850361533114, 243.679281116558, 241.692841999445,
    240.289700153545
  ))
  expect_equal(dists$delta, c(0.019, 0, 6.575, 3.404, 1.417, 0.014))
  expect_equal(dists$weight, c(0.268, 0.271, 0.01, 0.049, 0.133, 0.269))
})
