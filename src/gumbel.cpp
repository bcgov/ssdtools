#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector dgumbel_cpp(NumericVector x, NumericVector location, 
                          NumericVector scale, bool log_cpp) {
  NumericVector z = (x - location) / scale;
  NumericVector log_d = -z - exp(-z) - log(scale);
  if(log_cpp) return log_d;
  return exp(log_d);
}

// [[Rcpp::export]]
NumericVector pgumbel_cpp(NumericVector q, NumericVector location, 
                          NumericVector scale) {
  NumericVector p = exp(-exp(-(q - location)/scale));
  return p;
}

// [[Rcpp::export]]
NumericVector qgumbel_cpp(NumericVector p, NumericVector location, 
                          NumericVector scale) {
  NumericVector q = location - scale * log(-log(p));
  return q;
}

// [[Rcpp::export]]
NumericVector rgumbel_cpp(int n, NumericVector location, NumericVector scale) {
  NumericVector r = location - scale * log(-log(runif(n)));
  r[scale <= 0] = R_NaN;
  return r;
}

/*** R
dgumbel_cpp(c(31, 15, 32, 32, 642, 778, 187, 12), 0, 1)
pgumbel_cpp(c(0.5), 0, 1)
qgumbel_cpp(c(0.5), 0, 1)
rgumbel_cpp(0, 1)
*/
