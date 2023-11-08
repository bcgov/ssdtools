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

// Compute the negative log-likelihood of the inverse pareto distribution
// If Y ~ pareto (shape, scale) then 1/Y is inverse pareto (shape, scale)

// We are using the American Pareto distribution
//  See https://www.casact.org/sites/default/files/database/astin_vol20no2_201.pdf

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
//    log_shape  - log(shape)
//    log_scale  - log(scale)

// Note that the mle for the scale parameter for the Pareto distribution is min(Y).
// The scale parameter for the inverse-Pareto distribution is max(Y) when all values are uncensored
// You will need to either fix the scale parameter or maximize over both. In both cases
// the hessian is not useful for finding standard errors.

// Refer to http://kaskr.github.io/adcomp/matrix_arrays_8cpp-example.html for help in coding the log-likelihood function

// Refer to https://github.com/kaskr/adcomp/wiki/Development
// on instructions for including TMB code in an R package

#ifndef ll_invpareto_hpp
#define ll_invpareto_hpp

#undef TMB_OBJECTIVE_PTR
#define TMB_OBJECTIVE_PTR obj

template<class Type>
Type ll_invpareto(objective_function<Type>* obj) // normal with parameters mu and log(sigma)
{
  // Data
  DATA_VECTOR( left  );  // left and right values
  DATA_VECTOR( right );
  DATA_VECTOR( weight);  // weight

  // The order of these parameter statements determines the order of the estimates in the vector of parameters
   // Parameters
  PARAMETER( log_shape );
  PARAMETER( log_scale );
  
  Type shape = exp(log_shape);
  Type scale = exp(log_scale);
 
  Type nll = 0;
  int n_data    = left.size(); // number of data values
  Type pleft;    // probability that concentration < left(i)  used for censored data
  Type pright;   // probability that concentration < right(i) used for censored data
  Type y;
 
   // Check for limits of the data
   // We apply a penalty if the values are larer than the scale parameter
  for( int i=0; i<n_data; i++){
     if(left(i) == right(i)){  // uncensored data
        if(left(i) > scale)return(INFINITY);
        y = left(i);
        //if(y > scale)y = scale +( scale-y);  // we reflect about the maximum to enable estimation of scale and shape using MLE without fixing scale. 
        nll -= weight(i)*(log(shape) - shape*log(scale) + (shape+1)*log(y) - 2*log(y));
     };
     if(left(i) < right(i)){   // censored data
        pleft = 0;
        if(left(i)>scale)pleft=1;
        if((left(i)>0) && (left(i)<=scale)){ pleft= pow((left(i)/scale),shape);};  // need the other tail for the inverse
        pright = 1;
        if(right(i)<=scale) { pright=pow((right(i)/scale),shape);};
        nll -= weight(i)*log(pright-pleft);  // contribution to log-likelihood for censored values
     };
     
  };

  ADREPORT(shape);
  REPORT  (shape);
  ADREPORT(scale);
  REPORT  (scale);
  
  return nll;
};  
  
#undef TMB_OBJECTIVE_PTR
#define TMB_OBJECTIVE_PTR this
  
#endif
