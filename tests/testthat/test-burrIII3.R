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

test_that("dburrIII3 extremes", {
  expect_identical(dburrIII3(numeric(0)), numeric(0))
  expect_identical(dburrIII3(NA), NA_real_)
  expect_identical(dburrIII3(NaN), NaN)
  expect_identical(dburrIII3(0), 0)
  expect_equal(dburrIII3(2), 1/9) 
  expect_equal(dburrIII3(1), 0.25) 
  expect_equal(dburrIII3(1, log = TRUE), log(dburrIII3(1)))
  expect_identical(dburrIII3(0), 0)
  expect_identical(dburrIII3(-Inf), 0)
  expect_identical(dburrIII3(Inf), 0)
  expect_identical(dburrIII3(c(NA, NaN, 0, Inf, -Inf)), 
                   c(dburrIII3(NA), dburrIII3(NaN), dburrIII3(0), dburrIII3(Inf), dburrIII3(-Inf)))
  expect_equal(dburrIII3(1:2, lshape1 = 1:2, lshape2 = 3:4), 
               c(dburrIII3(1, 1, 3), dburrIII3(2, 2, 4)))
  expect_equal(dburrIII3(1:2, lshape1 = c(1, NA), lshape2 = 3:4), 
               c(dburrIII3(1, 1, 3), NA))
})

test_that("pburrIII3 extremes", {
  expect_identical(pburrIII3(numeric(0)), numeric(0))
  expect_identical(pburrIII3(NA), NA_real_)
  expect_identical(pburrIII3(NaN), NaN)
  expect_identical(pburrIII3(0), 0)
  expect_equal(pburrIII3(1), 0.5)
  expect_equal(pburrIII3(1/3), 0.25) # not sure if this is correct
  expect_equal(pburrIII3(1, log.p = TRUE), log(pburrIII3(1)))
  expect_equal(pburrIII3(1, lower.tail = FALSE), 1 - 0.5)
  expect_equal(pburrIII3(1, lower.tail = FALSE, log.p = TRUE), log(1 - 0.5))
  expect_identical(pburrIII3(0), 0)
  expect_identical(pburrIII3(-Inf), 1) # this should surely be 0
  expect_identical(pburrIII3(Inf), 1)
  expect_identical(pburrIII3(c(NA, NaN, 0, Inf, -Inf)), 
                   c(pburrIII3(NA), pburrIII3(NaN), pburrIII3(0), pburrIII3(Inf), pburrIII3(-Inf)))
  expect_equal(pburrIII3(1:2, lshape1 = 1:2, lshape2 = 3:4), 
               c(pburrIII3(1, 1, 3), pburrIII3(2, 2, 4)))
  expect_equal(pburrIII3(1:2, lshape1 = c(1, NA), lshape2 = 3:4), 
               c(pburrIII3(1, 1, 3), NA))
})

test_that("qburrIII3 extremes", {
  expect_identical(qburrIII3(numeric(0)), numeric(0))
  expect_identical(qburrIII3(NA), NA_real_)
  expect_identical(qburrIII3(NaN), NaN)
  expect_identical(qburrIII3(0), 0)
  expect_identical(qburrIII3(1), Inf)
  expect_equal(actuar::qburr(0.75, shape1 = 1, shape2 = 1, scale = 1), 3)
  expect_equal(actuar::qburr(0.25, shape1 = 1, shape2 = 1, scale = 1), 1/3)
  expect_equal(qburrIII3(0.75), 3)
  expect_equal(qburrIII3(0.75, log.p = TRUE), NaN)
  expect_equal(qburrIII3(log(0.75), log.p = TRUE), qburrIII3(0.75))
  expect_equal(qburrIII3(0.75, lower.tail = FALSE), qburrIII3(0.25))
  expect_equal(qburrIII3(log(0.75), lower.tail = FALSE, log.p = TRUE), qburrIII3(0.25))
  expect_identical(qburrIII3(0), 0)
  expect_identical(qburrIII3(-Inf), NaN)
  expect_identical(qburrIII3(Inf), NaN)
  expect_identical(qburrIII3(c(NA, NaN, 0, Inf, -Inf)), 
                   c(qburrIII3(NA), qburrIII3(NaN), qburrIII3(0), qburrIII3(Inf), qburrIII3(-Inf)))
  expect_equal(qburrIII3(1:2, lshape1 = 1:2, lshape2 = 3:4), 
               c(qburrIII3(1, 1, 3), qburrIII3(2, 2, 4)))
  expect_equal(qburrIII3(1:2,  c(1, NA), 3:4), 
               c(qburrIII3(1, 1, 3), NA))
  expect_equal(qburrIII3(pburrIII3(c(0, 0.1, 0.5, 0.9, 1))), c(0, 0.1, 0.5, 0.9, 1))
})

