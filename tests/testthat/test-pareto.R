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

test_that("dpareto", {
  lifecycle::expect_deprecated(dpareto(1))
  rlang::scoped_options(lifecycle_verbosity = "quiet")
  expect_equal(dpareto(numeric(0)), numeric(0))
  expect_equal(dpareto(c(0, 1, Inf, NaN, -1)), c(0, 1, 0, NA, 0))
  expect_equal(dpareto(2), 0.25)
  expect_equal(dpareto(2, log = TRUE), log(dpareto(2)))
  expect_equal(dpareto(1), 1)
  expect_equal(dpareto(0.5), 0)
  expect_equal(dpareto(1:3), c(1, 0.25, 0.111111111111111))
})

test_that("fit pareto", {
  rlang::scoped_options(lifecycle_verbosity = "quiet")
  dist <- ssd_fit_dist(ssdtools::boron_data, dist = "pareto")

  expect_true(is.fitdist(dist))
  expect_equal(
    coef(dist),
    c(shape = 0.390374158489078)
  )
})

test_that("fit pareto cis", {
  rlang::scoped_options(lifecycle_verbosity = "quiet")
  dist <- ssd_fit_dist(ssdtools::boron_data, dist = "pareto")

  skip_if_not(capabilities("long.double"))
  
  set.seed(77)
  hc <- ssd_hc(dist, ci = TRUE, nboot = 10)
  expect_is(hc, "tbl_df")
  expect_identical(colnames(hc), c("percent", "est", "se", "lcl", "ucl", "dist", "wt"))
  expect_identical(hc$percent, 5)
  expect_equal(hc$est, 1.14041839659127) 
  expect_equal(hc$se, 0.0212780854747505)
  expect_equal(hc$lcl, 1.11896006602472)
  expect_equal(hc$ucl, 1.17955575595707)
  expect_equal(hc$dist, "pareto")
  expect_equal(hc$wt, 1)
  
  set.seed(77)
  hp <- ssd_hp(dist, conc = 2, ci = TRUE, nboot = 10)
  expect_is(hp, "tbl_df")
  expect_identical(colnames(hp), c("conc", "est", "se", "lcl", "ucl", "dist", "wt"))
  expect_identical(hp$conc, 2)
  expect_equal(hp$est, 23.7068285156163)
  expect_equal(hp$se, 2.7637435813203)
  expect_equal(hp$lcl, 19.3919509212197)
  expect_equal(hp$ucl, 27.1171096778786)
  expect_equal(hp$dist, "pareto")
  expect_equal(hp$wt, 1)
})

test_that("ppareto", {
  lifecycle::expect_deprecated(ppareto(1))
  rlang::scoped_options(lifecycle_verbosity = "quiet")
  expect_equal(ppareto(1), 0)
  expect_equal(ppareto(2), 1 / 2)
  expect_equal(ppareto(3), 2 / 3)
  expect_equal(ppareto(3, log.p = TRUE), log(ppareto(3)))
  expect_equal(ppareto(3, lower.tail = FALSE), 1 / 3)
  expect_equal(ppareto(numeric(0)), numeric(0))
})

test_that("qpareto", {
  lifecycle::expect_deprecated(qpareto(1))
  rlang::scoped_options(lifecycle_verbosity = "quiet")
  expect_equal(qpareto(ppareto(2)), 2)
  expect_equal(qpareto(numeric(0)), numeric(0))
})

test_that("rpareto", {
  lifecycle::expect_deprecated(rpareto(1))
  rlang::scoped_options(lifecycle_verbosity = "quiet")
  set.seed(1)
  expect_equal(rpareto(1), 3.7663554483147)
})
