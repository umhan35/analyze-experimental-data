## Generalized Linear Mixed Model (GLMM) on Error_Rate
# Poisson nature

d = read.csv("GLMM/mbltxttrials.csv")
d$Subject = factor(d$Subject)
d$Posture_Order = factor(d$Posture_Order)
d$Trial = factor(d$Trial)
summary(d)

# turn Error_Rate into Errors counted out of 100
# need a nonnegative integer
d$Errors = d$Error_Rate * 100
summary(d)

# explore new Errors column
library(plyr)
ddply(d, ~ Keyboard * Posture, function(data) summary(data$Errors))
ddply(d, ~ Keyboard * Posture, summarise, M=mean(Errors), SD=sd(Errors))

# histogram for two factors
Error_Rate <- function(keyboard, posture)
  return(d[d$Keyboard == keyboard & d$Posture == posture, ]$Error_Rate)
par(mfrow=c(2,3))
for (k in levels(d$Keyboard)) {
  for (p in levels(d$Posture)) {
    hist(Error_Rate(k, p), main=paste(k, " & ", p), xlab=paste(k, " & ", p))
  }
}
par(mfrow=c(1,1))

boxplot(Error_Rate ~ Keyboard * Posture, d, xlab="Keyboard.Posture", ylab="Error_Rate") # box plot
# walk seemingly deferentially between the two keyboards
with(d, interaction.plot(Posture, Keyboard, Error_Rate, ylim=c(0, max(d$Error_Rate)))) # interaction plot



# see if new Errors data seems Poisson-distributed
library(fitdistrplus)
fit = fitdist(d[d$Keyboard == "iPhone" & d$Posture == "Sit",]$Errors, "pois", discrete=TRUE)
gofstat(fit) # goodness-of-fit test
# result: Chi-squared p-value:  0.1221833, n.s.

fit = fitdist(d[d$Keyboard == "iPhone" & d$Posture == "Stand",]$Errors, "pois", discrete=TRUE)
gofstat(fit) # goodness-of-fit test
fit = fitdist(d[d$Keyboard == "iPhone" & d$Posture == "Walk",]$Errors, "pois", discrete=TRUE)
gofstat(fit) # goodness-of-fit test
fit = fitdist(d[d$Keyboard == "Galaxy" & d$Posture == "Sit",]$Errors, "pois", discrete=TRUE)
gofstat(fit) # goodness-of-fit test
fit = fitdist(d[d$Keyboard == "Galaxy" & d$Posture == "Stand",]$Errors, "pois", discrete=TRUE)
gofstat(fit) # goodness-of-fit test
fit = fitdist(d[d$Keyboard == "Galaxy" & d$Posture == "Walk",]$Errors, "pois", discrete=TRUE)
gofstat(fit) # goodness-of-fit test

  
# libraries for GLMMs with Poisson regression we'll use on Errors
library(lme4) # for glmer
library(car) # for Anova

# set sum-to-zero contrasts for the Anova call
contrasts(d$Keyboard) <- "contr.sum"
contrasts(d$Posture) <- "contr.sum"
contrasts(d$Trial) <- "contr.sum"

# main GLMM test on Errors
# Keyboard, Posture, Keyboard:Posture and Trial are
# all fixed effects. Trial is nested within 
# Keyboard, Posture. Subject is a random effect.
m = glmer(Errors ~ (Keyboard * Posture)/Trial + (1|Subject), data=d, family=poisson, nAGQ=0)
Anova(m, type=3)
# note that in glmer, we set nAGQ to zero for speed.
# the results were almost the same as for nAGQ = 1, 
# the default, which takes a few minutes to complete.

# perform post hoc pairwise comparisons
with(d, interaction.plot(Posture, Keyboard, Errors, ylim=c(0, max(d$Errors)))) # for convenience
library(multcomp) # for glht
library(lsmeans) # for lsm
summary(glht(m, lsm(pairwise ~ Keyboard * Posture)), test=adjusted(type="holm"))
