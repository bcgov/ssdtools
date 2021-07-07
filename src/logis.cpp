#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double plogis_dummy(double q, double location, double scale) {
  if(scale <= 0) return R_NaN;
  return R::plogis(q, location, scale, true, false);
}
