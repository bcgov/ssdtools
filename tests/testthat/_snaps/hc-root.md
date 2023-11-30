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
      1 average       5  1.68 0.729  1.32  2.30     1 parametric     2     1

---

    Code
      hc_multi
    Output
      # A tibble: 1 x 10
        dist    percent   est    se   lcl   ucl    wt method     nboot pboot
        <chr>     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <dbl> <dbl>
      1 average       5  1.68 0.342  1.12  1.58     1 parametric     2     1

# hc multi lnorm default

    Code
      hc_average
    Output
      # A tibble: 1 x 10
        dist    percent   est    se   lcl   ucl    wt method     nboot pboot
        <chr>     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <dbl> <dbl>
      1 average       5  1.24 0.928  1.27  2.52     1 parametric     2     1

---

    Code
      hc_multi
    Output
      # A tibble: 1 x 10
        dist    percent   est    se   lcl   ucl    wt method     nboot pboot
        <chr>     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <dbl> <dbl>
      1 average       5  1.26 0.126 0.920  1.09     1 parametric     2     1

