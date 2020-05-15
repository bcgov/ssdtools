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
  expect_equal(
    dburrIII3(c(31, 15, 32, 32, 642, 778, 187, 12), lscale = 0, log = TRUE),
    log(c(
      0.0009765625, 0.00390625, 0.000918273645546373, 0.000918273645546373,
      2.41867799897932e-06, 1.64787810975198e-06, 2.82933454051607e-05,
      0.00591715976331361
    ))
  )
})

test_that("fit burrIII3", {
  data <- data.frame(Conc = c(31, 15, 32, 32, 642, 778, 187, 12))
  
  dist <- ssdtools:::ssd_fit_dist(data, dist = "burrIII3")
  
  expect_true(is.fitdist(dist))
  expect_equal(
    coef(dist),
    c(
      lshape1 = 3.59302197294215, lshape2 = -0.133674768538566,
      lscale = 0.568325580801304
    )
  )
  
  data$Conc <- data$Conc / 1000
  
  dist <- ssdtools:::ssd_fit_dist(data, dist = "burrIII3")
  
  expect_true(is.fitdist(dist))
  expect_equal(coef(dist), 
               c(lshape1 = 17.1408835835623, 
                 lshape2 = -0.148688158406167, lscale = 23.2767219745654
               ))
})

test_that("fit burrIII3 cis", {
  data <- data.frame(Conc = c(31, 15, 32, 32, 642, 778, 187, 12))
  
  dist <- ssdtools:::ssd_fit_dist(data, dist = "burrIII3")
  
  set.seed(77)
  expect_equal(
    as.data.frame(ssd_hc(dist, ci = TRUE, nboot = 10)),
    structure(list(
      percent = 5, est = 9.3654970353837, se = 12.1627650023649,
      lcl = 2.96137016375762, ucl = 38.498485438982, dist = "burrIII3"
    ), class = "data.frame", row.names = c(
      NA,
      -1L
    ))
  )
  set.seed(77)
  expect_equal(
    as.data.frame(ssd_hp(dist, conc = 2, ci = TRUE, nboot = 10)),
    structure(list(
      conc = 2, est = 0.00301316714398456, se = 1.4331681739529,
      lcl = 1.79517479162082e-10, ucl = 3.65177244931149, dist = "burrIII3"
    ), class = "data.frame", row.names = c(
      NA,
      -1L
    ))
  )
})

test_that("qburrIII3", {
  expect_identical(qburrIII3(numeric(0)), numeric(0))
  expect_identical(qburrIII3(0), 0)
  expect_identical(qburrIII3(1), Inf)
  expect_identical(qburrIII3(NA), NA_real_)
  expect_identical(qburrIII3(0.5, lscale = 0), 1)
  expect_equal(qburrIII3(c(0.1, 0.2), lscale = 0), c(0.111111111111111, 0.25))
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
