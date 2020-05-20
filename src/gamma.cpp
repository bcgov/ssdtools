#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double dgamma_ssd(double x, double shape, 
                   double scale, bool log_ssd) {
  if(shape <= 0) return R_NaN;
  if(scale <= 0) return R_NaN;
  return R::dgamma(x, shape, scale, log_ssd);
}
