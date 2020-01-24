## Test environments

Release 3.6.2

* OS X (local) - release
* Ubuntu (travis) - devel, release, oldrel and 3.5 - 3.4
* Windows (appveyor) - release
* Windows (win-builder) - devel

## R CMD check results

0 errors | 0 warnings | 3 notes

> See https://cran.r-project.org/web/checks/check_results_ssdtools.html .

> It seems this does not work with R 3.5.x despite

> Depends: 	R (≥ 3.4.0)

> Please correct (preferably by making it work with earlier versions, before Jan 31 to safely retain the package on CRAN.

Done

> Possibly mis-spelled words in DESCRIPTION:
  Posthuma (7:3)
  al (7:15)
  et (7:12)
  isbn (7:27)
  
The words are spelt correctly.

> Found the following (possibly) invalid URLs:
  URL: https://bcgov-env.shinyapps.io/ssdtools/
    From: inst/doc/distributions.html
          inst/doc/ssdtools.html
    Status: Error
    Message: libcurl error code 35:
      	Unknown SSL protocol error in connection to bcgov-env.shinyapps.io:443
      	
The url is valid.

## Reverse dependencies

There are no reverse dependencies.
