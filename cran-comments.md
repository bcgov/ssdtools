## Test environments

release 4.0.2

* OSX (local) - release
* OSX (actions) - oldrel, release and devel
* Ubuntu (actions) - 3.4 to release
* Windows (actions) - release
* Windows (winbuilder) - devel

## Existing CRAN check Problems

Found the following (possibly) invalid URLs:
   URL: http://doi.org/10.1006/eesa.1993.1006 (moved to https://doi.org/10.1006/eesa.1993.1006)
     From: inst/doc/distributions.html
     Status: 200
     Message: OK
   URL: http://doi.org/10.1007/b97636 (moved to https://doi.org/10.1007/b97636)
     From: inst/doc/distributions.html
     Status: 200
     Message: OK
   URL: https://github.com/BCDevExchange/docs/blob/master/discussion/projectstates.md (moved to https://github.com/BCDevExchange/Our-Project-Docs/blob/master/discussion/projectstates.md)
     From: README.md
     Status: 200
     Message: OK
   URL: https://www.crcpress.com/Species-Sensitivity-Distributions-in-Ecotoxicology/Posthuma-II-Traas/p/book/9781566705783 (moved to https://www.routledge.com/Species-Sensitivity-Distributions-in-Ecotoxicology/Posthuma-II-Traas/p/book/9781566705783)
     From: inst/doc/ssdtools.html
     Status: 200
     Message: OK

Fixed

## R CMD check results

0 errors | 0 warnings | 1 note

> Found the following (possibly) invalid URL:
  URL: https://bcgov-env.shinyapps.io/ssdtools
    From: inst/doc/distributions.html
          inst/doc/ssdtools.html
          README.md
    Status: Error
    Message: libcurl error code 35:
      	Unknown SSL protocol error in connection to bcgov-env.shinyapps.io:443
    
The URL is valid.
