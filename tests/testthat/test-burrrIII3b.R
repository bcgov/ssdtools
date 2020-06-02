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

test_that("dburrIII3b extremes", {
  expect_identical(dburrIII3b(numeric(0)), numeric(0))
  expect_identical(dburrIII3b(NA), NA_real_)
  expect_identical(dburrIII3b(NaN), NaN)
  expect_identical(dburrIII3b(0), 0)
  expect_equal(dburrIII3b(2), 1/9) 
  expect_equal(dburrIII3b(1), 0.25) 
  expect_equal(dburrIII3b(1, log = TRUE), log(dburrIII3b(1)))
  expect_identical(dburrIII3b(0), 0)
  expect_identical(dburrIII3b(-Inf), 0)
  expect_identical(dburrIII3b(Inf), 0)
  expect_identical(dburrIII3b(c(NA, NaN, 0, Inf, -Inf)), 
                   c(dburrIII3b(NA), dburrIII3b(NaN), dburrIII3b(0), dburrIII3b(Inf), dburrIII3b(-Inf)))
  expect_equal(dburrIII3b(1:2, lshape1 = 1:2, lshape2 = 3:4), 
               c(dburrIII3b(1, 1, 3), dburrIII3b(2, 2, 4)))
  expect_equal(dburrIII3b(1:2, lshape1 = c(1, NA), lshape2 = 3:4), 
               c(dburrIII3b(1, 1, 3), NA))
})

test_that("pburrIII3b extremes", {
  expect_identical(pburrIII3b(numeric(0)), numeric(0))
  expect_identical(pburrIII3b(NA), NA_real_)
  expect_identical(pburrIII3b(NaN), NaN)
  expect_identical(pburrIII3b(0), 0)
  expect_equal(pburrIII3b(1), 0.5)
  expect_equal(pburrIII3b(1/3), 0.75)
  expect_equal(pburrIII3b(1, log.p = TRUE), log(pburrIII3b(1)))
  expect_equal(pburrIII3b(1, lower.tail = FALSE), 1 - 0.5)
  expect_equal(pburrIII3b(1, lower.tail = FALSE, log.p = TRUE), log(1 - 0.5))
  expect_identical(pburrIII3b(0), 0)
  expect_identical(pburrIII3b(-Inf), 0)
  expect_identical(pburrIII3b(Inf), 1)
  expect_identical(pburrIII3b(c(NA, NaN, 0, Inf, -Inf)), 
                   c(pburrIII3b(NA), pburrIII3b(NaN), pburrIII3b(0), pburrIII3b(Inf), pburrIII3b(-Inf)))
  expect_equal(pburrIII3b(1:2, lshape1 = 1:2, lshape2 = 3:4), 
               c(pburrIII3b(1, 1, 3), pburrIII3b(2, 2, 4)))
  expect_equal(pburrIII3b(1:2, lshape1 = c(1, NA), lshape2 = 3:4), 
               c(pburrIII3b(1, 1, 3), NA))
})

test_that("qburrIII3b extremes", {
  expect_identical(qburrIII3b(numeric(0)), numeric(0))
  expect_identical(qburrIII3b(NA), NA_real_)
  expect_identical(qburrIII3b(NaN), NaN)
  expect_identical(qburrIII3b(0), 0)
  expect_identical(qburrIII3b(1), Inf)
  expect_equal(actuar::qburr(0.75, shape1 = 1, shape2 = 1, scale = 1), 3)
  expect_equal(actuar::qburr(1-0.75, shape1 = 1, shape2 = 1, scale = 1), 1/3)
  expect_equal(qburrIII3b(0.75), 1/3)
  expect_equal(qburrIII3b(0.75, log.p = TRUE), NaN)
  expect_equal(qburrIII3b(log(0.75), log.p = TRUE), qburrIII3b(0.75))
  expect_equal(qburrIII3b(0.75, lower.tail = FALSE), qburrIII3b(0.25))
  expect_equal(qburrIII3b(log(0.75), lower.tail = FALSE, log.p = TRUE), qburrIII3b(0.25))
  expect_identical(qburrIII3b(0), 0)
  expect_identical(qburrIII3b(-Inf), NaN)
  expect_identical(qburrIII3b(Inf), NaN)
  expect_identical(qburrIII3b(c(NA, NaN, 0, Inf, -Inf)), 
                   c(qburrIII3b(NA), qburrIII3b(NaN), qburrIII3b(0), qburrIII3b(Inf), qburrIII3b(-Inf)))
  expect_equal(qburrIII3b(1:2, lshape1 = 1:2, lshape2 = 3:4), 
               c(qburrIII3b(1, 1, 3), qburrIII3b(2, 2, 4)))
  expect_equal(qburrIII3b(1:2,  c(1, NA), 3:4), 
               c(qburrIII3b(1, 1, 3), NA))
  expect_equal(qburrIII3b(pburrIII3b(c(0, 0.1, 0.5, 0.9, 1))), c(0, 0.1, 0.5, 0.9, 1))
})

