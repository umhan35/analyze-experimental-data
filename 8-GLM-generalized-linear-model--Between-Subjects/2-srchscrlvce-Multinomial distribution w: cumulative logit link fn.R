# skipped because it is for between-subjects


## GLM 2: Ordinal logistic regression for Likert responses
## -----  Multinomial distribution w/ cumulative logit link fn

# re-read our data showing Effort Likert rating for finding contacts on a smartphone
srchscrlvce.2 = read.csv("srchscrlvce.csv") # revisiting so add ".2"
View(srchscrlvce.2)
srchscrlvce.2$Subject = (1:nrow(srchscrlvce.2)) # recode as between-Ss study
srchscrlvce.2$Subject = factor(srchscrlvce.2$Subject) # convert to nominal factor
srchscrlvce.2$Order = NULL # drop order, n/a for between-Ss 
View(srchscrlvce.2) # verify
summary(srchscrlvce.2)

# re-familiarize ourselves with the Effort Likert response
library(plyr)
ddply(srchscrlvce.2, ~ Technique, function(data) summary(data$Effort))
ddply(srchscrlvce.2, ~ Technique, summarise, Effort.mean=mean(Effort), Effort.sd=sd(Effort))
hist(srchscrlvce.2[srchscrlvce.2$Technique == "Search",]$Effort, breaks=c(1:7), xlim=c(1,7))
hist(srchscrlvce.2[srchscrlvce.2$Technique == "Scroll",]$Effort, breaks=c(1:7), xlim=c(1,7))
hist(srchscrlvce.2[srchscrlvce.2$Technique == "Voice",]$Effort, breaks=c(1:7), xlim=c(1,7))
plot(Effort ~ Technique, data=srchscrlvce.2) # boxplot

# analyze Effort Likert ratings by Technique with ordinal logistic regression
library(MASS) # for polr
library(car) # for Anova
srchscrlvce.2$Effort = ordered(srchscrlvce.2$Effort) # must be an ordinal response
# set sum-to-zero contrasts for the Anova call
contrasts(srchscrlvce.2$Technique) <- "contr.sum"
m = polr(Effort ~ Technique, data=srchscrlvce.2, Hess=TRUE) # ordinal logistic
Anova(m, type=3) # n.s.

# post hoc pairwise comparisons are NOT justified due to lack of sig.
# but here's how we would do them, just for completeness
library(multcomp)
summary(glht(m, mcp(Technique="Tukey")), test=adjusted(type="holm")) # Tukey means compare all pairs
library(lsmeans) # equivalent way using lsmeans, pairs, and as.glht
summary(as.glht(pairs(lsmeans(m, pairwise ~ Technique))), test=adjusted(type="holm"))
