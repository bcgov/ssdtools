#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector dgumbel_cpp(NumericVector x, double location = 0, double scale = 1) {
  NumericVector z = (x - location) / scale;
  NumericVector log_fx = -z - exp(-z) - log(scale);
  return exp(log_fx);
}

// [[Rcpp::export]]
NumericVector qgumbel_cpp(NumericVector p, NumericVector location, NumericVector scale) {
  NumericVector q = location - scale * log(-log(p));
  return q;
}

/*** R
dgumbel_cpp(c(31, 15, 32, 32, 642, 778, 187, 12))
qgumbel_cpp(c(0.5))
*/

