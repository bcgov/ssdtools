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

test_that("gompertz", {
  test_dist("gompertz")
  expect_equal(pgompertz(1), 0.820625921265983)
  expect_equal(qgompertz(0.75), 0.869741686191944)
  set.seed(42)
  expect_equal(rgompertz(2), c(1.24208466660006, 1.32596518320944))
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
#   expect_s3_class(hc, "tbl_df")
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
#   expect_s3_class(hp, "tbl_df")
#   expect_identical(colnames(hp), c("conc", "est", "se", "lcl", "ucl", "dist"))
#   expect_identical(hp$conc, 2)
#   expect_equal(hp$est, 7.59650778517608, tolerance = 1e-2)
#   expect_equal(hp$se, 1.14891770368466, tolerance = 1e-2) 
#   expect_equal(hp$lcl, 6.0020990844966, tolerance = 1e-2)
#   expect_equal(hp$ucl, 9.22516202386345, tolerance = 1e-2)
#   expect_equal(hp$dist, "gompertz")
#   expect_error(stringsAsFactors = TRUE)
# })
