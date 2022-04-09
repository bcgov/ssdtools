## Test environments

release 4.1.3

* OSX (local) - release
* OSX (actions) - release
* Ubuntu (actions) - release and devel
* Windows (actions) - release
* Windows (winbuilder) - devel

## Existing Issues

Check Details

Version: 1.0.0 
Check: whether package can be installed 
Result: WARN 
    Found the following significant warnings:
     ./ll_invpareto.hpp:92:12: warning: use of bitwise '&' with boolean operands [-Wbitwise-instead-of-logical] 
Flavors: r-devel-linux-x86_64-debian-clang, r-devel-linux-x86_64-fedora-clang

Fixed

Version: 1.0.0 
Check: dependencies in R code 
Result: NOTE 
    Namespace in Imports field not imported from: ‘ssddata’
     All declared Imports should be used. 
Flavors: r-devel-linux-x86_64-fedora-clang, r-devel-linux-x86_64-fedora-gcc, r-release-macos-x86_64

Fixed

Version: 1.0.0 
Check: installed package size 
Result: NOTE 
     installed size is 13.1Mb
     sub-directories of 1Mb or more:
     doc 1.2Mb
     help 1.0Mb
     libs 10.5Mb 
Flavors: r-devel-linux-x86_64-fedora-clang, r-devel-windows-x86_64-new-UL, r-release-macos-x86_64, r-release-windows-ix86+x86_64

The large size of these subdirectories is necessary.

## R CMD check results

0 errors | 0 warnings | 3 notes

* checking CRAN incoming feasibility ... NOTE
Maintainer: 'Joe Thorley <joe@poissonconsulting.ca>'

Possibly misspelled words in DESCRIPTION:
  Akaike (59:23)
  
This word is spelt correctly.

Found the following (possibly) invalid URLs:
  URL: https://doi.org/10.1002/etc.4925
    From: inst/doc/ssdtools.html
    Status: 503
    Message: Service Unavailable
  URL: https://doi.org/10.1897/02-435
    From: inst/doc/exposure-plots.html
    Status: 503
    Message: Service Unavailable
  URL: https://setac.onlinelibrary.wiley.com/doi/10.1002/etc.4925
    From: README.md
    Status: 503
    Message: Service Unavailable
  URL: https://setac.onlinelibrary.wiley.com/doi/abs/10.1897/02-435
    From: inst/doc/exposure-plots.html
    Status: 503
    Message: Service Unavailable
  URL: https://www.jstor.org/stable/2235756
    From: inst/doc/distributions.html
    Status: 403
    Message: Forbidden
    
These URLs are valid.

Version: 1.0.0 
Check: installed package size 
Result: NOTE 
     installed size is 13.1Mb
     sub-directories of 1Mb or more:
     doc 1.2Mb
     help 1.0Mb
     libs 10.5Mb
     
The large size of these subdirectories is necessary.

## revdepcheck results

We checked 1 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages
