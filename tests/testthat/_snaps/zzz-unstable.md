# hc multi_ci lnorm default 100

    Code
      hc_average
    Output
      # A tibble: 1 x 11
        dist    proportion   est    se   lcl   ucl    wt method    nboot pboot samples
        <chr>        <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>     <dbl> <dbl> <I<lis>
      1 average       0.05  1.24 0.743 0.479  3.19     1 parametr~   100     1 <dbl>  

---

    Code
      hc_multi
    Output
      # A tibble: 1 x 11
        dist    proportion   est    se   lcl   ucl    wt method    nboot pboot samples
        <chr>        <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>     <dbl> <dbl> <I<lis>
      1 average       0.05  1.26 0.757 0.410  3.25     1 parametr~   100  0.86 <dbl>  

# hp multi_ci lnorm default 100

    Code
      hp_average
    Output
      # A tibble: 1 x 11
        dist     conc   est    se   lcl   ucl    wt method     nboot pboot samples    
        <chr>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <dbl> <dbl> <I<list>>  
      1 average     1  3.90  2.32 0.738  9.57     1 parametric   100     1 <dbl [600]>

---

    Code
      hp_multi
    Output
      # A tibble: 1 x 11
        dist     conc   est    se   lcl   ucl    wt method     nboot pboot samples   
        <chr>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <dbl> <dbl> <I<list>> 
      1 average     1  3.90  2.50 0.343  9.20     1 parametric   100  0.86 <dbl [86]>

# sgompertz completely unstable!

    Code
      set.seed(94)
      ssdtools:::sgompertz(data)
    Output
      $log_location
      [1] -0.8105617
      
      $log_shape
      [1] -300.8251
      
    Code
      set.seed(99)
      ssdtools:::sgompertz(data)
    Output
      $log_location
      [1] -0.9662517
      
      $log_shape
      [1] -2.602139
      

# sgompertz with initial values still unstable!

    Code
      set.seed(94)
      ssdtools:::sgompertz(sdata)
    Output
      $log_location
      [1] -0.8105617
      
      $log_shape
      [1] -300.8251
      
    Code
      set.seed(94)
      ssdtools:::sgompertz(sdata, pars)
    Output
      $log_location
      [1] 4.078373
      
      $log_shape
      [1] -2989.932
      
    Code
      set.seed(99)
      ssdtools:::sgompertz(sdata)
    Output
      $log_location
      [1] -0.9662517
      
      $log_shape
      [1] -2.602139
      
    Code
      set.seed(99)
      ssdtools:::sgompertz(sdata, pars)
    Output
      $log_location
      [1] 3.433594
      
      $log_shape
      [1] -104.2544
      
    Code
      set.seed(100)
      ssdtools:::sgompertz(sdata, pars)
    Output
      $log_location
      [1] 3.81493
      
      $log_shape
      [1] -669.3178
      

