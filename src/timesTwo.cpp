#include <Rcpp.h>
using namespace Rcpp;

//' Multiply a number by two
//' 
//' @param x A single integer.
//' @export
// [[Rcpp::export]]
NumericVector timesTwo(NumericVector x) {
  return x * 2;
}

/*** R
timesTwo(42)
*/
