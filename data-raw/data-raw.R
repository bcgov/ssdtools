# Copyright 2015-2023 Province of British Columbia
# Copyright 2021 Environment and Climate Change Canada
# Copyright 2023-2024 Australian Government Department of Climate Change, 
# Energy, the Environment and Water
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

library(ssdtools)
library(ssddata)
library(tibble)
library(usethis)

dist_data <- tibble::tribble(
  ~dist, ~bcanz, ~tails, ~npars,
  "burrIII3", FALSE, TRUE, 3L,
  "gamma", TRUE, TRUE, 2L,
  "gompertz", FALSE, TRUE, 2L,
  "invpareto", FALSE, FALSE, 2L,
  "lgumbel", TRUE, TRUE, 2L,
  "llogis", TRUE, TRUE, 2L,
  "llogis_llogis", FALSE, TRUE, 5L,
  "lnorm", TRUE, TRUE, 2L,
  "lnorm_lnorm", TRUE, TRUE, 5L,
  "weibull", TRUE, TRUE, 2L
)

stopifnot(identical(dist_data$dist, ssdtools::ssd_dists()))
stopifnot(identical(dist_data$dist[dist_data$bcanz], ssdtools::ssd_dists_bcanz()))
stopifnot(identical(dist_data$dist[dist_data$npars == 2], ssdtools::ssd_dists(npars = 2)))
stopifnot(identical(dist_data$dist[dist_data$npars == 3], ssdtools::ssd_dists(npars = 3)))
stopifnot(identical(dist_data$dist[dist_data$npars == 4], ssdtools::ssd_dists(npars = 4)))
stopifnot(identical(dist_data$dist[dist_data$npars == 5], ssdtools::ssd_dists(npars = 5)))
stopifnot(identical(dist_data$dist[dist_data$tails], ssdtools::ssd_dists(tails = TRUE)))
stopifnot(identical(dist_data$dist[!dist_data$tails], ssdtools::ssd_dists(tails = FALSE)))

use_data(dist_data, overwrite = TRUE)

fits <- ssd_fit_dists(ssddata::ccme_boron)

withr::with_seed(
  99,
  boron_pred <- predict(fits, ci = TRUE)
)

use_data(boron_pred, overwrite = TRUE)
