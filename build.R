styler::style_pkg()
devtools::test()
devtools::document()
demo(ssdtools, ask = FALSE)
# knitr::knit("README.Rmd")
if(FALSE) {
  if(file.exists("DESCRIPTION")) unlink("docs", recursive = TRUE)
  pkgdown::build_site()
}
devtools::check()
