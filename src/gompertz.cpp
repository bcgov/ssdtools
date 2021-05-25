#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double pgompertz_ssd(double q, double location, double shape) {
  if(location <= 0) return R_NaN;
  if(shape <= 0) return R_NaN;
  return 1 - exp(-location/shape * (exp(q * shape) - 1));
}

// [[Rcpp::export]]
double qgompertz_ssd(double p, double location, double shape) {
  if(location <= 0) return R_NaN;
  if(shape <= 0) return R_NaN;
  return log(1 - shape/location * log(1-p)) / shape;
}

// [[Rcpp::export]]
NumericVector rgompertz_ssd(int n, double location, double shape) {
  if(location <= 0) {
    NumericVector v (n, R_NaN);
    return v;
  }
  if(shape <= 0) {
    NumericVector v (n, R_NaN);
    return v;
  }
  NumericVector p = Rcpp::runif(n);
  return log(1 - shape/location * log(1-p)) / shape;
}
