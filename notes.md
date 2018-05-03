is not sufficient, but need to be combined with other resourses

click on the function name and use F1 to see its documentation
no need to slect whole line and run it, just Run to run the current line

the R version of the original course was done by his student, so
prof. might not be proficient in R

----

test of proportions: couting subjects' answers
called one sample cause we have a sample of their preferences

reproduced chi-squared test in libreoffice calc
there is a significant difference 
non-significant difference: there is no detected difference

we had a binomial test with 60 data points and report the p-value

the . in R is like _ in other programming language



independent variables -> aka  factors   can takes levels (Site A & B)
	X

Y ~ X + e
	(epslon measurement error - kind of random - variation - true difference)
pages ~ site + e
numeric ~ categorical (nominal)

variable types




t-test



t-test asuumes normal distribution

independence - each subject is sampled independent of other subjects (snowball violates this) verified through experiment design
normality -
homoscedasticity (homogeneity of variance) - variance is similar







distribution:
lognormal: task time usually follows (intuition behind is: difficult to be fast, and easy to be slow; when trying to be faster, follows this tail)
exponential: wealth
	a special case of Gamma distribution when k=shape=1
Gamma distribution: waiting time in line, time in a queue, stress-testing products until they fail 


poisson distribution: count data, count of rare events
Binomial (yes/no/ success/fail)
multinomial (multiple response categories)








normality: residuals are normally distributed
residual
	the difference of the reponses you measure and the statistical models predictions
	gives the sense of how randomly off your statistical model is
	if normally distributed, no systematic effects going on that not considered in your statitical model
		systematic effects: missing variables or effects you are uncertain (hidden effect)







parametric vs nonparametric

parametric (eg ANOVA), making distribution assumptions, concerning the population that you're studying
nonparametric converts to ranks
	less powerful





* means significant;  know the null hypothesis









effect size?




http://www.cookbook-r.com/Graphs/Plotting_means_and_error_bars_(ggplot2)/#error-bars-for-within-subjects-variables








a main effect of keyboard
a main effect of posture
an interaction: diferential effect

N           x M
// levels
Between-Ss     Within-Ss









## GLM

so far: LM (anovas), now GLM

- analyze those otherwise violates normality
- can only handle between-subjects

GLM:

- multinominial logistic regression
- ordinal logistic regression
- Poisson regression


## GLMM


LMM (Linear Mixed Model)  ->  GLMM (General Linear Mixed Model)

### Random Effects

factors whose levels were sampled randomly from a larger population which we wish to generalize about, but whose specific levels we don't care about

#### e.g., Subject

we don't care about the levels, we only care about they are a pool of subjects

allows us to cprrelate measures across the same subjects, across diff rows in our data table. That's how we can handle within subjec's designs using mixed models

### Fixed Effects

factors in our study

---

when you have both, you have "mixed"

### Mixed models

#### Pros

- missing data cells
- unbalanced design
- no need: Mauchly's sphericity
 - just model the covariance in the data directly

#### Cons

more computation power

large DF (ok. is how Mixed modes should be working)

- DFres
- DFd

### Nesting - nested effects

practical matter

when the levels of the factor shouldn't be pooled by their label alone

when individual level doesn't mean anything

e.g., trial

trial 1 doesn't mean anything








