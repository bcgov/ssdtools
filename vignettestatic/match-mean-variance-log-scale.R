#  Solve for the parameter values for a function to match the mean and variance on the log-scale using BFI

library(tidyverse)
library(plyr)


match.moments.logscale <- function(mean.log, sd.log, dist.base, ival.log=c(1,0), nsim=100000){
   # match the moments computed using simulation to estimate the mean and variance on the log-scale
   # this assumes that the dist.base has two parameters
  
   discrep <- function(par, dist.base, mean.log, sd.log, nsim){
      # evalute the sum of squares of discrepancies between the mean and sd on log-scale for optimization 
      # random number generator for values on the concentration (i.e. anti-log scale)
      # we assume that the parameter estimates are on the log-scale so if using log-normal etc set the mean to 2 on the log-scale
      rfunc <- paste("ssd_r", dist.base, sep="")
      rv <- do.call(rfunc, list(nsim, exp(par[1]), exp(par[2])))
      omean.log <- mean(log(rv), na.rm=TRUE) # oberved mean and variance
      osd.log   <- sd  (log(rv), na.rm=TRUE)
      discrep <- (mean.log - omean.log)^2 + (sd.log - osd.log)^2 # discrepance
      discrep
   }
   #browser()
   fit <- optim( ival.log, discrep, dist.base=dist.base, mean.log=mean.log, sd.log=sd.log, nsim=nsim, control=list(abstol=.01))
   list(dist.base=dist.base, fit=fit)
}

# test for log-normal
fit <- match.moments.logscale(2, 1, "lnorm", log(c(2,1)) )

fit$fit$par
exp(fit$fit$par)
test.rv <- rlnorm(1000000, exp(fit$fit$par[1]), exp(fit$fit$par[2]))
mean(log(test.rv))
sd(log(test.rv))




# set up list of distributions and initial values for parameters based on pure guesses
# based on previous runs to match a mean.log=2, sd.log=1 
test.dist.csv <- textConnection(
"dist.base, iv1, iv2
lgumbel,  1.5, .8
lnorm,    2,   1
gamma,    1.4,.1") 

test.dist <- read.csv(test.dist.csv, as.is=TRUE)

# do the empirical matching
mean.log <- 2
sd.log <- 1

match <- plyr::alply(test.dist, 1, function(x, mean.log, sd.log, nsim=1000000){
   cat("*** starting to fit ***", x$dist.base, "\n")
   # notice we pass the log(initial values) to the match.moments.
   fit <- match.moments.logscale(mean.log, sd.log, x$dist.base, ival=log(c(x$iv1, x$iv2)), nsim=nsim)
   cat(fit$fit$par, exp(fit$fit$par), "\n")
   fit
  
}, mean.log=mean.log, sd.log=sd.log)


# extract parmeter values from match and find empirical mean and sd on the log scale for the given parameters
res <- plyr::ldply(match, function(x, nsim=1000000){
   #browser()
   base.dist <- x$dist.base
   lpar <- x$fit$par
   par  <- exp(lpar)
   rv <- do.call(paste0("ssd_r",base.dist), list(nsim, par[1], par[2]))
   omean.log <- mean(log(rv), na.rm=TRUE)
   osd.log   <- sd  (log(rv), na.rm=TRUE)
   data.frame(base.dist,  lpar[1], lpar[2], par[1], par[2], omean.log, osd.log)
})
res

# Plot the cumulative distribution on the log(Concentration) scale
plotdata <- plyr::ddply(res, "dist.base", function(x){
    logC <- seq(-3,7,.01)
    cdf  <- do.call( paste0("p",x$dist.base), list(exp(logC), x$par.1., x$par.2.))
    data.frame(logC=logC, cdf=cdf)
})

ggplot(data=plotdata, aes(x=logC, y=cdf, color=dist.base))+
   ggtitle("Comparing cdfs for dist with same mean and sd on the log-scale")+
   geom_line()

