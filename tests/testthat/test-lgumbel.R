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

test_that("dlgumbel extremes", {
  expect_identical(dlgumbel(numeric(0)), numeric(0))
  expect_identical(dlgumbel(NA), NA_real_)
  expect_identical(dlgumbel(0), NaN)
  expect_identical(dlgumbel(-Inf), NaN)
  expect_identical(dlgumbel(Inf), 0)
})

test_that("dlgumbel values", {
  expect_equal(dlgumbel(1), 0.367879441171442)
  expect_equal(dlgumbel(2), 0.151632664928158)
  expect_equal(dlgumbel(c(1, 2)), c(0.367879441171442, 0.151632664928158))
  expect_equal(dlgumbel(exp(3), 3, 1), 0.0183156388887342)
  expect_equal(dlgumbel(exp(4), 3, 1), 0.00466401114120162)
})

test_that("plgumbel extremes", {
  expect_identical(plgumbel(numeric(0)), numeric(0))
  expect_identical(plgumbel(NA), NA_real_)
  expect_identical(plgumbel(0), 0)
  expect_identical(plgumbel(-Inf), NaN)
  expect_identical(plgumbel(Inf), 1)
})

test_that("plgumbel values", {
  expect_equal(plgumbel(exp(3), 3, 1), 0.3678794, tolerance = 0.0000001)
  expect_equal(plgumbel(exp(4), 3, 1), 0.6922006, tolerance = 0.0000001)
  expect_identical(plgumbel(qlgumbel(0.5, 3, 1), 3, 1), 0.5)
})

test_that("qlgumbel extremes", {
  expect_identical(qlgumbel(numeric(0)), numeric(0))
  expect_equal(qlgumbel(NA), NA_real_)
  expect_identical(qlgumbel(0), 0)
  expect_identical(qlgumbel(1), Inf)
  expect_identical(qlgumbel(-Inf), NaN)
  expect_identical(qlgumbel(Inf), NaN)
})

test_that("qlgumbel values", {
  expect_equal(qlgumbel(0.5), 1.44269504088896)
  expect_equal(log(qlgumbel(c(0.2, 0.5, 0.9), 3, 1)), 
               c(2.52411500467289, 3.36651292058166, 5.25036732731245))
  expect_equal(log(qlgumbel(c(0.2, 0.5, 0.9), 3, 1,
                            lower.tail = FALSE
  )), c(4.49993998675952, 3.36651292058166, 2.16596755475204))
  
  expect_identical(
    log(qlgumbel(-1, log.p = TRUE)),
    log(qlgumbel(exp(-1)))
  )
})

test_that("rlgumbel extremes", {
  expect_identical(rlgumbel(0), numeric(0))
  chk::expect_chk_error(rlgumbel(-1))
  expect_error(rlgumbel(NA_integer_))
  expect_identical(rlgumbel(1, lscale = 0), NaN)
  expect_identical(rlgumbel(1, lscale = -1), NaN)
})

test_that("rlgumbel values", {
  set.seed(99)
  expect_equal(rlgumbel(1), 1.86346012295971)
  set.seed(99)
  expect_equal(rlgumbel(2), c(1.86346012295971, 0.460092963476341))
})

test_that("fit lgumbel", {
  dist <- ssdtools:::ssd_fit_dist(ssdtools::boron_data, dist = "lgumbel")
  
  expect_true(is.fitdist(dist))
  expect_equal(
    coef(dist),
    c(llocation = 1.92249767793641, lscale = 1.23235840307164)
  )
})

test_that("fit lgumbel Mn LT", {
  mn_lt <- ssdtools::test_data[ssdtools::test_data$Chemical == "Mn LT", ]
  
  dist <- ssdtools:::ssd_fit_dist(mn_lt, dist = "lgumbel")
  expect_true(is.fitdist(dist))
  expect_equal(
    coef(dist),
    c(llocation = 7.31628089226769, lscale = 1.00893875176455)
  )
})

test_that("fit lgumbel cis", {
  dist <- ssdtools:::ssd_fit_dist(ssdtools::boron_data, dist = "lgumbel")
  
  set.seed(77)
  expect_equal(
    as.data.frame(ssd_hc(dist, ci = TRUE, nboot = 10)),
    structure(list(
      percent = 5, est = 1.76891782851293, se = 0.370590354900628,
      lcl = 1.2300542477102, ucl = 2.26678393125552, dist = "lgumbel"
    ), class = "data.frame", row.names = c(
      NA,
      -1L
    ))
  )
  set.seed(77)
  expect_equal(
    as.data.frame(ssd_hp(dist, conc = 2, ci = TRUE, nboot = 10)),
    structure(list(
      conc = 2, est = 6.6426765222485, se = 3.00359276728387,
      lcl = 3.43548429065931, ucl = 12.0724651584046, dist = "lgumbel"
    ), class = "data.frame", row.names = c(
      NA,
      -1L
    ))
  )
})
