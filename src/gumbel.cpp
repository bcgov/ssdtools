#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector dgumbel_cpp(NumericVector x, double location = 0, double scale = 1, bool log_cpp = false) {
  NumericVector z = (x - location) / scale;
  NumericVector log_fx = -z - exp(-z) - log(scale);
  if(log_cpp) return log_fx;
  return exp(log_fx);
}

/*** R
dgumbel_(c(31, 15, 32, 32, 642, 778, 187, 12))
*/

