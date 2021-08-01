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

save_png <- function(x, width = 400, height = 400) {
  path <- tempfile(fileext = ".png")
  grDevices::png(path, width = width, height = height)
  on.exit(grDevices::dev.off())
  print(x)
  
  path
}

save_csv <- function(x) {
  path <- tempfile(fileext = ".csv")
  readr::write_csv(x, path)
  path
}

expect_snapshot_plot <- function(x, name) {
  testthat::skip_on_ci()
  testthat::skip_on_os("windows")
  path <- save_png(x)
  testthat::expect_snapshot_file(path, paste0(name, ".png"))
}

expect_snapshot_data <- function(x, name) {
  testthat::skip_on_ci()
  testthat::skip_on_os("windows")
  path <- save_csv(x)
  testthat::expect_snapshot_file(path, paste0(name, ".csv"))
}

ep <- function(text) {
  invisible(eval(parse(text = text)))
}

test_dist <- function(dist, qroottolerance = 1.490116e-08, upadj = 0) {
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
  
  ep(glue::glue("expect_equal(q{dist}(p{dist}(c(0, 0.1, 0.5, 0.9, 0.99))), c(0, 0.1, 0.5, 0.9, 0.99), tolerance = {qroottolerance})"))
  
  ep(glue::glue("expect_identical(ssd_r{dist}(numeric(0)), numeric(0))"))
  ep(glue::glue("expect_identical(ssd_r{dist}(0), numeric(0))"))
  ep(glue::glue("expect_error(ssd_r{dist}(NA))"))
  ep(glue::glue("expect_error(ssd_r{dist}(-1))"))
  ep(glue::glue("expect_identical(ssd_r{dist}(1, NA), NA_real_)"))
  ep(glue::glue("expect_identical(ssd_r{dist}(2, NA), c(NA_real_, NA_real_))"))
  ep(glue::glue("expect_error(ssd_r{dist}(1, 1:2))"))
  ep(glue::glue("expect_identical(length(ssd_r{dist}(1)), 1L)"))
  ep(glue::glue("expect_identical(length(ssd_r{dist}(2)), 2L)"))
  ep(glue::glue("expect_identical(length(ssd_r{dist}(3:4)), 2L)"))
  ep(glue::glue("expect_identical(length(ssd_r{dist}(c(NA, 1))), 2L)"))
  
  set.seed(97)
  data <- data.frame(Conc = ep(glue::glue("ssd_r{dist}(1000)")))
  fits <- ssd_fit_dists(data = data, dists = dist)
  tidy <- tidy(fits)
  testthat::expect_s3_class(tidy, "tbl_df")
  testthat::expect_identical(names(tidy), c("dist", "term", "est", "se"))
  testthat::expect_identical(tidy$dist[1], dist)
  tidy$lower <- tidy$est - tidy$se * 3
  tidy$upper <- tidy$est + tidy$se * 3
  
  default <- ep(glue::glue("formals(ssd_r{dist})"))
  default$n <- NULL
  default$chk <- NULL
  default <- data.frame(term = names(default), default = unlist(default))
  
  tidy <- merge(tidy, default, by = "term", all = "TRUE")
  testthat::expect_true(all(tidy$default > tidy$lower))
  testthat::expect_true(all(tidy$default < tidy$upper + upadj))
}
