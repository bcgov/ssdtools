/// @file NormalNLL.hpp

#ifndef NormalNLL_hpp
#define NormalNLL_hpp

#undef TMB_OBJECTIVE_PTR
#define TMB_OBJECTIVE_PTR obj

/// Negative log-likelihood of the normal distribution.
template<class Type>
Type NormalNLL(objective_function<Type>* obj) {
  DATA_VECTOR(x); // data vector
  PARAMETER(mu); // mean parameter
  PARAMETER(sigma); // standard deviation parameter
  return -sum(dnorm(x,mu,sigma,true)); // negative log likelihood
}

#undef TMB_OBJECTIVE_PTR
#define TMB_OBJECTIVE_PTR this

#endif
