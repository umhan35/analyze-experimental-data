# revisit our data file with 3 response categories, but now with sex (M/F)
prefsABCsex = read.csv("tests-of-proportions/prefsABCsex.csv")
View(prefsABCsex)
prefsABCsex$Subject = factor(prefsABCsex$Subject)
summary(prefsABCsex)
plot(prefsABCsex[prefsABCsex$Sex == "M",]$Pref)
plot(prefsABCsex[prefsABCsex$Sex == "F",]$Pref)

# Pearson chi-square test
prfs = xtabs(~Pref+Sex, data=prefsABCsex)
View(prfs)
chisq.test(prfs)

# G-test, asymptotic
library(RVAideMemoire)
G.test(prfs)

# Fisher's exact test
fisher.test(prfs)

# manual post hoc binomial tests for males
# w/ vars
prefsABCmale = prefsABCsex[prefsABCsex$Sex=="M",]
prefsABCmaleACount = sum(prefsABCmale$Pref == "A")
prefsABCmaleBCount = sum(prefsABCmale$Pref == "B")
prefsABCmaleCCount = sum(prefsABCmale$Pref == "C")
ma = binom.test(prefsABCmaleACount, nrow(prefsABCmale), p=1/3)
mb = binom.test(prefsABCmaleBCount, nrow(prefsABCmale), p=1/3)
mc = binom.test(prefsABCmaleCCount, nrow(prefsABCmale), p=1/3)
p_vals = c(ma$p.value, mb$p.value, mc$p.value)
p.adjust(p_vals, method="holm")

# w/o vars
ma = binom.test(sum(prefsABCsex[prefsABCsex$Sex=="M",]$Pref == "A"), nrow(prefsABCsex[prefsABCsex$Sex=="M",]), p=1/3)
mb = binom.test(sum(prefsABCsex[prefsABCsex$Sex=="M",]$Pref == "B"), nrow(prefsABCsex[prefsABCsex$Sex=="M",]), p=1/3)
mc = binom.test(sum(prefsABCsex[prefsABCsex$Sex=="M",]$Pref == "C"), nrow(prefsABCsex[prefsABCsex$Sex=="M",]), p=1/3)
p_vals = c(ma$p.value, mb$p.value, mc$p.value)
p.adjust(p_vals, method="holm")

# manual post hoc binomial tests for females
fa = binom.test(sum(prefsABCsex[prefsABCsex$Sex=="F",]$Pref == "A"), nrow(prefsABCsex[prefsABCsex$Sex=="F",]), p=1/3)
fb = binom.test(sum(prefsABCsex[prefsABCsex$Sex=="F",]$Pref == "B"), nrow(prefsABCsex[prefsABCsex$Sex=="F",]), p=1/3)
fc = binom.test(sum(prefsABCsex[prefsABCsex$Sex=="F",]$Pref == "C"), nrow(prefsABCsex[prefsABCsex$Sex=="F",]), p=1/3)
p_vals = c(fa$p.value, fb$p.value, fc$p.value)
p.adjust(p_vals, method="holm")