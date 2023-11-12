# Copyright 2023 Environment and Climate Change Canada
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       https://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

optim_convergence <- function(fit) {
  fit$optim$convergence
}

optim_message <- function(fit) {
  fit$optim$message
}

optimizer_converged <- function(fit) {
  code <- optim_convergence(fit)
  code == 0
}

optimizer_message <- function(fit) {
  code <- as.character(optim_convergence(fit))
  switch(code,
    "1" = "Iteration limit maxit reach (try increasing the maximum number of iterations in control).",
    "10" = "Degeneracy of Nelder-Mead simplex.",
    optim_message(fit)
  )
}
