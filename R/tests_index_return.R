
library(dplyr)
data(index_return)
index_return_US <- filter(index_return, Country == "United States")
