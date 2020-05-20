#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double dgamma_ssd(double x, double shape, 
                   double scale, bool log_ssd) {
  if(shape <= 0) return R_NaN;
  if(scale <= 0) return R_NaN;
  return R::dgamma(x, shape, scale, log_ssd);
}

// [[Rcpp::export]]
double pgamma_ssd(double q, double shape, 
                  double scale) {
  if(shape <= 0) return R_NaN;
  if(scale <= 0) return R_NaN;
  return R::pgamma(q, shape, scale, true, false);
}

// [[Rcpp::export]]
double qgamma_ssd(double p, double shape, 
                  double scale) {
  if(shape <= 0) return R_NaN;
  if(scale <= 0) return R_NaN;
  return R::qgamma(p, shape, scale, true, false);
}