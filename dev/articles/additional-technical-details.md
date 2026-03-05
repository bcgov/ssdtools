# Additional Technical Details

## Small sample bias

The ssdtools package uses the method of Maximum Likelihood (ML) to
estimate parameters for each distribution that is fit to the data.
Statistical theory says that maximum likelihood estimators are
asymptotically unbiased, but does not guarantee performance in small
samples. A detailed account of the issue of small sample bias in
estimates can be found in the small sample size vignette.

## Investigations into setting minimum sample sizes for uni-modal and bi-modal distributions in ssdtools

Most jurisdictions require a minimum sample size for fitting a valid
SSD. The current Australian and New Zealand minimum is 5, in order to
fit the two-parameter log-normal distribution (Warne et al. 2018). In
ssdtools the default minimum sample size is 6 (Thorley and Schwarz
2018), which is consistent with the current methodology for British
Columbia (BC Ministry of Environment and Climate Change Strategy 2019).

Here we report on a series of simulation studies designed to inform a
final decision on the default minimum sample size to adopt for both the
uni-modal 2 parameter distributions, as well as the bi-modal 5 parameter
distributions.

### Bias and CI coverage and interval width

#### Simulations based on ssddata

We used the example datasets in the
[`ssddata`](https://github.com/open-AIMS/ssddata) package in R (Fisher
and Thorley 2021) to undertake a simulation study to examine bias,
coverage and confidence interval (CI) widths using the recommended
default set of six distributions (lognormal, log-Gumbel, log-logistic,
gamma, Weibull, and the lognormal-log-normal mixture), with model
averaged estimates obtained using the multi-method, and confidence
intervals estimated using the recommended weighted sample bootstrap
method (see D. R. Fox et al. (2024)). A total of 20 unique datasets were
extracted from ssddata and used to define the parameters for the
simulation study as follows:

1.  Each dataset was extracted from `ssddata` and fit using the default
    distribution set as recommended in (D. Fox et al. 2022) and (D. R.
    Fox et al. 2024).
2.  Of the six default distributions, the parameters for the
    distribution having the highest weight for each dataset was used to
    generate new random datasets of varying values of N, including (but
    not limited to): 5 (current ANZG minimum), 6 (current BC minimum),
    and 8 (current ANZG preferred).
