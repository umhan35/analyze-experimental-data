## Nonparametric equivalent of one-way repeated measures ANOVA
##  Examine Effort Likert scale ratings for all 3 techniques

# Effort: how hard or effortful was it to use these techniques to find contacts?

# read in a data file with a third method, voice recognition
#  file name: # search scroll voice (bad naming...)
data = read.csv("one-factor-within-subjects-experiments/srchscrlvce.csv") 
data$Subject = factor(data$Subject)
data$Order   = factor(data$Order)
summary(data)

# describe
library(psych)
describeBy(data$Effort, group = data$Technique)

# graph histograms and boxplot
#  certainly not distributed
data.search = data[data$Technique == "Search", ]
data.scroll = data[data$Technique == "Scroll", ]
data.voice  = data[data$Technique == "Voice", ]
hist(data.search$Effort)
hist(data.scroll$Effort)
hist(data.voice$Effort)
plot(Effort ~ Technique, data)

# Friedman test on Errors
library(coin)
friedman_test(Effort ~ Technique | Subject, data=data, distribution="asymptotic")
# results is not significant

# note! this omnibus test is not significant so post hoc comparisons are not justified
# if we were to do them, we would use a set of 3 Wilcoxon signed-rank tests corrected
# with Holm's sequential Bonferroni corrections, just as we did for Errors priviously.