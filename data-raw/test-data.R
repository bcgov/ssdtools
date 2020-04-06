
test_data <- readr::read_csv("data-raw/test-data.csv")

test_data <- tidyr::pivot_longer(test_data, everything(), names_to = "Chemical", values_to = "Conc", values_drop_na = TRUE)

test_data <- dplyr::arrange(test_data, Chemical)

usethis::use_data(test_data, overwrite = TRUE)
