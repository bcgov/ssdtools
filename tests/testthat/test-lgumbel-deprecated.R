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

test_that("dlgumbel extremes", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_identical(dlgumbel(numeric(0)), numeric(0))
  expect_identical(dlgumbel(NA), NA_real_)
  expect_identical(dlgumbel(NaN), NaN)
  expect_identical(dlgumbel(0), 0)
  expect_equal(dlgumbel(1), 0.367879441171442)
  expect_equal(dlgumbel(1, log = TRUE), log(dlgumbel(1)))
  expect_equal(dlgumbel(1, scalelog = -1), NaN)
  expect_identical(dlgumbel(0), 0)
  expect_identical(dlgumbel(-Inf), 0)
  expect_identical(dlgumbel(Inf), 0)
  expect_identical(
    dlgumbel(c(NA, NaN, 0, Inf, -Inf)),
    c(dlgumbel(NA), dlgumbel(NaN), dlgumbel(0), dlgumbel(Inf), dlgumbel(-Inf))
  )
  expect_equal(
    dlgumbel(1:2, locationlog = 1:2, scalelog = 3:4),
    c(dlgumbel(1, 1, 3), dlgumbel(2, 2, 4))
  )
  expect_equal(
    dlgumbel(1:2, locationlog = c(1, NA), scalelog = 3:4),
    c(dlgumbel(1, 1, 3), NA)
  )
})

test_that("plgumbel extremes", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_identical(plgumbel(numeric(0)), numeric(0))
  expect_identical(plgumbel(NA), NA_real_)
  expect_identical(plgumbel(NaN), NaN)
  expect_identical(plgumbel(0), 0)
  expect_equal(plgumbel(1), 0.367879441171442)
  expect_equal(plgumbel(1, log.p = TRUE), log(plgumbel(1)))
  expect_equal(plgumbel(1, lower.tail = FALSE), 1 - plgumbel(1))
  expect_equal(plgumbel(1, lower.tail = FALSE, log.p = TRUE), log(1 - plgumbel(1)))
  expect_equal(plgumbel(1, scalelog = -1), NaN)
  expect_identical(plgumbel(0), 0)
  expect_identical(plgumbel(-Inf), 0)
  expect_identical(plgumbel(Inf), 1)
  expect_identical(
    plgumbel(c(NA, NaN, 0, Inf, -Inf)),
    c(plgumbel(NA), plgumbel(NaN), plgumbel(0), plgumbel(Inf), plgumbel(-Inf))
  )
  expect_equal(
    plgumbel(1:2, locationlog = 1:2, scalelog = 3:4),
    c(plgumbel(1, 1, 3), plgumbel(2, 2, 4))
  )
  expect_equal(
    plgumbel(1:2, locationlog = c(1, NA), scalelog = 3:4),
    c(plgumbel(1, 1, 3), NA)
  )
})

test_that("qlgumbel extremes", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_identical(qlgumbel(numeric(0)), numeric(0))
  expect_identical(qlgumbel(NA), NA_real_)
  expect_identical(qlgumbel(NaN), NaN)
  expect_identical(qlgumbel(0), 0)
  expect_identical(qlgumbel(1), Inf)
  expect_equal(qlgumbel(0.75), 3.47605949678221)
  expect_equal(qlgumbel(0.75, log.p = TRUE), NaN)
  expect_equal(qlgumbel(log(0.75), log.p = TRUE), qlgumbel(0.75))
  expect_equal(qlgumbel(0.75, lower.tail = FALSE), qlgumbel(0.25))
  expect_equal(qlgumbel(log(0.75), lower.tail = FALSE, log.p = TRUE), qlgumbel(0.25))
  expect_equal(qlgumbel(0.5, scalelog = -1), NaN)
  expect_identical(qlgumbel(0), 0)
  expect_identical(qlgumbel(-Inf), NaN)
  expect_identical(qlgumbel(Inf), NaN)
  expect_identical(
    qlgumbel(c(NA, NaN, 0, Inf, -Inf)),
    c(qlgumbel(NA), qlgumbel(NaN), qlgumbel(0), qlgumbel(Inf), qlgumbel(-Inf))
  )
  expect_equal(
    qlgumbel(1:2, locationlog = 1:2, scalelog = 3:4),
    c(qlgumbel(1, 1, 3), qlgumbel(2, 2, 4))
  )
  expect_equal(qlgumbel(1:2, locationlog = c(1, NA), scalelog = 3:4), c(Inf, NaN))
  expect_equal(qlgumbel(plgumbel(c(0, 0.1, 0.5, 0.9, 1))), c(0, 0.1, 0.5, 0.9, 1))
})

test_that("rlgumbel extremes", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_identical(rlgumbel(numeric(0)), numeric(0))
  expect_error(rlgumbel(NA))
  expect_identical(rlgumbel(0), numeric(0))
  set.seed(42)
  expect_equal(rlgumbel(1), 11.2305025213646)
  set.seed(42)
  expect_equal(rlgumbel(1.9), 11.2305025213646)
  set.seed(42)
  expect_equal(rlgumbel(2), c(11.2305025213646, 15.3866236451648))
  set.seed(42)
  expect_equal(rlgumbel(3:4), c(11.2305025213646, 15.3866236451648))
  expect_equal(rlgumbel(0, scalelog = -1), numeric(0))
  expect_equal(rlgumbel(1, scalelog = -1), NaN)
  expect_equal(rlgumbel(2, scalelog = -1), c(NaN, NaN))
  expect_error(rlgumbel(1, locationlog = 1:2))
  expect_error(rlgumbel(1, scalelog = 1:2))
  expect_identical(rlgumbel(1, locationlog = NA), NA_real_)
  expect_identical(rlgumbel(1, scalelog = NA), NA_real_)
})

test_that("dlgumbel values", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_equal(dlgumbel(1), 0.367879441171442)
  expect_equal(dlgumbel(2), 0.151632664928158)
  expect_equal(dlgumbel(c(1, 2)), c(0.367879441171442, 0.151632664928158))
  expect_equal(dlgumbel(exp(3), 3, 1), 0.0183156388887342)
  expect_equal(dlgumbel(exp(4), 3, 1), 0.00466401114120162)
})

test_that("plgumbel values", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_equal(plgumbel(exp(3), 3, 1), 0.367879441171442)
  expect_equal(plgumbel(exp(4), 3, 1), 0.692200627555346)
  expect_identical(plgumbel(qlgumbel(0.5, 3, 1), 3, 1), 0.5)
})

test_that("qlgumbel values", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_equal(qlgumbel(0.5), 1.44269504088896)
  expect_equal(
    log(qlgumbel(c(0.2, 0.5, 0.9), 3, 1)),
    c(2.52411500467289, 3.36651292058166, 5.25036732731245)
  )
  expect_equal(log(qlgumbel(c(0.2, 0.5, 0.9), 3, 1,
    lower.tail = FALSE
  )), c(4.49993998675952, 3.36651292058166, 2.16596755475204))

  expect_identical(
    log(qlgumbel(-1, log.p = TRUE)),
    log(qlgumbel(exp(-1)))
  )
})

test_that("rlgumbel values", {
  withr::local_options(lifecycle_verbosity = "quiet")
  set.seed(99)
  expect_equal(rlgumbel(1), 1.86346012295971)
  set.seed(99)
  expect_equal(rlgumbel(2), c(1.86346012295971, 0.460092963476341))
})
