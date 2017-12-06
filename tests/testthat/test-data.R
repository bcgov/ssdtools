context("data")

test_that("data", {
  expect_identical(checkr::check_data(ccme_data,
                                      values = list(Chemical = "",
                                                    Species = "",
                                                    Conc = c(0, Inf),
                                                    Group = factor(1)),
                                      nrow = c(1, Inf)), ccme_data)
})
