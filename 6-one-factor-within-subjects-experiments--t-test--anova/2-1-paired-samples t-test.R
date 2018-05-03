## paired-samples t-test
##
## scenario: Finding contacts in a smartphone contacts manager

# read in a data file with times to find a set of contacts
#  file name: # search scroll (bad naming...)
data = read.csv("one-factor-within-subjects-experiments/srchscrl.csv")
View(data)
data$Subject = factor(data$Subject)
data$Order   = factor(data$Order)
summary(data)

# view descriptive stats by Technique
library(psych)
describeBy(data$Time, group = data$Technique)

# explore the Time response
data.search = data[data$Technique == "Search", ]
data.scroll = data[data$Technique == "Scroll", ]
hist(data.search$Time)
hist(data.scroll$Time)
plot(Time ~ Technique, data)

# tried to compare
# h1 = hist(data.search$Time, plot = FALSE)
# h2 = hist(data.scroll$Time, plot = FALSE)
# max_x = max(data$Time)
# max_y = max(h1$counts, h2$counts)
# plot(h2, ylim=c(0,max_y), xlim=c(0, max_x), col=adjustcolor("red", 0.2))
# plot(h1, col=adjustcolor("green", 0.2), add=TRUE)



# test anova assumptions
# normality
shapiro.test(data.search$Time)
shapiro.test(data.scroll$Time)

# fit a model for testing residuals -- the Error fn is used
# to indicate within-subjects effects. Generally, Error(S/(A*B*C))
# mean each S was exposed to every level of A B C and S
# is a column encoding subject ids
m = aov(Time ~ Technique + Error(Subject/Technique), data)
# residuals for Subject
shapiro.test(residuals(m$Subject))
qqnorm(residuals(m$Subject))
qqline(residuals(m$Subject))
# residuals for Subject:Technique
shapiro.test(residuals(m$`Subject:Technique`))
qqnorm(residuals(m$`Subject:Technique`))
qqline(residuals(m$`Subject:Technique`))

# homoscedasticity
library(car)
leveneTest(Time ~ Technique, data=data, center=median)

# now test for an order effect -- did counterbalancing work?
# in the data, it's fully counterbalanced
library(reshape2)
# for a paired samples t-test we must use a wide-format table
# most R functions don't require a wide-format table, but dcast
# offers a quick way to translate long format into wide format
# when we need it
wide.order = dcast(data, Subject ~ Order, value.var="Time")
t.test(wide.order$`1`, wide.order$`2`, paired=TRUE, var.equal=TRUE)
# results is 0.199 which suggests we don't have an order effects
# where order itself is causing difference in performance
# report like a t-test



# finnaly the paired-samples t-test on Techniques
wide.tech = dcast(data, Subject ~ Technique, value.var="Time")
t.test(wide.tech$Search, wide.tech$Scroll, paired=TRUE, var.equal = TRUE)
plot(Time ~ Technique, data)









