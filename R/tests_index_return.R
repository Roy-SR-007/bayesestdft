
# library(dplyr)
# library(esquisse)
# library(ggplot2)
#
# data(index_return)

# extracting the country-specific data

# index_return_US <- filter(index_return, Country == "United States")
# index_return_JA <- filter(index_return, Country == "Japan")
# index_return_GE <- filter(index_return, Country == "Germany")
# index_return_SK <- filter(index_return, Country == "South Korea")


# plotting the log-rate returns of the four countries

# p1 = ggplot(index_return) +
#  aes(x = time_index, y = log_return_rate, colour = Country) +
#  geom_line() +
#  scale_color_hue(direction = 1) +
#  labs(x = "time frame", y = "log-rate returns (x)", title = "log-rate returns") +
#  theme_minimal() +
#  theme(legend.position = "top") +
#  facet_wrap(vars(Country))
#
# ggsave("index_return_1.png", plot = p1, dpi = 300)

# plotting the density of log-rate returns for US(S&P500)

# p2 = ggplot(index_return_US) +
#   aes(x = log_return_rate) +
#   geom_density(adjust = 1L, fill = "#F69075") +
#   labs(
#     x = "log-rate returns",
#     y = "density",
#     title = "Density Plot of US(S&P500)",
#     subtitle = "Heavy-tailed log-rate returns"
#   ) +
#   theme_minimal()
#
# ggsave("index_return_2.png", plot = p2, dpi = 300)

# modeling the log-rate returns
# x = index_return_US$log_return_rate
#
# par(mfrow=c(3,1))

# Jeffreys prior over the degrees of freedom
# nu_jeffreys = BayesJeffreys(x, S = 10000, sampling.alg = "MALA")
# plot(nu_jeffreys, col = "red", cex = 0.4, ylab = bquote("posterior samples from"~nu~"|x"),
#      main = paste0("Jeffreys prior; BayesJeffreys with PM=",
#                    round(mean(nu_jeffreys), 2)), xlab = "iteration")
# abline(h = mean(nu_jeffreys), lty = 2, col = "green", lwd = 2)

# Gamma prior over the degrees of freedom
# nu_gamma = BayesGA(x, S = 10000, a = 2, b = 0.1)
# plot(nu_gamma, col = "blue", cex = 0.4, ylab = bquote("posterior samples from"~nu~"|x"),
#      main = paste0("Gamma(2, 0.1) prior; BayesGA with PM=",
#                    round(mean(nu_gamma), 2)), xlab = "iteration")
# abline(h = mean(nu_gamma), lty = 2, col = "green", lwd = 2)

# Log-normal prior over the degrees of freedom
# nu_LNP = BayesLNP(x, S = 10000)
# plot(nu_LNP, col = "purple", cex = 0.4, ylab = bquote("posterior samples from"~nu~"|x"),
#      main = paste0("LNP(1, 1) prior; BayesLNP with PM=",
#                    round(mean(nu_LNP), 2)), xlab = "iteration")
# abline(h = mean(nu_LNP), lty = 2, col = "green", lwd = 2)

