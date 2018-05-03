## Nonparametric equivalent of one-way repeated measures ANOVA

# read in a data file with a third method, voice recognition
#  file name: # search scroll voice (bad naming...)
data = read.csv("one-factor-within-subjects-experiments/srchscrlvce.csv") 
data$Subject = factor(data$Subject)
data$Order   = factor(data$Order)
summary(data)

# examine Errors for 3 techniques
#library(plyr)
#ddply(data, ~ Technique, function(data) summary(data$Time))
#ddply(data, ~ Technique, summarize, Time_Mean=mean(Time), Time_SD=sd(Time))
#
# psych package shows them easily
library(psych)
describeBy(data$Error, group = data$Technique)

# graph histograms and boxplot
#  certainly not distributed
data.search = data[data$Technique == "Search", ]
data.scroll = data[data$Technique == "Scroll", ]
data.voice  = data[data$Technique == "Voice", ]
hist(data.search$Errors)
hist(data.scroll$Errors)
hist(data.voice$Errors)
plot(Errors ~ Technique, data)

# research question: are the voice error counts
#  possibly Poisson distributed as they seemed for
#  Scroll and Search?
library(fitdistrplus)
fit = fitdist(data.voice$Errors, "pois", discrete = TRUE)
gofstat(fit) # Chi-squared p-value:  0.9836055

# Friedman test on Errors
library(coin)
friedman_test(Errors ~ Technique | Subject, data=data, distribution="asymptotic")
# results is significant

# mannual post hoc Wilcoxon signed-rank test multiple comparisons
se.sc = wilcox.test(data.search$Errors, data.scroll$Errors, paired=TRUE, exact=FALSE)
se.vc = wilcox.test(data.search$Errors, data.voice$Errors,  paired=TRUE, exact=FALSE)
sc.vc = wilcox.test(data.scroll$Errors, data.voice$Errors,  paired=TRUE, exact=FALSE)
p.adjust(c(se.sc$p.value, se.vc$p.value, sc.vc$p.value), method="holm")
# /|\ all significant

# post hoc analysis using PMCMR for nonparametric pairwise comparisons
#  Conover method
library(PMCMR)
posthoc.friedman.conover.test(data$Errors, data$Technique, data$Subject, p.adjust.method="holm")
