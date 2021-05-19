#define TMB_LIB_INIT R_init_ssdtools_TMBExports

#include <TMB.hpp>
#include <fenv.h> // Extra line needed to detect under/overflow in burrrIII3

#include "ll_burrIII3.hpp"
#include "ll_gamma.hpp"
#include "ll_gompertz.hpp"
#include "ll_gumbel.hpp"
#include "ll_invpareto.hpp"
#include "ll_invweibull.hpp"
#include "ll_lgumbel.hpp"
#include "ll_llogis.hpp"
#include "ll_lnorm.hpp"
#include "ll_mx_llogis_llogis.hpp"
#include "ll_norm.hpp"
#include "ll_weibull.hpp"

template<class Type>
Type objective_function<Type>::operator() () {
  DATA_STRING(model);
  if (model == "ll_burrIII3") {
    return ll_burrIII3(this);
  }  if (model == "ll_gamma") {
    return ll_gamma(this);
  } else if (model == "ll_gompertz") {
    return ll_gompertz(this);
  } else if (model == "ll_lgumbel") {
    return ll_lgumbel(this);
  } else if (model == "ll_llogis") {
    return ll_llogis(this);
  } else if (model == "ll_mx_llogis_llogis") {
    return ll_mx_llogis_llogis(this);
  } else if(model == "ll_lnorm") {
    return ll_lnorm(this);
  } else if(model == "ll_weibull") {
    return ll_weibull(this);
  } else {
    error("Unknown model.");
  }
  return 0;
}
