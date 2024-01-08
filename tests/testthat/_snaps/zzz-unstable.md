# hc multi_ci lnorm default 100

    Code
      hc_average
    Output
      # A tibble: 1 x 11
        dist    percent   est    se   lcl   ucl    wt method     nboot pboot samples  
        <chr>     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <dbl> <dbl> <I<list>>
      1 average       5  1.24 0.743 0.479  3.19     1 parametric   100     1 <dbl>    

---

    Code
      hc_multi
    Output
      # A tibble: 1 x 11
        dist    percent   est    se   lcl   ucl    wt method     nboot pboot samples  
        <chr>     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <dbl> <dbl> <I<list>>
      1 average       5  1.26 0.774 0.410  3.25     1 parametric   100  0.86 <dbl>    

# hp multi_ci lnorm default 100

    Code
      hp_average
    Output
      # A tibble: 1 x 11
        dist     conc   est    se   lcl   ucl    wt method     nboot pboot samples    
        <chr>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <dbl> <dbl> <I<list>>  
      1 average     1  3.90  2.31 0.738  9.57     1 parametric   100     1 <dbl [600]>

---

    Code
      hp_multi
    Output
      # A tibble: 1 x 11
        dist     conc   est    se   lcl   ucl    wt method     nboot pboot samples   
        <chr>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <dbl> <dbl> <I<list>> 
      1 average     1  3.90  3.73 0.347  9.59     1 parametric   100  0.86 <dbl [86]>

