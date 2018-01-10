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

library(magrittr)
library(stringr)
library(devtools)
library(dplyr)
library(ssdca)

ccme_data <- read.csv("data-raw/CCME data.csv", stringsAsFactors = FALSE)
ccme_data %<>% rename(Concentration = Conc)
ccme_data <- ccme_data[!is.na(ccme_data$Concentration),]

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

ccme_data$Species.y <- NULL
ccme_data$Reference <- NULL

spp <- c("Simocephalus serrulatus",
         "Cryptomonas erosa",
         "Anabaena flosaquae",
         "Myriophyllum sibiricum",
         "Navicula pelliculosa",
         "Pseudosuccinea columella",
         "Scenedesmus quadricauda",
         "Scenedesmus obliquus",
         "Scenedesmus acutus",
         "Potamogeton pectinatus")

spp <- data_frame(Species = spp, Spp = str_replace(spp, "^(\\w)([^\\s]+)", "\\1."))

ccme_data %<>% left_join(spp, by = c(Species = "Spp"))

ccme_data$Species[!is.na(ccme_data$Species.y)] <-
  ccme_data$Species.y[!is.na(ccme_data$Species.y)]

ccme_data$Species.y <- NULL

ccme_data$Group <- str_replace(ccme_data$Species, "^(\\w+)((\\s+)(\\w+)){1,2}", "\\1")

ccme_data$Group %<>%
  str_replace("Salmo", "Fish") %>%
  str_replace("Oncorhynchus", "Fish") %>%
  str_replace("Esox", "Fish") %>%
  str_replace("Salvelinus", "Fish") %>%
  str_replace("Catostomus", "Fish") %>%
  str_replace("Pimephales", "Fish") %>%
  str_replace("Micropterus", "Fish") %>%
  str_replace("Ictalurus", "Fish") %>%
  str_replace("Cottus", "Fish") %>%
  str_replace("Acipenser", "Fish") %>%
  str_replace("Prosopium", "Fish") %>%
  str_replace("Brachydanio", "Fish") %>%
  str_replace("Carassius", "Fish") %>%
  str_replace("Channa", "Fish") %>%
  str_replace("Rana", "Amphibian") %>%
  str_replace("Xenopus", "Amphibian") %>%
  str_replace("Bufo", "Amphibian") %>%
  str_replace("Ambystoma", "Amphibian") %>%
  str_replace("Daphnia", "Invertebrate") %>%
  str_replace("Opercularia", "Invertebrate") %>%
  str_replace("Ceriodaphnia", "Invertebrate") %>%
  str_replace("Entosiphon", "Invertebrate") %>%
  str_replace("Chironomus", "Invertebrate") %>%
  str_replace("Paramecium", "Invertebrate") %>%
  str_replace("Hyalella", "Invertebrate") %>%
  str_replace("Hydra", "Invertebrate") %>%
  str_replace("Lampsilis", "Invertebrate") %>%
  str_replace("Gammarus", "Invertebrate") %>%
  str_replace("Aeolosoma", "Invertebrate") %>%
  str_replace("Lymnaea", "Invertebrate") %>%
  str_replace("Rhithrogena", "Invertebrate") %>%
  str_replace("Erythemis", "Invertebrate") %>%
  str_replace("Pachydiplax", "Invertebrate") %>%
  str_replace("Echinogammarus", "Invertebrate") %>%
  str_replace("Atyaephyra", "Invertebrate") %>%
  str_replace("Epioblasma", "Invertebrate") %>%
  str_replace("Lumbriculus", "Invertebrate") %>%
  str_replace("Villosa", "Invertebrate") %>%
  str_replace("Tubifex", "Invertebrate") %>%
  str_replace("Musculium", "Invertebrate") %>%
  str_replace("Elliptio", "Invertebrate") %>%
  str_replace("Stenonema", "Invertebrate") %>%
  str_replace("Brachionus", "Invertebrate") %>%
  str_replace("Physa", "Invertebrate") %>%
  str_replace("Moinodaphnia", "Invertebrate") %>%
  str_replace("Brachionus", "Invertebrate") %>%
  str_replace("Pseudosuccinea", "Invertebrate") %>%
  str_replace("Simocephalus", "Invertebrate") %>%
  str_replace("Elodea", "Plant") %>%
  str_replace("Spirodella", "Plant") %>%
  str_replace("Chlorella", "Plant") %>%
  str_replace("Selenastrum", "Plant") %>%
  str_replace("Scenedesmus", "Plant") %>%
  str_replace("Myriophyllum", "Plant") %>%
  str_replace("Phragmites", "Plant") %>%
  str_replace("Anacystis", "Plant") %>%
  str_replace("Ankistrodesmus", "Plant") %>%
  str_replace("Pseudokirchneriella", "Plant") %>%
  str_replace("Navicula", "Plant") %>%
  str_replace("Anabaena", "Plant") %>%
  str_replace("Cryptomonas", "Plant") %>%
  str_replace("Potamogeton", "Plant") %>%
  str_replace("Lemna", "Plant")

ccme_data$Group %<>% factor(levels = c("Amphibian", "Fish", "Invertebrate", "Plant"))

ccme_data$Units <- str_replace(ccme_data$Chemical, "Boron", "mg/L") %>%
  str_replace("Cadmium", "ug/L") %>%
  str_replace("Chloride", "mg/L") %>%
  str_replace("Endosulfan", "ng/L") %>%
  str_replace("Glyphosate", "ug/L") %>%
  str_replace("Uranium", "ug/L") %>%
  str_replace("Silver", "ug/L")

ccme_data %<>% as_tibble()

use_data(ccme_data, overwrite = TRUE)

boron_data <- ccme_data[ccme_data$Chemical == "Boron",]
use_data(boron_data, overwrite = TRUE)

boron_lnorm <- ssd_fit_dist(boron_data$Concentration, "lnorm")
use_data(boron_lnorm, overwrite = TRUE)

boron_dists <- ssd_fit_dists(boron_data$Concentration)
use_data(boron_dists, overwrite = TRUE)

boron_pred <- predict(boron_dists)
use_data(boron_pred, overwrite = TRUE)
