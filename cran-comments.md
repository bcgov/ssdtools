## Test environments

Release 3.6.2

* OS X (local) - release
* Ubuntu (travis) - devel, release, oldrel and 3.5 - 3.4
* Windows (appveyor) - release
* Windows (win-builder) - devel

## R CMD check results

0 errors | 0 warnings | 2 notes

> Possibly mis-spelled words in DESCRIPTION:
  Posthuma (7:3)
  al (7:15)
  et (7:12)
  isbn (7:27)
  
The words are spelt correctly.

> Found the following (possibly) invalid URLs:
  URL: http://creativecommons.org/licenses/by/4.0/
    From: inst/doc/distributions.html
          inst/doc/exposure-plots.html
          inst/doc/small-sample-bias-ref.html
          inst/doc/ssdtools.html
          README.md
    Status: 521
  URL: https://bcgov-env.shinyapps.io/ssdtools/
    From: inst/doc/distributions.html
          inst/doc/ssdtools.html
          README.md
    Status: Error
    Message: libcurl error code 35:
      	Unknown SSL protocol error in connection to bcgov-env.shinyapps.io:443
      	
The urls are valid.

## Reverse dependencies

There are no reverse dependencies.
