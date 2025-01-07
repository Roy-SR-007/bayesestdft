#'
#' @title Estimating the Student-t degrees of freedom (dof) with a Gamma Prior over the dof
#'
#' @description `BayesGA` samples from the posterior distribution of the degrees of freedom (dof) with Gamma prior endowed upon the dof, using a random walk Metropolis algorithm.
#'
#' @param y an N-dimensional vector of continuous observations supported on the real-line
#' @param ini.nu the initial posterior sample value of the degrees of freedom (default is 1)
#' @param S the number of posterior samples (default is 1000)
#' @param delta the step size for the respective sampling engines (default is 0.001)
#' @param a rate parameter of Gamma prior (default is 1, corresponds to an Exponential prior)
#' @param b rate parameter of Gamma prior (default is 0.1)
#'
#' @return A vector of posterior sample estimates
#' \item{res}{an S-dimensional vector with the posterior samples}
#'
#' @importFrom dplyr filter
#'
#' @export
#'
#' @examples
#'
#' # data from Student-t distribution with dof = 0.1
#' y = rt(n = 100, df = 0.1)
#'
#' # running the random walk Metropolis algorithm with default settings
#' nu = BayesGA(y)
#' # reporting the posterior mean estimate of the dof
#' mean(nu)
#'
#' # application to log-return (daily index values) of United States (S&P500)
#' library(dplyr)
#' data(index_return)
#' # log-returns of United States
#' index_return_US <- filter(index_return, Country == "United States")
#' y = index_return_US$log_return_rate
#'
#' # running the random walk Metropolis algorithm with default settings
#' nu = BayesGA(y)
#' # reporting the posterior mean estimate of the dof from the log-return data of US
#' mean(nu)
#'
#' @references
#' Lee, S. Y. (2022). "The Use of a Log-Normal Prior for the Student t-Distribution",
#' \emph{Axioms}, <https://doi.org/10.3390/axioms11090462>
#'
#' Fernández, C., Steel, M. F. (1998). "On Bayesian modeling of fat tails and skewness",
#' \emph{Journal of the American Statistical Association}, <https://www.tandfonline.com/doi/abs/10.1080/01621459.1998.10474117>
#'
#' Juárez, M. A., Steel, M. F. (2010). "Model-Based Clustering of Non-Gaussian Panel Data Based on Skew-t Distributions",
#' \emph{Journal of Business and Economic Statistics}, <https://www.tandfonline.com/doi/abs/10.1198/jbes.2009.07145>

BayesGA = function(y, ini.nu = 1 , S = 1000, delta = 0.001, a = 1, b = 0.1){

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
    # B. MH algorithm
    {
      # a . Define a criterion function :
      alpha = function(eta.new, eta.old){
        e = exp(1)

        # Likelihood ratio part
        f1 = lgamma( (e^eta.new + 1)/ 2 ) - ( eta.new/2 + log(pi)/2 + lgamma( (e^eta.new)/ 2 ))
        f2 = lgamma( (e^eta.old + 1)/ 2 ) - ( eta.old/2 + log(pi)/2 + lgamma( (e^eta.old)/ 2 ))

        f3 = ((exp(eta.new)+1)/2)*sum(log(1 + (y^2)/exp(eta.new)))
        f4 = ((exp(eta.old)+1)/2)*sum(log(1 + (y^2)/exp(eta.old)))

        # Prior ratio part
        p1 = a*(eta.new - eta.old)
        p2 = b*(exp(eta.new) - exp(eta.old))

        # Result
        res = min(exp(
          N*(f1 - f2) - (f3 - f4) +
            ( p1 - p2 )
        ),1)
        return(res)
      }

      # b. Choose a threshold:
      u = runif(n = 1, min = 0, max = 1)

      # c. Draw an initial proposal :
      eta.star = rnorm(n = 1, mean = eta[s], sd = sqrt(2*delta))

      # d. MH core step
      if (u < alpha(eta.new = eta.star, eta.old = eta[s])){
        eta[s+1] = eta.star
      } else {
        eta[s+1] = eta[s]
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
