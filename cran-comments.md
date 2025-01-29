## Previous Submission

> Thanks, we see:

> Size of tarball: 5665221 bytes

> Can this be reducd to less than 5 MB?

Yes we have transferred all but two small vignettes to vignettes/articles.

## R CMD check results

0 errors | 0 warnings | 1 note

> ❯ checking installed package size ... NOTE
>    installed size is 18.0Mb
>     sub-directories of 1Mb or more:
>       libs  16.9Mb

The large size of this sub-directory is necessary as it contains a .dll for the TMB model fitting functions.
