//    Copyright 2021 Environment and Climate Change Canada

//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at

//       https://www.apache.org/licenses/LICENSE-2.0

//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.

#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double plogis_dummy(double q, double location, double scale) {
  if(scale <= 0) return R_NaN;
  return R::plogis(q, location, scale, true, false);
}
