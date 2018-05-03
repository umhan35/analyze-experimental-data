## nonparametric equivalent of paired-samples t-test
# Effort, Likert scale data, nominal data

# read in a data file with times to find a set of contacts
#  file name: # search scroll (bad naming...)
data = read.csv("one-factor-within-subjects-experiments/srchscrl.csv")
data$Subject = factor(data$Subject)
data$Order   = factor(data$Order)


# explore effort, the ordinal Likert scale response (1-7)
# not satisfy ANOVA assumptions
library(psych)
describeBy(data$Effort, group = data$Technique)

data.search = data[data$Technique == "Search", ]
data.scroll = data[data$Technique == "Scroll", ]
hist(data.search$Effort, breaks=c(1:7), xlim=c(1,7))
hist(data.scroll$Effort, breaks=c(1:7), xlim=c(1,7))
plot(Effort ~ Technique, data)


# Wilcoxon signed-rank test on Errors
library(coin)
wilcoxsign_test(Effort ~ Technique | Subject, data, distribution="exact")
# p-value is over 0.05, not significant
# no detectable differences between the effort required for scrolling and searching