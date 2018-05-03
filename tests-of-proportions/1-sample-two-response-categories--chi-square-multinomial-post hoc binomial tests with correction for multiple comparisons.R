# read in a data file with 2 response categories
prefsABC = read.csv("tests-of-proportions/prefsABC.csv")
View(prefsABC)
prefsABC$Subject = factor(prefsABC$Subject)
summary(prefsABC)
plot(prefsABC$Pref)

# Pearson chi-square test
prfs = xtabs( ~ Pref, data=prefsABC)
prfs
chisq.test(prfs)

# multinomial test
library(XNomial)
xmulti(prfs, c(1/3, 1/3, 1/3), statName="Prob")

# post hoc binomial tests with correction for multiple comparisons
prefsABC$Pref == "A"
sum(prefsABC$Pref == "A")
nrow(prefsABC)
aa = binom.test(sum(prefsABC$Pref == "A"), nrow(prefsABC), p=1/3)
bb = binom.test(sum(prefsABC$Pref == "B"), nrow(prefsABC), p=1/3)
cc = binom.test(sum(prefsABC$Pref == "C"), nrow(prefsABC), p=1/3)
p_vals = c(aa$p.value, bb$p.value, cc$p.value)
p.adjust(p_vals, method="holm")
