## Test environments

release 4.0.2

* OSX (local) - release
* OSX (actions) - oldrel, release and devel
* Ubuntu (actions) - 3.4 to release
* Windows (actions) - release
* Windows (winbuilder) - devel

## Existing CRAN check Problems

Fixed 'noLD' additional issue.

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
    
The url is valid.
