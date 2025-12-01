# Default Parameter Estimates

Default Parameter Estimates

## Usage

``` r
ssd_eburrIII3()

ssd_egamma()

ssd_egompertz()

ssd_einvpareto()

ssd_elgumbel()

ssd_elgumbel()

ssd_ellogis_llogis()

ssd_ellogis()

ssd_elnorm_lnorm()

ssd_elnorm()

ssd_emulti()

ssd_eweibull()
```

## Functions

- `ssd_eburrIII3()`: Default Parameter Values for BurrIII Distribution

- `ssd_egamma()`: Default Parameter Values for Gamma Distribution

- `ssd_egompertz()`: Default Parameter Values for Gompertz Distribution

- `ssd_einvpareto()`: Default Parameter Values for Inverse Pareto
  Distribution

- `ssd_elgumbel()`: Default Parameter Values for Log-Gumbel Distribution

- `ssd_elgumbel()`: Default Parameter Values for log-Gumbel Distribution

- `ssd_ellogis_llogis()`: Default Parameter Values for
  Log-Logistic/Log-Logistic Mixture Distribution

- `ssd_ellogis()`: Default Parameter Values for Log-Logistic
  Distribution

- `ssd_elnorm_lnorm()`: Default Parameter Values for
  Log-Normal/Log-Normal Mixture Distribution

- `ssd_elnorm()`: Default Parameter Values for Log-Normal Distribution

- `ssd_emulti()`: Default Parameter Values for Multiple Distributions

- `ssd_eweibull()`: Default Parameter Values for Log-Normal Distribution

## See also

[`ssd_p`](https://bcgov.github.io/ssdtools/reference/ssd_p.md) and
[`ssd_q`](https://bcgov.github.io/ssdtools/reference/ssd_q.md)

## Examples

``` r
ssd_eburrIII3()
#> $shape1
#> [1] 1
#> 
#> $shape2
#> [1] 1
#> 
#> $scale
#> [1] 1
#> 

ssd_egamma()
#> $shape
#> [1] 1
#> 
#> $scale
#> [1] 1
#> 

ssd_egompertz()
#> $location
#> [1] 1
#> 
#> $shape
#> [1] 1
#> 

ssd_einvpareto()
#> $shape
#> [1] 3
#> 
#> $scale
#> [1] 1
#> 

ssd_einvpareto()
#> $shape
#> [1] 3
#> 
#> $scale
#> [1] 1
#> 

ssd_elgumbel()
#> $locationlog
#> [1] 0
#> 
#> $scalelog
#> [1] 1
#> 

ssd_ellogis_llogis()
#> $locationlog1
#> [1] 0
#> 
#> $scalelog1
#> [1] 1
#> 
#> $locationlog2
#> [1] 1
#> 
#> $scalelog2
#> [1] 1
#> 
#> $pmix
#> [1] 0.5
#> 

ssd_ellogis()
#> $locationlog
#> [1] 0
#> 
#> $scalelog
#> [1] 1
#> 

ssd_elnorm_lnorm()
#> $meanlog1
#> [1] 0
#> 
#> $sdlog1
#> [1] 1
#> 
#> $meanlog2
#> [1] 1
#> 
#> $sdlog2
#> [1] 1
#> 
#> $pmix
#> [1] 0.5
#> 

ssd_elnorm()
#> $meanlog
#> [1] 0
#> 
#> $sdlog
#> [1] 1
#> 

ssd_emulti()
#> $burrIII3.weight
#> [1] 0
#> 
#> $burrIII3.shape1
#> [1] 1
#> 
#> $burrIII3.shape2
#> [1] 1
#> 
#> $burrIII3.scale
#> [1] 1
#> 
#> $gamma.weight
#> [1] 0.1666667
#> 
#> $gamma.shape
#> [1] 1
#> 
#> $gamma.scale
#> [1] 1
#> 
#> $gompertz.weight
#> [1] 0
#> 
#> $gompertz.location
#> [1] 1
#> 
#> $gompertz.shape
#> [1] 1
#> 
#> $lgumbel.weight
#> [1] 0.1666667
#> 
#> $lgumbel.locationlog
#> [1] 0
#> 
#> $lgumbel.scalelog
#> [1] 1
#> 
#> $llogis.weight
#> [1] 0.1666667
#> 
#> $llogis.locationlog
#> [1] 0
#> 
#> $llogis.scalelog
#> [1] 1
#> 
#> $llogis_llogis.weight
#> [1] 0
#> 
#> $llogis_llogis.locationlog1
#> [1] 0
#> 
#> $llogis_llogis.scalelog1
#> [1] 1
#> 
#> $llogis_llogis.locationlog2
#> [1] 1
#> 
#> $llogis_llogis.scalelog2
#> [1] 1
#> 
#> $llogis_llogis.pmix
#> [1] 0.5
#> 
#> $lnorm.weight
#> [1] 0.1666667
#> 
#> $lnorm.meanlog
#> [1] 0
#> 
#> $lnorm.sdlog
#> [1] 1
#> 
#> $lnorm_lnorm.weight
#> [1] 0.1666667
#> 
#> $lnorm_lnorm.meanlog1
#> [1] 0
#> 
#> $lnorm_lnorm.sdlog1
#> [1] 1
#> 
#> $lnorm_lnorm.meanlog2
#> [1] 1
#> 
#> $lnorm_lnorm.sdlog2
#> [1] 1
#> 
#> $lnorm_lnorm.pmix
#> [1] 0.5
#> 
#> $weibull.weight
#> [1] 0.1666667
#> 
#> $weibull.shape
#> [1] 1
#> 
#> $weibull.scale
#> [1] 1
#> 

ssd_eweibull()
#> $shape
#> [1] 1
#> 
#> $scale
#> [1] 1
#> 
```
