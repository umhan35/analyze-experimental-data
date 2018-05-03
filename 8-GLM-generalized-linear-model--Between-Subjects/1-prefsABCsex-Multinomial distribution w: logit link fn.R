# Generalized Linear Models (GLM) extend Linear Models (LM) for studies
# with between-Ss factors to acommodate nomonal (incl. binomial) or ordinal
# responses, or with non-normal response distributions (e.g., Poisson,
# exponential, gamma). All GLMs have a distribution and a link fn relating
# their factors to their response. The GLM generalized the LM, which is a
# GLM with a normal distribution and "identity" link fn. See, e.g.,
# http://en.wikipedia.org/wiki/Generalized_linear_model

## GLM 1: Nomial logistic regression for preference responses
## -----  Multinomial distribution w/ logit link fn

# re-read our data showing preferences by sex
d = read.csv("GLM-generalized-linear-model/prefsABCsex.csv")
View(d)
d$Subject = factor(d$Subject) # convert to nominal factor
summary(d)
plot(d[d$Sex == "M", ]$Pref)
plot(d[d$Sex == "F", ]$Pref)

# analyze Pref by sex with multinomial logistic regression
# aka nomial logistic regression
library(nnet) # multinom
library(car) # Anova
contrasts(d$Sex) <- "contr.sum"
m = multinom(Pref ~ Sex, data=d) # if pref 2 responses, use binom
Anova(m, type=3) # Sex is stat. significant: sex does effect prefs.

# pairwise comparisons
ma = binom.test(sum(d[d$Sex == "M",]$Pref == "A"), nrow(d[d$Sex == "M",]), p=1/3)
mb = binom.test(sum(d[d$Sex == "M",]$Pref == "B"), nrow(d[d$Sex == "M",]), p=1/3)
mc = binom.test(sum(d[d$Sex == "M",]$Pref == "C"), nrow(d[d$Sex == "M",]), p=1/3)
p.adjust(c(ma$p.value, mb$p.value, mc$p.value), method="holm") # correct for multiple comparisons
# 0.109473564 0.126622172 0.001296754
# male really liked C

# use one method
p.adjust(method="holm",
         c(binom.test(sum(d[d$Sex == "M",]$Pref == "A"), nrow(d[d$Sex == "M",]), p=1/3)$p.value,
           binom.test(sum(d[d$Sex == "M",]$Pref == "B"), nrow(d[d$Sex == "M",]), p=1/3)$p.value,
           binom.test(sum(d[d$Sex == "M",]$Pref == "C"), nrow(d[d$Sex == "M",]), p=1/3)$p.value))

p.adjust(method="holm",
         c(binom.test(sum(d[d$Sex == "F",]$Pref == "A"), nrow(d[d$Sex == "F",]), p=1/3)$p.value,
           binom.test(sum(d[d$Sex == "F",]$Pref == "B"), nrow(d[d$Sex == "F",]), p=1/3)$p.value,
           binom.test(sum(d[d$Sex == "F",]$Pref == "C"), nrow(d[d$Sex == "F",]), p=1/3)$p.value))

# conclusion
# male really liked C
# femaled isliked A