#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double dgumbel_cpp(double x, double location, 
                          double scale, bool log_cpp) {
  if(scale <= 0) return R_NaN;
  
  double z = (x - location) / scale;
  double log_d = -z - exp(-z) - log(scale);
  if(log_cpp) return log_d;
  return exp(log_d);
}

// [[Rcpp::export]]
double pgumbel_cpp(double q, double location, 
                          double scale) {
  if(scale <= 0) return R_NaN;
  double p = exp(-exp(-(q - location)/scale));
  return p;
}

// [[Rcpp::export]]
double qgumbel_cpp(double p, double location, 
                          double scale) {
  if(scale <= 0) return R_NaN;
  double q = location - scale * log(-log(p));
  return q;
}

// [[Rcpp::export]]
NumericVector rgumbel_cpp(int n, double location, double scale) {
  if(scale <= 0) {
    NumericVector v (n, R_NaN);
    return v;
  }
  NumericVector r = location - scale * log(-log(runif(n)));
  return r;
}

/*** R
dgumbel_cpp(c(31, 15, 32, 32, 642, 778, 187, 12), 0, 1)
pgumbel_cpp(c(0.5), 0, 1)
qgumbel_cpp(c(0.5), 0, 1)
rgumbel_cpp(0, 1)
*/

