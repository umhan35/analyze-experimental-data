# revisit our data file with 2 response categories, but now with sex (M/F)
prefsABsex = read.csv("tests-of-proportions/prefsABsex.csv")
View(prefsABsex)
prefsABsex$Subject = factor(prefsABsex$Subject)
summary(prefsABsex)
plot(prefsABsex[prefsABsex$Sex == "M",]$Pref)
plot(prefsABsex[prefsABsex$Sex == "F",]$Pref)

# Pearson chi-square test
prfs = xtabs(~Pref+Sex, data=prefsABsex)
View(prfs)
chisq.test(prfs)

# G-test, asymptotic
library(RVAideMemoire)
G.test(prfs)

# Fisher's exact test
fisher.test(prfs)
