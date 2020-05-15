// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

// dburrXII_
NumericVector dburrXII_(NumericVector x, double shape1, double shape2, double scale, bool log_);
RcppExport SEXP _ssdtools_dburrXII_(SEXP xSEXP, SEXP shape1SEXP, SEXP shape2SEXP, SEXP scaleSEXP, SEXP log_SEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericVector >::type x(xSEXP);
    Rcpp::traits::input_parameter< double >::type shape1(shape1SEXP);
    Rcpp::traits::input_parameter< double >::type shape2(shape2SEXP);
    Rcpp::traits::input_parameter< double >::type scale(scaleSEXP);
    Rcpp::traits::input_parameter< bool >::type log_(log_SEXP);
    rcpp_result_gen = Rcpp::wrap(dburrXII_(x, shape1, shape2, scale, log_));
    return rcpp_result_gen;
END_RCPP
}
// dgumbel_
NumericVector dgumbel_(NumericVector x, double location, double scale, bool log_);
RcppExport SEXP _ssdtools_dgumbel_(SEXP xSEXP, SEXP locationSEXP, SEXP scaleSEXP, SEXP log_SEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericVector >::type x(xSEXP);
    Rcpp::traits::input_parameter< double >::type location(locationSEXP);
    Rcpp::traits::input_parameter< double >::type scale(scaleSEXP);
    Rcpp::traits::input_parameter< bool >::type log_(log_SEXP);
    rcpp_result_gen = Rcpp::wrap(dgumbel_(x, location, scale, log_));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_ssdtools_dburrXII_", (DL_FUNC) &_ssdtools_dburrXII_, 5},
    {"_ssdtools_dgumbel_", (DL_FUNC) &_ssdtools_dgumbel_, 4},
    {NULL, NULL, 0}
};

RcppExport void R_init_ssdtools(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
