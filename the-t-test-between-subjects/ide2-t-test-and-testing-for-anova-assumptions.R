# independent-samples t-test

ide2 = read.csv("the-t-test/ide2.csv")
View(ide2)
ide2$Subject = factor(ide2$Subject)
summary(ide2)

# descriptive statistics by Site
library(plyr)
ddply(ide2, ~ IDE, function(data) summary(data$Time))
ddply(ide2, ~ IDE, summarise, Pages.mean=mean(Time), Pages.sd=sd(Time))

# graph histograms and a boxplot
hist(ide2[ide2$IDE == "VStudio", ]$Time) # close to a bell curve
hist(ide2[ide2$IDE == "Eclipse", ]$Time) # not quite a guassian
plot(Time ~ IDE, data=ide2)

# independent-samples t-test (two sample t-test)
#  (suitable? maybe not, because Eclipse distribution if not Guassian)
t.test(Time ~ IDE, data=ide2, var.equal=TRUE)



## testing ANOVA assumptions

# Shapiro-Wilk normality test on response
# ANOVA is robust to mild departures from normality and violations of homogeneity or variance,
# # data points also matter
shapiro.test(ide2[ide2$IDE == "VStudio", ]$Time)
shapiro.test(ide2[ide2$IDE == "Eclipse", ]$Time)

# but really what matters most if the resuduals
m = aov(Time ~ IDE, data=ide2) # fit anova model
shapiro.test(residuals(m)) # test resuduals
qqnorm(residuals(m)); qqline(residuals(m)) # plot residuals
# as seen in the plots, not normally distributed

# now see if log-normality is a better fit
# Kolmogorov-Smirnov test for log-normality
# fit the distribution to a lognormal to estimate fit parameters
# then supply those to a Kolmogorov-Smirnov test with the lognormal distribution fn (see ?plnorm)
library(MASS)
fit = fitdistr(ide2[ide2$IDE == "VStudio", ]$Time, "lognormal")$estimate
ks.test(ide2[ide2$IDE == "VStudio", ]$Time, "plnorm", meanlog=fit[1], sdlog=fit[2], exact=TRUE)
fit = fitdistr(ide2[ide2$IDE == "Eclipse", ]$Time, "lognormal")$estimate
ks.test(ide2[ide2$IDE == "Eclipse", ]$Time, "plnorm", meanlog=fit[1], sdlog=fit[2], exact=TRUE)
# just showing it's not a significant departure from the log normal distribution

# tests for homoscedasticity (homogeneity of variance)
#  using Levene's test and Brown-Forsythe test (a variation on Levene's test)
#   significant result means violation
library(car)
leveneTest(Time ~ IDE, data=ide2, center=mean) # Levene's test -> significant result means violation
leveneTest(Time ~ IDE, data=ide2, center=median) # Brown-Forsythe test
# prefered, because it uses median, a little bit more robust to outliers

# Welch t-test for unequal variance 
# handles the violation of homoscedasticity,
# but not the violation of normality
t.test(Time ~ IDE, data=ide2, var.equal=FALSE)


# Data transformation, s.t., it confirms the assumption of normality
# create a new colimn in ide2 designed as log(time)
ide2$logTime = log(ide2$Time)
View(ide2)

vsData = ide2[ide2$IDE == "VStudio",]
eData = ide2[ide2$IDE == "Eclipse",]

# explore for intuition-building
hist(ide2[ide2$IDE == "VStudio",]$logTime)
hist(ide2[ide2$IDE == "Eclipse",]$logTime)

# re-test for nomality
shapiro.test(vsData$logTime)
shapiro.test(eData$logTime)
# test for residuals
m = aov(logTime ~ IDE, data=ide2) # fit model
shapiro.test(residuals(m)) # test residuals, 
# residuals don't depart from normality at a significant level
qqnorm(residuals(m)); qqline(residuals(m))
# little bit departure in the right up corner but not sevier as Time
# again ANOVA is robust from those minor departure in normality (run var.equal=TRUE)

# re-test for homoscedasticity (homogeneity of variance)
leveneTest(logTime ~ IDE, data=ide2, center=median)
# 0.07875  close but still not compliant

# independent-samples t-test (two sample t-test)
t.test(logTime ~ IDE, data=ide2, var.equal=TRUE)

# now we can trust the result more because we transformed our data