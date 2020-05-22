test_that("dlnorm extremes", {
  expect_identical(dlnorm(numeric(0)), numeric(0))
  expect_identical(dlnorm(NA), NA_real_)
  expect_identical(dlnorm(NaN), NaN)
  expect_identical(dlnorm(0), 0)
  expect_equal(dlnorm(1), 0.398942280401433)
  expect_equal(dlnorm(1, log = TRUE), log(dlnorm(1)))
  expect_equal(dlnorm(1, sdlog = -1), NaN)
  expect_identical(dlnorm(0), 0)
  expect_identical(dlnorm(-Inf), 0)
  expect_identical(dlnorm(Inf), 0)
  expect_identical(dlnorm(c(NA, NaN, 0, Inf, -Inf)), 
                   c(dlnorm(NA), dlnorm(NaN), dlnorm(0), dlnorm(Inf), dlnorm(-Inf)))
  expect_equal(dlnorm(1:2, meanlog = 1:2, sdlog = 3:4), 
               c(dlnorm(1, 1, 3), dlnorm(2, 2, 4)))
  expect_equal(dlnorm(1:2, meanlog = c(1, NA), sdlog = 3:4), 
               c(dlnorm(1, 1, 3), NA))
})

test_that("plnorm extremes", {
  expect_identical(plnorm(numeric(0)), numeric(0))
  expect_identical(plnorm(NA), NA_real_)
  expect_identical(plnorm(NaN), NaN)
  expect_identical(plnorm(0), 0)
  expect_equal(plnorm(1), 0.5)
  expect_equal(plnorm(1, log.p = TRUE), log(plnorm(1)))
  expect_equal(plnorm(1, lower.tail = FALSE), 1 - 0.5)
  expect_equal(plnorm(1, lower.tail = FALSE, log.p = TRUE), log(1 - 0.5))
  expect_equal(plnorm(1, sdlog = -1), NaN)
  expect_identical(plnorm(0), 0)
  expect_identical(plnorm(-Inf), 0)
  expect_identical(plnorm(Inf), 1)
  expect_identical(plnorm(c(NA, NaN, 0, Inf, -Inf)), 
                   c(plnorm(NA), plnorm(NaN), plnorm(0), plnorm(Inf), plnorm(-Inf)))
  expect_equal(plnorm(1:2, meanlog = 1:2, sdlog = 3:4), 
               c(plnorm(1, 1, 3), plnorm(2, 2, 4)))
  expect_equal(plnorm(1:2, meanlog = c(1, NA), sdlog = 3:4), 
               c(plnorm(1, 1, 3), NA))
})

test_that("qlnorm extremes", {
  expect_identical(qlnorm(numeric(0)), numeric(0))
  expect_identical(qlnorm(NA), NA_real_)
  expect_identical(qlnorm(NaN), NaN)
  expect_identical(qlnorm(0), 0)
  expect_identical(qlnorm(1), Inf)
  expect_equal(qlnorm(0.75), 1.96303108415826)
  expect_equal(qlnorm(0.75, log.p = TRUE), NaN)
  expect_equal(qlnorm(log(0.75), log.p = TRUE), qlnorm(0.75))
  expect_equal(qlnorm(0.75, lower.tail = FALSE), qlnorm(0.25))
  expect_equal(qlnorm(log(0.75), lower.tail = FALSE, log.p = TRUE), qlnorm(0.25))
  expect_equal(qlnorm(0.5, sdlog = -1), NaN)
  expect_identical(qlnorm(0), 0)
  expect_identical(qlnorm(-Inf), NaN)
  expect_identical(qlnorm(Inf), NaN)
  expect_identical(qlnorm(c(NA, NaN, 0, Inf, -Inf)), 
                   c(qlnorm(NA), qlnorm(NaN), qlnorm(0), qlnorm(Inf), qlnorm(-Inf)))
  expect_equal(qlnorm(1:2, meanlog = 1:2, sdlog = 3:4), 
               c(qlnorm(1, 1, 3), qlnorm(2, 2, 4)))
  expect_equal(qlnorm(1:2, meanlog = c(1, NA), sdlog = 3:4), 
               c(qlnorm(1, 1, 3), NA))
  expect_equal(qlnorm(plnorm(c(0, 0.1, 0.5, 0.9, 1))), c(0, 0.1, 0.5, 0.9, 1))
})

test_that("rlnorm extremes", {
  expect_identical(rlnorm(numeric(0)), numeric(0))
  expect_error(rlnorm(NA))
  expect_identical(rlnorm(0), numeric(0))
  set.seed(42)
  expect_equal(rlnorm(1), 3.93912432924107)
  set.seed(42)
  expect_equal(rlnorm(1.9), 3.93912432924107)
  set.seed(42)
  expect_equal(rlnorm(2), c(3.93912432924107, 0.568531719998709))
  set.seed(42)
  expect_equal(rlnorm(3:4), c(3.93912432924107, 0.568531719998709))
  expect_equal(rlnorm(0, sdlog = -1), numeric(0))
  expect_equal(rlnorm(1, sdlog = -1), NaN)
  expect_equal(rlnorm(2, sdlog = -1), c(NaN, NaN))
  expect_error(rlnorm(1, meanlog = 1:2))
  expect_error(rlnorm(1, sdlog = 1:2))
  expect_identical(rlnorm(1, meanlog = NA), NA_real_)
})

test_that("fit lnorm quinoline", {
  quin <- ssdtools::test_data[ssdtools::test_data$Chemical == "Quinoline", ]
  
  expect_warning(dist <- ssd_fit_dist(quin, dist = "lnorm"))
  expect_true(is.fitdist(dist))
  expect_equal(
    coef(dist),
    c(meanlog = 8.68875725361798, sdlog = 1.9908920631944)
  )
})

test_that("fit lnorm boron", {
  dist <- ssd_fit_dist(ssdtools::boron_data, dist = "lnorm")
  expect_true(is.fitdist(dist))
  expect_equal(
    coef(dist),
    c(meanlog = 2.56164375310683, sdlog = 1.24172540661694)
  )
})