3.  For each randomly generated dataset, `ssdtools` was used to re-fit
    the data, and model averaged estimates were obtained using the
    multi-method, with upper and lower confidence limits (CLs) produced
    using the recommended weighted sample method (see [Confidence
    Intervals for Hazard
    Concentrations](https://bcgov.github.io/ssdtools/articles/confidence-intervals.html)
    vignette).

The individual ssdtools fits are shown below for each of the 20
simulation datasets from ssddata, for the six recommended default
distributions, as well as the model averaged CDF (black line):

![An aggregate plot of all the 20 datasets from ssddata, showing how the
six recommended default distributions fit to each, as well as the model
averaged fit.](images/fitted_dists.png)  

This simulation process was repeated a minimum of 1,000 times for each
dataset, and the results collated across all iterations. For each
simulated dataset the true HCx values were obtained directly from the
parameter estimates of from data generating distribution. From these,
relative bias was calculated as the scaled-difference between the
estimated HCx values and the true HCx value, i.e
$$\frac{\widehat{HC}x - HCx}{HCx}$$ where $\widehat{HC}x$ is the
estimate of the true value, $HCx$; coverage was calculated as the
proportion of simulations where the true $HCx$ value fell within the
lower and upper 95% confidence limits; and the scaled confidence
interval width was calculated as $$\frac{UL - LL}{HCx}$$ where $UL$ and
$LL$ are the upper and lower limits respectively.

Bias, confidence interval width and coverage as a function of sample
size across ~1000 simulations of 20 datasets using the multi model
averaging method and the weighted sample method for estimating
confidence intervals via ssdtools are shown below:

![An aggregate plot showing how bias and confidence interval width
decrease, and coverage increases as the number of data points in the SSD
increases. The first three bars are colored to highlight that the
biggest changes are from five to six and then seven data
points.](images/ssdata_sims_collated.png)  

The simulation results showed significant gains in terms of reduced bias
from N=5 to N=6, as well as in coverage, which improved substantially
between N=5 and N=6. There is also a small additional gain in coverage
at N=7, where the median of the simulations reaches the expected 95% but
this is only the case for HC1.

#### Simulations based on EnviroTox

In addition to the analysis based on the 20 ssddata example datasets, we
also ran an expanded simulation study based on the EnviroTox dataset
analysed by Yanagihara et al. (2024). Combined with the ssddata
examples, this includes a total of 353 example datasets to use as case
studies. Using this larger dataset as a basis for simulations, we
followed the same procedure as described above to examine relative bias,
as well as changes in the AICc weights (see below) for various sample
sizes. Estimates of coverage and confidence interval widths were not
obtained for this larger dataset due to the computationally intensive
bootstrap method of obtaining confidence intervals.

Bias of sample size across ~1000 simulations of 353 datasets using the
multi model averaging method via ssdtools, for HC5, 10 and 20 (0.05,
0.1, and 0.2) are shown below:

![An aggregate plot showing how bias increases as the number of data
points in the SSD increases. Columns are for different proportions of
the community potentially effected. The biggest changes are for 5% of
the community effected. Data generated from a Gamma distribution show
the greatest bias, followed by the Weibull and then the
lognormal-lognormal mixture distribution.](images/all_sims_bias.png)  

Note that simulation results are shown separately for those derived from
each of the six distributions as the underlying source data generating
distribution.

The bias results for this larger combined dataset did not show the same
level of improvement from N=5 to N=6 as that based on the smaller
ssddata simulation. However, there as a gradual improvement in bias with
increasing N. There is no strong evidence for preferring N=6 over N=7 in
the context of bias from either of the simulation studies. We note that
the bias was highest at these small sample sizes for data generated
using a gamma distribution, likely reflecting the extreme left-tailed
nature of this distribution.

### AICc based model weights

Aside from considerations of bias, coverage and confidence interval
width, it is also prudent to examine how the weights of the different
distributions changed with sample size, for data generated using the six
different default distributions, to more fully investigate sample size
issues associated with the use of the mixture distributions. This was
examined using the simulation study across the larger combined ssddata
and EnviroTox datasets (353 datasets) to ensure a wide range of
potential representations of each of the six default distributions was
considered.

Below is a plot of the mean AICc weights as a function of sample size
(N) obtained for data simulated using the best fit distribution to 353
datasets. Results are shown separately for the six different source
distributions, with the upper plot (A) showing the AICc weight of the
source (data generating) distributions, when fit using the default set
of six distributions using ssdtools; and the lower plot (B) showing the
AICc weight of the lognormal-lognormal mixture distribution for each of
the source (data generating) distributions.

![A two panel plot, with both showing how AICc based weights increase as
the number of data points in the SSD increases. The top panel shows that
when there is a large enough sample size the AICc weights for the true
source distribution are high. The bottom panel shows the weights for the
lognormal-lognormal mixture distribution and highlights that these
remain low except when the lognormal-lognormal mixture is the source
distribution.](images/weights_collated.png)  

We found that the AICc weights for the five unimodal distributions were
relatively similar (~0.2) for very low N. This is because for small N it
is difficult to discern differences between the distributions in the
candidate list. The weights increase to above 0.5 as N increases
(i.e. their converge to the true underlying generating distribution at
high N, upper plot). For very low sample sizes (N=5, 6 or 7) the source
(data-generating) distribution is not preferentially weighted by the
AICc (upper plot, A).

For the lnorm_lnorm mixture, AICc weights can be \>0.5 at relatively N
(\>8, lower plot, B). We also looked specifically at the AICc weight of
the lognormal-lognormal mixture as one of six distributions in the
default candidate set, across simulation based on all six source
generating distributions. This was done to examine the potential for
erroneously highly weighting the lognormal-lognormal mixture
distribution by chance, when data are generated instead using one of the
five unimodal distributions. For all the unimodal source distributions
the lognormal-lognormal mixture never has high AICc weight, even at very
high sample sizes (N=256, lower plot, B). The AICc weights are
particularly low for the lnorm_lnorm mixture at low sample sizes for all
the uni-modal source distributions (a desirable property) (lower plot,
B).

### Conclusions

Overall, the results suggest that (relative) bias as a function of N
behaves as expected. The N=6 recommendation appears to be well-supported
as coverage is particularly low for N=5, but acceptable for N=6. The
lognormal-lognormal mixture AICc weights suggest that this distribution
will only be preferred (i.e. have a high AICc weight) when (i) there is
clear evidence of bimodality in the source data; and (ii) large N.

Based on these results, our recommendation is that only a single minimum
sample size of N=6 be adopted (for both unimodal and bimodal), since our
results suggest any gains in increasing this to 7 are minimal.

## The inverse Pareto and inverse Weibull as limiting distributions of the Burr Type-III distribution

### Burr III distribution

The probability density function, $f_{X}(x;b,c,k)$ and cumulative
distribution function, $F_{X}(x;b,c,k)$ for the Burr III distribution
(also known as the *Dagum* distribution) as used in `ssdtools` are

***Burr III Distribution***

$$f_{X}(x;b,c,k) = \frac{b\, k\, c}{x^{2}}\frac{\left( \frac{b}{x} \right)^{c - 1}}{\left\lbrack 1 + \left( \frac{b}{x} \right)^{c} \right\rbrack^{k + 1}},\quad b,c,k,x > 0$$

$$F_{X}(x;b,c,k) = \frac{1}{\left\lbrack 1 + \left( \frac{b}{x} \right)^{c} \right\rbrack^{k}},\quad b,c,k,x > 0$$

  

### Inverse Pareto distribution

Let $X \sim Burr(b,c,k)$ have the *pdf* given in the box above. It is
well known that the distribution of $Y = \frac{1}{X}$ is the *inverse
Burr* distribution (also known as the *SinghMaddala* distribution) for
which

\$\$ \begin{array}{\*{20}{c}} {{f_Y}(y;b,c,k) = \frac{{c{\kern 1pt}
{\kern 1pt} k{{\left( {\frac{y}{b}} \right)}^c}}}{{y{\kern 1pt}
{{\left\[ {1 + {{\left( {\frac{y}{b}} \right)}^c}} \right\]}^{k +
1}}}}}, & {b,c,k,y \> 0} \end{array} \$\$

$$\begin{matrix}
{{F_{Y}(y;b,c,k) = 1 - \frac{1}{\left\lbrack 1 + \left( \frac{y}{b} \right)^{c} \right\rbrack^{k}}},} & {b,c,k,y > 0}
\end{matrix}$$

We now consider the limiting distribution when
$\left. c\rightarrow\infty \right.$ and $\left. k\rightarrow 0 \right.$
in such a way that the product $ck$ remains constant,
i.e. $ck = \lambda$.

Now, $$\begin{array}{l}
{\operatorname{}\limits_{ck = \lambda}\left\{ F_{Y}(y;b,c,k) \right\} = 1 - \operatorname{}\limits_{ck = \lambda}\frac{1}{\left\lbrack 1 + \left( \frac{y}{b} \right)^{c} \right\rbrack^{k}}} \\
 \\
\text{and} \\
 \\
{\operatorname{}\limits_{ck = \lambda}\left\lbrack 1 + \left( \frac{y}{b} \right)^{c} \right\rbrack^{k} = \operatorname{}\limits_{ck = \lambda}\left\{ \left( \frac{y}{b} \right)^{ck}\left\lbrack 1 + \left( \frac{b}{y} \right)^{c} \right\rbrack^{k} \right\}} \\
 \\
\text{and} \\
 \\
{\operatorname{}\limits_{ck = \lambda}\left\{ \left( \frac{y}{b} \right)^{ck}\left\lbrack 1 + \left( \frac{b}{y} \right)^{c} \right\rbrack^{k} \right\} = \operatorname{}\limits_{ck = \lambda}\left\{ \left( \frac{y}{b} \right)^{ck} \right\}\operatorname{}\limits_{ck = \lambda}\left\{ \left\lbrack 1 + \left( \frac{b}{y} \right)^{c} \right\rbrack^{k} \right\}} \\
{= \operatorname{}\limits_{ck = \lambda}\left\{ \left( \frac{y}{b} \right)^{ck} \right\}\; \cdot \, 1} \\
{= \left( \frac{y}{b} \right)^{\lambda}}
\end{array}$$

Therefore, $$\begin{matrix}
{\operatorname{}\limits_{ck = \lambda}\left\{ F_{Y}(y;b,c,k) \right\} = 1 - \left( \frac{b}{y} \right)^{\lambda}} & {y \geq b}
\end{matrix}$$

which we recognise as the (American) Pareto distribution. So, if the
limiting distribution of $Y = \frac{1}{X}$ is a Pareto distribution,
then the limiting distribution of $X = \frac{1}{Y}$ is the (American)
*inverse Pareto* distribution

\$\$ \begin{array}{l} {f_X}\left( {x;\alpha ,\beta } \right) = \lambda
{b^\lambda }{x^{\lambda - 1}};{\rm{ }}0 \le x \le {\textstyle{1 \over
b}};{\rm{ }}\lambda {\rm{,}}b \> 0 \\ {F_X}\left( {x;\alpha ,\beta }
\right) = {\left( {xb} \right)^\lambda };{\rm{ }}0 \le x \le
{\textstyle{1 \over b}};{\rm{ }}\lambda {\rm{,}}b \> 0 \end{array} \$\$

For completeness, the MLEs of this distribution have closed-form
expressions and are given by

$$\begin{array}{l}
{\widehat{\lambda} = \left\lbrack \ln\left( \frac{g_{X}}{\widehat{b}} \right) \right\rbrack^{- 1}} \\
{\widehat{b} = \frac{1}{\max\{ X_{i}\}}}
\end{array}$$

and \$\rm{g_X}\$ is the *geometric mean* of the data.

### Inverse Weibull distribution

Let $X \sim \text{Burr}(b,c,k)$ have the *pdf* given in the box above.
We make the transformation $Y = \frac{bk^{\frac{1}{c}}\theta}{X}$, where
$\theta$ is a parameter (constant). The distribution of $Y$ is also a
Burr distribution and has *cdf*

$$G_{Y}(y) = 1 - \frac{1}{\left\lbrack 1 + \left( \frac{y}{k^{\frac{1}{c}}\theta} \right)^{c} \right\rbrack^{k}}.$$

We are interested in the limiting behavior of this Burr distribution as
$\left. k\rightarrow\infty \right.$.

Now,

$$\lim\limits_{k\rightarrow\infty}G_{Y}(y) = 1 - \lim\limits_{k\rightarrow\infty}\left\lbrack 1 + \left( \frac{y}{k^{\frac{1}{c}}\theta} \right)^{c} \right\rbrack^{- k}.$$

$$= 1 - \lim\limits_{k\rightarrow\infty}\left\lbrack 1 + \frac{\left( \frac{y}{\theta} \right)^{c}}{k} \right\rbrack^{- k}.$$

$$= 1 - \exp\left\lbrack - \left( \frac{y}{\theta} \right)^{c} \right\rbrack,$$

$$\left\{ {\text{using the fact that}\mspace{6mu}}\lim\limits_{n\rightarrow\infty}\left( 1 + \frac{z}{n} \right)^{- n} = e^{- z} \right\}.$$

We recognize the last expression as the *cdf* of a Weibull distribution
with parameters $c$ and $\theta$.

## References

BC Ministry of Environment and Climate Change Strategy. 2019.
*Derivation of Water Quality Guidelines for the Protection of Aquatic
Life in British Columbia. Water Quality Guideline Series, WQG‐06.*
Province of British Columbia, Victoria, BC, Canada.
<https://www2.gov.bc.ca/assets/gov/environment/air-land-water/water/waterquality/water-quality-guidelines/derivation-protocol/bc_wqg_aquatic_life_derivation_protocol.pdf>.

Fisher, Rebecca, and Joe Thorley. 2021. *Ssddata: Species Sensitivity
Distribution Data*. <https://CRAN.R-project.org/package=ssddata>.

Fox, David R, Rebecca Fisher, Thorley, and Joseph L. 2024. “Final Report
of the Joint Investigation into SSD Modelling and Ssdtools
Implementation for the Derivation of Toxicant Guidelines Values in
Australia and New Zealand.” Environmetrics Australia; Australian
Institute of Marine Science. <https://doi.org/10.25845/xtvt-yc51>.

Fox, DR, R Fisher, JL Thorley, and C Schwarz. 2022. “Joint Investigation
into statistical methodologies Underpinning the derivation of toxicant
guideline values in Australia and New Zealand.” Environmetrics
Australia; Australian Institute of Marine Science.
<https://doi.org/10.25845/fm9b-7n28>.

Thorley, Joe, and Carl Schwarz. 2018. “Ssdtools: An r Package to Fit
Species Sensitivity Distributions.” *Journal of Open Source Software* 3
(31). <https://joss.theoj.org/papers/10.21105/joss.01082>.

Warne, M, GE Batley, RA van Dam, JC Chapman, DR Fox, CW Hickey, and JL
Stauber. 2018. “Revised Method for Deriving Australian and New Zealand
Water Quality Guideline Values for Toxicants – Update of 2015 Version.”
Journal Article. *Prepared for the Revision of the Australian and New
Zealand Guidelines for Fresh and Marine Water Quality. Australian and
New Zealand Governments and Australian State and Territory Governments,
Canberra, 48 Pp*.

## Licensing

Copyright 2015-2023 Province of British Columbia  
Copyright 2021 Environment and Climate Change Canada  
Copyright 2023-2025 Australian Government Department of Climate Change,
Energy, the Environment and Water

The documentation is released under the [CC BY 4.0
License](https://creativecommons.org/licenses/by/4.0/)

The code is released under the [Apache License
2.0](https://www.apache.org/licenses/LICENSE-2.0)
