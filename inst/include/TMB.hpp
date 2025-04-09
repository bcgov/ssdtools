// Copyright 2015-2023 Province of British Columbia
// Copyright 2021 Environment and Climate Change Canada
// Copyright 2023-2025 Australian Government Department of Climate Change, 
// Energy, the Environment and Water
// 

#include "tmbutils/tmbutils.hpp"
#include "tmbutils/vectorize.hpp"
  using tmbutils::matrix;
  using tmbutils::vector;
  using CppAD::AD;
  using CppAD::ADFun;
  namespace CppAD{
  /* Add 'isfinite' to CppAD */
  using std::isfinite;
  template <class T>
  bool isfinite(const AD<T> &x)CSKIP({ return isfinite(Value(x)); })
  }
  