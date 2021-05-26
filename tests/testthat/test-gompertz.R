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
# 
# test_that("dgompertz extremes", {
#   expect_identical(dgompertz(numeric(0)), numeric(0))
#   expect_identical(dgompertz(NA), NA_real_)
#   expect_identical(dgompertz(NaN), NaN)
#   expect_identical(dgompertz(0), 1)
#   expect_equal(dgompertz(1), 0.487589298719261)
#   expect_equal(dgompertz(1, log = TRUE), log(dgompertz(1)))
#   expect_identical(dgompertz(0), 1)
#   expect_identical(dgompertz(-Inf), 0)
#   expect_identical(dgompertz(Inf), 0)
#   expect_identical(dgompertz(c(NA, NaN, 0, Inf, -Inf)), 
#                    c(dgompertz(NA), dgompertz(NaN), dgompertz(0), dgompertz(Inf), dgompertz(-Inf)))
#   expect_equal(dgompertz(1:2, llocation = 1:2, lshape = 3:4), 
#                c(dgompertz(1, 1, 3), dgompertz(2, 2, 4)))
#   expect_equal(dgompertz(1:2, llocation = c(1, NA), lshape = 3:4), 
#                c(dgompertz(1, 1, 3), NA))
# })
# 
test_that("pgompertz extremes", {
  expect_identical(pgompertz(numeric(0)), numeric(0))
  expect_identical(pgompertz(NA), NA_real_)
  expect_identical(pgompertz(NaN), NaN)
  expect_identical(pgompertz(0), 0)
  expect_equal(pgompertz(1), 0.820625921265983)
  expect_equal(pgompertz(1, log.p = TRUE), log(pgompertz(1)))
  expect_equal(pgompertz(1, lower.tail = FALSE), 1 - pgompertz(1))
  expect_equal(pgompertz(1, lower.tail = FALSE, log.p = TRUE), log(1 - pgompertz(1)))
  expect_identical(pgompertz(0), 0)
  expect_identical(pgompertz(-Inf), 0)
  expect_identical(pgompertz(Inf), 1)
  expect_identical(pgompertz(c(NA, NaN, 0, Inf, -Inf)),
                   c(pgompertz(NA), pgompertz(NaN), pgompertz(0), pgompertz(Inf), pgompertz(-Inf)))
  expect_equal(pgompertz(1:2, location = 1:2, shape = 3:4),
               c(pgompertz(1, 1, 3), pgompertz(2, 2, 4)))
  expect_equal(pgompertz(1:2, location = c(1, NA), shape = 3:4),
               c(pgompertz(1, 1, 3), NA))
})

test_that("qgompertz extremes", {
  expect_identical(qgompertz(numeric(0)), numeric(0))
  expect_identical(qgompertz(NA), NA_real_)
  expect_identical(qgompertz(NaN), NaN)
  expect_identical(qgompertz(0), 0)
  expect_identical(qgompertz(1), Inf)
  expect_equal(qgompertz(0.75), 0.869741686191944)
  expect_equal(qgompertz(0.75, log.p = TRUE), NaN)
  expect_equal(qgompertz(log(0.75), log.p = TRUE), qgompertz(0.75))
  expect_equal(qgompertz(0.75, lower.tail = FALSE), qgompertz(0.25))
  expect_equal(qgompertz(log(0.75), lower.tail = FALSE, log.p = TRUE), qgompertz(0.25))
  expect_identical(qgompertz(0), 0)
  expect_identical(qgompertz(-Inf), NaN)
  expect_identical(qgompertz(Inf), NaN)
  expect_identical(qgompertz(c(NA, NaN, 0, Inf, -Inf)),
                   c(qgompertz(NA), qgompertz(NaN), qgompertz(0), qgompertz(Inf), qgompertz(-Inf)))
  expect_equal(qgompertz(1:2, location = 1:2, shape = 3:4),
               c(qgompertz(1, 1, 3), qgompertz(2, 2, 4)))
  expect_equal(qgompertz(1:2, location = c(1, NA), shape = 3:4),
               c(qgompertz(1, 1, 3), NA))
  expect_equal(qgompertz(pgompertz(c(0, 0.1, 0.5, 0.9, 1))), c(0, 0.1, 0.5, 0.9, 1))
})

