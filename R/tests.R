
# -------------------------------------------------------------------------

## Student's t-distribution plot

# x = rt(10000, df = 25)
# y = rt(10000, df = 15)
# z = rt(10000, df = 5)
# w = rt(10000, df = 3)

# #plot(density(x), col = "black", main = bquote("Student's t-distribution:"~t[nu](x)), ylab = "density", xlab = "x")
# #lines(density(y), col = "red")
# #lines(density(z), col = "blue")
# #lines(density(w), col = "darkgreen")
# #legend("topright", legend=c(bquote(nu~"=25"), bquote(nu~"=15"), bquote(nu~"=5"), bquote(nu~"=3")),
#        col = c("black", "red", "blue", "darkgreen"), lty=1)


# -------------------------------------------------------------------------

## trace plots using BayesJeffreys(): Jeffreys prior

# par(mfrow = c(2, 2))
#
# x = rt(n = 100, df = 0.1)
# nu1.1 = BayesJeffreys(x, S = 10000, sampling.alg = "MH")
# nu2.1 = BayesJeffreys(x, S = 10000, sampling.alg = "MALA")
# mean(nu1.1)
# mean(nu2.1)

#plot(1:10000, nu1.1, col = "red", lty = 1, xlab = "iterations",
#     main = bquote("Traceplot with"~nu~"=0.1"), ylab = bquote("posterior samples of"~nu~"|x"))
#lines(nu2.1, col = "blue")
#abline(h = 0.1, lwd = 2, lty = 2)
#abline(h = (mean(nu1.1) + mean(nu2.1)) / 2, lwd = 2, lty = 2, col = "green")

#legend("topright", legend = c("RWM", "MALA"), col = c("red", "blue"), lty = 1)

# x = rt(n = 100, df = 3)
# nu1.2 = BayesJeffreys(x, S = 10000, sampling.alg = "MH")
# nu2.2 = BayesJeffreys(x, S = 10000, sampling.alg = "MALA")
# mean(nu1.2)
# mean(nu2.2)

#plot(1:10000, nu1.2, col = "red", lty = 1, xlab = "iterations",
#     main = bquote("Traceplot with"~nu~"=3"), ylab = bquote("posterior samples of"~nu~"|x"))
#lines(nu2.2, col = "blue")
#abline(h = 3, lwd = 2, lty = 2)
#abline(h = (mean(nu1.2) + mean(nu2.2)) / 2, lwd = 2, lty = 2, col = "green")

#legend("topright", legend = c("RWM", "MALA"), col = c("red", "blue"), lty = 1)

#x = rt(n = 100, df = 10)
#nu1.3 = BayesJeffreys(x, S = 10000, sampling.alg = "MH")
#nu2.3 = BayesJeffreys(x, S = 10000, sampling.alg = "MALA")
#mean(nu1.3)
#mean(nu2.3)

# plot(1:10000, nu1.3, col = "red", lty = 1, xlab = "iterations",
#      main = bquote("Traceplot with"~nu~"=10"), ylab = bquote("posterior samples of"~nu~"|x"))
# lines(nu2.3, col = "blue")
# abline(h = 10, lwd = 2, lty = 2)
# abline(h = (mean(nu1.3) + mean(nu2.3)) / 2, lwd = 2, lty = 2, col = "green")

#legend("topright", legend = c("RWM", "MALA"), col = c("red", "blue"), lty = 1)

# x = rt(n = 100, df = 25)
# nu1.4 = BayesJeffreys(x, S = 10000, sampling.alg = "MH")
# nu2.4 = BayesJeffreys(x, S = 10000, sampling.alg = "MALA")
# mean(nu1.4)
# mean(nu2.4)

# plot(1:10000, nu1.4, col = "red", lty = 1, xlab = "iterations",
#      main = bquote("Traceplot with"~nu~"=25"), ylab = bquote("posterior samples of"~nu~"|x"))
# lines(nu2.4, col = "blue")
# abline(h = 25, lwd = 2, lty = 2)
# abline(h = (mean(nu1.4) + mean(nu2.4)) / 2, lwd = 2, lty = 2, col = "green")

#legend("topright", legend = c("RWM", "MALA"), col = c("red", "blue"), lty = 1)


# -------------------------------------------------------------------------

## trace plots using BayesGA(): Exponential prior

# par(mfrow = c(2, 2))
#
# x = rt(n = 100, df = 0.1)
# nu.1 = BayesGA(x, S = 10000, a = 1, b = 0.1)
# mean(nu.1)
#
# plot(1:10000, nu.1, col = "red", lty = 1, xlab = "iterations",
#      main = bquote("Traceplot with"~nu~"=0.1"), ylab = bquote("posterior samples of"~nu~"|x"))
# abline(h = 0.1, lwd = 2, lty = 2)
# abline(h = mean(nu.1), lwd = 2, lty = 2, col = "green")
#
# x = rt(n = 100, df = 3)
# nu.2 = BayesGA(x, S = 10000, a = 1, b = 0.1)
# mean(nu.2)
#
# plot(1:10000, nu.2, col = "red", lty = 1, xlab = "iterations",
#      main = bquote("Traceplot with"~nu~"=3"), ylab = bquote("posterior samples of"~nu~"|x"))
# abline(h = 3, lwd = 2, lty = 2)
# abline(h = mean(nu.2), lwd = 2, lty = 2, col = "green")
#
# x = rt(n = 100, df = 10)
# nu.3 = BayesGA(x, S = 10000, a = 1, b = 0.1)
# mean(nu.3)
#
# plot(1:10000, nu.3, col = "red", lty = 1, xlab = "iterations",
#      main = bquote("Traceplot with"~nu~"=10"), ylab = bquote("posterior samples of"~nu~"|x"))
# abline(h = 10, lwd = 2, lty = 2)
# abline(h = mean(nu.3), lwd = 2, lty = 2, col = "green")
#
# x = rt(n = 100, df = 25)
# nu.4 = BayesGA(x, S = 10000, a = 1, b = 0.1)
# mean(nu.4)
#
# plot(1:10000, nu.4, col = "red", lty = 1, xlab = "iterations",
#      main = bquote("Traceplot with"~nu~"=25"), ylab = bquote("posterior samples of"~nu~"|x"))
# abline(h = 25, lwd = 2, lty = 2)
# abline(h = mean(nu.4), lwd = 2, lty = 2, col = "green")
#

# -------------------------------------------------------------------------

## trace plots using BayesGA(): Gamma prior

# par(mfrow = c(2, 2))
#
# x = rt(n = 100, df = 0.1)
# nu.1 = BayesGA(x, S = 10000, a = 2, b = 0.1)
# # posterior mean estimate
# mean(nu.1)
#
# plot(1:10000, nu.1, col = "red", lty = 1, xlab = "iterations",
#      main = bquote("Traceplot with"~nu~"=0.1"), ylab = bquote("posterior samples of"~nu~"|x"))
# abline(h = 0.1, lwd = 2, lty = 2)
# abline(h = mean(nu.1), lwd = 2, lty = 2, col = "green")
#
# x = rt(n = 100, df = 3)
# nu.2 = BayesGA(x, S = 10000, a = 2, b = 0.1)
# # posterior mean estimate
# mean(nu.2)
#
# plot(1:10000, nu.2, col = "red", lty = 1, xlab = "iterations",
#      main = bquote("Traceplot with"~nu~"=3"), ylab = bquote("posterior samples of"~nu~"|x"))
# abline(h = 3, lwd = 2, lty = 2)
# abline(h = mean(nu.2), lwd = 2, lty = 2, col = "green")
#
# x = rt(n = 100, df = 10)
# nu.3 = BayesGA(x, S = 10000, a = 2, b = 0.1)
# # posterior mean estimate
# mean(nu.3)
#
# plot(1:10000, nu.3, col = "red", lty = 1, xlab = "iterations",
#      main = bquote("Traceplot with"~nu~"=10"), ylab = bquote("posterior samples of"~nu~"|x"))
# abline(h = 10, lwd = 2, lty = 2)
# abline(h = mean(nu.3), lwd = 2, lty = 2, col = "green")
#
# x = rt(n = 100, df = 25)
# nu.4 = BayesGA(x, S = 10000, a = 2, b = 0.1)
# # posterior mean estimate
# mean(nu.4)
#
# plot(1:10000, nu.4, col = "red", lty = 1, xlab = "iterations",
#      main = bquote("Traceplot with"~nu~"=25"), ylab = bquote("posterior samples of"~nu~"|x"))
# abline(h = 25, lwd = 2, lty = 2)
# abline(h = mean(nu.4), lwd = 2, lty = 2, col = "green")


# -------------------------------------------------------------------------

## trace plots using BayesLNP(): Log-normal prior

# par(mfrow = c(2, 2))
#
# x = rt(n = 100, df = 0.1)
# # simulating S = 10000 posterior samples
# nu.1 = BayesLNP(x, S = 10000)
# # posterior mean estimate
# mean(nu.1)
#
# plot(1:10000, nu.1, col = "red", lty = 1, xlab = "iterations",
#      main = bquote("Traceplot with"~nu~"=0.1"), ylab = bquote("posterior samples of"~nu~"|x"))
# abline(h = 0.1, lwd = 2, lty = 2)
# abline(h = mean(nu.1), lwd = 2, lty = 2, col = "green")
#
# x = rt(n = 100, df = 3)
# # simulating S = 10000 posterior samples
# nu.2 = BayesLNP(x, S = 10000)
# # posterior mean estimate
# mean(nu.2)
#
# plot(1:10000, nu.2, col = "red", lty = 1, xlab = "iterations",
#      main = bquote("Traceplot with"~nu~"=3"), ylab = bquote("posterior samples of"~nu~"|x"))
# abline(h = 3, lwd = 2, lty = 2)
# abline(h = mean(nu.2), lwd = 2, lty = 2, col = "green")
#
#
# x = rt(n = 100, df = 10)
# # simulating S = 10000 posterior samples
# nu.3 = BayesLNP(x, S = 10000)
# # posterior mean estimate
# mean(nu.3)
#
# plot(1:10000, nu.3, col = "red", lty = 1, xlab = "iterations",
#      main = bquote("Traceplot with"~nu~"=10"), ylab = bquote("posterior samples of"~nu~"|x"))
# abline(h = 10, lwd = 2, lty = 2)
# abline(h = mean(nu.3), lwd = 2, lty = 2, col = "green")
#
#
# x = rt(n = 100, df = 25)
# # simulating S = 10000 posterior samples
# nu.4 = BayesLNP(x, S = 10000)
# # posterior mean estimate
# mean(nu.4)
#
# plot(1:10000, nu.4, col = "red", lty = 1, xlab = "iterations",
#      main = bquote("Traceplot with"~nu~"=25"), ylab = bquote("posterior samples of"~nu~"|x"))
# abline(h = 25, lwd = 2, lty = 2)
# abline(h = mean(nu.4), lwd = 2, lty = 2, col = "green")

# -------------------------------------------------------------------------


