#'
#' @title Estimating the Student-t degrees of freedom (dof) with a Log-normal Prior over the dof
#'
#' @description `BayesLNP` samples from the posterior distribution of the degrees of freedom (dof) with Log-normal prior endowed upon the dof, using an Elliptical Slice Sampler (ESS).
#'
#' @param y an N-dimensional vector of continuous observations supported on the real-line
#' @param ini.nu the initial posterior sample value of the degrees of freedom (default is 1)
#' @param S the number of posterior samples (default is 1000)
#' @param mu mean of the Log-normal prior density (default is 1)
#' @param sigma.sq variance of the Log-normal prior density (default is 1)
#'
#' @return A vector of posterior sample estimates
#' \item{res}{an S-dimensional vector with the posterior samples}
#'
#' @export
#'
#' @examples
#'
#' # data from Student-t distribution with dof = 0.1
#' y = rt(n = 100, df = 0.1)
#'
#' # running the Elliptical Slice Sampler (ESS) with default settings
#' nu = BayesLNP(y)
#' # reporting the posterior mean estimate of the dof
#' mean(nu)
#'
#' @references
#' Lee, S. Y. (2022). "The Use of a Log-Normal Prior for the Student t-Distribution",
#' \emph{Axioms}, <https://doi.org/10.3390/axioms11090462>
#'
#' Murray, I., Prescott Adams, R., MacKay, D. J. (2010). "Elliptical slice sampling",
#' \emph{Proceedings of the Thirteenth International Conference on Artificial Intelligence and Statistics}, <https://proceedings.mlr.press/v9/murray10a>

BayesLNP = function(y, ini.nu = 1 , S = 1000, mu = 1, sigma.sq = 1){

  # Sample size
  N = length(y)

  # Make a room
  nu = rep(0,S)
  eta = rep(0,S) # eta = log(nu)

  # Initial value
  nu[1] = ini.nu
  eta[1] = log(nu[1])

  for (s in 1:(S-1)){

    # A. Change of variable
    {
      eta[s] = log(nu[s])
    }
    # B. ESS
    {
      # a. Choose an ellipse centered at mu:
      rho = rnorm(n = 1, mean = mu, sd = sqrt(sigma.sq))

      # b. Define a criterion function :
      alpha = function(eta.new, eta.old){
        e = exp(1)
        f1 = lgamma( (e^eta.new + 1)/ 2 ) - ( eta.new/2 + log(pi)/2 + lgamma( (e^eta.new)/ 2 ))
        f2 = lgamma( (e^eta.old + 1)/ 2 ) - ( eta.old/2 + log(pi)/2 + lgamma( (e^eta.old)/ 2 ))
        f3 = ((exp(eta.new)+1)/2)*sum(log(1 + (y^2)/exp(eta.new)))
        f4 = ((exp(eta.old)+1)/2)*sum(log(1 + (y^2)/exp(eta.old)))
        res = min(exp(N*(f1 - f2) -(f3 - f4)),1)
        return(res)
      }

      # c. Choose a threshold and fix :
      u = runif(n = 1, min = 0, max = 1)

      # d. Draw an initial proposal :
      phi = runif(n = 1, min = -pi, max = pi)
      eta.star = ( eta[s] - mu) * cos(phi) + ( rho - mu) * sin(phi) + mu

      # e. ESS core step
      if (u < alpha(eta.new = eta.star, eta.old = eta[s])){
        eta[s+1] = eta.star
      } else {
        # Define a bracket:
        phi.min = -pi ; phi.max = pi

        while(u >= alpha(eta.new = eta.star, eta.old = eta[s])){
          # Shrink the braket and try a new point:
          if (phi>0) {phi.max = phi} else {phi.min = phi}
          phi = runif(n = 1, min = -pi, max = pi)
          eta.star = ( eta[s] - mu) * cos(phi) + ( rho - mu) * sin(phi) + mu
        }
        eta[s+1] = eta.star
      }

    }

    # C. Change of variable
    {
      nu[s+1] = exp(eta[s+1])
    }

  }

  res = nu

  return(res)

}
