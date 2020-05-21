#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double dgumbel_ssd(double x, double location, 
                          double scale) {
  if(scale <= 0) return R_NaN;
  
  double z = (x - location) / scale;
  double d = -z - exp(-z) - log(scale);
  return d;
}

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

/*** R
dgumbel_ssd(c(31, 15, 32, 32, 642, 778, 187, 12), 0, 1)
pgumbel_ssd(c(0.5), 0, 1)
qgumbel_ssd(c(0.5), 0, 1)
rgumbel_ssd(0, 1)
*/

