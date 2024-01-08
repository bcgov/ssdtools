# hp multi_ci lnorm

    Code
      hp_multi
    Output
      # A tibble: 1 x 11
        dist     conc   est    se   lcl   ucl    wt method     nboot pboot samples  
        <chr>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <int> <dbl> <I<list>>
      1 average     1  1.95    NA    NA    NA     1 parametric     0    NA <dbl [0]>

# hp multi_ci all

    Code
      hp_multi
    Output
      # A tibble: 1 x 11
        dist     conc   est    se   lcl   ucl    wt method     nboot pboot samples  
        <chr>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <int> <dbl> <I<list>>
      1 average     1  3.90    NA    NA    NA     1 parametric     0    NA <dbl [0]>

# hp multi_ci lnorm ci

    Code
      hp_average
    Output
      # A tibble: 1 x 11
        dist     conc   est    se   lcl   ucl    wt method     nboot pboot samples  
        <chr>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <dbl> <dbl> <I<list>>
      1 average     1  1.95  1.63 0.349  5.38     1 parametric   100     1 <dbl [0]>

---

    Code
      hp_multi
    Output
      # A tibble: 1 x 11
        dist     conc   est    se   lcl   ucl    wt method     nboot pboot samples  
        <chr>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <dbl> <dbl> <I<list>>
      1 average     1  1.95  1.42 0.337  5.16     1 parametric   100     1 <dbl [0]>

