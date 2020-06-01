#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double dburrXII_ssd(double x, double shape1, double shape2, double scale) {
  if(shape1 <= 0) return R_NaN;
  if(shape2 <= 0) return R_NaN;
  if(scale <= 0) return R_NaN;
  if(x <= 0) return(R_NegInf);
  return log((shape1 * shape2 * pow(x/scale, shape2))/(x * pow((1 + pow(x/scale, shape2)), shape1 + 1)));
}

// [[Rcpp::export]]
double pburrXII_ssd(double q, double shape1, double shape2, double scale) {
  if(shape1 <= 0) return R_NaN;
  if(shape2 <= 0) return R_NaN;
  if(scale <= 0) return R_NaN;
  if(q <= 0) return(0);
  
  return pow(exp(-log1pexp(shape2 * (log(q) - log(scale)))), shape1);
}

// [[Rcpp::export]]
double qburrXII_ssd(double p, double shape1, double shape2, double scale) {
  if(shape1 <= 0) return R_NaN;
  if(shape2 <= 0) return R_NaN;
  if(scale <= 0) return R_NaN;
  return scale * pow(pow(p, -1.0/shape1) - 1.0, 1.0/shape2);
}

// [[Rcpp::export]]
NumericVector rburrXII_ssd(int n, double shape1, double shape2, double scale) {
  if(shape1 <= 0) {
    NumericVector v (n, R_NaN);
    return v;
  }
  if(shape2 <= 0) {
    NumericVector v (n, R_NaN);
    return v;
  }
  if(scale <= 0) {
    NumericVector v (n, R_NaN);
    return v;
  }
  NumericVector p = Rcpp::runif(n);
  return scale * pow(pow(p, -1.0/shape1) - 1.0, 1.0/shape2);
}
