#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double dlogis_ssd(double x, double location, double scale) {
  if(scale <= 0) return R_NaN;
  return R::dlogis(x, location, scale, true);
}

// [[Rcpp::export]]
double plogis_ssd(double q, double location, double scale) {
  if(scale <= 0) return R_NaN;
  return R::plogis(q, location, scale, true, false);
}

// [[Rcpp::export]]
double qlogis_ssd(double p, double location, double scale) {
  if(scale <= 0) return R_NaN;
  return R::qlogis(p, location, scale, true, false);
}

// [[Rcpp::export]]
NumericVector rlogis_ssd(int n, double location, double scale) {
  if(scale <= 0) {
    NumericVector v (n, R_NaN);
    return v;
  }
  return Rcpp::rlogis(n, location, scale);
}
