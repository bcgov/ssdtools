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
