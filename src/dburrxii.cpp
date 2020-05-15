#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector dburrXII_(NumericVector x, double shape1 = 1, double shape2 = 1, double scale = 2.718282, bool log_ = false) {
  NumericVector fx = (shape1 * shape2 * pow(x/scale, shape2))/(x * pow((1 + pow(x/scale, shape2)), shape1 + 1));
  if(log_) return log(fx);
  return fx;
}

/*** R
dburrXII_(c(31, 15, 32, 32, 642, 778, 187, 12), scale = 1)
*/

