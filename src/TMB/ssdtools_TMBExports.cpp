//    Copyright 2023 Environment and Climate Change Canada

//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at

//       https://www.apache.org/licenses/LICENSE-2.0

//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.

#define TMB_LIB_INIT R_init_ssdtools_TMBExports

#include <TMB.hpp>
#include <fenv.h> // Extra line needed to detect under/overflow in burrrIII3

#include "ll_burrIII3.hpp"
#include "ll_gamma.hpp"
#include "ll_gompertz.hpp"
#include "ll_invpareto.hpp"
#include "ll_lgumbel.hpp"
#include "ll_llogis.hpp"
#include "ll_llogis_llogis.hpp"
#include "ll_lnorm.hpp"
#include "ll_lnorm_lnorm.hpp"
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
  } else if (model == "ll_invpareto") {
    return ll_invpareto(this);
  }  else if (model == "ll_llogis") {
    return ll_llogis(this);
  } else if (model == "ll_llogis_llogis") {
    return ll_llogis_llogis(this);
  } else if(model == "ll_lnorm") {
    return ll_lnorm(this);
  } else if(model == "ll_lnorm_lnorm") {
    return ll_lnorm_lnorm(this);
  } else if(model == "ll_weibull") {
    return ll_weibull(this);
  } else {
    error("Unknown model.");
  }
  return 0;
}
