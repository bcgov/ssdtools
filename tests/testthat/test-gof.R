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

test_that("ssd_gof", {
  glance <- glance(boron_lnorm)
  expect_s3_class(glance, "tbl_df")
  expect_identical(colnames(glance), c("dist", "npars", "nobs", "log_lik", "aic", "aicc", "delta", "weight"))
  expect_identical(glance$dist, "lnorm")
  expect_equal(glance$aicc, 1.03548089655296)
  
  x <- ssd_gof(boron_lnorm)
  
  expect_s3_class(x, "tbl")
  expect_identical(colnames(x), c("dist", "ad", "ks", "cvm", "aic", "aicc", "bic", "delta", "weight"))
  expect_identical(x$dist, "lnorm")
  # expect_equal(x$ad, 0.506765995104718)
  # expect_equal(x$ks, 0.106478603062667)
  # expect_equal(x$cvm, 0.0702966462329144)
  expect_equal(x$aic, 0.555480896552964)
  expect_equal(x$aicc, 1.03548089655296)
  expect_equal(x$bic, 3.21988991690337)
  
  glance <- glance(boron_dists)
  expect_s3_class(glance, "tbl_df")
  expect_identical(colnames(glance), c("dist", "npars", "nobs", "log_lik", "aic", "aicc", "delta", "weight"))
  expect_identical(glance$dist, c("gamma", "llogis", "lnorm"))
  expect_equal(glance$delta, c(0, 3.38455325148215, 1.39811558141363))
  expect_equal(glance$weight, c(0.594829740553168, 0.109508107600024, 0.295662151846809))

  xs <- ssd_gof(boron_dists)
  expect_s3_class(xs, "tbl")
  expect_identical(colnames(xs), c("dist", "ad", "ks", "cvm", "aic", "aicc", "bic", "delta", "weight"))
  expect_identical(xs$dist, names(boron_dists))

  dists <- ssd_fit_dists(boron_data[1:6, ], dists = c("llogis", "gamma", "lnorm"))
  xx <- ssd_gof(dists)

  expect_s3_class(xx, "tbl")
  expect_identical(colnames(xx), c("dist", "ad", "ks", "cvm", "aic", "aicc", "bic", "delta", "weight"))
  expect_identical(xx$dist, c("llogis", "gamma", "lnorm"))
})
