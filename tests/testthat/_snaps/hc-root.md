# hc multi lnorm

    Code
      hc_multi
    Output
      # A tibble: 1 x 10
        dist    percent   est    se   lcl   ucl    wt method     nboot pboot
        <chr>     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <int> <dbl>
      1 average       5  1.68    NA    NA    NA     1 parametric     0    NA

# hc multi all

    Code
      hc_multi
    Output
      # A tibble: 1 x 10
        dist    percent   est    se   lcl   ucl    wt method     nboot pboot
        <chr>     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <int> <dbl>
      1 average       5  1.26    NA    NA    NA     1 parametric     0    NA

# hc multi lnorm ci

    Code
      hc_average
    Output
      # A tibble: 1 x 10
        dist    percent   est    se   lcl   ucl    wt method     nboot pboot
        <chr>     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <dbl> <dbl>
      1 average       5  1.68 0.529 0.948  2.76     1 parametric   100     1

---

    Code
      hc_multi
    Output
      # A tibble: 1 x 10
        dist    percent   est    se   lcl   ucl    wt method     nboot pboot
        <chr>     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <dbl> <dbl>
      1 average       5  1.68 0.535 0.979  2.99     1 parametric   100     1

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
      1 average       5  1.26 0.752 0.360  3.25     1 parametric   100     1

