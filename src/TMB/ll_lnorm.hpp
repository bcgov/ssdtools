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

// Compute the negative log-likelihood of the log-normal distribution
//  If Y ~ logNormal (meanlog, sdlog) then log(Y) ~ Normal (meanlog, sdlog)
// 
// Input data are left(1...n) right(1...n) weight(1...n)
// where 
//    n = sample size (inferred from the vectors)
//    left(i) right(i) specify the uncensored or censored data as noted below
//    weight(i)  - relative weight to be given to each observation's log-likelihood. Use values of 1 for ordinary likelihood
//
//  left(i) and right(i) can take the following forms
//     left(i) == right(i)  - non-censored data
//     left(i) <  right(i)  - interval censored data
//  left(i) must be non-negative (all concentrations must be non-negative)
//  right(i) can take the value Inf for no upper limit
// 
//  E.g.  left(i) right(i)
//          3       3       non-censored values
//          0       3       0 < concentration < 3
//          3       Inf     3 < concentration.
//
// Parameters are
//    meanlog     - mean      on the log(Concentration) scale
//    log_sdlog   - log(sd)   on the log(Concentration) scale, i.e. sdlog=exp(log_sdlog)
//                  This make optimization on log_sdlog unbounded without any constraints

// Refer to http://kaskr.github.io/adcomp/matrix_arrays_8cpp-example.html for help in coding the log-likelihood function

// Refer to https://github.com/kaskr/adcomp/wiki/Development
// on instructions for including TMB code in an R package

/// @file ll_lnorm.hpp

#ifndef ll_lnorm_hpp
#define ll_lnorm_hpp

#undef TMB_OBJECTIVE_PTR
#define TMB_OBJECTIVE_PTR obj

template<class Type>
Type ll_lnorm(objective_function<Type>* obj) {
  // Data
  DATA_VECTOR( left  );  // left and right values
  DATA_VECTOR( right );
  DATA_VECTOR( weight);  // weight

  // The order of these parameter statements determines the order of the estimates in the vector of parameters
  // Parameters
  PARAMETER( meanlog );
  PARAMETER( log_sdlog );
  
  Type sdlog;
  sdlog = exp(log_sdlog);  // convert to [0, Inf] scale

  Type nll = 0;  // negative log-likelihood
  int n_data    = left.size(); // number of data values
  Type pleft;    // probability that concentration < left(i)  used for censored data
  Type pright;   // probability that concentration < right(i) used for censored data
 
   // pdf of log(normal) obtained from pdf(normal) using the standard transformation theory
  for( int i=0; i<n_data; i++){
     if(left(i) == right(i)){  // uncensored data
        nll -= weight(i)*(dnorm( log(left(i)), meanlog, sdlog, true ) - log(left(i)));   // log likelihood for uncensored values
     };
     if(left(i) < right(i)){   // censored data
        pleft = 0;
        if(left(i)>0){ pleft=pnorm(log(left(i)), meanlog, sdlog);};
        pright = pnorm(log(right(i)), meanlog, sdlog);
        nll -= weight(i)*log(pright-pleft);  // contribution to log-likelihood for censored values
     };
     
  };

  ADREPORT(sdlog);  // return this transformed parameter in the summary reports
  REPORT  (sdlog);

  return nll;
  

};

#undef TMB_OBJECTIVE_PTR
#define TMB_OBJECTIVE_PTR this

#endif