test_that("rburrIII3b extremes", {
  expect_identical(rburrIII3b(numeric(0)), numeric(0))
  expect_error(rburrIII3b(NA))
  expect_identical(rburrIII3b(0), numeric(0))
  set.seed(42)
  expect_equal(rburrIII3b(1), 10.7379218085407)
  set.seed(42)
  expect_equal(rburrIII3b(1.9), 10.7379218085407)
  set.seed(42)
  expect_equal(rburrIII3b(2), c(10.7379218085407, 14.8920392236127))
  set.seed(42)
  expect_equal(rburrIII3b(3:4), c(10.7379218085407, 14.8920392236127))
  expect_error(rburrIII3b(1, 1:2))
  expect_error(rburrIII3b(1, 1:2, 1:2))
  expect_identical(rburrIII3b(1, NA), NA_real_)
})

test_that("dburrIII3b", {
  expect_identical(dburrIII3b(numeric(0)), numeric(0))
  expect_equal(dburrIII3b(NA), NA_real_) # equal for windows
  
  expect_equal(
    dburrIII3b(c(31, 15, 32, 32, 642, 778, 187, 12), lscale = 0),
    c(
      0.0009765625, 0.00390625, 0.000918273645546373, 0.000918273645546373,
      2.41867799897932e-06, 1.64787810975198e-06, 2.82933454051607e-05,
      0.00591715976331361
    )
  )
  warning("this is different to dburrIII3")
  expect_equal(
    dburrIII3b(c(31, 15, 32, 32, 642, 778, 187, 12), lscale = 0, log = TRUE),
    c(-6.60742940990222e-05, -0.000573675743445077, -6.01008958335033e-05, 
          -6.01008958335033e-05, -7.55243324336062e-09, -4.24436030807565e-09, 
          -3.05032799071329e-07, -0.00111170427324356))
})

test_that("fit burrIII3b", {
  data <- data.frame(Conc = c(31, 15, 32, 32, 642, 778, 187, 12))
  
  dist <- ssd_fit_dist(data, dist = "burrIII3b")
  
  expect_true(is.fitdist(dist))
  expect_equal(
    coef(dist),
    c(lshape1 = 16.5173802829891, lshape2 = 1.47487713265822, lscale = 1.17790909109356
    )
  )
  
  data$Conc <- data$Conc / 1000
  
  expect_error(ssd_fit_dist(data, dist = "burrIII3b"), "failed to estimate")
})

test_that("fit burrIII3b cis", {
  data <- data.frame(Conc = c(31, 15, 32, 32, 642, 778, 187, 12))
  
  dist <- ssd_fit_dist(data, dist = "burrIII3b")
  
  set.seed(77)
  expect_error(as.data.frame(ssd_hc(dist, ci = TRUE, nboot = 10)),
  "bootstraps include missing values")
  set.seed(77)
  expect_error(
    expect_error(ssd_hp(dist, conc = 2, ci = TRUE, nboot = 10),
                 "bootstraps including missing values"))
})

test_that("qburrIII3b", {
  expect_identical(qburrIII3b(numeric(0)), numeric(0))
  expect_identical(qburrIII3b(0), 0)
  expect_identical(qburrIII3b(1), Inf)
  expect_identical(qburrIII3b(NA), NA_real_)
  expect_identical(qburrIII3b(0.5, lscale = 0), 1)
  warning("also getting inverse of burrIII3")
  expect_equal(qburrIII3b(c(0.1, 0.2), lscale = 0), c(9, 4))
})

test_that("pburrIII3b", {
  expect_identical(pburrIII3b(numeric(0)), numeric(0))
  expect_identical(pburrIII3b(0), 0)
  expect_identical(pburrIII3b(1, lscale = 0), 0.5)
  expect_identical(pburrIII3b(NA), NA_real_)
  expect_identical(pburrIII3b(qburrIII3b(0.5)), 0.5)
  expect_equal(
    pburrIII3b(qburrIII3b(c(.001, .01, .05, .50, .99))),
    c(.001, .01, .05, .50, .99)
  )
})

test_that("rburrIII3b", {
  expect_identical(rburrIII3b(0), numeric(0))
  set.seed(101)
  expect_equal(
    rburrIII3b(10, lscale = 0),
    c(
      0.592859849849427, 0.0458334582732346, 2.44452273715775, 1.92133200433186,
      0.33307689063302, 0.428683341542249, 1.40886438557549, 0.500301132990527,
      1.6455863786175, 1.20181169357475
    )
  )
})

test_that("burrIII3b", {
  warning("burrIII3 fitting with boron_data")
  dist <- ssd_fit_dists(ssdtools::boron_data, dist = "burrIII3b")
  
  expect_true(is.fitdists(dist))
  expect_equal(
    coef(dist),
    list(burrIII3b = c(lshape1 = 14.3220464095642, lshape2 = 0.922503546546153, 
                       lscale = 5.44314511761215))
  )
})
