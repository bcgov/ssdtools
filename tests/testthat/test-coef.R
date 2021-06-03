test_that("multiplication works", {
  coef <- coef(boron_dists)
  expect_s3_class(coef, "tbl_df")
  expect_identical(colnames(coef), c("dist", "term", "est", "se"))
  expect_equal(coef$se, c(0.108068054691563, 0.222581466959462, 
                          0.248256783289835, 0.11437423651516, 
                          0.234629067176328, 0.165907749058667))
})
