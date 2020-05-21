#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double dlnorm_ssd(double x, double meanlog, double sdlog) {
  if(sdlog <= 0) return R_NaN;
  return R::dlnorm(x, meanlog, sdlog, true);
}

// [[Rcpp::export]]
double plnorm_ssd(double q, double meanlog, double sdlog) {
  if(sdlog <= 0) return R_NaN;
  return R::plnorm(q, meanlog, sdlog, true, false);
}

// [[Rcpp::export]]
double qlnorm_ssd(double p, double meanlog, double sdlog) {
  if(sdlog <= 0) return R_NaN;
  return R::qlnorm(p, meanlog, sdlog, true, false);
}

// [[Rcpp::export]]
NumericVector rlnorm_ssd(int n, double meanlog, double sdlog) {
  if(sdlog <= 0) {
    NumericVector v (n, R_NaN);
    return v;
  }
  return Rcpp::rlnorm(n, meanlog, sdlog);
}
