optim_convergence <- function(fit) {
  fit$optim$convergence
}

optim_message <- function(fit) {
  fit$optim$convergence
}

optimizer_converged <- function(fit) {
  code <- optim_convergence(fit)
  code == 0
}

optimizer_message <- function(fit) {
  code <- optim_convergence(fit)
  switch(code,
    "1" =  "Iteration limit maxit reach (try increasing the maximum number of iterations in control).",
    "10" = "Degeneracy of Nelder-Mead simplex.",
    optim_message(fit))
}
