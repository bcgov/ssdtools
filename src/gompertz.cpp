#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double dgompertz_ssd(double x, double location, double shape) {
  if(location <= 0) return R_NaN;
  if(shape <= 0) return R_NaN;
  return log(location) + x * shape - (location/shape) * (exp(x * shape) - 1);
}
