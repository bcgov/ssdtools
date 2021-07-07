ep <- function(text) {
  eval(parse(text = text))
  invisible()
}

test_dist <- function(dist) {
  ep(glue::glue("expect_identical(p{dist}(numeric(0)), numeric(0))"))
  ep(glue::glue("expect_identical(p{dist}(NA), NA_real_)"))
  ep(glue::glue("expect_identical(p{dist}(NaN), NaN)"))
  ep(glue::glue("expect_identical(p{dist}(0), 0)"))
  ep(glue::glue("expect_identical(p{dist}(-Inf), 0)"))
  ep(glue::glue("expect_identical(p{dist}(Inf), 1)"))
  ep(glue::glue("expect_gt(p{dist}(1.000001), p{dist}(1))"))
  
  ep(glue::glue("expect_equal(p{dist}(1, log.p = TRUE), log(p{dist}(1)))"))
  ep(glue::glue("expect_equal(p{dist}(1, lower.tail = FALSE), 1- p{dist}(1))"))
  ep(glue::glue("expect_equal(p{dist}(1, lower.tail = FALSE, log.p = TRUE), log(1 - p{dist}(1)))"))
  
  ep(glue::glue("expect_identical(p{}(c(NA, NaN, 0, Inf, -Inf)),
                   c(NA_real_, NaN, 0, Inf, -Inf))"))
  ep(glue::glue("expect_equal(p{dist}(1:2, 1:2, 3:4),
               c(p{dist}(1, 1, 3), p{dist}(2, 2, 4)))"))
  ep(glue::glue("expect_equal(p{dist}(1:2, c(1, NA), 3:4),
               c(p{dist}(1, 1, 3), NA_real_))"))
  
  ep(glue::glue("expect_identical(q{dist}(numeric(0)), numeric(0))"))
  ep(glue::glue("expect_identical(q{dist}(NA), NA_real_)"))
  ep(glue::glue("expect_identical(q{dist}(NaN), NaN)"))
  ep(glue::glue("expect_identical(q{dist}(0), 0)"))
  ep(glue::glue("expect_identical(q{dist}(1), Inf)"))
  ep(glue::glue("expect_identical(q{dist}(-1), NaN)"))
  ep(glue::glue("expect_identical(q{dist}(2), NaN)"))
  ep(glue::glue("expect_identical(q{dist}(-Inf), NaN)"))
  ep(glue::glue("expect_identical(q{dist}(Inf), NaN)"))
  ep(glue::glue("expect_identical(q{dist}(0.75, log.p = TRUE), NaN)"))
  ep(glue::glue("expect_gt(q{dist}(0.5000001), q{dist}(0.5))"))
  ep(glue::glue("expect_identical(q{dist}(log(0.75), log.p = TRUE), q{dist}(0.75))"))
  ep(glue::glue("expect_identical(q{dist}(0.75, lower.tail = FALSE), q{dist}(0.25))"))
  ep(glue::glue("expect_identical(q{dist}(log(0.75), lower.tail = FALSE, log.p = TRUE), q{dist}(0.25))"))

  ep(glue::glue("expect_identical(q{dist}(c(NA, NaN, 0, Inf, -Inf)), c(NA_real_, NaN, 0, NaN, NaN))"))
  
  ep(glue::glue("expect_identical(q{dist}(c(0.25, 0.75), 1:2, 3:4), c(q{dist}(0.25, 1, 3), q{dist}(0.75, 2, 4)))"))
  ep(glue::glue("expect_identical(q{dist}(c(0.25, 0.75), c(1,NA), 3:4), c(q{dist}(0.25, 1, 3), NA_real_))"))
  
  ep(glue::glue("expect_equal(q{dist}(p{dist}(c(0, 0.1, 0.5, 0.9, 1))), c(0, 0.1, 0.5, 0.9, 1))"))
}