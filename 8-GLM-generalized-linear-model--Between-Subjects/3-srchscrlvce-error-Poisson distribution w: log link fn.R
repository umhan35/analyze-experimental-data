# skipped, Between-Ss

## GLM 3: Poisson regression for count responses
## -----  Poisson distribution w/ log link fn

# our data also has an "Errors" response, count data
# re-familiarize ourselves with the Errors response
library(plyr)
ddply(srchscrlvce.2, ~ Technique, function(data) summary(data$Errors))
ddply(srchscrlvce.2, ~ Technique, summarise, Errors.mean=mean(Errors), Errors.sd=sd(Errors))
hist(srchscrlvce.2[srchscrlvce.2$Technique == "Search",]$Errors)
hist(srchscrlvce.2[srchscrlvce.2$Technique == "Scroll",]$Errors)
hist(srchscrlvce.2[srchscrlvce.2$Technique == "Voice",]$Errors)
plot(Errors ~ Technique, data=srchscrlvce.2) # boxplot

# re-verify that these data are Poisson-distributed
library(fitdistrplus)
fit = fitdist(srchscrlvce.2[srchscrlvce.2$Technique == "Search",]$Errors, "pois", discrete=TRUE)
gofstat(fit) # goodness-of-fit test
fit = fitdist(srchscrlvce.2[srchscrlvce.2$Technique == "Scroll",]$Errors, "pois", discrete=TRUE)
gofstat(fit) # goodness-of-fit test
fit = fitdist(srchscrlvce.2[srchscrlvce.2$Technique == "Voice",]$Errors, "pois", discrete=TRUE)
gofstat(fit) # goodness-of-fit test

# analyze using Poisson regression
# set sum-to-zero contrasts for the Anova call
contrasts(srchscrlvce.2$Technique) <- "contr.sum"
# family parameter identifies both distribution and link fn
m = glm(Errors ~ Technique, data=srchscrlvce.2, family=poisson)
Anova(m, type=3)
qqnorm(residuals(m)); qqline(residuals(m)) # s'ok! Poisson regression makes no normality assumption

# conduct pairwise comparisons among levels of Technique
library(multcomp)
summary(glht(m, mcp(Technique="Tukey")), test=adjusted(type="holm")) # Tukey means compare all pairs
