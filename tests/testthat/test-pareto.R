context("pareto")

test_that("dpareto", {
  expect_equal(dpareto(2), 0.25)
  expect_equal(dpareto(2, log = TRUE), log(dpareto(2)))
  expect_equal(dpareto(1), 1)
  expect_equal(dpareto(0.5), 0)
  expect_equal(dpareto(1:3), c(1, 0.25, 0.111111111111111))
  expect_equal(dpareto(numeric(0)), numeric(0))
})

test_that("fit pareto", {
  dist <- ssdtools:::ssd_fit_dist(ssdtools::boron_data, dist = "pareto")

  expect_true(is.fitdist(dist))
  expect_equal(coef(dist),
  c(shape = 0.390374158489078))
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
