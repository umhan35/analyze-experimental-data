# read in a data file with 2 response categories
prefsAB = read.csv("tests-of-proportions/prefsAB.csv")
View(prefsAB)
prefsAB$Subject = factor(prefsAB$Subject)
summary(prefsAB)
plot(prefsAB$Pref)