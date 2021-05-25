#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double pgamma_ssd(double q, double shape, double scale) {
  if(shape <= 0) return R_NaN;
  if(scale <= 0) return R_NaN;
  return R::pgamma(q, shape, scale, true, false);
}

// [[Rcpp::export]]
double qgamma_ssd(double p, double shape, double scale) {
  if(shape <= 0) return R_NaN;
  if(scale <= 0) return R_NaN;
  return R::qgamma(p, shape, scale, true, false);
}

// [[Rcpp::export]]
NumericVector rgamma_ssd(int n, double shape, double scale) {
  if(shape <= 0) {
    NumericVector v (n, R_NaN);
    return v;
  }
  if(scale <= 0) {
    NumericVector v (n, R_NaN);
    return v;
  }
  return Rcpp::rgamma(n, shape, scale);
}
