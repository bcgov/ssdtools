#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double dburrIII3_ssd(double x, double shape1, double shape2, double scale) {
  if(shape1 <= 0) return R_NaN;
  if(shape2 <= 0) return R_NaN;
  if(scale <= 0) return R_NaN;
  if(x <= 0) return(R_NegInf);
  return log(shape1) + log(shape2) + log(x) * -(shape2 + 1) + log(1 + scale * pow(x, -shape2)) * -(shape1 / scale + 1);   
}

// [[Rcpp::export]]
double pburrIII3_ssd(double q, double shape1, double shape2, double scale) {
  if(shape1 <= 0) return R_NaN;
  if(shape2 <= 0) return R_NaN;
  if(scale <= 0) return R_NaN;
  if(q <= 0) return(0);
  return pow(1 + scale * pow(q, -shape2), -shape1 / scale);
}

// [[Rcpp::export]]
double qburrIII3_ssd(double p, double shape1, double shape2, double scale) {
  if(shape1 <= 0) return R_NaN;
  if(shape2 <= 0) return R_NaN;
  if(scale <= 0) return R_NaN;
  return pow((pow(p, -scale/shape1) - 1) / scale,  -1/shape2);
}

// [[Rcpp::export]]
NumericVector rburrIII3_ssd(int n, double shape1, double shape2, double scale) {
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
  return pow((pow(p, -scale/shape1) - 1) / scale, -1/shape2);
}
