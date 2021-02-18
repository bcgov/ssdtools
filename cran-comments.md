## Test environments

release 4.0.4

* OSX (local) - release
* OSX (actions) - release
* Ubuntu (actions) - 3.5, 3.6, oldrel, release and devel
* Windows (actions) - release
* Windows (winbuilder) - devel

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

## revdepcheck results

We checked 1 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages
