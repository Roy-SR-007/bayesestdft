## [**`bayesestdft`**]{.underline}: *Estimating the degrees of freedom of the Student's t-distribution under a Bayesian framework*

## Contents

-   [Overview](#overview)
-   [Installation](#installation)
-   [Goal](#goal)
-   [Jeffreys prior](#jeffreys-prior)
-   [Exponential prior](#exponential-prior)
-   [Gamma prior](#gamma-prior)
-   [Log-normal prior](#log-normal-prior)

## Overview {#overview}

`bayesestdft` is an R package providing tools to implement Bayesian estimation of the degrees of freedom in the Student's t-distribution, that are developed in [Lee (2022)](https://doi.org/10.3390/axioms11090462). Estimation experiments are run both on simulated as well as real data, where broadly three Markov Chain Monte Carlo (MCMC) sampling algorithms are used: (i) *random walk Metropolis* (**RMW**), (ii) *Metropolis-adjusted Langevin Algorithm* (**MALA**) and (iii) *Elliptical Slice Sampler* (**ESS**) respectively, to sample from the posterior distribution of the degrees of freedom.

The current version of the package `bayesestdft 1.0.0` provides Bayesian routines to estimate the degrees of freedom of the Student's t-distribution with **Jeffreys** prior (`BayesJeffreys`), **Gamma** prior (`BayesGA`), and **Log-normal** prior (`BayesLNP`) endowed upon as the prior distribution over the degrees of freedom. **MALA** is used to draw posterior samples in case of the Jeffreys prior, hence to operate the function `BayesJeffreys`, the user needs to install the `numDeriv` R package. For more technical insights into `bayesestdft`, refer to the [slides](https://github.com/yain22/bayesestdft/blob/master/doc/Explaining%20R%20Package%20bayesestdft.pdf).

## Installation Guide for `bayesestdft` {#installation}

-   An R version of **4.0.4**, or higher is required to install `bayesestdft`.
-   **Core dependencies** include `numDeriv` and `dplyr`.

Now `bayesestdft` can be installed from both **Github** and **CRAN** respectively, using the following lines of code:

1.  **Github Installation**

``` r
library(devtools)
devtools::install_github("Roy-SR-007/bayesestdft")
library(bayesestdft)
```

2.  **CRAN Installation**

``` r
install.packages("bayesestdft")
library(bayesestdft)
```

## Goal {#goal}

The goal of R Package `bayesestdft` is the fully Bayesian estimation of the number of degrees of the freedom of the Student's t-distribution. More precisely, provided the $N$ number of independently and identically distributed samples $x = (x_1,\cdots,x_N)$ drawn from the Student t-distribution

$$ 
t_{\nu}(x) = \frac{\Gamma\left( \frac{\nu+1}{2} \right)}{\sqrt{\nu \pi} \Gamma\left( \frac{\nu}{2} \right)} \left(1 + \frac{x^2}{\nu} \right)^{-\frac{\nu +1}{2}}, \quad x \in \mathbb{R},
$$

and a prior distribution $\pi(\nu)$, the aim is to draw posterior samples from the posterior distribution

$$
\pi(\nu|\textbf{x}) = \frac{\prod t_{\nu}(x_i) \cdot \pi(\nu)}{\int \prod t_{\nu}(x_i) \cdot \pi(\nu) d\nu}, \quad \nu \in \mathbb{R}^+.
$$

The current version of the package provides four options of the priors $\pi(\nu)$. They are the Jeffreys prior $\pi_J(\nu)$, an exponential prior $\pi_E(\nu)$, a gamma prior $\pi_G(\nu)$, and a log-normal prior $\pi_L(\nu)$.

## Jeffreys prior {#jeffreys-prior}

$$ \pi_{J}(\nu) \propto \left(\frac{\nu}{\nu+3} \right)^{1/2} \left( \psi'\left(\frac{\nu}{2}\right) -\psi'\left(\frac{\nu+1}{2}\right) -\frac{2(\nu + 3)}{\nu(\nu+1)^2}\right)^{1/2},\quad \nu \in \mathbb{R}^+$$

#### Estimation of the degrees of freedom from simulated data

``` r
x = rt(n = 100, df = 0.1)
nu1 = BayesJeffreys(x, sampling.alg = "MH")
nu2 = BayesJeffreys(x, sampling.alg = "MALA")
mean(nu1)
mean(nu2)
```

#### Estimation of the degrees of freedom of daily log-return rate of S&P500 index time series data

``` r
library(dplyr)
data(index_return)
index_return_US <- filter(index_return, Country == "United States")
x = index_return_US$log_return_rate
nu1 = BayesJeffreys(x, sampling.alg = "MH")
nu2 = BayesJeffreys(x, sampling.alg = "MALA")
mean(nu1)
mean(nu2)
```

## Exponential prior {#exponential-prior}

$$ \pi_{E}(\nu) =Ga(\nu|1,0.1) = Exp(\nu|0.1) = \frac{1}{10} e^{-\nu/10},\quad \nu \in \mathbb{R}^+$$

#### Estimation of the degrees of freedom from simulated data

``` r
x = rt(n = 100, df = 0.1)
nu = BayesGA(x, a = 1, b = 0.1)
mean(nu)
```

#### Estimation of the degrees of freedom of daily log-return rate of S&P500 index time series data

``` r
library(dplyr)
data(index_return)
index_return_US <- filter(index_return, Country == "United States")
x = index_return_US$log_return_rate
nu = BayesGA(x, a = 1, b = 0.1)
mean(nu)
```

## Gamma prior {#gamma-prior}

$$ \pi_{G}(\nu) =Ga(\nu|2,0.1) =\frac{\nu}{100} e^{-\nu/10},\quad \nu \in \mathbb{R}^+$$

#### Estimation of the degrees of freedom from simulated data

``` r
x = rt(n = 100, df = 0.1)
nu = BayesGA(x, a = 2, b = 0.1)
mean(nu)
```

#### Estimation of the degrees of freedom of daily log-return rate of S&P500 index time series data

``` r
library(dplyr)
data(index_return)
index_return_US <- filter(index_return, Country == "United States")
x = index_return_US$log_return_rate
nu = BayesGA(x, a = 2, b = 0.1)
mean(nu)
```

## Log-normal prior {#log-normal-prior}

$$ \pi_{L}(\nu) =logN(\nu|1,1) =\frac{1}{\nu \sqrt{2\pi}} \exp\left[- \frac{(\log \nu - 1)^2}{2} \right],\quad \nu \in \mathbb{R}^+$$

#### Estimation of the degrees of freedom from simulated data

``` r
x = rt(n = 100, df = 0.1)
nu = BayesLNP(x)
mean(nu)
```

#### Estimation of the degrees of freedom of daily log-return rate of S&P500 index time series data

``` r
library(dplyr)
data(index_return)
index_return_US <- filter(index_return, Country == "United States")
x = index_return_US$log_return_rate
nu = BayesLNP(x)
mean(nu)
```

## References

[1] [Se Yoon Lee. (2022) "The Use of a Log-Normal Prior for the Student t-Distribution," Axioms](https://www.mdpi.com/2075-1680/11/9/462)
