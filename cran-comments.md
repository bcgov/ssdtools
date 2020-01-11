## Test environments

release 3.6.1

* OS X (local) - release
* Ubuntu (travis) - release and devel
* win-builder - release and devel

## R CMD check results

0 errors | 0 warnings | 2 notes

Possibly mis-spelled words in DESCRIPTION:
  Posthuma (7:3)
  al (7:15)
  et (7:12)
  isbn (7:27)
  
The words are spelt correctly.

Found the following (possibly) invalid URLs:
  URL: https://bcgov-env.shinyapps.io/ssdtools/
    From: inst/doc/distributions.html
          inst/doc/ssdtools.html
    Status: Error
    Message: libcurl error code 35:
      	Unknown SSL protocol error in connection to bcgov-env.shinyapps.io:443
      	
The url is valid.

This is a resubmission.

Thanks, we see on platforms without long doubles (noLD):

 > test_check("ssdtools")
 ── 1. Failure: fit_dists computable (@test-fit.R#101) ─────────────────────────
 `ssd_fit_dists(data, dists = "gamma")` did not throw an error.

 ── 2. Failure: fit_dists computable (@test-fit.R#107) ─────────────────────────
 fit$sd not equal to c(scale = NaN, shape = 0.0414094229126189).
 2/2 mismatches (average diff: 0.00029)
 [1] 7.51e+03 -    NaN ==     NaN
 [2] 4.17e-02 - 0.0414 == 0.00029

 ── 3. Failure: fit_dists computable (@test-fit.R#112) ─────────────────────────
 fit$sd not equal to c(scale = 673.801371511101, shape = 0.0454275860604086).
 2/2 mismatches (average diff: 0.136)
 [1] 673.5298 - 673.8014 == -2.72e-01
 [2]   0.0454 -   0.0454 == -2.91e-06

 ── 4. Failure: fit pareto cis (@test-pareto.R#41) ─────────────────────────────
 as.data.frame(ssd_hc(dist, ci = TRUE, nboot = 10)) not equal to structure(...).
 Component "se": Mean relative difference: 2.947362e-08

 ── 5. Failure: fit pareto cis (@test-pareto.R#52) ─────────────────────────────
 as.data.frame(ssd_hp(dist, conc = 2, ci = TRUE, nboot = 10)) not equal to structure(...).
 Component "est": Mean relative difference: 2.242121e-08
 Component "se": Mean relative difference: 1.867354e-08
 Component "lcl": Mean relative difference: 2.306981e-08
 Component "ucl": Mean relative difference: 2.187393e-08

 ══ testthat results ═══════════════════════════════════════════════════════════
 [ OK: 263 | SKIPPED: 0 | WARNINGS: 9 | FAILED: 5 ]
 1. Failure: fit_dists computable (@test-fit.R#101)
 2. Failure: fit_dists computable (@test-fit.R#107)
 3. Failure: fit_dists computable (@test-fit.R#112)
 4. Failure: fit pareto cis (@test-pareto.R#41)
 5. Failure: fit pareto cis (@test-pareto.R#52)
 
 Fixed!

## Reverse dependencies

There are no reverse dependencies.
