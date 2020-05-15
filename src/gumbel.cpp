#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector dgumbel_cpp(NumericVector x, double location, double scale) {
  NumericVector z = (x - location) / scale;
  NumericVector log_d = -z - exp(-z) - log(scale);
  return exp(log_d);
}

// [[Rcpp::export]]
NumericVector qgumbel_cpp(NumericVector p, double location, double scale) {
  NumericVector q = location - scale * log(-log(p));
  return q;
}

/*** R
dgumbel_cpp(c(31, 15, 32, 32, 642, 778, 187, 12), 0, 1)
qgumbel_cpp(c(0.5), 0, 1)
*/

