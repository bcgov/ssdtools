#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double pgumbel_ssd(double q, double location, 
                          double scale) {
  if(scale <= 0) return R_NaN;
  double p = exp(-exp(-(q - location)/scale));
  return p;
}

// [[Rcpp::export]]
double qgumbel_ssd(double p, double location, 
                          double scale) {
  if(scale <= 0) return R_NaN;
  double q = location - scale * log(-log(p));
  return q;
}

// [[Rcpp::export]]
NumericVector rgumbel_ssd(int n, double location, double scale) {
  if(scale <= 0) {
    NumericVector v (n, R_NaN);
    return v;
  }
  NumericVector r = location - scale * log(-log(runif(n)));
  return r;
}
