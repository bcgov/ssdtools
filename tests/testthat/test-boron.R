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
  tidy <- tidy(fits)
  expect_s3_class(tidy, "tbl_df")
  expect_equal(as.data.frame(tidy), structure(list(
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
  
  glance <- glance(fits)
  expect_s3_class(glance, "tbl")
  expect_equal(as.data.frame(glance),
               structure(list(
                 dist = c("gamma", "lgumbel", "llogis", "lnorm", 
                          "weibull"), 
                 npars = c(2L, 2L, 2L, 2L, 2L), 
                 nobs = c(28L, 28L, 
                          28L, 28L, 28L), 
                 log_lik = c(-116.81515869884, -120.092975580318, 
                             -118.507435324864, -117.514216489547, -116.81264387617), 
                 aic = c(237.630317397681, 
                         244.185951160636, 241.014870649727, 239.028432979094, 237.625287752339
                 ), 
                 aicc = c(238.110317397681, 244.665951160636, 241.494870649727, 
                          239.508432979094, 238.105287752339), 
                 delta = c(0.00502964534129546, 
                           6.56066340829656, 3.3895828973877, 1.4031452267549, 0), 
                 weight = c(0.367460381868861, 
                            0.0138571123365061, 0.0676494268556018, 0.182647436425698, 0.368385642513334
                 )), 
                 row.names = c(NA, -5L), class = "data.frame")) 
  
  gof <- ssd_gof(fits)
  expect_s3_class(gof, "tbl")
  expect_equal(as.data.frame(gof),
               structure(list(
                 dist = c("gamma", "lgumbel", "llogis", "lnorm", 
                          "weibull"), 
                 ad = c(NA_real_, NA_real_, NA_real_, NA_real_, NA_real_
                 ), 
                 ks = c(NA_real_, NA_real_, NA_real_, NA_real_, NA_real_), 
                 cvm = c(NA_real_, NA_real_, NA_real_, NA_real_, NA_real_), 
                 aic = c(237.630317397681, 244.185951160636, 241.014870649727, 
                         239.028432979094, 237.625287752339), 
                 aicc = c(238.110317397681, 
                          244.665951160636, 241.494870649727, 239.508432979094, 238.105287752339
                 ), 
                 bic = c(240.294726418031, 246.850360180986, 243.679279670078, 
                         241.692841999445, 240.28969677269), 
                 delta = c(0.005, 6.561, 
                           3.39, 1.403, 0), 
                 weight = c(0.367, 0.014, 0.068, 0.183, 0.368
                 )), 
                 row.names = c(NA, -5L), class = "data.frame"))
  
  estimates <- estimates(fits)
  expect_type(estimates, "list")
  expect_identical(unlist(estimates), setNames(tidy$est, paste(tidy$dist, tidy$term, sep = ".")))
  
  expect_identical(coef(fits), tidy)
  expect_identical(augment(fits), ssdtools::boron_data)
  
  set.seed(102)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10, average = FALSE)
  expect_s3_class(hc, "tbl")
  expect_equal(as.data.frame(hc), 
               structure(list(
                 dist = c("gamma", "lgumbel", "llogis", "lnorm", 
                          "weibull"), 
                 percent = c(5, 5, 5, 5, 5), 
                 est = c(1.07428453014496, 
                         1.76938547654574, 1.56226388133415, 1.6811748398812, 1.08673385398691
                 ), 
                 se = c(0.943453446295525, 0.466289589831322, 0.513428900764099, 
                        0.382521299435556, 0.504669632705483), 
                 lcl = c(0.382343631258803, 
                         1.28866461383402, 1.41933606523229, 0.81398585656334, 0.774438807570494
                 ), 
                 ucl = c(3.16461333423632, 2.70033927362266, 2.89536573124329, 
                         1.89834434365108, 2.11024170883212)), 
                 row.names = c(NA, -5L), class = "data.frame"))
  
  set.seed(102)
  hp <- ssd_hp(fits, conc = 1, ci = TRUE, nboot = 10, average = FALSE)
  expect_s3_class(hp, "tbl")
  expect_equal(as.data.frame(hp), 
               structure(list(
                 dist = c("gamma", "lgumbel", "llogis", "lnorm", 
                          "weibull"), 
                 conc = c(1, 1, 1, 1, 1), 
                 est = c(4.67758994580286, 
                         0.856451573991328, 2.80047097268139, 1.9543030195088, 4.62300470445696
                 ), 
                 se = c(3.115625991872, 0.920606501855927, 0.91949360967132, 
                        1.90438018252244, 1.55259874860264), 
                 lcl = c(0.915651204993843, 
                         0.104235165112368, 0.873951137045136, 1.2332579525854, 2.17995956128767
                 ), 
                 ucl = c(9.9269396998523, 2.77829343301924, 3.41785755992175, 
                         6.4619493048247, 6.20931944384517)), 
                 row.names = c(NA, -5L), class = "data.frame"))
})