test_that("rgompertz extremes", {
  expect_identical(rgompertz(numeric(0)), numeric(0))
  expect_error(rgompertz(NA))
  expect_identical(rgompertz(0), numeric(0))
  set.seed(42)
  expect_equal(rgompertz(1), 1.24208466660006)
  set.seed(42)
  expect_equal(rgompertz(1.9), 1.24208466660006)
  set.seed(42)
  expect_equal(rgompertz(2), c(1.24208466660006, 1.32596518320944))
  set.seed(42)
  expect_equal(rgompertz(3:4), c(1.24208466660006, 1.32596518320944))
  expect_equal(rgompertz(0, location = -1), numeric(0))
  expect_equal(rgompertz(0, shape = -1), numeric(0))
  expect_error(rgompertz(1, location = 1:2))
  expect_error(rgompertz(1, shape = 1:2))
  expect_identical(rgompertz(1, location = NA), NA_real_)
  expect_identical(rgompertz(1, shape = NA), NA_real_)
})
# 
# test_that("sgompertz", {
#   warning("sgompertz errors")
#   x <- c(160, 800, 840, 1500, 8200, 12800, 22000, 38000, 60900, 63000)
#   expect_error(sgompertz(x))
# 
#   quin <- ssdtools::test_data[ssdtools::test_data$Chemical == "Quinoline", ]
# 
#   expect_error(dist <- ssd_fit_dist(quin, dist = "gompertz"))
# })
# 
# test_that("fit gompertz boron", {
#   set.seed(42)
#   dist <- ssd_fit_dist(ssdtools::boron_data, dist = "gompertz")
#   expect_true(is.tmbfit(dist))
#   expect_equal(
#     coef(dist),
#     c(llocation = -3.23372380148428, lshape = -5.95162275054023)
#   )
# })
# 
# test_that("fit gompertz", {
#   set.seed(9)
#   dist <- ssd_fit_dist(ssdtools::boron_data, dist = "gompertz")
# 
#   expect_true(is.tmbfit(dist))
#   expect_equal(
#     coef(dist),
#     c(llocation = -3.23394197210355, lshape = -5.94837894139464)
#   )
# })

test_that("fit gompertz tmb", {
  dist <- ssd_fit_dists(ssdtools::boron_data, dist = "gompertz")
  
  # gompertz really poor convergence
  expect_true(is.tmbfit(dist$gompertz))
  expect_equal(
    estimates(dist$gompertz),
    list(location = 0.0394063017563918, shape = 0.00260524222893499),
    tolerance = 1e-02
  )
})
# 
# test_that("gompertz coefs", {
#   warning("gompertz poor convergence")
#   set.seed(77)
#   dist <- ssd_fit_dist(ssdtools::boron_data, dist = "gompertz")
#   expect_equal(coef(dist), c(llocation = -3.23385214013791, lshape = -5.94988038614341))
# 
#   set.seed(85)
#   dist <- ssd_fit_dist(ssdtools::boron_data, dist = "gompertz")
#   expect_equal(coef(dist), c(llocation = -3.23372348939004, lshape = -5.95206320995978))
# })
# 
# 
# test_that("fit gompertz cis", {
#   set.seed(77)
#   dist <- ssd_fit_dist(ssdtools::boron_data, dist = "gompertz")
# 
#   hc <- ssd_hc(dist, ci = TRUE, nboot = 10)
#   expect_is(hc, "tbl_df")
#   expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl"))
#   expect_identical(hc$percent, 5)
#   expect_equal(hc$est, 1.29947858260222)
#   expect_equal(hc$se, 0.234474369346749)
#   expect_equal(hc$lcl, 0.966156147429702)
#   expect_equal(hc$ucl, 1.58273480439059)
#   expect_equal(hc$dist, "gompertz")
#   expect_error(stringsAsFactors = TRUE)
# 
#   set.seed(77)
#   hp <- ssd_hp(dist, conc = 2, ci = TRUE, nboot = 10)
#   expect_is(hp, "tbl_df")
#   expect_identical(colnames(hp), c("conc", "est", "se", "lcl", "ucl", "dist"))
#   expect_identical(hp$conc, 2)
#   expect_equal(hp$est, 7.59650778517608, tolerance = 1e-2)
#   expect_equal(hp$se, 1.14891770368466, tolerance = 1e-2) 
#   expect_equal(hp$lcl, 6.0020990844966, tolerance = 1e-2)
#   expect_equal(hp$ucl, 9.22516202386345, tolerance = 1e-2)
#   expect_equal(hp$dist, "gompertz")
#   expect_error(stringsAsFactors = TRUE)
# })
