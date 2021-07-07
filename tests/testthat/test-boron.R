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

test_that("boron stable", {
  dists <- ssd_dists("stable")
  fits <- ssd_fit_dists(ssdtools::boron_data, dists = dists)
  fits <- as.data.frame(tidy(fits))
  expect_equal(fits, structure(list(
    dist = c("gamma", "gamma", "lgumbel", "lgumbel", 
             "llogis", "llogis", "lnorm", "lnorm", "weibull", "weibull"), 
    term = c("scale", "shape", "locationlog", "scalelog", "locationlog", 
             "scalelog", "meanlog", "sdlog", "scale", "shape"), 
    est = c(25.1268319779061, 
            0.950179460431249, 1.92263082409711, 1.23223883525026, 2.62627625930417, 
            0.740426376456358, 2.56164496371788, 1.24154032419128, 23.5139783002509, 
            0.966099901938021), 
    se = c(7.64041146669503, 0.222581466959488, 
           0.247321058974131, 0.173020274627147, 0.248257436357321, 
           0.114374887744215, 0.234629067176348, 0.165907749058664, 
           4.8551658235763, 0.145420497304533)), row.names = c(NA, -10L
           ), class = "data.frame"))
})

test_that("boron unstable", {
  dists <- ssd_dists("unstable")
  set.seed(50)
  expect_warning(fits <- ssd_fit_dists(ssdtools::boron_data, dists = dists),
                 "Distribution 'burrIII3' failed to fit")
  fits <- as.data.frame(tidy(fits))
  expect_equal(fits, structure(list(
    dist = c("gompertz", "gompertz", "mx_llogis_llogis", 
             "mx_llogis_llogis", "mx_llogis_llogis", "mx_llogis_llogis", "mx_llogis_llogis"
    ), 
    term = c("location", "shape", "locationlog1", "locationlog2", 
             "pmix", "scalelog1", "scalelog2"), 
    est = c(0.0394098186724785, 
            0.00260152464540154, 0.896785336771335, 3.14917770255953, 0.255223497712533, 
            0.317650881482978, 0.496708998267848), 
    se = c(0.011983859348259, 
           0.0099785211858212, 0.379712940033151, 0.288285822914499, 0.144350756347623, 
           0.167981647634004, 0.135112373508756)), row.names = c(NA, -7L
           ), class = "data.frame"))
})