test_that("boron unstable", {
  dists <- ssd_dists("unstable")
  set.seed(50)
  expect_warning(fits <- ssd_fit_dists(ssdtools::boron_data, dists = dists),
                 "Distribution 'burrIII3' failed to fit")
  tidy <- tidy(fits)
  expect_s3_class(tidy, "tbl_df")
  expect_equal(as.data.frame(tidy), structure(list(
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
  
  glance <- glance(fits)
  expect_s3_class(glance, "tbl")
  expect_equal(as.data.frame(glance),
               structure(list(
                 dist = c("gompertz", "mx_llogis_llogis"), 
                 npars = c(2L, 
                           5L), 
                 nobs = c(28L, 28L), 
                 log_lik = c(-116.805577237298, -115.894989612752
                 ), 
                 aic = c(237.611154474595, 241.789979225505), 
                 aicc = c(238.091154474595, 
                          244.517251952777), 
                 delta = c(0, 6.42609747818196), 
                 weight = c(0.96132238228674, 
                            0.0386776177132603)), 
                 row.names = c(NA, -2L), class = "data.frame")) 
  
  gof <- ssd_gof(fits)
  expect_s3_class(gof, "tbl")
  expect_equal(as.data.frame(gof),
               structure(list(dist = c("gompertz", "mx_llogis_llogis"), 
                              ad = c(NA_real_, 
                                     NA_real_), 
                              ks = c(NA_real_, NA_real_), 
                              cvm = c(NA_real_, NA_real_
                              ), 
                              aic = c(237.611154474595, 241.789979225505), 
                              aicc = c(238.091154474595, 
                                       244.517251952777), 
                              bic = c(240.275563494946, 248.451001776381
                              ), 
                              delta = c(0, 6.426), 
                              weight = c(0.961, 0.039)), 
                         row.names = c(NA, 
                                       -2L), class = "data.frame")) 
  
  estimates <- estimates(fits)
  expect_type(estimates, "list")
  expect_identical(unlist(estimates), setNames(tidy$est, paste(tidy$dist, tidy$term, sep = ".")))
  
  expect_identical(coef(fits), tidy)
  expect_identical(augment(fits), ssdtools::boron_data)
  
  # set.seed(102)
  # 
  # hc <- ssd_hc(fits, ci = TRUE, nboot = 10, average = FALSE)
  # expect_s3_class(hc, "tbl")
  # expect_equal(as.data.frame(hc), 
  #              structure(list(
  #                dist = c("gamma", "lgumbel", "llogis", "lnorm", 
  #                         "weibull"), 
  #                percent = c(5, 5, 5, 5, 5), 
  #                est = c(1.07428453014496, 
  #                        1.76938547654574, 1.56226388133415, 1.6811748398812, 1.08673385398691
  #                ), 
  #                se = c(0.943453446295525, 0.466289589831322, 0.513428900764099, 
  #                       0.382521299435556, 0.504669632705483), 
  #                lcl = c(0.382343631258803, 
  #                        1.28866461383402, 1.41933606523229, 0.81398585656334, 0.774438807570494
  #                ), 
  #                ucl = c(3.16461333423632, 2.70033927362266, 2.89536573124329, 
  #                        1.89834434365108, 2.11024170883212)), 
  #                row.names = c(NA, -5L), class = "data.frame"))
  # 
  set.seed(102)
  hp <- ssd_hp(fits, conc = 1, ci = TRUE, nboot = 10, average = FALSE)
  expect_s3_class(hp, "tbl")
  expect_equal(as.data.frame(hp), 
               structure(list(
                 dist = c("gompertz", "mx_llogis_llogis"), 
                 conc = c(1, 1), 
                 est = c(3.86926768388197, 1.56256400293298), 
                 se = c(0.700718236698958, 1.31386184167695), 
                 lcl = c(2.51238335587379, 0.178961042184077), 
                 ucl = c(4.78629039008938, 3.61388745593962)), 
                 row.names = c(NA, -2L), class = "data.frame"))
})
