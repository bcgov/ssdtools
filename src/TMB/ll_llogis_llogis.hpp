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

// Compute the negative log-likelihood of the mixture log-logistic/log-logistic distribution
//    If Y ~ log-logistic( locationlog, scalelog) then log(Y) ~ logisitic(locationlog, scalelog)
// This is a mixture of two log-logistic distributions
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
//    locationlog1  - location on the log(Concentration) scale for first component
//    log_scalelog1 - log(scale)    on the log(Concentration) scale
//    locationlog2  - location on the log(Concentration) scale for second component
//    log_scalelog2 - log(scale)    on the log(Concentration) scale
//    logit_pmix    - logit(proportion) of mixture in the first components

// Refer to http://kaskr.github.io/adcomp/matrix_arrays_8cpp-example.html for help in coding the log-likelihood function

// Refer to https://github.com/kaskr/adcomp/wiki/Development
// on instructions for including TMB code in an R package

#ifndef ll_llogis_llogis_hpp
#define ll_llogis_llogis_hpp

#undef TMB_OBJECTIVE_PTR
#define TMB_OBJECTIVE_PTR obj

template<class Type>
Type ll_llogis_llogis(objective_function<Type>* obj) // normal with parameters mu and log(sigma)
{
  // Data
  DATA_VECTOR( left  );  // left and right values
  DATA_VECTOR( right );
  DATA_VECTOR( weight);  // weight

  // The order of these parameter statements determines the order of the estimates in the vector of parameters
  PARAMETER( locationlog1 ); // first distribution
  PARAMETER( log_scalelog1    );
  PARAMETER( locationlog2 ); // second distribution
  PARAMETER( log_scalelog2    );
  PARAMETER( logit_pmix         );  // mixing proportion

  Type scalelog1 = exp(log_scalelog1);    // Convert to the [0,Inf] range
  Type scalelog2 = exp(log_scalelog2);
  Type pmix      = 1/(1+exp(-logit_pmix));// Convert to the [0,1] range
  
  
  Type nll = 0;  // negative log-likelihood
  int n_data    = left.size(); // number of data values
  Type pleft;    // probability that concentration < left(i)  used for censored data
  Type pright;   // probability that concentration < right(i) used for censored data

  //vector<Type> mynll(n_data); //(for debugging)
   
  // Probability of data conditional on parameter values for uncensored data
  // pdf of log(normal) obtained from pdf(normal) using the standard transformation theory
  for( int i=0; i<n_data; i++){
     if(left(i) == right(i)){   // uncensored values
       if(left(i)>0){
        nll -= weight(i)*(log(   pmix * dlogis( log(left(i)), locationlog1, scalelog1, false )/left(i) +
                             (1-pmix) * dlogis( log(left(i)), locationlog2, scalelog2, false )/left(i)));   // log likelihood for uncensored values
       };
     };
     if(left(i) < right(i)){    // censored values; no builtin function so we code the cdf directly
        pleft = 0;
        if(left(i)>0){ pleft=pmix   * 1/(1+exp(-(log(left(i))-locationlog1)/scalelog1))+
                            (1-pmix)* 1/(1+exp(-(log(left(i))-locationlog2)/scalelog2));};
        pright=pmix    * 1/(1+exp(-(log(right(i))-locationlog1)/scalelog1))+
                                       (1-pmix)* 1/(1+exp(-(log(right(i))-locationlog2)/scalelog2));
        nll -= weight(i)*log(pright-pleft);
     };
     // mynll(i) = nll;  // for debugging
  };

  ADREPORT(scalelog1);
  REPORT  (scalelog1);
  ADREPORT(scalelog2);
  REPORT  (scalelog2);
  ADREPORT(pmix);
  REPORT  (pmix);
  
  
  //REPORT( mynll);  //for debugging
  return nll;
}

#undef TMB_OBJECTIVE_PTR
#define TMB_OBJECTIVE_PTR this

#endif
