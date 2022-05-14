## Test environments

release 4.2.0

* OSX (local) - release
* OSX (actions) - release
* Ubuntu (actions) - oldrel, release and devel
* Windows (actions) - release
* Windows (winbuilder) - devel

## R CMD check results

0 errors | 0 warnings | 2 notes

> checking installed package size ... NOTE
>  installed size is 13.2Mb
>  sub-directories of 1Mb or more:
>    doc 1.2Mb
>    help 1.0Mb
>    libs 10.5Mb

The large size of these subdirectories is necessary.

> Found the following (possibly) invalid URLs:
>  URL: https://doi.org/10.1002/etc.4925
>    From: inst/doc/ssdtools.html
>          README.md
>    Status: 503
>    Message: Service Unavailable
>  URL: https://doi.org/10.1897/02-435
>    From: inst/doc/exposure-plots.html
>    Status: 503
>    Message: Service Unavailable
>  URL: https://www.jstor.org/stable/2235756
>    From: inst/doc/distributions.html
>    Status: 403
>    Message: Forbidden

These URLs are valid.

## revdepcheck results

We checked 1 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages


