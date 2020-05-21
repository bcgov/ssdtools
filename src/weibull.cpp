#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double dweibull_ssd(double x, double shape, double scale) {
  if(shape <= 0) return R_NaN;
  if(scale <= 0) return R_NaN;
  return R::dweibull(x, shape, scale, true);
}

// [[Rcpp::export]]
double pweibull_ssd(double q, double shape, double scale) {
  if(shape <= 0) return R_NaN;
  if(scale <= 0) return R_NaN;
  return R::pweibull(q, shape, scale, true, false);
}

// [[Rcpp::export]]
double qweibull_ssd(double p, double shape, double scale) {
  if(shape <= 0) return R_NaN;
  if(scale <= 0) return R_NaN;
  return R::qweibull(p, shape, scale, true, false);
}

// [[Rcpp::export]]
NumericVector rweibull_ssd(int n, double shape, double scale) {
  if(shape <= 0) {
    NumericVector v (n, R_NaN);
    return v;
  }
  if(scale <= 0) {
    NumericVector v (n, R_NaN);
    return v;
  }
  return Rcpp::rweibull(n, shape, scale);
}
