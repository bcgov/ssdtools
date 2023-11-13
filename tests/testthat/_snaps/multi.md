# ssd_emulti

    Code
      tidyr::unnest(wt_est, "data")
    Output
      # A tibble: 15 x 4
         dist        weight term          est
         <chr>        <dbl> <chr>       <dbl>
       1 gamma        0.167 shape         1  
       2 gamma        0.167 scale         1  
       3 lgumbel      0.167 locationlog   0  
       4 lgumbel      0.167 scalelog      1  
       5 llogis       0.167 locationlog   0  
       6 llogis       0.167 scalelog      1  
       7 lnorm        0.167 meanlog       0  
       8 lnorm        0.167 sdlog         1  
       9 lnorm_lnorm  0.167 meanlog1      0  
      10 lnorm_lnorm  0.167 sdlog1        1  
      11 lnorm_lnorm  0.167 meanlog2      1  
      12 lnorm_lnorm  0.167 sdlog2        1  
      13 lnorm_lnorm  0.167 pmix          0.5
      14 weibull      0.167 shape         1  
      15 weibull      0.167 scale         1  

