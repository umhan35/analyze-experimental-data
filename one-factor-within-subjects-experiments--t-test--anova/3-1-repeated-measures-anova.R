## one-way repeated measures ANOVA

# read in a data file with a third method, voice recognition
#  file name: # search scroll voice (bad naming...)
data = read.csv("one-factor-within-subjects-experiments/srchscrlvce.csv") 
data$Subject = factor(data$Subject)
data$Order   = factor(data$Order)
summary(data)

# view descriptive stats by Technique
library(plyr)
ddply(data, ~ Technique, function(data) summary(data$Time))
ddply(data, ~ Technique, summarize, Time_Mean=mean(Time), Time_SD=sd(Time))

library(psych)
describeBy(data$Time, group = data$Technique)

# research question: is the technique of voice fast enough to make a difference?

# graph histograms and boxplot
data.search = data[data$Technique == "Search", ]
data.scroll = data[data$Technique == "Scroll", ]
data.voice  = data[data$Technique == "Voice", ]
hist(data.search$Time)
hist(data.scroll$Time)
hist(data.voice$Time)
plot(Time ~ Technique, data)

# repeated measures ANOVA
#  if the test is significant, do a pairwise comparisons
library(ez)
# ez let us specify the depedent variable (Time),
#  within-subjects variables (Technique), and
#  the subject variable (Subject)
# from ?ezANOVA:
#  dv mighe be collapsed to a mean for each cell
#  see within_full
m = ezANOVA(data, dv=Time, wid=Subject, within=Technique)
m # show all info
#
# check the model for violation of sphericity, which is
#  the situation where the variances of the differences
#  between all combinations of levels of
#  a within-subjects factor are equa. It always holds for
#  within-subjects factors with 2 levels, but for 2+ levels
#
# Mauchly's Test of Sphericity
#  p < .05 means violation.
m$Mauchly # result (p=0.00058) shows violation
#  if no violation, examine the uncorrected ANOVA in m$ANOVA
#  ges: Generalized Eta-Squared measure of effect size
m$ANOVA
#  if violation, look at
#   m$`Sphericity Corrections` and
#   use the Greenhouse-Geisser correction, GGe.
m$`Sphericity Corrections`
m$Sphericity # the same as above
m$S # the same as above

### now correct results since violation
# include the corrected DFs for each corrected effect
pos = match(m$`Sphericity Corrections`$Effect, m$ANOVA$Effect)
m$S$GGe.DFn = m$S$GGe * m$ANOVA$DFn[pos]
m$S$GGe.DFd = m$S$GGe * m$ANOVA$DFd[pos]
m$S$HFe.DFn = m$S$HFe * m$ANOVA$DFn[pos]
m$S$HFe.DFd = m$S$HFe * m$ANOVA$DFd[pos]
m$S # show results

# mannual post hoc pairwise comparisons with paired-samples t-tests
library(reshape2)
data.wide.tech = dcast(data, Subject ~ Technique, value.var = "Time")
View(data.wide.tech)
View(data)
# se = search, sv = scroll, vc = voice
se.sc = t.test(data.wide.tech$Search, data.wide.tech$Scroll, paired=TRUE)
se.vc = t.test(data.wide.tech$Search, data.wide.tech$Voice,  paired=TRUE)
sc.vc = t.test(data.wide.tech$Scroll, data.wide.tech$Voice, paired=TRUE)
p.adjust(c(se.sc$p.value, se.vc$p.value, sc.vc$p.value))
