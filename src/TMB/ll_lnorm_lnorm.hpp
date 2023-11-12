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

#ifndef ll_lnorm_lnorm_hpp
#define ll_lnorm_lnorm_hpp

#undef TMB_OBJECTIVE_PTR
#define TMB_OBJECTIVE_PTR obj

template<class Type>
Type ll_lnorm_lnorm(objective_function<Type>* obj) // normal with parameters mu and log(sigma)
{
  // Data
  DATA_VECTOR( left  );  // left and right values
  DATA_VECTOR( right );
  DATA_VECTOR( weight);  // weight

  // The order of these parameter statements determines the order of the estimates in the vector of parameters
  PARAMETER( meanlog1 ); // first distribution
  PARAMETER( log_sdlog1    );
  PARAMETER( meanlog2 ); // second distribution
  PARAMETER( log_sdlog2    );
  PARAMETER( logit_pmix         );  // mixing proportion

  Type sdlog1 = exp(log_sdlog1);    // Convert to the [0,Inf] range
  Type sdlog2 = exp(log_sdlog2);
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
        nll -= weight(i)*(log(pmix * dnorm(log(left(i)), meanlog1, sdlog1, false )/left(i) +
                             (1-pmix) * dnorm(log(left(i)), meanlog2, sdlog2, false )/left(i)));   // log likelihood for uncensored values
       };
     };
     if(left(i) < right(i)){    // censored values; no builtin function so we code the cdf directly
        pleft = 0;
        if(left(i)>0){ pleft=pmix * pnorm(log(left(i)), meanlog1, sdlog1)+
                            (1-pmix) * pnorm(log(left(i)), meanlog2, sdlog2);};
        pright=pmix * pnorm(log(right(i)), meanlog1, sdlog1)+
                                       (1-pmix)* pnorm(log(right(i)), meanlog2, sdlog2);
        nll -= weight(i)*log(pright-pleft);
     };
  };

  ADREPORT(sdlog1);
  REPORT  (sdlog1);
  ADREPORT(sdlog2);
  REPORT  (sdlog2);
  ADREPORT(pmix);
  REPORT  (pmix);
  
  return nll;
}

#undef TMB_OBJECTIVE_PTR
#define TMB_OBJECTIVE_PTR this

#endif