test_that("rburrIII3 extremes", {
  expect_identical(rburrIII3(numeric(0)), numeric(0))
  expect_error(rburrIII3(NA))
  expect_identical(rburrIII3(0), numeric(0))
  set.seed(42)
  expect_equal(rburrIII3(1), 10.7379218085407)
  set.seed(42)
  expect_equal(rburrIII3(1.9), 10.7379218085407)
  set.seed(42)
  expect_equal(rburrIII3(2), c(10.7379218085407, 14.8920392236127))
  set.seed(42)
  expect_equal(rburrIII3(3:4), c(10.7379218085407, 14.8920392236127))
  expect_error(rburrIII3(1, 1:2))
  expect_error(rburrIII3(1, 1:2, 1:2))
  expect_equal(rburrIII3(1, NA), NA_real_) # should be NA_real_ not NaN
})

test_that("dburrIII3", {
  expect_identical(dburrIII3(numeric(0)), numeric(0))
  expect_equal(dburrIII3(NA), NA_real_) # equal for windows
  
  expect_equal(
    dburrIII3(c(31, 15, 32, 32, 642, 778, 187, 12), lscale = 0),
    c(
      0.0009765625, 0.00390625, 0.000918273645546373, 0.000918273645546373,
      2.41867799897932e-06, 1.64787810975198e-06, 2.82933454051607e-05,
      0.00591715976331361
    )
  )
})

test_that("fit burrIII3", {
  data <- data.frame(Conc = c(31, 15, 32, 32, 642, 778, 187, 12))
  
  dist <- ssd_fit_dist(data, dist = "burrIII3")
  
  expect_true(is.fitdist(dist))
  expect_equal(
    coef(dist),
    c(lshape1 = 3.59302197294215, lshape2 = -0.133674768538566, lscale = 0.568325580801304
    )
  )
  
  data$Conc <- data$Conc / 1000
  
  dist <- ssd_fit_dist(data, dist = "burrIII3")
  expect_equal(
    coef(dist),
    c(lshape1 = 17.3403456134406, lshape2 = -0.148732959674022, lscale = 23.5089158967839
    )
  )
})

test_that("fit burrIII3 cis", {
  data <- data.frame(Conc = c(31, 15, 32, 32, 642, 778, 187, 12))
  
  dist <- ssd_fit_dist(data, dist = "burrIII3")
  
  set.seed(77)
  hc <- ssd_hc(dist, ci = TRUE, nboot = 10)
  
  expect_equal(hc, tibble::tibble(percent = 5, est = 9.3654970353837, se = 12.1627650023649, 
                                  lcl = 2.96137016375762, ucl = 38.498485438982, dist = "burrIII3"))
})

test_that("qburrIII3", {
  expect_identical(qburrIII3(numeric(0)), numeric(0))
  expect_identical(qburrIII3(0), 0)
  expect_identical(qburrIII3(1), Inf)
  expect_identical(qburrIII3(NA), NA_real_)
  expect_identical(qburrIII3(0.5, lscale = 0), 1)
  expect_equal(qburrIII3(c(0.1, 0.2), lscale = 0), c(1/9, 1/4))
})

test_that("pburrIII3", {
  expect_identical(pburrIII3(numeric(0)), numeric(0))
  expect_identical(pburrIII3(0), 0)
  expect_identical(pburrIII3(1, lscale = 0), 0.5)
  expect_identical(pburrIII3(NA), NA_real_)
  expect_identical(pburrIII3(qburrIII3(0.5)), 0.5)
  expect_equal(
    pburrIII3(qburrIII3(c(.001, .01, .05, .50, .99))),
    c(.001, .01, .05, .50, .99)
  )
})

test_that("rburrIII3", {
  expect_identical(rburrIII3(0), numeric(0))
  set.seed(101)
  expect_equal(
    rburrIII3(10, lscale = 0),
    c(
      0.592859849849427, 0.0458334582732346, 2.44452273715775, 1.92133200433186,
      0.33307689063302, 0.428683341542249, 1.40886438557549, 0.500301132990527,
      1.6455863786175, 1.20181169357475
    )
  )
})
