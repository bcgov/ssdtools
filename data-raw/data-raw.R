library(magrittr)
library(stringr)
library(devtools)
library(tibble)

ccme_data <- read.csv("data-raw/CCME data.csv", stringsAsFactors = FALSE)
ccme_data <- ccme_data[!is.na(ccme_data$Conc),]

ccme_data$Species %<>%
  str_replace("O. kisutch", "Oncorhynchus kisutch") %>%
  str_replace("O. mykiss", "Oncorhynchus mykiss") %>%
  str_replace("P. promelas", "Pimephales promelas")
# need to assign genera
# need to assign taxonomic groups

ccme_data$Reference <- NULL
ccme_data$Group <- NA_character_

ccme_data %<>% as_tibble()

use_data(ccme_data, overwrite = TRUE)
