#' Stock Market Index Return Data
#'
#' The stock market returns are recorded for four countries viz., United States (S&P500), Japan (NIKKEI225), Germany (DAX Index), and South Korea (KOSPI). Specifically log return rates (as computed in Section 5 of <https://doi.org/10.3390/axioms11090462>) are recorded for 5 months in the year 2009 for all the four countries, where these rates are considered to be Student's t-distributed and used for the purpose of estimating the corresponding degrees of freedom using a Bayesian model-based framework, developed in <https://doi.org/10.3390/axioms11090462>.
#'
#' @source (Lee, 2022),
#'   \doi{10.3390/axioms11090462}.
#' @format A data frame with 4 columns:
#' \describe{
#' \item{Country}{name of the country to which the log return rate corresponds to: 'United States', 'Japan', 'Germany', and 'South Korea'}
#' \item{log_return_rate}{value of the log return rate}
#' \item{time_index}{an index for the log return rate observations}
#' \item{date}{the date on which the log return rate was recorded}
#' }
"index_return"
