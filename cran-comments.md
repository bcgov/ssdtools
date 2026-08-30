ssdtools 2.7.0

## Cran Repository Policy

- [x] Reviewed CRP last edited 2024-08-27.

## Notes

This release removes the dependency on the ggtext package, which CRAN has scheduled for archival on 2026-09-12.
Nothing was added in its place.

The small sample bias vignette was removed because it depended on mle.tools, which has been archived on CRAN.

## revdepcheck results

We checked 2 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages
