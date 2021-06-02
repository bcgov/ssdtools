test_that("multiplication works", {
  coef <- coef(boron_dists)
  expect_s3_class(coef, "tbl_df")
  expect_identical(colnames(coef), c("dist", "term", "est", "se"))
  expect_equal(coef$se, c(7.64041146669503, 0.222581466959488, 
                          0.248257436357321, 0.114374887744215, 
                          0.234629067176348, 0.165907749058664))
})
