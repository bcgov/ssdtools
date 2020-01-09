## Test environments

release 3.6.1

* OS X (local) - release
* Ubuntu (travis) - release and devel
* win-builder - release and devel

## R CMD check results

0 errors | 0 warnings | 1 note

Found the following (possibly) invalid URLs:
  URL: https://bcgov-env.shinyapps.io/ssdtools/
    From: inst/doc/distributions.html
          inst/doc/ssdtools.html
    Status: Error
    Message: libcurl error code 35:
      	Unknown SSL protocol error in connection to bcgov-env.shinyapps.io:443

The url is valid.

Found the following (possibly) invalid file URIs:
   URI: CONTRIBUTING.md
     From: README.md
   URI: CODE_OF_CONDUCT.md
     From: README.md

Please use fully specified URLs or include the files in your package - or omit the links at all.

I've replaced with fully specified URLs.

Is there some reference about the method you can add in the Description field in the form Authors (year) <doi:.....>?



## Reverse dependencies

There are no reverse dependencies.
