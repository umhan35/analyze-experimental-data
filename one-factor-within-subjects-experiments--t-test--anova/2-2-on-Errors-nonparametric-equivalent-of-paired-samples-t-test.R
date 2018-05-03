## nonparametric equivalent of paired-samples t-test
# he Errors response: error counts (actually count data) are often Poisson
# likert scale data, nominal data

# read in a data file with times to find a set of contacts
#  file name: # search scroll (bad naming...)
data = read.csv("one-factor-within-subjects-experiments/srchscrl.csv")
data$Subject = factor(data$Subject)
data$Order   = factor(data$Order)

# explore the Errors response: error counts are often Poisson
# 
library(psych)
describeBy(data$Errors, group = data$Technique, mat=TRUE)

data.search = data[data$Technique == "Search", ]
data.scroll = data[data$Technique == "Scroll", ]
hist(data.search$Errors)
hist(data.scroll$Errors)
plot(Errors ~ Technique, data)

# we might once again test ANOVO assumptions (normality, homoscedasticity)
# but we have now covered that amply, so we'll omit those steps until there's
# something new to be learned. remember, they are guidelines anyway, not law.

# try to fit a Poisson distribution for count data. note that ks.test
# only works for continuous distributions, but Poisson distributions
# are discrete, so use fitdist, not fitdistr, and test with gofstat.
library(fitdistrplus)
fit = fitdist(data.search$Errors, "pois", discrete=TRUE)
gofstat(fit) # gof: goodness of fit
fit = fitdist(data.scroll$Errors, "pois", discrete=TRUE)
gofstat(fit)
# chi-squared p-value is not significantly departing from a Poisson distribution

# Wilcoxon signed-rank test on Errors
library(coin)
wilcoxsign_test(Errors ~ Technique | Subject, data, distribution="exact")
# p-value is much less than 0.05