// Copyright 2015-2023 Province of British Columbia
// Copyright 2021 Environment and Climate Change Canada
// Copyright 2023-2024 Australian Government Department of Climate Change, 
// Energy, the Environment and Water
//
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//
//       https://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.

#ifndef ll_weibull_hpp
#define ll_weibull_hpp

#undef TMB_OBJECTIVE_PTR
#define TMB_OBJECTIVE_PTR obj

template<class Type>
Type ll_weibull(objective_function<Type>* obj) {
  
  DATA_VECTOR(left);
  DATA_VECTOR(right);
  DATA_VECTOR(weight); 
  
  PARAMETER(log_shape);
  PARAMETER(log_scale);
  
  Type shape;
  Type scale;
  shape = exp(log_shape);
  scale = exp(log_scale);
  
  Type nll = 0;
  int n_data = left.size();
  Type pleft; 
  Type pright;
  
  for(int i = 0; i < n_data; i++) {
    if(left(i) == right(i)) {
      nll -= weight(i) * (dweibull(left(i), shape, scale, true));
    };
    if(left(i) < right(i)) {
      pleft = 0;
      if(left(i) > 0) {
        pleft=pweibull(left(i), shape, scale );
      };
      pright = 1;
      using std::isfinite;
      if(isfinite(right(i))) { 
        pright = pweibull(right(i), shape, scale);
      };
      nll -= weight(i) * log(pright-pleft);
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
