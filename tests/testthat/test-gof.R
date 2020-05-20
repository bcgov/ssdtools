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

test_that("ssd_gof", {
  x <- ssd_gof(boron_lnorm)
  expect_is(x, "tbl")
  expect_identical(colnames(x), c("dist", "ad", "ks", "cvm", "aic", "aicc", "bic"))
  expect_identical(x$dist, "lnorm")
  expect_equal(x$ad, 0.506765995104718)
  expect_equal(x$ks, 0.106478603062667)
  expect_equal(x$cvm, 0.0702966462329144)
  expect_equal(x$aic, 239.028434223307)
  expect_equal(x$aicc, 239.508434223307)
  expect_equal(x$bic, 241.692843243657)

  xs <- ssd_gof(boron_dists)
  expect_is(xs, "tbl")
  expect_identical(colnames(xs), c("dist", "ad", "ks", "cvm", "aic", "aicc", "bic", "delta", "weight"))
  expect_identical(xs$dist, names(boron_dists))
  expect_equal(xs[xs$dist == "lnorm", c("dist", "ad", "ks", "cvm", "aic", "aicc", "bic")], x,
    check.attributes = FALSE
  )

  dists <- ssd_fit_dists(boron_data[1:6, ], dists = c("llogis", "gamma", "lnorm"))
  xx <- ssd_gof(dists)

  expect_is(xx, "tbl")
  expect_identical(colnames(xx), c("dist", "ad", "ks", "cvm", "aic", "aicc", "bic", "delta", "weight"))
  expect_identical(xx$dist, names(boron_dists))
})

test_that("ssd_gof fitdistscens", {
  dists <- ssd_gof(fluazinam_dists)
  expect_is(dists, "tbl_df")
  expect_identical(colnames(dists), c("dist", "aic", "bic", "delta", "weight"))
  expect_equal(dists$aic, c(149.908903257135, 152.809136132656, 149.625327602334))
  expect_equal(dists$weight, c(0.419, 0.098, 0.483))
})
