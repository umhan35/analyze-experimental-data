# Nonparametric approach to factorial ANOVA
# The Aligned Rank Transform (ART) procedure
#  the data is aligned before being ranked
#  aligned means: only the effect of interest is left in the data
#   because we substract out values from it that removes the causes
#   of other effects
#
# on Error Rate

# read in data file of smartphone text entry by 24 people
data = read.csv("factorial-anova/mbltxt.csv")
View(data)
data$Subject = factor(data$Subject)
data$Posture_Order = factor(data$Posture_Order)
summary(data)

# explore the data
library(plyr)
ddply(data, ~ Keyboard * Posture, function(data) summary(data$Error_Rate))
ddply(data, ~ Keyboard * Posture, summarise, mean=mean(Error_Rate), sd=sd(Error_Rate))

#histograms, boxplots, and interaction plot

# histogram for two factors
Error_Rate <- function(keyboard, posture)
  return(data[data$Keyboard == keyboard & data$Posture == posture, ]$Error_Rate)
par(mfrow=c(2,3))
for (k in levels(data$Keyboard)) {
  for (p in levels(data$Posture)) {
    hist(Error_Rate(k, p), main=paste(k, " & ", p), xlab=paste(k, " & ", p), ylim=c(0,7))
  }
}
par(mfrow=c(1,1))
# histogram for two factors (course code)
hist(mbltxt[mbltxt$Keyboard == "iPhone" & mbltxt$Posture == "Sit",]$Error_Rate)
hist(mbltxt[mbltxt$Keyboard == "iPhone" & mbltxt$Posture == "Stand",]$Error_Rate)
hist(mbltxt[mbltxt$Keyboard == "iPhone" & mbltxt$Posture == "Walk",]$Error_Rate)
hist(mbltxt[mbltxt$Keyboard == "Galaxy" & mbltxt$Posture == "Sit",]$Error_Rate)
hist(mbltxt[mbltxt$Keyboard == "Galaxy" & mbltxt$Posture == "Stand",]$Error_Rate)
hist(mbltxt[mbltxt$Keyboard == "Galaxy" & mbltxt$Posture == "Walk",]$Error_Rate)


boxplot(Error_Rate ~ Keyboard * Posture, data, xlab="Keyboard.Posture", ylab="Error_Rate") # box plot
# walk seemingly deferentially between the two keyboards
with(data, interaction.plot(Posture, Keyboard, Error_Rate, ylim=c(0, max(data$Error_Rate)))) # interaction plot

# Alighed Rank Transform on Error_Rate
library(ARTool)
m = art(Error_Rate ~ Keyboard * Posture + (1|Subject), data)
anova(m) # report anova
shapiro.test(residuals(m)) # normality?
qqnorm(residuals(m)); qqline(residuals(m));

# conduct post hoc pairwide comparisons within each factor
with(data, interaction.plot(Posture, Keyboard, Error_Rate, ylim=c(0, max(data$Error_Rate))))
library(lsmeans)
lsmeans(artlm(m, "Keyboard"), pairwise ~ Keyboard) # !!! returns z test, but in video is t test...
lsmeans(artlm(m, "Posture"),  pairwise ~ Posture)
#lsmeans(artlm(m, "Keyboard : Posture"), pairwise ~ Keyboard : Posture) # don't do this in ART!

# the above contrast-testing method is invalid for cross-factor pairwise comparisons in ART.
# and you can't just grab aligned-ranks for manual t-tests. instead, use testInteractions 
# from the phia package to perform "interaction contrasts." see vignette("art-contrasts").
library(phia)
testInteractions(artlm(m, "Keyboard:Posture"), pairwise=c("Keyboard", "Posture"), adjustment="holm")
# in the output, A-B : C-D is interpreted as a difference-of-differences, i.e., the difference 
# between (A-B | C) and (A-B | D). in words, is the difference between A and B significantly 
# different in condition C from condition D?

