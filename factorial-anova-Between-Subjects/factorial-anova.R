# Mixed Factorial ANOVA on WPM (words per minute)
#
# Note: "Mixed" here is not "mixed effects" as in LMMs (Linear Mixed Models)
# Whose will be used farther down below.
# "Mixed" here is mixing between-Ss and within-Ss factors.
# By contrast, "mixed" in LMMs is mixing fixed and random effects,
# which we'll cover later.
#
# Mixed factorial designs are also called "mixed designs"
# or "split-plot designs." It's easy to extrapolate to
# purely between-Ss or within-Ss factorial designs
# from what we do here

# read in data file of smartphone text entry by 24 people
data = read.csv("factorial-anova/mbltxt.csv")
View(data)
data$Subject = factor(data$Subject)
data$Posture_Order = factor(data$Posture_Order)
summary(data)

# explore the data
library(plyr)
ddply(data, ~ Keyboard * Posture, function(data) summary(data$WPM))
ddply(data, ~ Keyboard * Posture, summarise, mean=mean(WPM), sd=sd(WPM))


# histogram for two factors
WPM <- function(keyboard, posture)
  return(data[data$Keyboard == keyboard & data$Posture == posture, ]$WPM)
par(mfrow=c(2,3))
for (k in levels(data$Keyboard)) {
  for (p in levels(data$Posture)) {
    hist(WPM(k, p), main=paste(k, " & ", p), xlab=paste(k, " & ", p), ylim=c(0, 5))
  }
}
par(mfrow=c(1,1))
# histogram for two factors (course code)
hist(mbltxt[mbltxt$Keyboard == "iPhone" & mbltxt$Posture == "Sit",]$WPM)
hist(mbltxt[mbltxt$Keyboard == "iPhone" & mbltxt$Posture == "Stand",]$WPM)
hist(mbltxt[mbltxt$Keyboard == "iPhone" & mbltxt$Posture == "Walk",]$WPM)
hist(mbltxt[mbltxt$Keyboard == "Galaxy" & mbltxt$Posture == "Sit",]$WPM)
hist(mbltxt[mbltxt$Keyboard == "Galaxy" & mbltxt$Posture == "Stand",]$WPM)
hist(mbltxt[mbltxt$Keyboard == "Galaxy" & mbltxt$Posture == "Walk",]$WPM)


boxplot(WPM ~ Keyboard * Posture, data, xlab="Keyboard.Posture", ylab="WPM") # box plot
with(data, interaction.plot(Posture, Keyboard, WPM, ylim=c(0, max(data$WPM)))) # interaction plot

# test for a Posture order effect to ensure counterbalancing worked
library(ez)
m = ezANOVA(data, dv=WPM, between=Keyboard, within=Posture_Order, wid=Subject)
m$`Mauchly's Test for Sphericity` # > 0.05.    n.s.
m$ANOVA # Posture_Order & Keyboard:Posture_Order  n.s.
# means our counter-balancing works
# we are not confounding the order


# now perform the two-way mixed factorial repeated measures ANOVA
m = ezANOVA(data, WPM, Subject, between=Keyboard, within=Posture)
m$`Mauchly's Test for Sphericity` # significant. use GGe correction, use dif. DF
m$ANOVA
# note: "ges" in m$ANOVA is the generalized eta-squared measure
# of effect size, prefered to eta-squared or partial eta-squared.
# see Bakeman (2005) in the References at ?ezANOVA

# Now compute the corrected DFs for each corrected effect
# include the corrected DFs for each corrected effect
pos = match(m$`Sphericity Corrections`$Effect, m$ANOVA$Effect)
m$S$GGe.DFn = m$S$GGe * m$ANOVA$DFn[pos]
m$S$GGe.DFd = m$S$GGe * m$ANOVA$DFd[pos]
m$S$HFe.DFn = m$S$HFe * m$ANOVA$DFn[pos]
m$S$HFe.DFd = m$S$HFe * m$ANOVA$DFd[pos]
m$S # show results

# mannual post hoc pairwise comparisons in light of significant interaction
#  the overral or omnibus F test was significant, but ;et's do some looking
#  between levels
library(reshape2)
wide = dcast(data, Subject + Keyboard ~ Posture, value.var="WPM")
View(wide)
sit   = t.test(wide$Sit   ~ Keyboard, wide) # iPhone vs Galaxy WPM sitting
stand = t.test(wide$Stand ~ Keyboard, wide) # iPhone vs Galaxy WPM standing
walk  = t.test(wide$Walk  ~ Keyboard, wide) # iPhone vs Galaxy WPM walking
p.adjust(c(sit$p.value, stand$p.value, walk$p.value), method="holm")
# all three are statistically significant at the 0.05 level
# differences are big neough in light of their variance 

# just curious: also compare iPhone "sit" and "walk"
wide.iphone = wide[wide$Keyboard == "iPhone", ]
t.test(wide.iphone$Sit, wide.iphone$Walk, paired=TRUE)
boxplot(wide.iphone$Sit, wide.iphone$Walk, xlab="iPhone.Sit vs. iPhone.Walk", ylab="WPM")
