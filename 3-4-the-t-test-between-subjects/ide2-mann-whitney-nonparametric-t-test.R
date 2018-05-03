ide2 = read.csv("the-t-test/ide2.csv")
ide2$logTime = log(ide2$Time)

# Mann-Whitney U test
library(coin)
wilcox_test(Time ~ IDE, data=ide2, distribution="exact")
# if logTime, the same result
#  because doesn't fundamentally change the rank order of the response
#  the rank order of all measures remains the same when log is taken
wilcox_test(logTime ~ IDE, data=ide2, distribution="exact")
