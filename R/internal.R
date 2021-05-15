#    Copyright 2015 Province of British Columbia
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

is_censored_data <- function(data) {
  any(data$left != data$right) || any(data$left == 0) || any(is.infinite(data$right))
}

probs <- function(level) {
  probs <- (1 - level) / 2
  c(probs, 1 - probs)
}

safely <- function(.f) {
  function(...) {
    x <- try(.f(...), silent = TRUE)
    if (inherits(x, "try-error")) {
      return(list(result = NULL, error = as.character(x)))
    }
    list(result = x, error = NULL)
  }
}
