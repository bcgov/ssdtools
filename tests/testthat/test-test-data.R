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

test_that("test_data", {
  expect_error(chk::check_data(
    test_data,
    values = list(
      Chemical = "",
      Conc = c(0.04, 76500)
    ),
    exclusive = TRUE,
    order = TRUE,
    nrow = 141L
  ), NA)
  expect_is(test_data, "tbl")
})

test_that("test_data Quinoline", {
  
  if (!capabilities("long.double")) {
    skip("gamma computes standard errors with noLD")
  }
  
  quin <- test_data[test_data$Chemical == "Quinoline", ]

  # expect_warning(
  #   fit <- ssd_fit_dists(quin,
  #     dists = c("gamma", "lnorm"),
  #     computable = TRUE
  #   ),
  #   "^Distribution gamma failed to compute standard errors [(]try rescaling the data or increasing the sample size[)]"
  # )
  # expect_identical(names(dists), "lnorm")
  # expect_equal(
  #   coef(dists),
  #   list(lnorm = c(meanlog = 8.68875725361798, sdlog = 1.9908920631944
  #   )))
  # 
  # expect_warning(dists <- ssd_fit_dists(quin, dist = c("gamma", "lnorm"), computable = FALSE),
  #                "diag[(][.][)] had 0 or NA entries; non-finite result is doubtful")
  # expect_identical(names(dists), c("gamma", "lnorm"))
  # expect_equal(
  #   coef(dists),
  #   list(gamma = c(scale = 41276.5658303504, shape = 0.504923953282222
  #   ), lnorm = c(meanlog = 8.68875725361798, sdlog = 1.9908920631944
  #   ))
  # )
  # set.seed(99)
  # hc <- ssd_hc(dists, ci = TRUE, nboot = 10)
  # expect_is(hc, "tbl_df")
  # expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl"))
  # expect_identical(hc$percent, 5)
  # expect_equal(hc$est, 134.853117244289)
  # expect_equal(hc$se, 171.585648187402)
  # expect_equal(hc$lcl, 46.0424235514809)
  # expect_equal(hc$ucl, 517.999234124554)
  # expect_equal(hc$dist, "average")
                                                                                              
})
