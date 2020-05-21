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

test_that("dgompertz extremes", {
  expect_identical(dgompertz(numeric(0)), numeric(0))
  expect_identical(dgompertz(NA), NA_real_)
  expect_identical(dgompertz(NaN), NaN)
  expect_identical(dgompertz(0), 1)
  expect_equal(dgompertz(1), 0.487589298719261)
  expect_equal(dgompertz(1, log = TRUE), log(dgompertz(1)))
  expect_equal(dgompertz(1, shape = -1), NaN)
  expect_equal(dgompertz(1, scale = -1), NaN)
  expect_identical(dgompertz(0), 1)
  expect_identical(dgompertz(-Inf), 0)
  expect_identical(dgompertz(Inf), 0)
  expect_identical(dgompertz(c(NA, NaN, 0, Inf, -Inf)), 
                   c(dgompertz(NA), dgompertz(NaN), dgompertz(0), dgompertz(Inf), dgompertz(-Inf)))
  expect_equal(dgompertz(1:2, shape = 1:2, scale = 3:4), 
               c(dgompertz(1, 1, 3), dgompertz(2, 2, 4)))
  expect_equal(dgompertz(1:2, shape = c(1, NA), scale = 3:4), 
               c(dgompertz(1, 1, 3), NA))
})

test_that("pgompertz extremes", {
  expect_identical(pgompertz(numeric(0)), numeric(0))
  expect_identical(pgompertz(NA), NA_real_)
  expect_identical(pgompertz(NaN), NaN)
  expect_identical(pgompertz(0), 0)
  expect_equal(pgompertz(1), 0.820625921265983)
  expect_equal(pgompertz(1, log.p = TRUE), log(pgompertz(1)))
  expect_equal(pgompertz(1, lower.tail = FALSE), 1 - pgompertz(1))
  expect_equal(pgompertz(1, lower.tail = FALSE, log.p = TRUE), log(1 - pgompertz(1)))
  expect_equal(pgompertz(1, shape = -1), NaN)
  expect_equal(pgompertz(1, scale = -1), NaN)
  expect_identical(pgompertz(0), 0)
  expect_identical(pgompertz(-Inf), 0)
  expect_identical(pgompertz(Inf), 1)
  expect_identical(pgompertz(c(NA, NaN, 0, Inf, -Inf)), 
                   c(pgompertz(NA), pgompertz(NaN), pgompertz(0), pgompertz(Inf), pgompertz(-Inf)))
  expect_equal(pgompertz(1:2, shape = 1:2, scale = 3:4), 
               c(pgompertz(1, 1, 3), pgompertz(2, 2, 4)))
  expect_equal(pgompertz(1:2, shape = c(1, NA), scale = 3:4), 
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
  expect_equal(qgompertz(0.5, shape = -1), NaN)
  expect_equal(qgompertz(0.5, scale = -1), NaN)
  expect_identical(qgompertz(0), 0)
  expect_identical(qgompertz(-Inf), NaN)
  expect_identical(qgompertz(Inf), NaN)
  expect_identical(qgompertz(c(NA, NaN, 0, Inf, -Inf)), 
                   c(qgompertz(NA), qgompertz(NaN), qgompertz(0), qgompertz(Inf), qgompertz(-Inf)))
  expect_equal(qgompertz(1:2, shape = 1:2, scale = 3:4), 
               c(qgompertz(1, 1, 3), qgompertz(2, 2, 4)))
  expect_equal(qgompertz(1:2, shape = c(1, NA), scale = 3:4), 
               c(qgompertz(1, 1, 3), NA))
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
  expect_equal(rgompertz(0, shape = -1), numeric(0))
  expect_equal(rgompertz(1, shape = -1), NaN)
  expect_equal(rgompertz(2, shape = -1), c(NaN, NaN))
  expect_equal(rgompertz(0, scale = -1), numeric(0))
  expect_equal(rgompertz(1, scale = -1), NaN)
  expect_equal(rgompertz(2, scale = -1), c(NaN, NaN))
  expect_error(rgompertz(1, shape = 1:2))
  expect_error(rgompertz(1, scale = 1:2))
  expect_identical(rgompertz(1, shape = NA), NA_real_)
})

test_that("fit gompertz quinoline", {
  quin <- ssdtools::test_data[ssdtools::test_data$Chemical == "Quinoline", ]
  
  expect_warning(dist <- ssdtools:::ssd_fit_dist(quin, dist = "gompertz"))
  expect_true(is.fitdist(dist))
  expect_equal(
    coef(dist),
    c(shape = 0.627542681172847, scale = 15343.492101029)
  )
})

test_that("fit gompertz boron", {
  set.seed(42)
  dist <- ssdtools:::ssd_fit_dist(ssdtools::boron_data, dist = "gompertz")
  expect_true(is.fitdist(dist))
  expect_equal(
    coef(dist),
    c(shape = 0.0394104684415101, scale = 0.00260161531844944)
  )
})


test_that("dgompertz", {
  expect_equal(dgompertz(1, shape = 1), 0.487589298719261)
  expect_equal(dgompertz(1, shape = 1, log = TRUE), log(0.487589298719261))
  expect_identical(dgompertz(numeric(0), shape = 1, log = TRUE), numeric(0))
})

test_that("fit gompertz", {
  set.seed(9)
  dist <- ssdtools:::ssd_fit_dist(ssdtools::boron_data, dist = "gompertz")

  expect_true(is.fitdist(dist))
  expect_equal(
    coef(dist),
    c(shape = 0.0394018711730742, scale = 0.00261006816431015)
  )
})

test_that("fit gompertz cis", {
  dist <- ssdtools:::ssd_fit_dist(ssdtools::boron_data, dist = "gompertz")

  set.seed(77)
  expect_equal(as.data.frame(ssd_hc(dist, ci = TRUE, nboot = 10)),
    structure(list(
      percent = 5, est = 1.29966505882089, se = 0.210577831926091,
      lcl = 1.06020559561544, ucl = 1.65959404402591, dist = "gompertz"
    ), class = "data.frame", row.names = c(
      NA,
      -1L
    )),
    tolerance = 1e-03
  )

  set.seed(77)
  expect_equal(as.data.frame(ssd_hp(dist, conc = 2, ci = TRUE, nboot = 10)),
    structure(list(
      conc = 2, est = 7.59650778517607, se = 1.14878323330099,
      lcl = 6.00209908449661, ucl = 9.2251620377782, dist = "gompertz"
    ), class = "data.frame", row.names = c(
      NA,
      -1L
    )),
    tolerance = 1e-03
  )
})

test_that("qgompertz", {
  expect_identical(qgompertz(numeric(0)), numeric(0))
  expect_identical(
    qgompertz(0.8),
    0.959134838920824
  )
  expect_identical(
    qgompertz(0),
    0
  )
  expect_identical(
    qgompertz(1),
    Inf
  )
  expect_identical(qgompertz(log(0.8), log.p = TRUE), qgompertz(0.8))
  expect_equal(qgompertz(pgompertz(0.9)), 0.9)
})

test_that("pgompertz", {
  expect_equal(pgompertz(1), 0.820625921265983)
  expect_equal(pgompertz(1, lower.tail = FALSE), 1 - pgompertz(1))
  expect_equal(pgompertz(1, log.p = TRUE), log(pgompertz(1)))
  expect_identical(pgompertz(numeric(0)), numeric(0))
})

test_that("rgompertz", {
  set.seed(1)
  expect_equal(rgompertz(1, shape = 1), 0.268940346907911)
})
