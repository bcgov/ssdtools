library(magrittr)
library(stringr)
library(devtools)
library(dplyr)

ccme_data <- read.csv("data-raw/CCME data.csv", stringsAsFactors = FALSE)
ccme_data <- ccme_data[!is.na(ccme_data$Conc),]

ccme_data$Species %<>%
  str_replace("Pseudokirchneriell a", "Pseudokirchneriella") %>%
  str_replace("Scenedesmus subpicatus", "Scenedesmus subspicatus") %>%
  str_replace("transmont anus", "transmontanus") %>%
  str_replace("Atyae phyra", "Atyaephyra") %>%
  str_replace("subcapitatum", "subcapitata") %>%
  str_replace("luius$", "lucius") %>%
  str_replace("L. gibba", "Lemna gibba") %>%

  str_replace("(^[:upper:][:lower:]+([:blank:][:lower:]+){1,2})(.*)", "\\1") %>%
  str_replace("(^[:upper:][.])([:lower:])(.*)", "\\1 \\2\\3")

ccme_species <- ccme_data %>%
  filter(str_detect(Species, "^[:upper:][:lower:]")) %>%
  select(Species) %>%
  arrange(Species) %>%
  distinct() %>%
  mutate(Spp = str_replace(Species, "(^[:upper:])([:lower:]+)(.*)", "\\1.\\3"))

ccme_data %<>% left_join(ccme_species, by = c(Species = "Spp"))

ccme_data$Species[!is.na(ccme_data$Species.y)] <-
  ccme_data$Species.y[!is.na(ccme_data$Species.y)]

# need to identify full species names
# need to assign taxonomic groups

ccme_data$Group <- factor("Fish", levels = c("Fish", "Invert", "Algae"))

ccme_data$Group[str_detect(ccme_data$Species,
                           "Daphnia")] <- "Invert"

ccme_data$Species.y <- NULL
ccme_data$Reference <- NULL

ccme_data %<>% as_tibble()

use_data(ccme_data, overwrite = TRUE)
