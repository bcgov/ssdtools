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

test_that("dlgumbel", {
  expect_equal(dlgumbel(exp(3), log(3), log(1)), 0.01831564, tolerance = 0.0000001)
  expect_equal(dlgumbel(exp(4), log(3), log(1)), 0.004664011, tolerance = 0.0000001)
})

test_that("fit lgumbel", {
  dist <- ssdtools:::ssd_fit_dist(ssdtools::boron_data, dist = "lgumbel")

  expect_true(is.fitdist(dist))
  expect_equal(
    coef(dist),
    c(llocation = 0.653681627422279, lscale = 0.208983173310441)
  )
})

test_that("fit lgumbel Mn LT", {
  mn_lt <- ssdtools::test_data[ssdtools::test_data$Chemical == "Mn LT",]
  dist <- ssdtools:::ssd_fit_dist(mn_lt, dist = "lgumbel")
  expect_true(is.fitdist(dist))
  expect_equal(
    coef(dist),
    c(llocation = 0.653681627422279, lscale = 0.208983173310441)
  )  
})

test_that("fit lgumbel cis", {
  dist <- ssdtools:::ssd_fit_dist(ssdtools::boron_data, dist = "lgumbel")

  set.seed(77)
  expect_equal(
    as.data.frame(ssd_hc(dist, ci = TRUE, nboot = 10)),
    structure(list(
      percent = 5, est = 1.76898186161132, se = 0.370544140148798,
      lcl = 1.23066000903158, ucl = 2.26731711889413, dist = "lgumbel"
    ), class = "data.frame", row.names = c(
      NA,
      -1L
    ))
  )
  set.seed(77)
  expect_equal(
    as.data.frame(ssd_hp(dist, conc = 2, ci = TRUE, nboot = 10)),
    structure(list(
      conc = 2, est = 6.64205158066981, se = 3.00152144129526,
      lcl = 3.43280320738647, ucl = 12.0632543930362, dist = "lgumbel"
    ), class = "data.frame", row.names = c(
      NA,
      -1L
    ))
  )
})

test_that("pqlgumbel", {
  expect_equal(log(qlgumbel(c(0.2, 0.5, 0.9), log(3), log(1))), c(2.52411500467289, 3.36651292058166, 5.25036732731245))
  expect_equal(log(qlgumbel(c(0.2, 0.5, 0.9), log(3), log(1),
    lower.tail = FALSE
  )), c(4.49993998675952, 3.36651292058166, 2.16596755475204))

  expect_identical(
    log(qlgumbel(-1, log.p = TRUE)),
    log(qlgumbel(exp(-1)))
  )

  expect_equal(plgumbel(exp(3), log(3), log(1)), 0.3678794, tolerance = 0.0000001)
  expect_equal(plgumbel(exp(4), log(3), log(1)), 0.6922006, tolerance = 0.0000001)
  expect_identical(plgumbel(qlgumbel(0.5, 3, 1), 3, 1), 0.5)
})

test_that("rlgumbel", {
  set.seed(99)
  r <- rlgumbel(100000, llocation = log(100), lscale = log(3))
  expect_identical(length(r), 100000L)
  expect_equal(mean(log(r)), 3 * 0.57721 + 100, tolerance = 0.001)
})
