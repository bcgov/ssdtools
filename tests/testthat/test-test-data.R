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

test_that("test_data", {
  expect_null(chk::check_data(
    test_data,
    values = list(
      Chemical = "",
      Conc = c(0.04, 76500)
    ),
    exclusive = TRUE,
    order = TRUE,
    nrow = 141L
  ))
  expect_is(test_data, "tbl")
})

test_that("test_data Quinoline", {
  quin <- test_data[test_data$Chemical == "Quinoline", ]

  expect_warning(
    dists <- ssd_fit_dists(quin,
      dist = c("gamma", "lnorm"),
      computable = TRUE
    ),
    "^Distribution gamma failed to compute standard errors [(]try rescaling the data or increasing the sample size[)]"
  )
  expect_identical(names(dists), "lnorm")
  expect_equal(
    coef(dists),
    list(lnorm = c(meanlog = 8.68875153351101, sdlog = 1.99119217351429))
  )

  expect_warning(dists <- ssd_fit_dists(quin, dist = c("gamma", "lnorm"), computable = FALSE),
                 "diag[(][.][)] had 0 or NA entries; non-finite result is doubtful")
  expect_identical(names(dists), c("gamma", "lnorm"))
  expect_equal(
    coef(dists),
    list(gamma = c(scale = 41276.5658303504, shape = 0.504923953282222), lnorm = c(meanlog = 8.68875153351101, sdlog = 1.99119217351429))
  )
  set.seed(99)
  expect_equal(
    as.data.frame(ssd_hc(dists, ci = TRUE, nboot = 10)),
    structure(list(
      percent = 5, est = 134.81374077839, se = 171.657247532188,
      lcl = 45.9882119991699, ucl = 518.208614896573, dist = "average"
    ), row.names = c(
      NA,
      -1L
    ), class = "data.frame")
  )
})
