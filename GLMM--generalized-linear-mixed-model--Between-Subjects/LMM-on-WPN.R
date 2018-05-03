# Linear Mixed Models (LMM) do everything Linear Models (LM) do but
# can have both fixed and random effects.
# Random effects allow usto handle within-subjects factors
# by modeling "Subject" as a random effect. 
# Generalized Linear Mixed Models (GLMM) do everything 
# Generalized Linear Models (GLM) do, but also can have both fixed 
# and random effects. LMMs and GLMMs are called "mixed effects 
# models." See Generalized Linear Mixed Models (GLMM) do everything 
# Generalized Linear Models (GLM) do, but also can have both fixed 
# and random effects. LMMs and GLMMs are called "mixed effects 
# models." See https://en.wikipedia.org/wiki/Generalized_linear_mixed_model

# analyze WPM with a linear model
# analyze Error_Rate with a generalized linear model

# read in data file of smartphone text entry by 24 people, but now
# it has every single trial performed, not averaged over trials.
d = read.csv("GLMM/mbltxttrials.csv")
d$Subject = factor(d$Subject)
d$Posture_Order = factor(d$Posture_Order)
d$Trial = factor(d$Trial)
summary(d)

# explore the WPM data
library(plyr)
ddply(d, ~ Keyboard * Posture, function(data) summary(data$WPM))
ddply(d, ~ Keyboard * Posture, summarise, M=mean(WPM), SD = sd(WPM))

# histogram for 2 facotrs
WPM <- function(keyboard, posture)
  return(d[d$Keyboard == keyboard & d$Posture == posture, ]$WPM)
par(mfrow=c(2,3))
for (k in levels(d$Keyboard)) {
  for (p in levels(d$Posture)) {
    hist(WPM(k, p), main=paste(k, " & ", p), xlab=paste(k, " & ", p), ylim=c(0, 120))
  }
}
par(mfrow=c(1,1))

boxplot(WPM ~ Keyboard * Posture, d, xlab="Keyboard.Posture", ylab="WPM") # box plot
with(d, interaction.plot(Posture, Keyboard, WPM, ylim=c(0, max(d$WPM)))) # interaction?

# libraries for LMMs we'll use on WPM
library(lmerTest)
library(car) # for Anova

# set sum-to-zero contrasts for the Anova calls
#  sum-to-zero really means:compare the level evenly to each other
contrasts(d$Keyboard) <- "contr.sum"
contrasts(d$Posture) <- "contr.sum"
contrasts(d$Posture_Order) <- "contr.sum"
contrasts(d$Trial) <- "contr.sum"


# LMM order effect test
# Keyboard, Posture_Order, Keyboard:Posture_Order and Trial
# are all fixed effects. Trial is nested within Keyboard, Posture_Order.
# Subject is a random effect.
library(lme4) # for lmer
m = lmer(WPM ~ (Keyboard * Posture_Order)/Trial + (1|Subject), d)
Anova(m, type=3, test.statistic="F")
# results shows Order doesn't effect our data

# main LMM test on WPM
# Keyboard, Posture, Keyboard:Posture and Trial are
# all fixed effects. Trial is nested within 
# Keyboard, Posture. Subject is a random effect.
m = lmer(WPM ~ (Keyboard * Posture)/Trial  + (1|Subject), d)
Anova(m, type=3, test.statistic="F")

# we should consider Trial to be a random effect and we obtain
# almost exactly the same results, but takes longer to run.
# NOTE: the syntax in the Coursera video was incorrect for this 
# and has been corrected here.
#m = lmer(WPM ~ (Keyboard * Posture)/(1|Trial) + (1|Subject), data=mbltxttrials)  # old, incorrect
m = lmer(WPM ~ Keyboard * Posture + (1|Keyboard:Posture:Trial) + (1|Subject), data=mbltxttrials) # new, correct
Anova(m, type=3, test.statistic="F")

# perform post hoc pairwise comparisons
library(multcomp) # for glht
library(lsmeans) # for lsm
summary(glht(m, lsm(pairwise ~ Keyboard * Posture)), test=adjusted(type="holm"))
with(mbltxttrials, interaction.plot(Posture, Keyboard, WPM, ylim=c(0, max(mbltxttrials$WPM)))) # for convenience
