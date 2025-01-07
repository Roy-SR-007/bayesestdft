#'
#' @title Estimating the Student-t degrees of freedom (dof) with a Jeffreys Prior over the dof
#'
#' @description `BayesJeffreys` samples from the posterior distribution of the degrees of freedom (dof) with Jeffreys prior endowed upon the dof, using a random walk Metropolis algorithm and Metropolis-adjusted Langevin algorithm (MALA).
#'
#' @param y an N-dimensional vector of continuous observations supported on the real-line
#' @param ini.nu the initial posterior sample value of the degrees of freedom (default is 1)
#' @param S the number of posterior samples (default is 1000)
#' @param delta the step size for the respective sampling engines (default is 0.001)
#' @param sampling.alg takes the choice of the sampling algorithm to be performed, either 'MH' or 'MALA'
#'
#' @return A vector of posterior sample estimates
#' \item{res}{an S-dimensional vector with the posterior samples}
#'
#' @importFrom numDeriv grad
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
#' nu1 = BayesJeffreys(y, sampling.alg = "MH")
#' # reporting the posterior mean estimate of the dof
#' mean(nu1)
#'
#' # running MALA with default settings
#' nu2 = BayesJeffreys(y, sampling.alg = "MALA")
#' # reporting the posterior mean estimate of the dof
#' mean(nu2)
#'
#' # application to log-return (daily index values) of United States (S&P500)
#' library(dplyr)
#' data(index_return)
#' # log-returns of United States
#' index_return_US <- filter(index_return, Country == "United States")
#' y = index_return_US$log_return_rate
#'
#' # running the random walk Metropolis algorithm with default settings
#' nu1 = BayesJeffreys(y, sampling.alg = "MH")
#' # reporting the posterior mean estimate of the dof from the log-return data of US
#' mean(nu1)
#'
#' # running MALA with default settings
#' nu2 = BayesJeffreys(y, sampling.alg = "MALA")
#' # reporting the posterior mean estimate of the dof from the log-return data of US
#' mean(nu2)
#'
#' @references
#' Lee, S. Y. (2022). "The Use of a Log-Normal Prior for the Student t-Distribution",
#' \emph{Axioms}, <https://doi.org/10.3390/axioms11090462>
#'
#' Gustafson, P. (1998). "A guided walk Metropolis algorithm",
#' \emph{Statistics and Computing}, <https://link.springer.com/article/10.1023/A:1008880707168>

BayesJeffreys = function(y, ini.nu = 1 , S = 1000, delta = 0.001, sampling.alg = c("MH","MALA")){

  if(sampling.alg == "MH"){

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
          p1 = log( (e^eta.new) / ( e^eta.new + 3 ) )
          p2 = log( (e^eta.new) / ( e^eta.old + 3 ) )
          p3 = log(trigamma( (e^eta.new)/2 ) - trigamma( (e^eta.new + 1)/2 ) -2 * (e^eta.new + 3) / ((e^eta.new) * (e^eta.new + 1)^2 ))
          p4 = log(trigamma( (e^eta.old)/2 ) - trigamma( (e^eta.old + 1)/2 ) -2 * (e^eta.old + 3) / ((e^eta.old) * (e^eta.old + 1)^2 ))

          # Result
          res = min(exp(
            N*(f1 - f2) - (f3 - f4) +
              (1/2)*( p1 - p2 + p3 - p4) +
              eta.new - eta.old
          ),1)
          return(res)
        }

        # b. Choose a threshold:
        u = runif(n = 1, min = 0, max = 1)

        # c. Draw an initial proposal :
        eta.star = rnorm(n = 1, mean = eta[s], sd = sqrt(2*delta))

        # d. MH correction step
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

  }

  if(sampling.alg == "MALA"){

    # Install library(numDeriv) if missing
    list.of.packages <- c("numDeriv")
    new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
    if(length(new.packages)) install.packages(new.packages)
    library("numDeriv")

    # Sample size
    N = length(y)

    # Make a room
    nu = rep(0,S)
    eta = rep(0,S) # eta = log(nu)

    # Initial value
    nu[1] = 1
    eta[1] = log(nu[1])

    for (s in 1:(S-1)){

      # A. Change of variable
      {
        eta[s] = log(nu[s])
      }
      # B. MH algorithm
      {
        # a . Define a criterion function :
        gamma_target = function(eta){
          e = exp(1)

          log_likelihood_part = N * (lgamma( (e^eta + 1)/ 2 ) - ( eta/2 + log(pi)/2 + lgamma( (e^eta)/ 2 )) ) -
            ((exp(eta)+1)/2)*sum(log(1 + (y^2)/exp(eta)))

          log_prior_part = (1/2) * (log( (e^eta) / ( e^eta + 3 ) ) + log(trigamma( (e^eta)/2 ) - trigamma( (e^eta + 1)/2 ) -2 * (e^eta + 3) / ((e^eta) * (e^eta + 1)^2 ))   )

          res = - (log_likelihood_part + log_prior_part + eta)
          return(res)
        }

        grad_gamma_target = function(eta){
          res = grad(func = gamma_target, x = eta)
          return(res)
        }

        alpha = function(eta.new, eta.old){
          e = exp(1)

          # Likelihood ratio part
          f1 = lgamma( (e^eta.new + 1)/ 2 ) - ( eta.new/2 + log(pi)/2 + lgamma( (e^eta.new)/ 2 ))
          f2 = lgamma( (e^eta.old + 1)/ 2 ) - ( eta.old/2 + log(pi)/2 + lgamma( (e^eta.old)/ 2 ))

          f3 = ((exp(eta.new)+1)/2)*sum(log(1 + (y^2)/exp(eta.new)))
          f4 = ((exp(eta.old)+1)/2)*sum(log(1 + (y^2)/exp(eta.old)))

          # Prior ratio part
          p1 = log( (e^eta.new) / ( e^eta.new + 3 ) )
          p2 = log( (e^eta.new) / ( e^eta.old + 3 ) )
          p3 = log(trigamma( (e^eta.new)/2 ) - trigamma( (e^eta.new + 1)/2 ) -2 * (e^eta.new + 3) / ((e^eta.new) * (e^eta.new + 1)^2 ))
          p4 = log(trigamma( (e^eta.old)/2 ) - trigamma( (e^eta.old + 1)/2 ) -2 * (e^eta.old + 3) / ((e^eta.old) * (e^eta.old + 1)^2 ))

          Log_of_Likelihood.ratio.part = N*(f1 - f2) - (f3 - f4) +(1/2)*( p1 - p2 + p3 - p4) + eta.new - eta.old
          Log_of_MH.correction.part = dnorm(x = eta.old, mean = eta.new - delta*grad_gamma_target(eta.new), sd = sqrt(2*delta), log = T ) -
            dnorm(x = eta.new, mean = eta.old - delta*grad_gamma_target(eta.old), sd = sqrt(2*delta), log = T )
          res = min( exp (Log_of_Likelihood.ratio.part + Log_of_MH.correction.part) ,1)

          return(res)
        }

        # b. Choose a threshold:
        u = runif(n = 1, min = 0, max = 1)

        # c. Draw an initial proposal :
        eta.star = rnorm(n = 1, mean = eta[s] - delta*grad_gamma_target(eta[s]), sd = sqrt(2*delta))

        # d. MH correction step
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

  }

  res = nu

  return(res)

}
