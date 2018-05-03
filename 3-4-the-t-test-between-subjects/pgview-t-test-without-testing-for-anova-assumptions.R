# independent-samples t-test

pgviews = read.csv("the-t-test/pgviews.csv")
View(pgviews)
pgviews$Subject = factor(pgviews$Subject)
summary(pgviews)

# descriptive statistics by Site
library(plyr)
ddply(pgviews, ~ Site, function(data) summary(data$Pages))
ddply(pgviews, ~ Site, summarise, Pages.mean=mean(Pages), Pages.sd=sd(Pages))

# graph hisgrams and a boxplot
hist(pgviews[pgviews$Site == "A",]$Pages) # seems normally distributed
hist(pgviews[pgviews$Site == "B",]$Pages) # not a bell curve, will ses the difference later
plot(Pages ~ Site, data=pgviews) # boxplot

# independent-samples t-test
t.test(Pages ~ Site, data=pgviews, var.equal=TRUE)
