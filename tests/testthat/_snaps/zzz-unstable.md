# hc multi lnorm default 100

    Code
      hc_average
    Output
      # A tibble: 1 x 10
        dist    percent   est    se   lcl   ucl    wt method     nboot pboot
        <chr>     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <dbl> <dbl>
      1 average       5  1.24 0.743 0.479  3.19     1 parametric   100     1

---

    Code
      hc_multi
    Output
      # A tibble: 1 x 10
        dist    percent   est    se   lcl   ucl    wt method     nboot pboot
        <chr>     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <dbl> <dbl>
      1 average       5  1.26 0.582 0.364  2.69     1 parametric   100  0.86

# hp multi lnorm default 100

    Code
      hp_average
    Output
      # A tibble: 1 x 10
        dist     conc   est    se   lcl   ucl    wt method     nboot pboot
        <chr>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <dbl> <dbl>
      1 average     1  3.90  2.31 0.738  9.57     1 parametric   100     1

---

    Code
      hp_multi
    Output
      # A tibble: 1 x 10
        dist     conc   est    se   lcl   ucl    wt method     nboot pboot
        <chr>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <dbl> <dbl>
      1 average     1  3.90  2.57  1.46  10.4     1 parametric   100  0.86

