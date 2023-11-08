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

// Compute the negative log-likelihood of the Burr III 3-parameter distribution

//  Y ~ BurrIII3 (shape1, shape2, scale) 
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
//    log_shape1  - log(shape1)
//    log_shape2  - log(shape2)
//    log_scale   - log(scale)

// Refer to http://kaskr.github.io/adcomp/matrix_arrays_8cpp-example.html for help in coding the log-likelihood function

// Refer to https://github.com/kaskr/adcomp/wiki/Development
// on instructions for including TMB code in an R package

#ifndef ll_burrIII3_hpp
#define ll_burrIII3_hpp

#undef TMB_OBJECTIVE_PTR
#define TMB_OBJECTIVE_PTR obj

template<class Type>
Type ll_burrIII3(objective_function<Type>* obj) // normal with parameters mu and log(sigma)
{
  feraiseexcept(FE_INVALID | FE_OVERFLOW | FE_DIVBYZERO | FE_UNDERFLOW); // Extra line needed for over/underflow detection
  
  // Data
  DATA_VECTOR( left  );  // left and right values
  DATA_VECTOR( right );
  DATA_VECTOR( weight);  // weight

  // The order of these parameter statements determines the order of the estimates in the vector of parameters
   // Parameters
  PARAMETER( log_shape1 );
  PARAMETER( log_shape2 );
  PARAMETER( log_scale );
  
  Type shape1 = exp(log_shape1);
  Type shape2 = exp(log_shape2);
  Type scale  = exp(log_scale);  // notice we have scale on top of X; actuar::burrIII has scale on bottom. Hence take -log_scale here

  Type nll = 0;
  int n_data    = left.size(); // number of data values
  Type pleft;    // probability that concentration < left(i)  used for censored data
  Type pright;   // probability that concentration < right(i) used for censored data
 
   // pdf of weibull distribution is avaialble in TMB directly
  for( int i=0; i<n_data; i++){
     if(left(i) == right(i)){  // uncensored data
        nll -= weight(i)*(log_shape1 + log_shape2 + log_scale + (shape2-1)*log(scale/left(i))
              -2*log(left(i)) - (shape1+1)*log(1+ pow(scale/left(i),shape2))   );
     };
     if(left(i) < right(i)){   // censored data
        pleft = 0;
        if(left(i)>0){ pleft=1/pow(1+pow(scale/left(i),shape2),shape1);};
        pright = 1/pow(1+pow(scale/right(i),shape2),shape1);
        nll -= weight(i)*log(pright-pleft);  // contribution to log-likelihood for censored values
     };
     
  };

  ADREPORT(shape1);
  REPORT  (shape1);
  ADREPORT(shape2);
  REPORT  (shape2);
  ADREPORT(scale);
  REPORT  (scale);
  
  return nll;
};

  // Probability of data conditional on parameter values for right censored data i.e. value > given valu
  //for( int i=0; i<n_data_rightcen; i++){
  //   jnll -= log(1-pweibull( y_rightcen(i), location, scale )); 
  //};

  
#undef TMB_OBJECTIVE_PTR
#define TMB_OBJECTIVE_PTR this
  
#endif
