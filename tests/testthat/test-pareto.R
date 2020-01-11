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

context("pareto")

test_that("dpareto", {
  expect_equal(dpareto(numeric(0)), numeric(0))
  expect_equal(dpareto(c(0, 1, Inf, NaN, -1)), c(0, 1, 0, NA, 0))
  expect_equal(dpareto(2), 0.25)
  expect_equal(dpareto(2, log = TRUE), log(dpareto(2)))
  expect_equal(dpareto(1), 1)
  expect_equal(dpareto(0.5), 0)
  expect_equal(dpareto(1:3), c(1, 0.25, 0.111111111111111))
})

test_that("fit pareto", {
  dist <- ssdtools:::ssd_fit_dist(ssdtools::boron_data, dist = "pareto")

  expect_true(is.fitdist(dist))
  expect_equal(
    coef(dist),
    c(shape = 0.390374158489078)
  )
})

test_that("fit pareto cis", {
  dist <- ssdtools:::ssd_fit_dist(ssdtools::boron_data, dist = "pareto")

  set.seed(77)
  expect_equal(
    as.data.frame(ssd_hc(dist, ci = TRUE, nboot = 10)),
    structure(list(
      percent = 5, est = 1.14041839659127, se = 0.0212780854747505,
      lcl = 1.11896006602472, ucl = 1.17955575595707, dist = "pareto"
    ), class = "data.frame", row.names = c(
      NA,
      -1L
    )),
    tolerance = 1e-07 # for noLD
  )
  set.seed(77)
  expect_equal(
    as.data.frame(ssd_hp(dist, conc = 2, ci = TRUE, nboot = 10)),
    structure(list(
      conc = 2, est = 23.7068285156163, se = 2.7637435813203,
      lcl = 19.3919509212197, ucl = 27.1171096778786, dist = "pareto"
    ), class = "data.frame", row.names = c(
      NA,
      -1L
    )),
    tolerance = 1e-07 # for noLD
  )
})

test_that("ppareto", {
  expect_equal(ppareto(1), 0)
  expect_equal(ppareto(2), 1 / 2)
  expect_equal(ppareto(3), 2 / 3)
  expect_equal(ppareto(3, log.p = TRUE), log(ppareto(3)))
  expect_equal(ppareto(3, lower.tail = FALSE), 1 / 3)
  expect_equal(ppareto(numeric(0)), numeric(0))
})

test_that("qpareto", {
  expect_equal(qpareto(ppareto(2)), 2)
  expect_equal(qpareto(numeric(0)), numeric(0))
})

test_that("rpareto", {
  set.seed(1)
  expect_equal(rpareto(1), 3.7663554483147)
})
